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

// Đặt tên mapping là "profile"
@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    /**
     * Xử lý GET: Hiển thị trang thông tin tài khoản.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        // Nếu chưa đăng nhập, chuyển về trang login
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // Chuyển đến trang JSP để hiển thị
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    /**
     * Xử lý POST: Cập nhật thông tin tài khoản.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        // Bảo vệ: Nếu chưa đăng nhập
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // Lấy thông tin từ form
        String hoTen = request.getParameter("hoTen");
        String email = request.getParameter("email");
        String sdt = request.getParameter("sdt");
        String diaChi = request.getParameter("diaChi");

        UserDAO userDAO = new UserDAO();

        // 1. Kiểm tra xem email mới có bị trùng với người khác không
        if (userDAO.checkEmailExistForOtherUser(email, user.getMaNguoiDung())) {
            // Nếu email bị trùng
            request.setAttribute("errorMessage", "Email này đã được sử dụng bởi một tài khoản khác!");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        // 2. Cập nhật thông tin vào đối tượng User hiện tại
        user.setHoTen(hoTen);
        user.setEmail(email);
        user.setSoDienThoai(sdt);
        user.setDiaChi(diaChi);

        // 3. Gọi DAO để lưu vào CSDL
        boolean isUpdated = userDAO.updateProfile(user);

        if (isUpdated) {
            // 4. Cập nhật lại session
            session.setAttribute("acc", user);
            request.setAttribute("successMessage", "Cập nhật thông tin thành công!");
        } else {
            request.setAttribute("errorMessage", "Có lỗi xảy ra, không thể cập nhật!");
        }

        // 5. Gửi lại trang profile với thông báo
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}