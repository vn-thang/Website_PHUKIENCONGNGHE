package Servlet;

import DAO.CartDAO; // Thêm import
import DAO.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Cart; // Thêm import
import model.User;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String user = request.getParameter("user");
        String pass = request.getParameter("pass");
        UserDAO dao = new UserDAO();
        User account = dao.login(user, pass);

        if (account == null) {
            request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("acc", account);
            request.setAttribute("successMesage", " Đăng nhập thành công!");

            // --- LOGIC MỚI: TẢI GIỎ HÀNG TỪ DATABASE ---
            CartDAO cartDAO = new CartDAO();
            Cart cart = cartDAO.getCartByUserId(account.getMaNguoiDung());
            session.setAttribute("cart", cart);
            // --- KẾT THÚC LOGIC MỚI ---
            
            if ("admin".equalsIgnoreCase(account.getVaiTro())) {
                response.sendRedirect("manager-product");
            } else {
                response.sendRedirect("home");
            }
        }
    }
}

