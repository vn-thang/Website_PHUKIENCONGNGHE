package Servlet;

import DAO.UserDAO;
//import Service.EmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;
import model.User;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail(email);

        if (user == null) {
            request.setAttribute("error", "Email không tồn tại trong hệ thống.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        } else {
            String newPassword = UUID.randomUUID().toString().substring(0, 8);
            boolean isUpdated = userDAO.updatePassword(user.getMaNguoiDung(), newPassword);
            
            if (isUpdated) {
//                EmailService emailService = new EmailService();
//                boolean isEmailSent = emailService.sendPasswordResetEmail(email, newPassword);

//                if (isEmailSent) {
                    request.getSession().setAttribute("successMsg", "Mật khẩu mới đã được gửi đến email của bạn. Vui lòng kiểm tra!");
                    response.sendRedirect("login");
                } else {
                    request.setAttribute("error", "Không thể gửi email. Vui lòng thử lại sau.");
                    request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                }}

            }
        }
//    }
//}

