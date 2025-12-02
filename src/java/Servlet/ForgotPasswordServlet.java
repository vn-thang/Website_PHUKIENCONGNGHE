package Servlet;

import DAO.UserDAO;
import utils.EmailUtility;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgotPassword"})
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
      
        // Chuyển hướng đến trang nhập email
        request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
//          try {
//        EmailUtility.sendEmail("tuanhoang19042004@gmail.com", "Test", "Hello");
//        response.getWriter().println("Gửi email thành công!");
//    } catch (Exception ex) {
//        ex.printStackTrace();
//        response.getWriter().println("Gửi email thất bại: " + ex.getMessage());
//    }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        UserDAO userDAO = new UserDAO();

        // Gọi hàm kiểm tra email bạn đã viết
        if (userDAO.checkAccountByEmail(email)) {
            
            // 1. Tạo mã OTP ngẫu nhiên (6 số)
            Random rand = new Random();
            int otpValue = 100000 + rand.nextInt(900000);
            String otp = String.valueOf(otpValue);

            // 2. Lưu OTP vào Database (Gọi hàm bạn đã viết)
            userDAO.updateRecoveryToken(email, otp);

            // 3. Gửi Email cho khách
            String subject = "Mã xác thực quên mật khẩu";
            String content = "Xin chào, mã xác thực (OTP) của bạn là: " + otp + 
                             "\n\nMã này sẽ hết hạn sau 10 phút. Vui lòng không chia sẻ cho ai khác.";
            
            // Chạy việc gửi mail trong luồng riêng để web không bị đơ
            new Thread(() -> {
                EmailUtility.sendEmail(email, subject, content);
            }).start();

            // 4. Lưu email vào Session để dùng ở bước sau
            HttpSession session = request.getSession();
            session.setAttribute("resetEmail", email);
            
            request.setAttribute("message", "Mã OTP đã được gửi! Vui lòng kiểm tra email.");
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
            
        } else {
            request.setAttribute("error", "Email này không tồn tại trong hệ thống!");
            request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
        }
    }
}