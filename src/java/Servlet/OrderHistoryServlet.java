package Servlet;

import DAO.CategoryDAO;
import DAO.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Category;
import model.Order;
import model.OrderDetail;
import model.User;

@WebServlet(name = "OrderHistoryServlet", urlPatterns = {"/order-history"})
public class OrderHistoryServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        // Bắt buộc đăng nhập
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        String action = request.getParameter("action");

        // 1. Tải danh mục (cho header) - BẮT BUỘC
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categoryList = categoryDAO.getAllCategories();
        request.setAttribute("categoryList", categoryList);
        
        // 2. Xử lý GET (Hiển thị)
        if ("view".equals(action)) {
            // Xem chi tiết 1 đơn hàng
            try {
                int orderId = Integer.parseInt(request.getParameter("id"));
                // [Bảo mật] Gọi hàm kiểm tra đúng user
                Order order = orderDAO.getOrderByIdForUser(orderId, user.getMaNguoiDung());
                
                if (order == null) {
                    // Nếu đơn hàng không tồn tại (hoặc không phải của user này)
                    response.sendRedirect("order-history");
                    return;
                }
                
                List<OrderDetail> detailList = orderDAO.getOrderDetailsByOrderId(orderId);
                
                request.setAttribute("order", order);
                request.setAttribute("detailList", detailList);
                request.getRequestDispatcher("orderDetailUser.jsp").forward(request, response);
                
            } catch (Exception e) {
                response.sendRedirect("order-history");
            }
        } 
        else if ("cancel".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("id"));
                boolean check = orderDAO.cancelOrder(orderId, user.getMaNguoiDung());
                
                if (check) {
                    session.setAttribute("msgSuccess", "Đã hủy đơn hàng thành công!");
                } else {
                    session.setAttribute("msgError", "Không thể hủy đơn hàng! Có thể đơn hàng đang được giao hoặc đã hoàn thành.");
                }
                // Quay lại trang chi tiết để xem kết quả
                response.sendRedirect("order-history?action=view&id=" + orderId);
            } catch (Exception e) {
                response.sendRedirect("order-history");
            }
            return;
        }
        else {
            // Xem danh sách tất cả đơn hàng (Mặc định)
            List<Order> orderList = orderDAO.getOrdersByUserId(user.getMaNguoiDung());
            request.setAttribute("orderList", orderList);
            request.getRequestDispatcher("orderHistory.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}