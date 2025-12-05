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
import model.Product;
import model.Review;
/**
 *
 * @author Thang
 */
public class ReviewDAO {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // 1. Lấy danh sách Review của 1 sản phẩm (Chỉ lấy cái TrangThai = 1)
    public List<Review> getAllReviews(int pid) {
        List<Review> list = new ArrayList<>();
        // [CẬP NHẬT]: Thêm điều kiện r.TrangThai = 1
        String query = "SELECT r.*, a.TenDangNhap FROM DanhGia r " +
                       "JOIN NguoiDung a ON r.MaNguoiDung = a.MaNguoiDung " +
                       "WHERE r.MaSanPham = ? AND r.TrangThai = 1 " + 
                       "ORDER BY r.MaDanhGia DESC";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, pid);
            rs = ps.executeQuery();
            while (rs.next()) {
                // Sử dụng Constructor cũ
                Review r = new Review(
                    rs.getInt("MaDanhGia"),
                    rs.getInt("MaNguoiDung"),
                    rs.getInt("MaSanPham"),
                    rs.getInt("SoSao"),
                    rs.getString("NoiDung"),
                    rs.getDate("NgayDanhGia"),
                    rs.getString("TenDangNhap")
                );
                
                // [MỚI] Set thêm dữ liệu từ 2 cột mới
                r.setTrangThai(rs.getInt("TrangThai"));
                r.setPhanHoi(rs.getString("PhanHoi"));
                
                list.add(r);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 2. Tính điểm sao trung bình (Chỉ tính những đánh giá được hiện)
    public double getAverageRating(int pid) {
        // [CẬP NHẬT]: Thêm TrangThai = 1 để tính điểm chính xác hơn
        String query = "SELECT AVG(CAST(SoSao AS FLOAT)) FROM DanhGia WHERE MaSanPham = ? AND TrangThai = 1";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, pid);
            rs = ps.executeQuery();
            if (rs.next()) {
                return Math.round(rs.getDouble(1) * 10.0) / 10.0;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // 3. Đếm số lần MUA THÀNH CÔNG
    public int countLuotMua(int uID, int pid) {
        // [LƯU Ý]: Kiểm tra kỹ trạng thái 'Da giao' hay 'Đã giao' trong DB của bạn
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

    // 5. Thêm Review mới (Khách hàng)
    public void insertReview(int uID, int pid, int sao, String noiDung) {
        // Mặc định TrangThai = 1 và PhanHoi = NULL (do thiết lập DB)
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

    // =================================================================
    // PHẦN 2: DÀNH CHO ADMIN (QUẢN LÝ) - [MỚI THÊM]
    // =================================================================

    // 6. [ADMIN] Lấy TẤT CẢ đánh giá (Cả ẩn và hiện) để quản lý
    public List<Review> getAllReviewsForAdmin() {
    List<Review> list = new ArrayList<>();

    String query = "SELECT r.*, a.TenDangNhap, p.TenSanPham, p.HinhAnh " +
                   "FROM DanhGia r " +
                   "JOIN NguoiDung a ON r.MaNguoiDung = a.MaNguoiDung " +
                   "JOIN SanPham p ON r.MaSanPham = p.MaSanPham " +
                   "ORDER BY r.NgayDanhGia DESC";

    try {
        conn = new DBContext().getConnection();
        ps = conn.prepareStatement(query);
        rs = ps.executeQuery();

        while (rs.next()) {

            Review r = new Review();
            r.setMaDanhGia(rs.getInt("MaDanhGia"));
            r.setMaNguoiDung(rs.getInt("MaNguoiDung"));
            r.setMaSanPham(rs.getInt("MaSanPham"));
            r.setSoSao(rs.getInt("SoSao"));
            r.setNoiDung(rs.getNString("NoiDung"));
            r.setNgayDanhGia(rs.getDate("NgayDanhGia"));
            r.setTenUser(rs.getString("TenDangNhap"));
            r.setTrangThai(rs.getInt("TrangThai"));
            r.setPhanHoi(rs.getString("PhanHoi"));

            // Set Product
            Product p = new Product();
            p.setMaSanPham(rs.getInt("MaSanPham"));
            p.setTenSanPham(rs.getString("TenSanPham"));
            p.setHinhAnh(rs.getString("HinhAnh"));

            r.setProduct(p);

            list.add(r);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
    // 7. [ADMIN] Trả lời đánh giá & Cập nhật trạng thái (Ẩn/Hiện)
    public void updateReviewAdmin(int maDanhGia, String phanHoi, int trangThai) {
        String query = "UPDATE DanhGia SET PhanHoi = ?, TrangThai = ? WHERE MaDanhGia = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setNString(1, phanHoi);
            ps.setInt(2, trangThai);
            ps.setInt(3, maDanhGia);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 8. [ADMIN] Xóa vĩnh viễn đánh giá (Nếu cần)
    public void deleteReview(int maDanhGia) {
        String query = "DELETE FROM DanhGia WHERE MaDanhGia = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, maDanhGia);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}
