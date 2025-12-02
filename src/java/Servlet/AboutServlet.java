package Servlet;

import DAO.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "AboutServlet", urlPatterns = {"/about"})
public class AboutServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        OrderDAO dao = new OrderDAO();
        
        // Lấy số liệu thực tế để hiển thị cho "oách"
        int totalSold = dao.countTotalOrders();
        int totalCustomers = dao.countTotalUsers();
        
        // Giả lập số năm kinh nghiệm (hoặc fix cứng)
        int yearsExp = 5; 

        request.setAttribute("totalSold", totalSold);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("yearsExp", yearsExp);

        request.getRequestDispatcher("about.jsp").forward(request, response);
    }
}