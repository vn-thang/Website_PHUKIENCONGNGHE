/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import DAO.BotDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.ChuDeBot;

/**
 *
 * @author Thang
 */
@WebServlet(name = "ManagerBotServlet", urlPatterns = {"/managerBot"})
public class ManagerBotServlet extends HttpServlet {

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
        String action = request.getParameter("action");
        BotDAO dao = new BotDAO();

        try {
            if (action == null) {
                List<ChuDeBot> list = dao.getAllTopics();
                List<String> listLoi = dao.getUnansweredQuestions();
                
                request.setAttribute("listBot", list);
                request.setAttribute("listLoi", listLoi);
                
                // Chuyển sang trang JSP tên mới
                request.getRequestDispatcher("/managerBot.jsp").forward(request, response);
            } 
            
            // --- CÁC CHỨC NĂNG (Gửi về URL /manager-bot) ---
            
            else if (action.equals("add_topic")) {
                String ten = request.getParameter("ten");
                String loai = request.getParameter("loai");
                String phanHoi = request.getParameter("phanhoi");
                dao.addTopic(ten, loai, phanHoi);
                response.sendRedirect("managerBot"); 
            } 
            else if (action.equals("update_topic")) {
                int id = Integer.parseInt(request.getParameter("id"));
                String ten = request.getParameter("ten");
                String loai = request.getParameter("loai");
                String phanHoi = request.getParameter("phanhoi");
                
                dao.updateTopic(id, ten, loai, phanHoi);
                response.sendRedirect("managerBot");
            }
            
            else if (action.equals("add_keyword")) {
                int id = Integer.parseInt(request.getParameter("id"));
                String tuKhoa = request.getParameter("tukhoa");
                if (tuKhoa != null && !tuKhoa.isEmpty()) {
                    String[] arr = tuKhoa.split(",");
                    for (String k : arr) {
                        dao.addKeyword(id, k.trim());
                    }
                }
                response.sendRedirect("managerBot");
            }
            
            else if (action.equals("delete_topic")) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteTopic(id);
                response.sendRedirect("managerBot");
            }
            
            else if (action.equals("delete_keyword")) {
                int id = Integer.parseInt(request.getParameter("id"));
                String k = request.getParameter("key");
                dao.deleteKeyword(id, k);
                response.sendRedirect("managerBot");
            }
            
            else if (action.equals("delete_log")) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteUnanswered(id);
                response.sendRedirect("managerBot");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("managerBot");
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
