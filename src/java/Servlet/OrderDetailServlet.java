/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import DAO.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Order;
import model.OrderDetail;
import model.User;

/**
 *
 * @author Thang
 */
@WebServlet(name = "OrderDetailServlet", urlPatterns = {"/order-detail"})
public class OrderDetailServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8"); // Đảm bảo xử lý tiếng Việt
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");

        // 1. Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect("login"); // Về servlet "login"
            return;
        }

        String maDonHangStr = request.getParameter("madon");
        
        try {
            int maDonHang = Integer.parseInt(maDonHangStr);
            int maNguoiDung = user.getMaNguoiDung(); 
            
            OrderDAO orderDAO = new OrderDAO();
            
            // 2. Kiểm tra bảo mật: Đơn hàng có thuộc về người dùng này không?
            // (Sử dụng hàm mới trong DAO)
            Order order = orderDAO.getOrderByIdAndUserID(maDonHang, maNguoiDung);
            
            if (order == null) {
                // Nếu không, quay lại lịch sử với thông báo lỗi
                request.setAttribute("errorMessage", "Không tìm thấy đơn hàng hoặc bạn không có quyền xem.");
                request.getRequestDispatcher("/order-history").forward(request, response);
                return;
            }
            
            // 3. Nếu hợp lệ, lấy chi tiết đơn hàng (sử dụng hàm mới trong DAO)
            List<OrderDetail> detailList = orderDAO.getOrderDetailsByOrderID(maDonHang);
            
            // 4. Gửi dữ liệu qua JSP
            request.setAttribute("order", order);       // Gửi thông tin chung của đơn hàng
            request.setAttribute("detailList", detailList); // Gửi danh sách sản phẩm
request.getRequestDispatcher("orderDetail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Mã đơn hàng không hợp lệ.");
            request.getRequestDispatcher("/order-history").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi, vui lòng thử lại.");
            request.getRequestDispatcher("/order-history").forward(request, response);
        }
        
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}