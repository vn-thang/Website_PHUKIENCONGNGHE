package Servlet;

import DAO.CategoryDAO;
import DAO.OrderDAO;
import DAO.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import model.Category;
import model.ProductStatistic;
import model.User;

@WebServlet(name = "StatisticServlet", urlPatterns = {"/statistic"})
public class StatisticServlet extends HttpServlet {

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
        ProductDAO productDAO = new ProductDAO();

        // --- LẤY THÁNG VÀ NĂM ĐƯỢC CHỌN TỪ FORM ---
        LocalDate today = LocalDate.now();
        int selectedYear = today.getYear();
        int selectedMonth = today.getMonthValue();

        String yearParam = request.getParameter("selectedYear");
        if (yearParam != null) {
            try { selectedYear = Integer.parseInt(yearParam); } 
            catch (NumberFormatException e) {  }
        }
        
        String monthParam = request.getParameter("selectedMonth");
        if (monthParam != null) {
            try { selectedMonth = Integer.parseInt(monthParam); } 
            catch (NumberFormatException e) { /* Bỏ qua */ }
        }
        
        // --- LẤY DỮ LIỆU ---

        // 1. Lấy Tổng doanh thu cho tháng được chọn 
        double totalMonthRevenue = orderDAO.getTotalRevenueForMonth(selectedYear, selectedMonth);

        // 2. Lấy Doanh thu theo ngày cho tháng được chọn 
        Map<Integer, Double> dailyRevenueMap = orderDAO.getDailyRevenueForMonth(selectedYear, selectedMonth);

        // 3. [SỬA ĐỔI] Lấy thống kê sản phẩm THEO THÁNG
        
        List<ProductStatistic> statisticList = productDAO.getProductStatisticsByMonth(selectedYear, selectedMonth);
CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categoryList = categoryDAO.getAllCategories();
        request.setAttribute("categoryList", categoryList);
        // --- GỬI DỮ LIỆU RA JSP ---
        request.setAttribute("statisticList", statisticList); // Dữ liệu đã được lọc
        request.setAttribute("totalMonthRevenue", totalMonthRevenue);
        request.setAttribute("dailyRevenueMap", dailyRevenueMap);
        
        request.setAttribute("selectedYear", selectedYear);
        request.setAttribute("selectedMonth", selectedMonth);
        
        int daysInMonth = LocalDate.of(selectedYear, selectedMonth, 1).lengthOfMonth();
        request.setAttribute("daysInMonth", daysInMonth);
        
        request.getRequestDispatcher("statistic.jsp").forward(request, response);
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