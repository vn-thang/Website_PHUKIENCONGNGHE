/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import DAO.BotDAO;
import DAO.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.NumberFormat;
import java.util.List;
import model.ChuDeBot;
import model.Product;
import java.util.Locale;
/**
 *
 * @author Thang
 */
@WebServlet(name = "ChatServlet", urlPatterns = {"/ChatServlet"})
public class ChatServlet extends HttpServlet {

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
        
        // 1. Cấu hình Tiếng Việt chuẩn
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            
            String msg = request.getParameter("msg");
            if (msg == null || msg.trim().isEmpty()) return;

            BotDAO botDAO = new BotDAO();
            ProductDAO productDAO = new ProductDAO();
            
            ChuDeBot intent = botDAO.checkIntent(msg);
            
            // --- XỬ LÝ LOGIC ---
            if (intent != null) {
                String action = intent.getLoaiHanhDong(); 
                String value = intent.getGiaTriPhanHoi(); 
                
                // ======================================================
                // CASE 1: CHAT XÃ GIAO
                // ======================================================
                if (action.equalsIgnoreCase("CHAT")) {
                    out.print(value); 
                } 
                
                // ======================================================
                // CASE 2: MENU TƯ VẤN (MỚI THÊM)
                // ======================================================
           else if (action.equalsIgnoreCase("MENU")) {
                    String[] options = value.split(";");
                    
                    // 1. Lời dẫn
                    out.print("<div class='bot-text-bubble'>");
                    out.print("Dạ, TStore có các nhóm này ạ:");
                    out.print("</div>");
                    
                    // 2. Danh sách nút (Dùng class 'faq-list' của bạn để xếp dọc)
                    // Thêm style width:100% để container không bị co quá nhỏ
                    out.print("<div class='faq-list' style='width: 100%; margin-top: 5px;'>");
                    
                    for (String opt : options) {
                        String cleanOpt = opt.trim();
                        
                        // 3. Nút bấm (Dùng class 'faq-btn' của bạn)
                        // Giữ nguyên mọi thứ, chỉ thêm onclick
                        out.print("<button class='faq-btn' onclick=\"sendQuickMessage('" + cleanOpt + "')\">" + 
                                  // Thêm icon trang trí nếu thích (hoặc bỏ đi nếu muốn giống hệt 100%)
                                  "🔹 " + cleanOpt + 
                                  "</button>");
                    }
                    out.print("</div>");
                }
                
                // ======================================================
                // CASE 3: TÌM KIẾM SẢN PHẨM
            else if (action.equalsIgnoreCase("TIM_KIEM")) {
                List<Product> list = productDAO.searchProductsByNameForAdmin(value); 
                
                if (list != null && !list.isEmpty()) {
                    
                    // 1. Lời dẫn (Cho vào bong bóng .bot-text-bubble để tách biệt và full dòng)
                    out.print("<div class='bot-text-bubble'>");
                    out.print("Mình tìm thấy " + list.size() + " mẫu <b>" + value + "</b> này ạ:");
                    out.print("</div>");
                    
                    // 2. Container chứa danh sách sản phẩm (Nằm rời bên dưới)
                    out.print("<div style='display:flex; flex-direction:column; gap:8px; margin-top:5px; width:100%; max-width: 300px;'>");
                    
                    int count = 0;
                    String contextPath = request.getContextPath(); 
                    
                    for (Product p : list) {
                        if (count >= 4) break; 
                        
                        NumberFormat nf = NumberFormat.getInstance(new Locale("vi", "VN"));
                        String price = nf.format(p.getGia());
                        
                        // Xử lý ảnh
                        String rawImg = p.getHinhAnh(); 
                        String imgSrc = (rawImg != null && (rawImg.startsWith("http") || rawImg.startsWith("https"))) ? rawImg : contextPath + "/images/" + rawImg;

                        // 3. BIẾN TOÀN BỘ KHUNG THÀNH THẺ A (LINK)
                        // Bấm vào bất cứ đâu cũng chuyển trang
                        out.print("<a href='detail?pid=" + p.getMaSanPham() + "' target='_blank' style='text-decoration:none; color:inherit; display:block;'>");
                        
                            // Khung giao diện sản phẩm
                            out.print("<div style='" +
                                      "display:flex; align-items:center; " +
                                      "background:#fff; " +
                                      "padding:10px; " +
                                      "border:1px solid #e1e4e8; " + // Viền xám
                                      "border-radius:12px; " +        // Bo tròn
                                      "width:100%; box-sizing:border-box; " +
                                      "box-shadow: 0 2px 4px rgba(0,0,0,0.03); " +
                                      "transition: all 0.2s ease;' " +
                                      // Hiệu ứng Hover
                                      "onmouseover=\"this.style.borderColor='#007bff'; this.style.backgroundColor='#f9f9f9';\" " +
                                      "onmouseout=\"this.style.borderColor='#e1e4e8'; this.style.backgroundColor='#fff';\" " +
                                      ">");
                                
                                // Ảnh sản phẩm
                                out.print("<img src='" + imgSrc + "' style='width:45px; height:45px; object-fit:cover; border-radius:6px; margin-right:12px; flex-shrink:0;' onerror=\"this.src='https://via.placeholder.com/40'\">");
                                
                                // Thông tin (Tên + Giá)
                                out.print("<div style='flex:1; min-width:0;'>");
                                    out.print("<div style='font-size:12px; font-weight:600; color:#333; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; margin-bottom:3px;'>" + p.getTenSanPham() + "</div>");
                                    out.print("<div style='font-size:12px; color:#d70018; font-weight:bold;'>" + price + "₫</div>");
                                out.print("</div>");
                                
                                // ĐÃ XÓA MŨI TÊN (>) Ở ĐÂY NHƯ BẠN YÊU CẦU
                                
                            out.print("</div>"); // Đóng div khung
                        out.print("</a>"); // Đóng thẻ a
                        
                        count++;
                    }
                    out.print("</div>"); // Đóng container
                    
                    // Nút xem thêm
                    if (list.size() > 4) {
                        out.print("<div style='text-align:center; margin-top:8px;'>" + 
                                  "<a href='home?search=" + value + "' target='_blank' " + 
                                  "style='font-size:12px; color:#007bff; text-decoration:none; font-weight:500;'>" + 
                                  "Xem tất cả " + list.size() + " sản phẩm &rarr;" + 
                                  "</a></div>");
                    }
                } else {
                    // Không tìm thấy thì cũng cho vào bong bóng
                    out.print("<div class='bot-text-bubble'>");
                    out.print("Tiếc quá, hiện tại shop đang hết mặt hàng '" + value + "' rồi ạ. Bạn thử tìm món khác nhé!");
                    out.print("</div>");
                }
            }
           } else {
                // ============================================================
                // TRƯỜNG HỢP: BOT KHÔNG HIỂU -> HIỆN MENU CỨU CÁNH (STYLE FAQ)
                // ============================================================
                
                // 1. Ghi log
                botDAO.insertUnanswered(msg);
                
                // 2. In câu xin lỗi (Trong bong bóng xám)
                out.print("<div class='bot-text-bubble'>");
                out.print("Em không hiểu rõ câu hỏi của Anh/Chị. Anh/Chị có thể diễn đạt lại giúp em được không?<br>Có thể Anh/Chị đang quan tâm các mục này:");
                out.print("</div>");
                
                // 3. Tự động hiện Menu (Dùng class 'faq-list' để xếp dọc, thẳng hàng bên trái)
                // Các mục này bạn điền khớp với Database nhé
                String[] defaultOptions = {"Tai nghe & Loa", "Chuột & Bàn phím", "Phụ kiện Laptop", "Phụ kiện Điện thoại", "Thiết bị Mạng"};
                
                out.print("<div class='faq-list' style='width:100%; margin-top:5px;'>");
                
                for (String opt : defaultOptions) {
                    // [QUAN TRỌNG] Dùng class 'faq-btn' để nhận diện mạo giống hệt phần gợi ý
                    out.print("<button class='faq-btn' onclick=\"sendQuickMessage('" + opt + "')\">" + 
                              // Thêm icon 🔹 để đẹp hơn (hoặc bỏ đi nếu muốn tối giản)
                              "🔹 " + opt + 
                              "</button>");
                }
                out.print("</div>");
            }
            // Đẩy dữ liệu đi ngay
            out.flush(); 
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
