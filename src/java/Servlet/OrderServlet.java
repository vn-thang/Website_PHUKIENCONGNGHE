package Servlet;

import DAO.CartDAO;
import DAO.OrderDAO;
import DAO.ProductDAO; // Vẫn cần
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Cart;
import model.CartItem;
import model.User;

@WebServlet(name = "OrderServlet", urlPatterns = {"/order"})
public class OrderServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
    HttpSession session = request.getSession();
    
    User user = (User) session.getAttribute("acc");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }

    // Lấy giỏ hàng *ĐẦY ĐỦ* từ session (để làm cơ sở)
    Cart originalCart = (Cart) session.getAttribute("cart");
    if (originalCart == null || originalCart.getItems().isEmpty()) {
        response.sendRedirect("cart"); // Giỏ hàng trống
        return;
    }

    // *** THAY ĐỔI QUAN TRỌNG: LẤY SẢN PHẨM ĐƯỢC CHỌN TỪ FORM ***
    String[] selectedProductIds = request.getParameterValues("selectedProducts");

    if (selectedProductIds == null || selectedProductIds.length == 0) {
        // Lỗi (mặc dù JS đã chặn nhưng backend vẫn phải kiểm tra)
        session.setAttribute("cartError", "Bạn chưa chọn sản phẩm nào.");
        response.sendRedirect("cart");
        return;
    }

    // *** TẠO MỘT GIỎ HÀNG MỚI (CHỈ CHỨA HÀNG ĐƯỢC CHỌN) ***
    Cart selectedCart = new Cart();
    for (String pidStr : selectedProductIds) {
        try {
            int productId = Integer.parseInt(pidStr);
            // Lấy CartItem (bao gồm cả số lượng) từ giỏ hàng gốc
            if (originalCart.getItems().containsKey(productId)) {
                CartItem item = originalCart.getItems().get(productId);
                selectedCart.addItem(item); // Thêm vào giỏ hàng "sẽ mua"
            }
        } catch (NumberFormatException e) {
            // Bỏ qua nếu ID không hợp lệ
        }
    }

    if (selectedCart.getItems().isEmpty()) {
        session.setAttribute("cartError", "Các sản phẩm bạn chọn không hợp lệ.");
        response.sendRedirect("cart");
        return;
    }
    
    // Lấy thông tin giao hàng (như cũ)
    String hoTen = request.getParameter("hoTenGiaoHang");
    String sdt = request.getParameter("soDienThoaiGiaoHang");
    String diaChi = request.getParameter("diaChiGiaoHang");
    String paymentMethod = request.getParameter("paymentMethod");
    String trangThai = "paypal".equals(paymentMethod) ? "Da Thanh Toan" : "Dang xu ly";

    OrderDAO orderDAO = new OrderDAO();
    
    // *** GỌI createOrder VỚI GIỎ HÀNG ĐÃ LỌC (selectedCart) ***
    String errorMessage = orderDAO.createOrder(user, selectedCart, hoTen, sdt, diaChi, trangThai);

    if (errorMessage == null) {
        // THÀNH CÔNG
        
        // *** THAY ĐỔI QUAN TRỌNG: CHỈ XÓA NHỮNG MỤC ĐÃ MUA ***
        // Chúng ta không xóa toàn bộ giỏ hàng nữa.
        CartDAO cartDAO = new CartDAO();
        for (String pidStr : selectedProductIds) {
            int productId = Integer.parseInt(pidStr);
            originalCart.removeItem(productId); // Xóa khỏi session cart
            cartDAO.removeItem(user.getMaNguoiDung(), productId); // Xóa khỏi DB cart
        }
        
        // Cập nhật lại session với giỏ hàng đã loại bỏ sản phẩm
        session.setAttribute("cart", originalCart); 
        session.setAttribute("orderSuccess", "true"); 
        response.sendRedirect("home");
        
    } else {
        // THẤT BẠI
        session.setAttribute("cartError", errorMessage);
        response.sendRedirect("cart");
    }
    }
}