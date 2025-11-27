package Servlet;

import DAO.CartDAO;
import DAO.ProductDAO;
import DAO.CategoryDAO; // <-- [THÊM MỚI] Import
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List; // <-- [THÊM MỚI] Import
import model.Cart;
import model.CartItem;
import model.Category; // <-- [THÊM MỚI] Import
import model.Product;
import model.User;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
        }

        User user = (User) session.getAttribute("acc");
        CartDAO cartDAO = new CartDAO();
        
        // [SỬA LỖI] Khởi tạo CategoryDAO ở đây
        CategoryDAO categoryDAO = new CategoryDAO();

        String action = request.getParameter("action");

        // [SỬA LỖI 1] Khi action = null (tức là chỉ xem giỏ hàng)
        if (action == null || action.isEmpty()) {
            
            // Phải tải danh mục cho header
            List<Category> categoryList = categoryDAO.getAllCategories();
            request.setAttribute("categoryList", categoryList);
            
            // Forward đến JSP
            request.getRequestDispatcher("cart.jsp").forward(request, response);
            return;
        }

        try {
            switch (action) {
                case "add":
                    String idStr = request.getParameter("productId");
                    if (idStr != null && !idStr.isEmpty()) {
                        ProductDAO pDao = new ProductDAO();
                        Product product = pDao.getProductByID(idStr); // Đã sửa lỗi (idStr)

                        if (product != null) {
                            CartItem item = new CartItem(product, 1);
                            cart.addItem(item);

                            if (user != null) {
                                CartItem currentItem = cart.getItems().get(product.getMaSanPham());
                                if (currentItem != null) {
                                    cartDAO.saveOrUpdateItem(
                                            user.getMaNguoiDung(),
                                            product.getMaSanPham(),
                                            currentItem.getQuantity()
                                    );
                                }
                            }
                        }
                    }

                    // Giữ nguyên trang đang ở
                    String refererAdd = request.getHeader("Referer");
                    session.setAttribute("cart", cart);
                    if (refererAdd != null && !refererAdd.isEmpty()) {
                        
                        response.sendRedirect(refererAdd);
                    } else {
                        response.sendRedirect("home");
                    }
                    return; 

                case "update":
                case "remove":
                    int productId = Integer.parseInt(request.getParameter("productId"));
                    if ("update".equals(action)) {
                        int quantity = Integer.parseInt(request.getParameter("quantity"));
                        cart.updateItem(productId, quantity);
                        if (user != null) {
                            if (quantity > 0) {
                                cartDAO.saveOrUpdateItem(user.getMaNguoiDung(), productId, quantity);
                            } else {
                                cartDAO.removeItem(user.getMaNguoiDung(), productId);
                            }
                        }
                    } else { // "remove"
                        cart.removeItem(productId);
                        if (user != null) {
                            cartDAO.removeItem(user.getMaNguoiDung(), productId);
                        }
                    }
                    break;
            }
        } catch (NumberFormatException e) {
            System.err.println("Lỗi trong CartServlet: " + e.getMessage());
        }

        session.setAttribute("cart", cart);

        // [SỬA LỖI 2] Chuyển hướng về "cart" (Servlet)
        // thay vì "cart.jsp" (File). Điều này đảm bảo nó chạy lại SỬA LỖI 1.
        response.sendRedirect("cart");
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