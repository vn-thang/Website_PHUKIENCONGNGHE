/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement; // Import thêm cái này để lấy ID tự tăng
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

    // HÀM 1: Kiểm tra xem tin nhắn của khách có khớp chủ đề nào không
    public ChuDeBot checkIntent(String msg) {
        String userMsg = msg.toLowerCase().trim();
        String query = "SELECT c.* "
                + "FROM ChuDeBot c "
                + "JOIN TuKhoaBot k ON c.MaChuDe = k.MaChuDe "
                + "WHERE ? LIKE CONCAT('%', k.TuKhoa, '%') "
                + "ORDER BY LENGTH(k.TuKhoa) DESC LIMIT 1";

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, userMsg);
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
        return null;
    }

    // HÀM 2: Ghi lại câu hỏi lạ để Admin dạy sau
    public void insertUnanswered(String msg) {
        String cleanMsg = msg.trim();
        if (cleanMsg.length() < 2) return;
        try {
            conn = new DBContext().getConnection();
            // Check trùng
            String checkQuery = "SELECT COUNT(*) FROM NhatKyCauHoi WHERE NoiDungCauHoi = ?";
            ps = conn.prepareStatement(checkQuery);
            ps.setString(1, cleanMsg);
            rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) return;

            // Insert
            String insertQuery = "INSERT INTO NhatKyCauHoi (NoiDungCauHoi) VALUES (?)";
            ps = conn.prepareStatement(insertQuery);
            ps.setString(1, cleanMsg);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // HÀM 3: Lấy danh sách chủ đề
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
                c.setListTuKhoa(getKeywordsByTopic(c.getMaChuDe()));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            // [QUAN TRỌNG] BẮT BUỘC PHẢI ĐÓNG KẾT NỐI
            try { if(rs != null) rs.close(); } catch(Exception e){}
            try { if(ps != null) ps.close(); } catch(Exception e){}
            try { if(conn != null) conn.close(); } catch(Exception e){}
        }
        return list;
    }

    // HÀM 4: Lấy danh sách từ khóa
    public List<String> getKeywordsByTopic(int maChuDe) {
    Connection conn2 = null;
    PreparedStatement ps2 = null;
    ResultSet rs2 = null;
    List<String> list = new ArrayList<>();

    String query = "SELECT TuKhoa FROM TuKhoaBot WHERE MaChuDe = ?";

    try {
        conn2 = new DBContext().getConnection();
        ps2 = conn2.prepareStatement(query);
        ps2.setInt(1, maChuDe);
        rs2 = ps2.executeQuery();

        while (rs2.next()) {
            list.add(rs2.getString("TuKhoa"));
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs2 != null) rs2.close(); } catch (Exception e) {}
        try { if (ps2 != null) ps2.close(); } catch (Exception e) {}
        try { if (conn2 != null) conn2.close(); } catch (Exception e) {}
    }

    return list;
}


    // --- [QUAN TRỌNG] HÀM 5: THÊM CHỦ ĐỀ & TRẢ VỀ ID VỪA TẠO ---
    // (Đã sửa từ void -> int để phục vụ tính năng trả lời nhanh)
    public int addNewTopic(String ten, String loai, String phanHoi) {
        String query = "INSERT INTO ChuDeBot (TenChuDe, LoaiHanhDong, GiaTriPhanHoi) VALUES (?, ?, ?)";
        try {
            conn = new DBContext().getConnection();
            // Thêm Statement.RETURN_GENERATED_KEYS để lấy ID tự tăng
            ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            ps.setNString(1, ten);
            ps.setString(2, loai);
            ps.setNString(3, phanHoi);
            ps.executeUpdate();
            
            // Lấy ID vừa sinh ra
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1); // Trả về ID mới (Ví dụ: 15)
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0; // Lỗi
    }

    // HÀM 6: Thêm từ khóa
    public void addKeyword(int maChuDe, String tuKhoa) {
        String query = "INSERT INTO TuKhoaBot (MaChuDe, TuKhoa) VALUES (?, ?)";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, maChuDe);
            ps.setNString(2, tuKhoa);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // HÀM 7: Xóa Chủ đề (Cascade)
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
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // HÀM 8: Xóa 1 từ khóa
    public void deleteKeyword(int maChuDe, String tuKhoa) {
        String query = "DELETE FROM TuKhoaBot WHERE MaChuDe = ? AND TuKhoa = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, maChuDe);
            ps.setNString(2, tuKhoa);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // HÀM 9: Lấy danh sách câu hỏi Bot không hiểu
    public List<String> getUnansweredQuestions() {
        List<String> list = new ArrayList<>();
        // Lưu ý: Kiểm tra tên bảng là NhatKyCauHoi hay nhatkycauhoi (MySQL thường phân biệt hoa thường)
        String query = "SELECT * FROM NhatKyCauHoi ORDER BY MaNhatKy DESC";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            while (rs.next()) {
                // Trả về: ID###Nội dung
                list.add(rs.getInt("MaNhatKy") + "###" + rs.getString("NoiDungCauHoi"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- [QUAN TRỌNG] HÀM 10: XÓA LOG LỖI (Đổi tên từ deleteUnanswered thành deleteLog) ---
    public void deleteLog(int id) {
        try {
            conn = new DBContext().getConnection();
            String query = "DELETE FROM NhatKyCauHoi WHERE MaNhatKy = ?";
            ps = conn.prepareStatement(query);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // HÀM 11: Lấy 1 chủ đề để sửa
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // HÀM 12: Cập nhật chủ đề
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
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}