package Servlet;

import DAO.CategoryDAO;
import DAO.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Category;
import model.User;

@WebServlet(name = "ManageUserServlet", urlPatterns = {"/manage-user"})
public class ManageUserServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        // Kiểm tra quyền Admin
        if (user == null || !"admin".equalsIgnoreCase(user.getVaiTro())) {
            response.sendRedirect("home");
            return;
        }

        UserDAO userDAO = new UserDAO();
        String action = request.getParameter("action");

        if (action != null) {
            try {
                int userId = Integer.parseInt(request.getParameter("userId"));
                
                if ("delete".equals(action)) {
                    // Xử lý xóa (cẩn thận lỗi ràng buộc)
                    try {
                        userDAO.deleteUser(userId);
                    } catch (Exception e) {
                        session.setAttribute("adminError", "Lỗi: Không thể xóa tài khoản này (có thể do còn đơn hàng).");
                    }
                } else if ("updateRole".equals(action)) {
                    // Xử lý cập nhật vai trò
                    String role = request.getParameter("role");
                    userDAO.updateUserRole(userId, role);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
            response.sendRedirect("manage-user");
            return;
        }

        // 1. Tải danh sách danh mục (cho header)
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categoryList = categoryDAO.getAllCategories();
        request.setAttribute("categoryList", categoryList);

        // 2. Tải danh sách người dùng (trừ admin hiện tại)
        List<User> userList = userDAO.getAllUsers(user.getMaNguoiDung());
        request.setAttribute("userList", userList);
        
        // 3. Hiển thị thông báo lỗi (nếu có)
        if (session.getAttribute("adminError") != null) {
            request.setAttribute("adminError", session.getAttribute("adminError"));
            session.removeAttribute("adminError");
        }

        request.getRequestDispatcher("manageUser.jsp").forward(request, response);
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