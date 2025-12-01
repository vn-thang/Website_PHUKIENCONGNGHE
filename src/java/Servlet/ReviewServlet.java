/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import DAO.ReviewDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 *
 * @author Thang
 */
@WebServlet(name = "AddReviewServlet", urlPatterns = {"/review"})
public class ReviewServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     */
    @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        System.out.println("=================================================");
        System.out.println(">>> DEBUG: ReviewServlet doPost() ĐÃ ĐƯỢC GỌI!");

        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("acc"); 
        
        // 1. Kiểm tra đăng nhập
        if (acc == null) {
            System.out.println(">>> DEBUG: User bị NULL. Redirect về Login.");
            response.sendRedirect("Login.jsp");
            return;
        } else {
            System.out.println(">>> DEBUG: User ID = " + acc.getMaNguoiDung());
        }

        try {
            // 2. Lấy dữ liệu từ Form
            String pidRaw = request.getParameter("pid");
            String ratingRaw = request.getParameter("rating");
            String noiDung = request.getParameter("comment"); // Nhớ bên JSP để name="comment"

            System.out.println(">>> DEBUG: Dữ liệu nhận được:");
            System.out.println("   + PID: " + pidRaw);
            System.out.println("   + Rating: " + ratingRaw);

            // Ép kiểu dữ liệu
            int pid = Integer.parseInt(pidRaw);
            int sao = Integer.parseInt(ratingRaw);

            ReviewDAO dao = new ReviewDAO();
            
            // =================================================================
            // 3. LOGIC CỐT LÕI: KIỂM TRA QUYỀN ĐÁNH GIÁ (SHOPEE STYLE)
            // =================================================================
            
            // A. Đếm số lần khách đã mua đơn hàng thành công (Trạng thái 'Đã giao')
            int soLanMua = dao.countLuotMua(acc.getMaNguoiDung(), pid);
            
            // B. Đếm số lần khách đã viết đánh giá cho sản phẩm này
            int soLanDaReview = dao.countLuotDanhGia(acc.getMaNguoiDung(), pid);
            
            System.out.println(">>> DEBUG CHECK QUYỀN:");
            System.out.println("   - Số lần đã mua thành công: " + soLanMua);
            System.out.println("   - Số lần đã Review: " + soLanDaReview);
            
            // C. So sánh: Nếu số lần Review ÍT HƠN số lần Mua -> Được phép đánh giá tiếp
            if (soLanDaReview < soLanMua) {
                System.out.println(">>> KẾT QUẢ: Đủ điều kiện -> Đang lưu vào DB...");
                
                dao.insertReview(acc.getMaNguoiDung(), pid, sao, noiDung);
                
                System.out.println(">>> THÀNH CÔNG: Đã thêm đánh giá mới.");
            } else {
                // Nếu không đủ điều kiện (Ví dụ mua 1 lần mà đòi đánh giá 2 lần)
                System.out.println(">>> TỪ CHỐI: Bạn đã đánh giá hết số lượt mua.");
                System.out.println(">>> (Mua " + soLanMua + " lần, đã review " + soLanDaReview + " lần)");
            }
            // =================================================================

            response.sendRedirect("detail?pid=" + pid); 
            
        } catch (Exception e) {
            System.out.println(">>> DEBUG: ❌ CÓ LỖI XẢY RA:");
            e.printStackTrace(); 
            response.sendRedirect("home");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}