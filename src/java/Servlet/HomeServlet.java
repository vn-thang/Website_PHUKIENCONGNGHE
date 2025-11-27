package Servlet;

import DAO.CategoryDAO;
import DAO.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Category;
import model.Product;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        
        // 1. Lấy danh sách danh mục (giữ nguyên)
        List<Category> categoryList = categoryDAO.getAllCategories();
        
        // --- BẮT ĐẦU LOGIC PHÂN TRANG ---
        final int PRODUCTS_PER_PAGE = 20; 
        int totalProducts = 0;
        int totalPages = 0;
        int currentPage = 1;

       
       // 2. Lấy tham số (Thêm priceFrom, priceTo)
        String categoryId = request.getParameter("cid");
        
        // [SỬA LỖI] Nếu chọn "Tất cả" (all) thì coi như không chọn gì (null)
        if ("all".equals(categoryId)) {
            categoryId = null;
        }

        String searchQuery = request.getParameter("search");
        String priceFrom = request.getParameter("priceFrom");
        String priceTo = request.getParameter("priceTo");
        String pageParam = request.getParameter("page");
        
        // 3. Lấy trang hiện tại từ URL
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                currentPage = 1; 
            }
        }
        
        // 4. Xử lý logic LỌC TỔNG HỢP (Thay thế cấu trúc if-else cũ)
        
        // Bước 4a: Đếm tổng sản phẩm thỏa mãn TẤT CẢ điều kiện
        totalProducts = productDAO.countFilteredProducts(categoryId, searchQuery, priceFrom, priceTo);
        
        // Bước 4b: Tính toán phân trang
        totalPages = (int) Math.ceil((double) totalProducts / PRODUCTS_PER_PAGE);
        if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
        if (currentPage < 1) currentPage = 1;
        
        int offset = (currentPage - 1) * PRODUCTS_PER_PAGE;
        
        // Bước 4c: Lấy danh sách sản phẩm (Đã lọc + Phân trang)
        List<Product> productList = productDAO.filterProducts(categoryId, searchQuery, priceFrom, priceTo, offset, PRODUCTS_PER_PAGE);
        
        
        // 5. Logic hiển thị "SẢN PHẨM BÁN CHẠY" 
        // (Chỉ hiện khi ở trang chủ thuần túy: Không lọc danh mục, không tìm kiếm)
        if ((categoryId == null || categoryId.isEmpty()) && (searchQuery == null || searchQuery.isEmpty())) {
             List<Product> bestSellers = productDAO.getTopBestSellingProducts(7);
            
            if (bestSellers != null && !bestSellers.isEmpty()) {
                request.setAttribute("top1BestSeller", bestSellers.get(0));
                if (bestSellers.size() > 1) {
                    request.setAttribute("top2to7BestSellers", bestSellers.subList(1, Math.min(7, bestSellers.size())));
                }
            }
        }
        // --- KẾT THÚC LOGIC XỬ LÝ ---

        
        // 6. Đặt các thuộc tính vào request
        request.setAttribute("productList", productList);
        request.setAttribute("categoryList", categoryList);
        
        // Gửi lại thông tin lọc để giữ trạng thái trên giao diện
        request.setAttribute("activeCategoryId", categoryId); 
        request.setAttribute("searchQuery", searchQuery); 
        request.setAttribute("priceFrom", priceFrom); // Mới
        request.setAttribute("priceTo", priceTo);     // Mới
        
        // Gửi thông tin phân trang
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        
        // 7. Chuyển đến trang home.jsp
        request.getRequestDispatcher("home.jsp").forward(request, response);
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