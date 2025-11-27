package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException; // Thêm import này
import java.sql.Statement;
import java.util.ArrayList; // Thêm import này
import java.util.List;     // Thêm import này
import java.util.Map;
import model.Cart;
import model.CartItem;
import model.Order;       // Thêm import này
import model.OrderDetail; // Thêm import này
import model.Product;     // Thêm import này
import model.User;
// BẠN CŨNG THIẾU IMPORT DBContext
import DAO.DBContext;

public class OrderDAO {

    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;

    // ... (Hàm createOrder và getMonthlyRevenue của bạn ở đây)
    // ... (Hàm createOrder, getMonthlyRevenue... của bạn)
    /**
     * HÀM MỚI (Đã Sửa): Lấy tất cả đơn hàng, sắp xếp mới nhất trước.
     */
    public List<model.Order> getAllOrders() {
        List<model.Order> list = new ArrayList<>();
        // Lấy thông tin từ 2 bảng: donhang và nguoidung
        String query = "SELECT d.*, n.HoTen "
                + "FROM donhang d "
                + "JOIN nguoidung n ON d.MaNguoiDung = n.MaNguoiDung "
                + "ORDER BY d.NgayDat DESC";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            while (rs.next()) {
                // Sử dụng constructor rỗng và setter
                model.Order order = new model.Order();

                order.setMaDonHang(rs.getInt("MaDonHang"));
                order.setMaNguoiDung(rs.getInt("MaNguoiDung"));
                order.setTongTien(rs.getDouble("TongTien"));
                order.setHoTenNguoiNhan(rs.getString("HoTenNguoiNhan")); // Tên người nhận
                order.setSdtNguoiNhan(rs.getString("SDTNguoiNhan"));
                order.setDiaChiNhanHang(rs.getString("DiaChiNhanHang"));
                order.setTrangThai(rs.getString("TrangThai"));
                order.setNgayDat(rs.getTimestamp("NgayDat"));

                // [PHẦN SỬA LỖI] Gọi hàm setTenNguoiDat
                order.setTenNguoiDat(rs.getString("HoTen"));

                list.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * HÀM MỚI (Đã Sửa): Lấy 1 đơn hàng theo ID.
     */
    public model.Order getOrderById(int orderId) {
        String query = "SELECT d.*, n.HoTen "
                + "FROM donhang d "
                + "JOIN nguoidung n ON d.MaNguoiDung = n.MaNguoiDung "
                + "WHERE d.MaDonHang = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            if (rs.next()) {
                // Sử dụng constructor rỗng và setter
                model.Order order = new model.Order();

                order.setMaDonHang(rs.getInt("MaDonHang"));
                order.setMaNguoiDung(rs.getInt("MaNguoiDung"));
                order.setTongTien(rs.getDouble("TongTien"));
                order.setHoTenNguoiNhan(rs.getString("HoTenNguoiNhan"));
                order.setSdtNguoiNhan(rs.getString("SDTNguoiNhan"));
                order.setDiaChiNhanHang(rs.getString("DiaChiNhanHang"));
                order.setTrangThai(rs.getString("TrangThai"));
                order.setNgayDat(rs.getTimestamp("NgayDat"));

                // [PHẦN SỬA LỖI] Gọi hàm setTenNguoiDat
                order.setTenNguoiDat(rs.getString("HoTen"));

                return order;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * HÀM MỚI: Lấy chi tiết các sản phẩm trong 1 đơn hàng.
     */
    public List<model.OrderDetail> getOrderDetailsByOrderId(int orderId) {
        List<model.OrderDetail> list = new ArrayList<>();
        String query = "SELECT p.*, ct.SoLuong, ct.DonGia "
                + "FROM chitietdonhang ct "
                + "JOIN sanpham p ON ct.MaSanPham = p.MaSanPham "
                + "WHERE ct.MaDonHang = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            while (rs.next()) {
                // Tạo Product
                Product p = new Product(
                        rs.getInt("MaSanPham"),
                        rs.getString("TenSanPham"),
                        rs.getString("HinhAnh"),
                        rs.getDouble("Gia"),
                        rs.getString("MoTa"),
                        rs.getInt("SoLuongTon"),
                        rs.getInt("MaDanhMuc")
                );
                // Lấy số lượng và giá lúc mua
                int quantity = rs.getInt("SoLuong");
                double price = rs.getDouble("DonGia");

                list.add(new model.OrderDetail(p, quantity, price));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * HÀM MỚI: Cập nhật trạng thái đơn hàng.
     */
    public void updateOrderStatus(int orderId, String status) {
        String query = "UPDATE donhang SET TrangThai = ? WHERE MaDonHang = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
    }

   
    public double getTotalRevenueForMonth(int year, int month) {
        String query = "SELECT SUM(TongTien) AS TongDoanhThu "
                + "FROM donhang "
                + "WHERE YEAR(NgayDat) = ? AND MONTH(NgayDat) = ? "
                + "AND (TrangThai = 'Da giao' OR TrangThai = 'Da Thanh Toan')"; // Chỉ tính đơn thành công
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, year);
            ps.setInt(2, month);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("TongDoanhThu");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
    }

    /**
     * [ĐÃ SỬA] Lấy doanh thu theo TỪNG NGÀY trong tháng (Chỉ tính đơn thành công).
     */
    public java.util.Map<Integer, Double> getDailyRevenueForMonth(int year, int month) {
        java.util.Map<Integer, Double> dailyMap = new java.util.HashMap<>();
        
        String query = "SELECT DAY(NgayDat) AS Ngay, SUM(TongTien) AS DoanhThuNgay "
                + "FROM donhang "
                + "WHERE YEAR(NgayDat) = ? AND MONTH(NgayDat) = ? "
                + "AND (TrangThai = 'Da giao' OR TrangThai = 'Da Thanh Toan') " // Chỉ tính đơn thành công
                + "GROUP BY DAY(NgayDat) "
                + "ORDER BY Ngay ASC";
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, year);
            ps.setInt(2, month);
            rs = ps.executeQuery();

            while (rs.next()) {
                int day = rs.getInt("Ngay");
                double revenue = rs.getDouble("DoanhThuNgay");
                dailyMap.put(day, revenue);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return dailyMap;
    }
     
    public String createOrder(User user, Cart cart, String hoTenGiaoHang, String sdtGiaoHang, String diaChiGiaoHang, String trangThai) {

        // [SỬA ĐỔI] Thêm cột 'NgayDat' và 'TrangThai'
        String insertOrderSQL = "INSERT INTO donhang (MaNguoiDung, TongTien, HoTenNguoiNhan, SDTNguoiNhan, DiaChiNhanHang, TrangThai, NgayDat) VALUES (?, ?, ?, ?, ?, ?, ?)";

        String insertDetailSQL = "INSERT INTO chitietdonhang (MaDonHang, MaSanPham, SoLuong, DonGia) VALUES (?, ?, ?, ?)";
        String updateStockSQL = "UPDATE sanpham SET SoLuongTon = SoLuongTon - ? WHERE MaSanPham = ? AND SoLuongTon >= ?";

        // [MỚI] SQL để xóa các item đã đặt khỏi giỏ hàng DB
        String deleteCartItemSQL = "DELETE FROM giohang WHERE MaNguoiDung = ? AND MaSanPham = ?";

        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // BƯỚC 1: KIỂM TRA VÀ CẬP NHẬT TỒN KHO
            PreparedStatement psUpdateStock = conn.prepareStatement(updateStockSQL);
            for (Map.Entry<Integer, CartItem> entry : cart.getItems().entrySet()) {
                CartItem item = entry.getValue();

                psUpdateStock.setInt(1, item.getQuantity());
                psUpdateStock.setInt(2, item.getProduct().getMaSanPham());
                psUpdateStock.setInt(3, item.getQuantity());

                int rowsAffected = psUpdateStock.executeUpdate();

                if (rowsAffected == 0) {
                    conn.rollback();
                    return "Sản phẩm '" + item.getProduct().getTenSanPham() + "' không đủ hàng trong kho!";
                }
            }
            psUpdateStock.close();

            // BƯỚC 2: TẠO ĐƠN HÀNG
            ps = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, user.getMaNguoiDung());
            ps.setDouble(2, cart.getTotalCartPrice());
            ps.setString(3, hoTenGiaoHang);
            ps.setString(4, sdtGiaoHang);
            ps.setString(5, diaChiGiaoHang);
            ps.setString(6, trangThai); 
            ps.setTimestamp(7, new java.sql.Timestamp(System.currentTimeMillis())); // Lưu NgayDat

            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            int orderId = -1;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

            if (orderId == -1) {
                conn.rollback();
                return "Không thể tạo mã đơn hàng.";
            }

            // BƯỚC 3: THÊM CHI TIẾT ĐƠN HÀNG
            ps = conn.prepareStatement(insertDetailSQL);
            for (Map.Entry<Integer, CartItem> entry : cart.getItems().entrySet()) {
                CartItem item = entry.getValue();
                ps.setInt(1, orderId);
                ps.setInt(2, item.getProduct().getMaSanPham());
                ps.setInt(3, item.getQuantity());
                ps.setDouble(4, item.getProduct().getGia());
                ps.addBatch();
            }
            ps.executeBatch();

            // [MỚI] BƯỚC 4: XÓA CÁC SẢN PHẨM ĐÃ MUA KHỎI GIỎ HÀNG (TRONG CSDL)
            PreparedStatement psDeleteCart = conn.prepareStatement(deleteCartItemSQL);
            for (Integer productId : cart.getItems().keySet()) {
                psDeleteCart.setInt(1, user.getMaNguoiDung());
                psDeleteCart.setInt(2, productId);
                psDeleteCart.addBatch();
            }
            psDeleteCart.executeBatch();
            psDeleteCart.close();

            // Nếu mọi thứ thành công
            conn.commit(); // Xác nhận Transaction
            return null; // Trả về NULL = Thành công

        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return "Lỗi CSDL: " + e.getMessage(); // Trả về lỗi
        } finally {
            closeResources();
        }
    }

    public Order getOrderByIdAndUserID(int maDonHang, int maNguoiDung) {
        String sql = "SELECT MaDonHang, NgayDat, TongTien, TrangThai, HoTenNguoiNhan, SDTNguoiNhan, DiaChiNhanHang "
                + "FROM donhang WHERE MaDonHang = ? AND MaNguoiDung = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, maDonHang);
            ps.setInt(2, maNguoiDung);
            rs = ps.executeQuery();
            if (rs.next()) {
                Order order = new Order( // Dòng này cần 'Order'
                        rs.getInt("MaDonHang"),
                        rs.getTimestamp("NgayDat"),
                        rs.getDouble("TongTien"),
                        rs.getString("TrangThai"),
                        rs.getString("HoTenNguoiNhan"),
                        rs.getString("SDTNguoiNhan"),
                        rs.getString("DiaChiNhanHang")
                );
                return order;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            closeResources();
        }
        return null; // Không tìm thấy
    }

    /**
     * HÀM MỚI (Đã Sửa): Lấy tất cả đơn hàng của MỘT người dùng.
     */
    public List<model.Order> getOrdersByUserId(int userId) {
        List<model.Order> list = new ArrayList<>();
        String query = "SELECT * FROM donhang WHERE MaNguoiDung = ? ORDER BY NgayDat DESC";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                // [SỬA LỖI] Đảm bảo gọi constructor rỗng và setter
                model.Order order = new model.Order();

                order.setMaDonHang(rs.getInt("MaDonHang"));
                order.setMaNguoiDung(rs.getInt("MaNguoiDung"));
                order.setTongTien(rs.getDouble("TongTien"));
                order.setHoTenNguoiNhan(rs.getString("HoTenNguoiNhan"));
                order.setSdtNguoiNhan(rs.getString("SDTNguoiNhan"));
                order.setDiaChiNhanHang(rs.getString("DiaChiNhanHang"));
                order.setTrangThai(rs.getString("TrangThai"));
                order.setNgayDat(rs.getTimestamp("NgayDat"));

                // (Hàm này không cần setTenNguoiDat)
                list.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * HÀM MỚI (Bảo mật, Đã Sửa): Lấy 1 đơn hàng theo ID và ID người dùng.
     */
    public model.Order getOrderByIdForUser(int orderId, int userId) {
        String query = "SELECT * FROM donhang WHERE MaDonHang = ? AND MaNguoiDung = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, orderId);
            ps.setInt(2, userId); // Kiểm tra chính chủ
            rs = ps.executeQuery();
            if (rs.next()) {
                // [SỬA LỖI] Đảm bảo gọi constructor rỗng và setter
                model.Order order = new model.Order();

                order.setMaDonHang(rs.getInt("MaDonHang"));
                order.setMaNguoiDung(rs.getInt("MaNguoiDung"));
                order.setTongTien(rs.getDouble("TongTien"));
                order.setHoTenNguoiNhan(rs.getString("HoTenNguoiNhan"));
                order.setSdtNguoiNhan(rs.getString("SDTNguoiNhan"));
                order.setDiaChiNhanHang(rs.getString("DiaChiNhanHang"));
                order.setTrangThai(rs.getString("TrangThai"));
                order.setNgayDat(rs.getTimestamp("NgayDat"));

                return order;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null; // Trả về null nếu không tìm thấy (hoặc không đúng chủ)
    }

    /**
     * HÀM MỚI: Lấy chi tiết các sản phẩm trong một đơn hàng
     */
    public List<OrderDetail> getOrderDetailsByOrderID(int maDonHang) {
        List<OrderDetail> list = new ArrayList<>(); // Dòng này cần 'List', 'OrderDetail', 'ArrayList'
        String sql = "SELECT sp.MaSanPham, sp.TenSanPham, sp.HinhAnh, ctdh.SoLuong, ctdh.DonGia "
                + "FROM chitietdonhang AS ctdh "
                + "JOIN sanpham AS sp ON ctdh.MaSanPham = sp.MaSanPham "
                + "WHERE ctdh.MaDonHang = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, maDonHang);
            rs = ps.executeQuery();
            while (rs.next()) {
                Product product = new Product( // Dòng này cần 'Product'
                        rs.getInt("MaSanPham"),
                        rs.getString("TenSanPham"),
                        rs.getString("HinhAnh")
                );
                OrderDetail detail = new OrderDetail( // Dòng này cần 'OrderDetail'
                        product,
                        rs.getInt("SoLuong"),
                        rs.getDouble("DonGia")
                );
                list.add(detail);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }
/**
     * HÀM MỚI: Khách hàng tự hủy đơn hàng.
     * Điều kiện: Chỉ hủy được khi trạng thái là 'Dang xu ly'.
     */
    public boolean cancelOrder(int orderId, int userId) {
        // Cập nhật trạng thái thành 'Da huy'
        // Chỉ áp dụng cho đơn hàng của đúng User đó VÀ đang ở trạng thái 'Dang xu ly'
        String query = "UPDATE donhang SET TrangThai = 'Da huy' " +
                       "WHERE MaDonHang = ? AND MaNguoiDung = ? AND TrangThai = 'Dang xu ly'";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            
            int row = ps.executeUpdate();
            return row > 0; // Trả về true nếu hủy thành công
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
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
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
