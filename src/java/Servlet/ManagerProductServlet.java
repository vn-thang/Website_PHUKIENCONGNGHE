/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import DAO.CategoryDAO;
import DAO.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Category;
import model.Product;
import model.User;

/**
 *
 * @author admin
 */
@WebServlet(name = "ManagerProductServlet", urlPatterns = {"/manager-product"})
public class ManagerProductServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // --- BẢO VỆ TRANG ADMIN ---
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        // Thay đổi điều kiện kiểm tra vai trò admin
        if (user == null || !"admin".equalsIgnoreCase(user.getVaiTro())) {
            response.sendRedirect("home"); // Chuyển về trang chủ nếu không phải admin
            return;
        }

        String action = request.getParameter("action");
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        if (action == null) {
            action = "list"; // Mặc định là hiển thị danh sách
        }

        switch (action) {
            case "delete":
                deleteProduct(request, response, productDAO);
                break;
            case "load":
                loadProductForEdit(request, response, productDAO);
                break;
            case "update":
                updateProduct(request, response, productDAO);
                break;
            case "add":
                addProduct(request, response, productDAO);
                break;
            case "show-add-form":
                showAddForm(request, response, categoryDAO);
                break;
            case "list":
            default:
                listProducts(request, response, productDAO,categoryDAO);
                break;
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response, ProductDAO dao,CategoryDAO cdao) throws ServletException, IOException {
        // ... (Sau khi xử lý 'action' add/update/delete)
        String search = request.getParameter("search");
        String cid = request.getParameter("cid");
        // Tải danh sách sản phẩm để hiển thị (trường hợp mặc định)
        List<Product> list;
        if (search != null && !search.trim().isEmpty()) {
            list = dao.searchProductsByNameForAdmin(search);
            request.setAttribute("searchValue", search);
        } else if (cid != null && !"all".equals(cid)) {
            list = dao.getProductsByCategoryForAdmin(cid);
            request.setAttribute("tag", cid);
        } else {
            list = dao.getAllProducts();
        }
        List<Category> categories = cdao.getAllCategories();
        request.setAttribute("productList", list);
        request.setAttribute("categoryList", categories);
        request.getRequestDispatcher("managerProduct.jsp").forward(request, response);
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response, ProductDAO dao) throws IOException {
        String pid = request.getParameter("pid");
        dao.deleteProduct(pid);
        request.getSession().setAttribute("success", "Xoá sản phẩm thành công!");
        response.sendRedirect("manager-product");
    }

    private void loadProductForEdit(HttpServletRequest request, HttpServletResponse response, ProductDAO productDAO) throws ServletException, IOException {
        String id = request.getParameter("pid");
        Product product = productDAO.getProductByID(id);
        request.setAttribute("productDetail", product);

        // [PHẦN SỬA LỖI] Tải CategoryList cho form edit VÀ cho header
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categoryList = categoryDAO.getAllCategories();
        request.setAttribute("categoryList", categoryList);
        // [HẾT PHẦN SỬA LỖI]

        request.getRequestDispatcher("editProduct.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response, CategoryDAO categoryDAO) throws ServletException, IOException {
        List<Category> categoryList = categoryDAO.getAllCategories();
        request.setAttribute("categoryList", categoryList);
        request.getRequestDispatcher("editProduct.jsp").forward(request, response);
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response, ProductDAO dao) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String image = request.getParameter("image");
        double price = Double.parseDouble(request.getParameter("price"));
        String description = request.getParameter("description");
        int stock = Integer.parseInt(request.getParameter("stock"));
        int categoryId = Integer.parseInt(request.getParameter("category"));

        Product p = new Product(id, name, image, price, description, stock, categoryId);
        dao.updateProduct(p);
        request.getSession().setAttribute("success", "Cập sản phẩm thành công!");
        response.sendRedirect("manager-product");
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response, ProductDAO dao) throws IOException {
        String name = request.getParameter("name");
        String image = request.getParameter("image");
        double price = Double.parseDouble(request.getParameter("price"));
        String description = request.getParameter("description");
        int stock = Integer.parseInt(request.getParameter("stock"));
        int categoryId = Integer.parseInt(request.getParameter("category"));
        Product p = new Product(0, name, image, price, description, stock, categoryId);
        dao.insertProduct(p);
        request.getSession().setAttribute("success", "Thêm sản phẩm thành công!");
        response.sendRedirect("manager-product");
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
