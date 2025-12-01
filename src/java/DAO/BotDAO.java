/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.ChuDeBot;
/**
 *
 * @author Thang
 */
public class BotDAO {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // HÀM 1: Quét Database xem câu nói khách hàng khớp với từ khóa nào
   // HÀM: Kiểm tra xem tin nhắn của khách có khớp chủ đề nào không
    public ChuDeBot checkIntent(String msg) {
        // Chuyển tin nhắn về chữ thường để so sánh không phân biệt hoa thường
        String userMsg = msg.toLowerCase().trim();
        
        // CÂU LỆNH SQL THÔNG MINH (Dành cho MySQL)
        // Logic: Tìm những từ khóa nằm TRONG tin nhắn của khách
        // ORDER BY LENGTH DESC: Ưu tiên từ khóa dài nhất (chính xác nhất) trước
        String query = "SELECT c.* " +
                       "FROM ChuDeBot c " +
                       "JOIN TuKhoaBot k ON c.MaChuDe = k.MaChuDe " +
                       "WHERE ? LIKE CONCAT('%', k.TuKhoa, '%') " +
                       "ORDER BY LENGTH(k.TuKhoa) DESC LIMIT 1";
                       
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, userMsg); // Gán tin nhắn của khách vào dấu ?
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return new ChuDeBot(
                    rs.getInt("MaChuDe"),
                    rs.getString("TenChuDe"),
                    rs.getString("LoaiHanhDong"),
                    rs.getString("GiaTriPhanHoi")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // Không tìm thấy thì trả về null
    }

    // HÀM 2: Ghi lại câu hỏi lạ để Admin dạy sau
   public void insertUnanswered(String msg) {
        // 1. Chuẩn hóa tin nhắn: Xóa khoảng trắng thừa, chuyển về chữ thường
        // Để "Hi", "hi ", "HI" đều coi là một
        String cleanMsg = msg.trim(); 
        
        // Nếu tin nhắn quá ngắn hoặc rỗng thì bỏ qua luôn (đỡ rác)
        if (cleanMsg.length() < 2) return; 
        try {
            conn = new DBContext().getConnection();
            
            // 2. KIỂM TRA XEM CÂU NÀY ĐÃ CÓ TRONG DB CHƯA?
            String checkQuery = "SELECT COUNT(*) FROM NhatKyCauHoi WHERE NoiDungCauHoi = ?";
            ps = conn.prepareStatement(checkQuery);
            ps.setString(1, cleanMsg);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt(1);
                // Nếu count > 0 nghĩa là đã có rồi -> DỪNG LẠI, KHÔNG LƯU NỮA
                if (count > 0) {
                    return; 
                }
            }

            // 3. NẾU CHƯA CÓ -> MỚI LƯU VÀO DB
            String insertQuery = "INSERT INTO NhatKyCauHoi (NoiDungCauHoi) VALUES (?)";
            ps = conn.prepareStatement(insertQuery);
            ps.setString(1, cleanMsg);
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
   public List<ChuDeBot> getAllTopics() {
        List<ChuDeBot> list = new ArrayList<>();
        String query = "SELECT * FROM ChuDeBot ORDER BY MaChuDe DESC";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            while (rs.next()) {
                ChuDeBot c = new ChuDeBot();
                c.setMaChuDe(rs.getInt("MaChuDe"));
                c.setTenChuDe(rs.getString("TenChuDe"));
                c.setLoaiHanhDong(rs.getString("LoaiHanhDong"));
                c.setGiaTriPhanHoi(rs.getString("GiaTriPhanHoi"));
                
                // Quan trọng: Load luôn danh sách từ khóa của chủ đề này
                c.setListTuKhoa(getKeywordsByTopic(c.getMaChuDe())); 
                list.add(c);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // HÀM 4: Lấy danh sách từ khóa theo ID Chủ đề (Hàm phụ trợ cho Hàm 3)
    public List<String> getKeywordsByTopic(int maChuDe) {
        List<String> list = new ArrayList<>();
        String query = "SELECT TuKhoa FROM TuKhoaBot WHERE MaChuDe = ?";
        try {
            PreparedStatement ps2 = conn.prepareStatement(query);
            ps2.setInt(1, maChuDe);
            ResultSet rs2 = ps2.executeQuery();
            while(rs2.next()){
                list.add(rs2.getString("TuKhoa"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // HÀM 5: Thêm Chủ đề mới (Create Topic)
    public void addTopic(String ten, String loai, String phanHoi) {
        String query = "INSERT INTO ChuDeBot (TenChuDe, LoaiHanhDong, GiaTriPhanHoi) VALUES (?, ?, ?)";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setNString(1, ten);
            ps.setString(2, loai);
            ps.setNString(3, phanHoi);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // HÀM 6: Dạy thêm Từ khóa cho Bot (Train Keyword)
    public void addKeyword(int maChuDe, String tuKhoa) {
        String query = "INSERT INTO TuKhoaBot (MaChuDe, TuKhoa) VALUES (?, ?)";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, maChuDe);
            ps.setNString(2, tuKhoa);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // HÀM 7: Xóa Chủ đề (Cascade Delete: Xóa cả từ khóa con)
    public void deleteTopic(int id) {
        try {
            conn = new DBContext().getConnection();
            // Xóa từ khóa trước
            PreparedStatement ps1 = conn.prepareStatement("DELETE FROM TuKhoaBot WHERE MaChuDe = ?");
            ps1.setInt(1, id);
            ps1.executeUpdate();
            
            // Xóa chủ đề sau
            PreparedStatement ps2 = conn.prepareStatement("DELETE FROM ChuDeBot WHERE MaChuDe = ?");
            ps2.setInt(1, id);
            ps2.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    
    // HÀM 8: Xóa 1 từ khóa cụ thể (Nếu Bot học sai)
    public void deleteKeyword(int maChuDe, String tuKhoa) {
        String query = "DELETE FROM TuKhoaBot WHERE MaChuDe = ? AND TuKhoa = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, maChuDe);
            ps.setNString(2, tuKhoa);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // HÀM 9: Lấy danh sách câu hỏi Bot không hiểu (Từ Nhật Ký)
    public List<String> getUnansweredQuestions() {
        List<String> list = new ArrayList<>();
        String query = "SELECT * FROM nhatkycauhoi ORDER BY manhatky DESC"; 
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            while (rs.next()) {
                // Trả về chuỗi gộp để Servlet dễ xử lý: "ID###Nội dung"
                list.add(rs.getInt("manhatky") + "###" + rs.getString("NoiDungCauHoi")); 
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // HÀM 10: Xóa câu hỏi trong nhật ký (Sau khi đã dạy Bot xong)
    public void deleteUnanswered(int id) {
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement("DELETE FROM nhatkycauhoi WHERE manhatky = ?");
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    public ChuDeBot getTopicById(int id) {
        String query = "SELECT * FROM ChuDeBot WHERE MaChuDe = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new ChuDeBot(
                    rs.getInt("MaChuDe"),
                    rs.getString("TenChuDe"),
                    rs.getString("LoaiHanhDong"),
                    rs.getString("GiaTriPhanHoi")
                );
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // --- [MỚI] HÀM 10: CẬP NHẬT CHỦ ĐỀ (SỬA) ---
    public void updateTopic(int id, String ten, String loai, String phanHoi) {
        String query = "UPDATE ChuDeBot SET TenChuDe=?, LoaiHanhDong=?, GiaTriPhanHoi=? WHERE MaChuDe=?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setNString(1, ten);
            ps.setString(2, loai);
            ps.setNString(3, phanHoi);
            ps.setInt(4, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}
