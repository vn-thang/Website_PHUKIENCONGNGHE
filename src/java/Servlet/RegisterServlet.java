/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import DAO.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String hoTen = request.getParameter("hoTen");
        String user = request.getParameter("user");
        String pass = request.getParameter("pass");
        String re_pass = request.getParameter("re_pass");
        String email = request.getParameter("email");
        String sdt = request.getParameter("sdt");
        String diaChi = request.getParameter("diaChi");

        if (!pass.equals(re_pass)) {
            request.setAttribute("errorMessage", "Mật khẩu nhập lại không khớp!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } else {
            UserDAO dao = new UserDAO();
            User account = dao.checkUserExist(user);
            boolean emailExists = dao.checkEmailExist(email); // GỌI HÀM KIỂM TRA EMAIL

            if (account != null) {
                // Tên đăng nhập đã tồn tại
                request.setAttribute("errorMessage", "Tên đăng nhập đã tồn tại!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            } else if (emailExists) {
                // Email đã tồn tại
                request.setAttribute("errorMessage", "Email này đã được sử dụng!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            } else {
                // Tên đăng nhập và email đều hợp lệ, tiến hành đăng ký
                dao.register(hoTen, user, pass, email, sdt, diaChi);
                response.sendRedirect("login.jsp"); // Chuyển hướng đến trang đăng nhập
            }
        }
    }
}
