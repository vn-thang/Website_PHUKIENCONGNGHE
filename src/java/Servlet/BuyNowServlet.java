package Servlet;

import DAO.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Cart;
import model.CartItem;
import model.Product;
import model.User;

@WebServlet(name = "BuyNowServlet", urlPatterns = {"/buy-now"})
public class BuyNowServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        // 1. Kiểm tra đăng nhập
        // Yêu cầu: Nếu chưa đăng nhập -> bắt đăng nhập
        if (user == null) {
            response.sendRedirect("login"); 
            return;
        }

        // Yêu cầu: Nếu đã đăng nhập -> xử lý mua ngay
        try {
            // 2. Lấy ID sản phẩm
            int productId = Integer.parseInt(request.getParameter("pid"));
            
            // 3. Lấy thông tin sản phẩm
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getProductByID(productId);

            if (product != null && product.getSoLuongTon() > 0) {
                // 4. Tạo giỏ hàng MỚI chỉ chứa sản phẩm này
                Cart buyNowCart = new Cart();
                CartItem item = new CartItem(product, 1); // Mua ngay với số lượng 1
                buyNowCart.addItem(item);
                
                // 5. GHI ĐÈ giỏ hàng trong session bằng giỏ hàng "Mua Ngay"
                session.setAttribute("cart", buyNowCart);
                
                // 6. Chuyển đến trang giỏ hàng (nơi có modal checkout)
                // Trang cart.jsp sẽ hiển thị 1 sản phẩm và bạn có thể bấm "Tiến hành đặt hàng"
                response.sendRedirect("cart.jsp");
            } else {
                // Nếu sản phẩm không tồn tại hoặc hết hàng, quay lại
                response.sendRedirect("detail?pid=" + productId);
            }
        } catch (NumberFormatException e) {
            // Nếu pid không hợp lệ, về trang chủ
            response.sendRedirect("home");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}