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
            request.setAttribute("errorMessage", "Chưa chọn sản phẩm nào!");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
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
        // XỬ LÝ VOUCHER (RIÊNG) & FREESHIP (RIÊNG)
        // =================================================================
        double totalMoney = selectedCart.getTotalCartPrice(); // Tiền hàng
        
        // 1. Xử lý Phí Ship (Mặc định 30k)
        double shippingFee = 30000;
        String useFreeship = request.getParameter("useFreeship"); // "true" hoặc null
        if ("true".equals(useFreeship)) {
            shippingFee = 0; // Nếu tích chọn Freeship -> Ship = 0
        }

        // 2. Xử lý Voucher Giảm giá (Check lại điều kiện an toàn)
        double discount = 0;
        try {
            double clientDiscount = Double.parseDouble(request.getParameter("selectedDiscount"));
            if (clientDiscount == 1000000 && totalMoney >= 10000000) discount = 1000000;
            else if (clientDiscount == 500000 && totalMoney >= 3000000) discount = 500000;
            else if (clientDiscount == 200000 && totalMoney >= 1000000) discount = 200000;
        } catch (Exception e) {}

        // 3. Tổng cuối cùng
        double finalTotal = totalMoney + shippingFee - discount;
        if (finalTotal < 0) finalTotal = 0;
        // =================================================================

        // Lưu vào DB
        OrderDAO orderDAO = new OrderDAO();
        String errorMessage = orderDAO.createOrder(user, selectedCart, hoTen, sdt, diaChi, trangThai, finalTotal);

        if (errorMessage == null) {
            for (String pidStr : selectedProductIds) {
                originalCart.removeItem(Integer.parseInt(pidStr));
            }
            session.setAttribute("cart", originalCart);
            session.setAttribute("size", originalCart.getItems().size());
            
            // Thông báo
            StringBuilder msg = new StringBuilder("Đặt hàng thành công!");
            if(shippingFee == 0) msg.append(" (Freeship)");
            if(discount > 0) msg.append(" (Giảm ").append(String.format("%,.0f", discount)).append("đ)");
            
            session.setAttribute("msgSuccess", msg.toString());
            response.sendRedirect("order-history");
        } else {
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }
}