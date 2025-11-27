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

@WebServlet(name = "ManageOrderServlet", urlPatterns = {"/manage-order"})
public class ManageOrderServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null || !"admin".equalsIgnoreCase(user.getVaiTro())) {
            response.sendRedirect("home");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        String action = request.getParameter("action");

        // 1. Tải danh mục (cho header)
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categoryList = categoryDAO.getAllCategories();
        request.setAttribute("categoryList", categoryList);
        
        // 2. Xử lý POST (Cập nhật trạng thái)
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            if ("updateStatus".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String status = request.getParameter("status");
                orderDAO.updateOrderStatus(orderId, status);
                
                // Quay lại trang chi tiết
                response.sendRedirect("manage-order?action=view&id=" + orderId);
                return;
            }
        }

        // 3. Xử lý GET (Hiển thị)
        if ("view".equals(action)) {
            // Xem chi tiết 1 đơn hàng
            try {
                int orderId = Integer.parseInt(request.getParameter("id"));
                Order order = orderDAO.getOrderById(orderId);
                List<OrderDetail> detailList = orderDAO.getOrderDetailsByOrderId(orderId);
                
                request.setAttribute("order", order);
                request.setAttribute("detailList", detailList);
                request.getRequestDispatcher("orderDetailAdmin.jsp").forward(request, response);
            } catch (Exception e) {
                response.sendRedirect("manage-order");
            }
        } else {
            // Xem danh sách tất cả đơn hàng
            List<Order> orderList = orderDAO.getAllOrders();
            request.setAttribute("orderList", orderList);
            request.getRequestDispatcher("manageOrder.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}