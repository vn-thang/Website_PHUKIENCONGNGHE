package Servlet;

import DAO.ProductDAO;
import DAO.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Product;
import model.Review;
import model.User;

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
            
            ReviewDAO reviewDao = new ReviewDAO();

                // A. Lấy danh sách đánh giá & Thống kê sao
                List<Review> listReview = reviewDao.getAllReviews(productId);
                double avgVote = reviewDao.getAverageRating(productId);
                
                request.setAttribute("listReview", listReview);
                request.setAttribute("avgVote", avgVote);
                request.setAttribute("countReview", listReview.size());

                // B. Kiểm tra quyền đánh giá (Logic Shopee: Mua rồi mới được đánh giá)
                HttpSession session = request.getSession();
                User acc = (User) session.getAttribute("acc"); // Lấy user từ session

                boolean canReview = false;
                String reviewMessage = "";
                int luotConLai = 0;

                if (acc == null) {
                    reviewMessage = "Vui lòng đăng nhập để đánh giá.";
                } else {
                    // Đếm số lần mua thành công
                    int soLanMua = reviewDao.countLuotMua(acc.getMaNguoiDung(), productId); // Kiểm tra lại acc.getId() hay acc.getuID() nhé
                    // Đếm số lần đã đánh giá
                    int soLanDaReview = reviewDao.countLuotDanhGia(acc.getMaNguoiDung(), productId);

                    if (soLanMua == 0) {
                        reviewMessage = "Bạn cần mua sản phẩm này để đánh giá.";
                    } else if (soLanDaReview >= soLanMua) {
                        reviewMessage = "Bạn đã đánh giá hết số lượt mua sản phẩm này.";
                    } else {
                        canReview = true; // Cho phép đánh giá
                        luotConLai = soLanMua - soLanDaReview;
                    }
                }

                // Đẩy biến kiểm tra sang JSP
                request.setAttribute("canReview", canReview);
                request.setAttribute("reviewMessage", reviewMessage);
                request.setAttribute("luotConLai", luotConLai);
                
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
