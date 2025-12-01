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
import model.Review;
/**
 *
 * @author Thang
 */
public class ReviewDAO {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // 1. Lấy danh sách Review của 1 sản phẩm
    public List<Review> getAllReviews(int pid) {
        List<Review> list = new ArrayList<>();
        // Giả sử bảng Account có cột 'user' là tên đăng nhập
        String query = "SELECT r.*, a.TenDangNhap FROM DanhGia r JOIN NguoiDung a ON r.MaNguoiDung = a.MaNguoiDung WHERE r.MaSanPham = ? ORDER BY r.MaDanhGia DESC";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, pid);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Review(
                    rs.getInt("MaDanhGia"),
                    rs.getInt("MaNguoiDung"),
                    rs.getInt("MaSanPham"),
                    rs.getInt("SoSao"),
                    rs.getString("NoiDung"),
                    rs.getDate("NgayDanhGia"),
                    rs.getString("TenDangNhap")
                ));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 2. Tính điểm sao trung bình (VD: 4.5)
    public double getAverageRating(int pid) {
        String query = "SELECT AVG(CAST(SoSao AS FLOAT)) FROM DanhGia WHERE MaSanPham = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, pid);
            rs = ps.executeQuery();
            if (rs.next()) {
                // Làm tròn 1 chữ số thập phân
                return Math.round(rs.getDouble(1) * 10.0) / 10.0;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // 3. Đếm số lần MUA THÀNH CÔNG (Logic cốt lõi)
    public int countLuotMua(int uID, int pid) {
        // [LƯU Ý]: Bạn cần kiểm tra lại cột Status=4 trong DB của bạn có phải là "Hoàn thành" không nhé
        String query = "SELECT COUNT(*) FROM DonHang o " +
                       "JOIN ChiTietDonHang od ON o.MaDonHang = od.MaDonHang " +
                       "WHERE o.MaNguoiDung = ? AND od.MaSanPham = ? AND o.TrangThai = N'Da giao'"; 
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, uID);
            ps.setInt(2, pid);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // 4. Đếm số lần ĐÃ ĐÁNH GIÁ
    public int countLuotDanhGia(int uID, int pid) {
        String query = "SELECT COUNT(*) FROM DanhGia WHERE MaNguoiDung = ? AND MaSanPham = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, uID);
            ps.setInt(2, pid);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // 5. Thêm Review mới
    public void insertReview(int uID, int pid, int sao, String noiDung) {
        String query = "INSERT INTO DanhGia(MaNguoiDung, MaSanPham, SoSao, NoiDung) VALUES (?, ?, ?, ?)";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, uID);
            ps.setInt(2, pid);
            ps.setInt(3, sao);
            ps.setNString(4, noiDung);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}
