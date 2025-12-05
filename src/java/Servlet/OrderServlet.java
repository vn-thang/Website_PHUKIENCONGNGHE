package Servlet;

import DAO.OrderDAO;
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
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        Cart originalCart = (Cart) session.getAttribute("cart");

        if (user == null) { response.sendRedirect("login.jsp"); return; }
        if (originalCart == null || originalCart.getItems().isEmpty()) { response.sendRedirect("home"); return; }

        String[] selectedProductIds = request.getParameterValues("selectedProducts");
        if (selectedProductIds == null || selectedProductIds.length == 0) {
            response.sendRedirect("cart.jsp");
            return;
        }

        // Tạo giỏ hàng tạm
        Cart selectedCart = new Cart();
        for (String pidStr : selectedProductIds) {
            try {
                int pid = Integer.parseInt(pidStr);
                if (originalCart.getItems().containsKey(pid)) {
                    selectedCart.addItem(originalCart.getItems().get(pid));
                }
            } catch (NumberFormatException e) {}
        }

        String hoTen = request.getParameter("hoTenGiaoHang");
        String sdt = request.getParameter("soDienThoaiGiaoHang");
        String diaChi = request.getParameter("diaChiGiaoHang");
        String paymentMethod = request.getParameter("paymentMethod");
        String trangThai = "paypal".equals(paymentMethod) ? "Da Thanh Toan" : "Dang xu ly";

        // =================================================================
        // LOGIC TÍNH TOÁN 2 LOẠI VOUCHER
        // =================================================================
        double subTotal = selectedCart.getTotalCartPrice(); 
        
        // 1. Phí Ship Gốc (30k hoặc 89k)
        double baseShip = 30000;
        try { baseShip = Double.parseDouble(request.getParameter("shippingMethod")); } catch (Exception e) {}

        // 2. Giảm giá Ship (Freeship)
        double shipDiscount = 0;
        try { 
            // Nhận giá trị max được giảm (ví dụ 300k)
            double clientShipDisc = Double.parseDouble(request.getParameter("shipDiscount"));
            // Kiểm tra điều kiện > 3 triệu
            if (clientShipDisc > 0 && subTotal >= 3000000) {
                shipDiscount = clientShipDisc; 
            }
        } catch (Exception e) {}
        
        // Tính phí ship thực tế (Không âm)
        double finalShip = baseShip - shipDiscount;
        if (finalShip < 0) finalShip = 0; // Nếu giảm nhiều hơn phí ship thì về 0

        // 3. Giảm giá Shop (Tiền hàng)
        double shopDiscount = 0;
        try {
            double clientShopDisc = Double.parseDouble(request.getParameter("shopDiscount"));
            if (clientShopDisc == 1000000 && subTotal >= 10000000) shopDiscount = 1000000;
            else if (clientShopDisc == 500000 && subTotal >= 3000000) shopDiscount = 500000;
            else if (clientShopDisc == 200000 && subTotal >= 1000000) shopDiscount = 200000;
        } catch (Exception e) {}

        // 4. TỔNG CUỐI CÙNG
        double finalTotal = subTotal + finalShip - shopDiscount;
        if (finalTotal < 0) finalTotal = 0;
        // =================================================================

        OrderDAO orderDAO = new OrderDAO();
        String errorMessage = orderDAO.createOrder(user, selectedCart, hoTen, sdt, diaChi, trangThai, finalTotal);

        if (errorMessage == null) {
            for (String pidStr : selectedProductIds) {
                originalCart.removeItem(Integer.parseInt(pidStr));
            }
            session.setAttribute("cart", originalCart);
            session.setAttribute("size", originalCart.getItems().size());
            
            // Thông báo chi tiết
            String msg = "Đặt hàng thành công!";
            if(finalShip == 0 && baseShip > 0) msg += " (Freeship)";
            if(shopDiscount > 0) msg += " (Giảm hàng " + String.format("%,.0f", shopDiscount/1000) + "k)";
            
            session.setAttribute("msgSuccess", msg);
            response.sendRedirect("order-history");
        } else {
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }
}