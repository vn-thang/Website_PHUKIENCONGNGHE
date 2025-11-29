package Servlet;

import DAO.UserDAO;
import utils.PasswordHasher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/resetPassword"})
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("resetEmail");
        
        String otp = request.getParameter("otp");
        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPass");

        // Nếu session hết hạn hoặc không có email
        if (email == null) {
            response.sendRedirect("forgotPassword.jsp");
            return;
        }

        // Kiểm tra mật khẩu nhập lại
        if (!newPass.equals(confirmPass)) {
            request.setAttribute("error", "Mật khẩu xác nhận không trùng khớp!");
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        
        // 1. Kiểm tra OTP (Gọi hàm bạn đã viết)
        if (userDAO.validateOtp(email, otp)) {
            
            // 2. Mã hóa mật khẩu mới (Nếu bạn dùng SHA-256)
            // Nếu bạn lưu pass thường thì bỏ dòng này và truyền thẳng newPass
            
            
            // 3. Cập nhật vào DB (Gọi hàm bạn đã viết)
            userDAO.changePasswordAfterReset(email, newPass);
            
            // 4. Xóa session
            session.removeAttribute("resetEmail");
            
            request.setAttribute("message", "Đổi mật khẩu thành công! Hãy đăng nhập lại.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            
        } else {
            request.setAttribute("error", "Mã OTP sai hoặc đã hết hạn!");
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
        }
    }
}