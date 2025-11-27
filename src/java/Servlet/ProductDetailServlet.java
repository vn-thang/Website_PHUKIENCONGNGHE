package Servlet;

import DAO.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Product;

@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/detail"})
public class ProductDetailServlet extends HttpServlet {

//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//        
//        String productIdStr = request.getParameter("pid"); // Lấy ID từ URL
//        
//        try {
//            int productId = Integer.parseInt(productIdStr);
//            ProductDAO dao = new ProductDAO();
//            Product product = dao.getProductByID(productId);
//            
//            // Đặt đối tượng product vào request để trang JSP có thể sử dụng
//            request.setAttribute("productDetail", product);
//            
//            // Chuyển hướng đến trang JSP để hiển thị
//            request.getRequestDispatcher("productDetail.jsp").forward(request, response);
//            
//        } catch (NumberFormatException e) {
//            // Xử lý nếu pid không phải là số
//            response.sendRedirect("home");
//        }
//    }
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String productIdStr = request.getParameter("pid"); // Lấy ID từ URL
        
        try {
            int productId = Integer.parseInt(productIdStr);
            ProductDAO dao = new ProductDAO();
            Product product = dao.getProductByID(productId);
            
            // Đặt đối tượng product vào request (như cũ)
            request.setAttribute("productDetail", product);

        
            if (product != null) {
                // Lấy 4 sản phẩm liên quan (cùng danh mục, trừ sản phẩm này)
                int categoryId = product.getMaDanhMuc();
                List<Product> relatedProducts = dao.getRelatedProducts(categoryId, productId, 4);
                
                // Đặt danh sách liên quan vào request
                request.setAttribute("relatedProducts", relatedProducts);
            }
            // --- [HẾT PHẦN MỚI] ---
            
            // Chuyển hướng đến trang JSP (như cũ)
            request.getRequestDispatcher("productDetail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            // Xử lý nếu pid không phải là số
            response.sendRedirect("home");
        }
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
