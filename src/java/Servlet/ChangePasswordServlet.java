package Servlet;

import DAO.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/change-password"})
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getSession().getAttribute("acc") == null) {
            response.sendRedirect("login");
            return;
        }
        request.getRequestDispatcher("change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String oldPass = request.getParameter("oldPass");
        String newPass = request.getParameter("newPass");
        String reNewPass = request.getParameter("reNewPass");

        if (!user.getMatKhau().equals(oldPass)) {
            request.setAttribute("error", "Mật khẩu cũ không chính xác.");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }

        if (!newPass.equals(reNewPass)) {
            request.setAttribute("error", "Mật khẩu mới không khớp.");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        boolean isUpdated = userDAO.updatePassword(user.getMaNguoiDung(), newPass);
        
        if (isUpdated) {
            user.setMatKhau(newPass);
            session.setAttribute("acc", user);
            request.setAttribute("success", "Đổi mật khẩu thành công!");
        } else {
            request.setAttribute("error", "Đã có lỗi xảy ra. Vui lòng thử lại.");
        }
        
        request.getRequestDispatcher("change-password.jsp").forward(request, response);
    }
}

