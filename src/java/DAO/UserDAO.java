package DAO;

import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;

    // ... (Các hàm login, signup, getUserByID... của bạn)
    // ... (Các hàm login, signup, getUserByID... của bạn)
    /**
     * HÀM MỚI (ĐÃ SỬA LỖI CONSTRUCTOR): Lấy tất cả người dùng (trừ admin hiện
     * tại).
     */
    public List<User> getAllUsers(int currentAdminId) {
        List<User> list = new ArrayList<>();
        // Lấy tất cả trừ admin đang đăng nhập
        String query = "SELECT * FROM nguoidung WHERE MaNguoiDung != ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, currentAdminId);
            rs = ps.executeQuery();
            while (rs.next()) {

                // [SỬA LỖI] Sử dụng constructor rỗng và các hàm set
                User u = new User();

                // Đảm bảo tên cột ("MaNguoiDung", "HoTen"...) khớp với CSDL của bạn
                u.setMaNguoiDung(rs.getInt("MaNguoiDung"));
                u.setTenDangNhap(rs.getString("TenDangNhap"));
                u.setMatKhau(rs.getString("MatKhau")); // (Có thể bỏ qua không set mật khẩu nếu không cần)
                u.setHoTen(rs.getString("HoTen"));
                u.setEmail(rs.getString("Email"));
                u.setSoDienThoai(rs.getString("SoDienThoai"));
                u.setDiaChi(rs.getString("DiaChi"));
                u.setVaiTro(rs.getString("VaiTro"));

                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * HÀM MỚI: Xóa một người dùng (cần xử lý ràng buộc CSDL cẩn thận).
     */
    public void deleteUser(int userId) {
        // ... (Hàm này giữ nguyên như bước 88) ...
        String query = "DELETE FROM nguoidung WHERE MaNguoiDung = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Không thể xóa tài khoản, có thể do còn đơn hàng liên quan.", e);
        } finally {
            closeResources();
        }
    }

    /**
     * HÀM MỚI: Cập nhật vai trò (user/admin).
     */
    public void updateUserRole(int userId, String role) {
        // ... (Hàm này giữ nguyên như bước 88) ...
        String query = "UPDATE nguoidung SET VaiTro = ? WHERE MaNguoiDung = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, role);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
    }

    // ... (Hàm login không đổi)
    public User login(String username, String password) {
        String query = "SELECT * FROM nguoidung WHERE TenDangNhap = ? AND MatKhau = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("MaNguoiDung"),
                        rs.getString("HoTen"),
                        rs.getString("TenDangNhap"),
                        rs.getString("MatKhau"),
                        rs.getString("Email"),
                        rs.getString("SoDienThoai"),
                        rs.getString("DiaChi"),
                        rs.getString("VaiTro")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }

    public User checkUserExist(String username) {
        String query = "SELECT * FROM nguoidung WHERE TenDangNhap = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new User();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * HÀM MỚI: Kiểm tra xem email đã tồn tại trong CSDL chưa.
     */
    public boolean checkEmailExist(String email) {
        String query = "SELECT * FROM nguoidung WHERE Email = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                // Nếu tìm thấy kết quả, tức là email đã tồn tại
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        // Mặc định trả về false nếu không tìm thấy hoặc có lỗi
        return false;
    }

    // ... (Hàm register không đổi)
    public void register(String hoTen, String username, String password, String email, String sdt, String diaChi) {
        String query = "INSERT INTO nguoidung (HoTen, TenDangNhap, MatKhau, Email, SoDienThoai, DiaChi, VaiTro) VALUES (?, ?, ?, ?, ?, ?, 'user')";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, hoTen);
            ps.setString(2, username);
            ps.setString(3, password);
            ps.setString(4, email);
            ps.setString(5, sdt);
            ps.setString(6, diaChi);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
    }

    public User getUserByEmail(String email) {
        String query = "SELECT * FROM nguoidung WHERE Email = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("MaNguoiDung"),
                        rs.getString("HoTen"), 
                        rs.getString("TenDangNhap"), 
                        rs.getString("MatKhau"),
                        rs.getString("Email"),
                        rs.getString("SoDienThoai"),
                        rs.getString("DiaChi"), 
                        rs.getString("VaiTro"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * HÀM MỚI: Cập nhật mật khẩu cho người dùng.
     */
    public boolean updatePassword(int userId, String newPassword) {
        String query = "UPDATE nguoidung SET MatKhau = ? WHERE MaNguoiDung = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * HÀM MỚI: Cập nhật thông tin cá nhân (không bao gồm mật khẩu).
     *
     * @param user Đối tượng user chứa thông tin mới
     * @return true nếu cập nhật thành công
     */
    public boolean updateProfile(User user) {
        // SỬA LỖI: Tên bảng là "nguoidung" (viết thường)
        String query = "UPDATE nguoidung SET HoTen = ?, Email = ?, SoDienThoai = ?, DiaChi = ? WHERE MaNguoiDung = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, user.getHoTen());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getSoDienThoai());
            ps.setString(4, user.getDiaChi());
            ps.setInt(5, user.getMaNguoiDung());

            int result = ps.executeUpdate();
            return result > 0; // Trả về true nếu có hàng bị ảnh hưởng
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * HÀM MỚI: Kiểm tra xem email đã tồn tại cho người dùng KHÁC chưa.
     *
     * @param email Email cần kiểm tra
     * @param currentUserId ID của người dùng hiện tại
     * @return true nếu email đã được người khác sử dụng
     */
    public boolean checkEmailExistForOtherUser(String email, int currentUserId) {
        // SỬA LỖI: Tên bảng là "nguoidung" (viết thường)
        String query = "SELECT * FROM nguoidung WHERE Email = ? AND MaNguoiDung != ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            ps.setInt(2, currentUserId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return true; // Email tồn tại cho người khác
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false; // Email không tồn tại hoặc chỉ thuộc về user hiện tại
    }

    
    
    // ================================================================
    // CÁC HÀM MỚI CHO CHỨC NĂNG QUÊN MẬT KHẨU (FORGOT PASSWORD)
    // ================================================================

    /**
     * 1. Kiểm tra tài khoản có tồn tại qua Email hay không.
     * Tên hàm: checkAccountByEmail (Thay vì checkEmailExist)
     */
    public boolean checkAccountByEmail(String email) {
        String query = "SELECT MaNguoiDung FROM nguoidung WHERE Email = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                return true; // Email có tồn tại
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * 2. Lưu mã OTP (Token) và cài đặt thời gian hết hạn (ví dụ: 10 phút).
     * Tên hàm: updateRecoveryToken (Thay vì updateResetToken)
     */
    public void updateRecoveryToken(String email, String token) {
        // Cập nhật mã xác thực và set thời gian hết hạn là NOW() + 10 phút
        String query = "UPDATE nguoidung SET MaXacThuc = ?, ThoiGianHetHan = DATE_ADD(NOW(), INTERVAL 10 MINUTE) WHERE Email = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, token);
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
    }

    /**
     * 3. Xác minh mã OTP có đúng và còn hạn sử dụng không.
     * Tên hàm: validateOtp (Thay vì checkToken)
     */
    public boolean validateOtp(String email, String otp) {
        // Kiểm tra 3 điều kiện: Email đúng, Mã đúng, Thời gian chưa hết hạn (> NOW)
        String query = "SELECT MaNguoiDung FROM nguoidung WHERE Email = ? AND MaXacThuc = ? AND ThoiGianHetHan > NOW()";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, otp);
            rs = ps.executeQuery();
            if (rs.next()) {
                return true; // Mã hợp lệ
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * 4. Đặt lại mật khẩu mới và xóa mã OTP cũ.
     * Tên hàm: changePasswordAfterReset (Thay vì updatePassword)
     */
    public void changePasswordAfterReset(String email, String newPassword) {
        String query = "UPDATE nguoidung SET MatKhau = ?, MaXacThuc = NULL, ThoiGianHetHan = NULL WHERE Email = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, newPassword); // Lưu ý: newPassword nên được mã hóa (SHA-256) trước khi truyền vào đây
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
    }
    
    
    private void closeResources() {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
