/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;





import model.Product;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ProductStatistic;

public class ProductDAO {

    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;
/**
     * HÀM MỚI (Cho Admin): Tìm kiếm sản phẩm theo tên.
     */
    public List<Product> searchProductsByNameForAdmin(String txtSearch) {
        List<Product> list = new ArrayList<>();
        String query = "SELECT * FROM sanpham WHERE TenSanPham LIKE ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, "%" + txtSearch + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(
                        rs.getInt("MaSanPham"),
                        rs.getString("TenSanPham"),
                        rs.getString("HinhAnh"),
                        rs.getDouble("Gia"),
                        rs.getString("MoTa"),
                        rs.getInt("SoLuongTon"),
                        rs.getInt("MaDanhMuc")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }
    /**
     * HÀM MỚI (Cho Admin): Lọc sản phẩm theo danh mục.
     */
    public List<Product> getProductsByCategoryForAdmin(String cid) {
        List<Product> list = new ArrayList<>();
        String query = "SELECT * FROM sanpham WHERE MaDanhMuc = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, cid);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(
                        rs.getInt("MaSanPham"),
                        rs.getString("TenSanPham"),
                        rs.getString("HinhAnh"),
                        rs.getDouble("Gia"),
                        rs.getString("MoTa"),
                        rs.getInt("SoLuongTon"),
                        rs.getInt("MaDanhMuc")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }
    /**
     * Lấy tất cả sản phẩm từ database.
     * @return Danh sách các sản phẩm.
     */
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String query = "SELECT * FROM SanPham";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product(
                    rs.getInt("MaSanPham"),
                    rs.getString("TenSanPham"),
                    rs.getString("HinhAnh"),
                    rs.getDouble("Gia"),
                    rs.getString("MoTa"),
                    rs.getInt("SoLuongTon"),
                    rs.getInt("MaDanhMuc")
                );
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }
public List<ProductStatistic> getProductStatistics() {
        List<ProductStatistic> list = new ArrayList<>();
        
        // Câu lệnh SQL này JOIN bảng sản phẩm và chi tiết đơn hàng,
        // sau đó GROUP BY theo tên sản phẩm và TÍNH TỔNG số lượng đã bán
        String query = "SELECT sp.TenSanPham, SUM(ct.SoLuong) AS TongDaBan " +
                       "FROM sanpham sp " +
                       "JOIN chitietdonhang ct ON sp.MaSanPham = ct.MaSanPham " +
                       "GROUP BY sp.TenSanPham " +
                       "ORDER BY TongDaBan DESC"; // Sắp xếp giảm dần
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                String productName = rs.getString("TenSanPham");
                int totalSold = rs.getInt("TongDaBan");
                list.add(new ProductStatistic(productName, totalSold));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(); // Đảm bảo bạn đã có hàm closeResources() trong DAO
        }
        return list;
    }
// ... (Hàm getProductStatistics (cũ) của bạn ở đây)

    /**
     * HÀM MỚI: Lấy dữ liệu thống kê sản phẩm bán chạy THEO THÁNG/NĂM.
     * @param year Năm cần thống kê
     * @param month Tháng cần thống kê
     * @return Danh sách ProductStatistic
     */
    public List<ProductStatistic> getProductStatisticsByMonth(int year, int month) {
        List<ProductStatistic> list = new ArrayList<>();
        
        // Câu lệnh SQL này JOIN 3 bảng: sanpham, chitietdonhang, và donhang
        // để lọc theo NgayDat
        String query = "SELECT sp.TenSanPham, SUM(ct.SoLuong) AS TongDaBan " +
                       "FROM sanpham sp " +
                       "JOIN chitietdonhang ct ON sp.MaSanPham = ct.MaSanPham " +
                       "JOIN donhang dh ON ct.MaDonHang = dh.MaDonHang " + // Join với bảng đơn hàng
                       "WHERE YEAR(dh.NgayDat) = ? AND MONTH(dh.NgayDat) = ? " + // Lọc theo tháng/năm
                       "GROUP BY sp.TenSanPham " +
                       "ORDER BY TongDaBan DESC";
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, year);
            ps.setInt(2, month);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                String productName = rs.getString("TenSanPham");
                int totalSold = rs.getInt("TongDaBan");
                list.add(new ProductStatistic(productName, totalSold));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }


   public void updateProduct(Product p) {
        String query = "UPDATE SanPham SET TenSanPham = ?, HinhAnh = ?, Gia = ?, MoTa = ?, SoLuongTon = ?, MaDanhMuc = ? WHERE MaSanPham = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            // Gán giá trị cho các cột cần cập nhật
            ps.setString(1, p.getTenSanPham());
            ps.setString(2, p.getHinhAnh());
            ps.setDouble(3, p.getGia());
            ps.setString(4, p.getMoTa());
            ps.setInt(5, p.getSoLuongTon());
            ps.setInt(6, p.getMaDanhMuc());
            // Gán giá trị cho điều kiện WHERE để đảm bảo cập nhật đúng sản phẩm
            ps.setInt(7, p.getMaSanPham());
            // Thực thi câu lệnh
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public Product getProductByID(int id) {
        String query = "SELECT * FROM SanPham WHERE MaSanPham = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                 return new Product(
                    rs.getInt("MaSanPham"),
                    rs.getString("TenSanPham"),
                    rs.getString("HinhAnh"),
                    rs.getDouble("Gia"),
                    rs.getString("MoTa"),
                    rs.getInt("SoLuongTon"),
                    rs.getInt("MaDanhMuc")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }
    public void deleteProduct(String pid) {
        String query = "DELETE FROM SanPham WHERE MaSanPham = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            // Gán ID sản phẩm cần xóa vào câu lệnh
            ps.setString(1, pid);
            // Thực thi câu lệnh
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
 public void insertProduct(Product p) {
        // Câu lệnh SQL INSERT với các tham số (?) để tránh lỗi SQL Injection
        String query = "INSERT INTO SanPham (TenSanPham, HinhAnh, Gia, MoTa, SoLuongTon, MaDanhMuc) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            // 1. Mở kết nối đến CSDL
            conn = new DBContext().getConnection();
            // 2. Chuẩn bị câu lệnh SQL
            ps = conn.prepareStatement(query);
            // 3. Gán giá trị cho từng tham số (?) theo đúng thứ tự
            ps.setString(1, p.getTenSanPham());
            ps.setString(2, p.getHinhAnh());
            ps.setDouble(3, p.getGia());
            ps.setString(4, p.getMoTa());
            ps.setInt(5, p.getSoLuongTon());
            ps.setInt(6, p.getMaDanhMuc());
            // 4. Thực thi câu lệnh để thêm dữ liệu vào bảng
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace(); // In ra lỗi nếu có
        }
    }
  public List<ProductStatistic> getProductSalesStatistics() {
        // Khởi tạo một danh sách rỗng để chứa kết quả
        List<ProductStatistic> list = new ArrayList<>();
        
        // Câu lệnh SQL để thống kê:
        // 1. JOIN bảng SanPham và ChiTietDonHang qua MaSanPham.
        // 2. SUM(ct.SoLuong) để tính tổng số lượng bán ra của mỗi sản phẩm.
        // 3. GROUP BY sp.MaSanPham để nhóm theo từng sản phẩm.
        // 4. ORDER BY TongSoLuongBanRa DESC để sắp xếp sản phẩm bán chạy nhất lên đầu.
        String query = "SELECT sp.TenSanPham, SUM(ct.SoLuong) AS TongSoLuongBanRa " +
                       "FROM SanPham sp " +
                       "JOIN ChiTietDonHang ct ON sp.MaSanPham = ct.MaSanPham " +
                       "GROUP BY sp.MaSanPham, sp.TenSanPham " +
                       "ORDER BY TongSoLuongBanRa DESC";
        try {
            // Mở kết nối
            conn = new DBContext().getConnection();
            // Chuẩn bị và thực thi câu lệnh
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            
            // Lặp qua từng dòng kết quả trả về
            while (rs.next()) {
                // Tạo đối tượng ProductStatistic từ dữ liệu đọc được và thêm vào danh sách
                list.add(new ProductStatistic(
                        rs.getString("TenSanPham"),
                        rs.getInt("TongSoLuongBanRa")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra console nếu có sự cố
        }
        // Trả về danh sách kết quả
        return list;
    }
    // Đóng các tài nguyên kết nối
   

     /**
     * SỬA LỖI (MySQL): Lấy TẤT CẢ sản phẩm THEO TRANG.
     */
    public List<Product> getProductsWithPagination(int offset, int limit) {
        List<Product> list = new ArrayList<>();
        // Cú pháp MySQL
        String query = "SELECT * FROM sanpham ORDER BY MaSanPham LIMIT ? OFFSET ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, limit);  // LIMIT
            ps.setInt(2, offset); // OFFSET
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(rs.getInt("MaSanPham"),
                        rs.getString("TenSanPham"),
                        rs.getString("HinhAnh"),
                        rs.getDouble("Gia"),
                        rs.getString("MoTa"),
                        rs.getInt("SoLuongTon"),
                        rs.getInt("MaDanhMuc")));
            }
        } catch (Exception e) { e.printStackTrace(); } 
        finally { closeResources(); }
        return list;
    }

    /**
     * SỬA LỖI (MySQL): Lấy sản phẩm THEO DANH MỤC và THEO TRANG.
     */
    public List<Product> getProductsByCategoryId(String categoryId, int offset, int limit) {
        List<Product> list = new ArrayList<>();
        // Cú pháp MySQL
        String query = "SELECT * FROM sanpham WHERE MaDanhMuc = ? ORDER BY MaSanPham LIMIT ? OFFSET ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, categoryId);
            ps.setInt(2, limit);    // LIMIT
            ps.setInt(3, offset);   // OFFSET
             rs = ps.executeQuery();
            while (rs.next()) {
                 list.add(new Product(rs.getInt("MaSanPham"),
                        rs.getString("TenSanPham"),
                        rs.getString("HinhAnh"),
                        rs.getDouble("Gia"),
                        rs.getString("MoTa"),
                        rs.getInt("SoLuongTon"),
                        rs.getInt("MaDanhMuc")));
            }
        } catch (Exception e) { e.printStackTrace(); } 
        finally { closeResources(); }
        return list;
    }
    
    /**
     * SỬA LỖI (MySQL): Lấy sản phẩm THEO TÌM KIẾM và THEO TRANG.
     */
    public List<Product> searchProductsByName(String searchQuery, int offset, int limit) {
        List<Product> list = new ArrayList<>();
        // Cú pháp MySQL
        String query = "SELECT * FROM sanpham WHERE TenSanPham LIKE ? ORDER BY MaSanPham LIMIT ? OFFSET ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, "%" + searchQuery + "%");
            ps.setInt(2, limit);    // LIMIT
            ps.setInt(3, offset);   // OFFSET
             rs = ps.executeQuery();
            while (rs.next()) {
                 list.add(new Product(rs.getInt("MaSanPham"),
                        rs.getString("TenSanPham"),
                        rs.getString("HinhAnh"),
                        rs.getDouble("Gia"),
                        rs.getString("MoTa"),
                        rs.getInt("SoLuongTon"),
                        rs.getInt("MaDanhMuc")));
            }
        } catch (Exception e) { e.printStackTrace(); } 
        finally { closeResources(); }
        return list;
    }

     public Product getProductByID(String id) {
        try {
            int intId = Integer.parseInt(id);
            return getProductByID(intId); // Gọi lại hàm gốc với kiểu int
        } catch (NumberFormatException e) {
            // Trường hợp id không phải là một số hợp lệ
            System.err.println("Lỗi chuyển đổi ID sản phẩm: " + e.getMessage());
            return null;
        }
    }
    
     
     /**
 * HÀM MỚI 1: Đếm tổng số sản phẩm (cho trang "Tất cả sản phẩm").
 */
public int getTotalProductCount() {
    String sql = "SELECT COUNT(*) FROM sanpham";
    try {
        conn = DBContext.getConnection();
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1); // Trả về giá trị của cột COUNT(*)
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        closeResources();
    }
    return 0;
}



/**
 * HÀM MỚI 3: Đếm tổng số sản phẩm THEO DANH MỤC.
 */
public int getTotalProductCountByCid(String categoryId) {
    String sql = "SELECT COUNT(*) FROM sanpham WHERE MaDanhMuc = ?";
    try {
        conn = DBContext.getConnection();
        ps = conn.prepareStatement(sql);
        ps.setString(1, categoryId);
        rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        closeResources();
    }
    return 0;
}

/**
 * HÀM MỚI 4: Lấy sản phẩm THEO DANH MỤC có phân trang.
 */
public List<Product> getRelatedProducts(int categoryId, int currentProductId, int limit) {
        List<Product> list = new ArrayList<>();
        // SỬA LỖI: Tên bảng là "sanpham" (viết thường)
        String query = "SELECT * FROM sanpham WHERE MaDanhMuc = ? AND MaSanPham != ? LIMIT ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, categoryId);
            ps.setInt(2, currentProductId);
            ps.setInt(3, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(rs.getInt("MaSanPham"),
                        rs.getString("TenSanPham"),
                        rs.getString("HinhAnh"),
                        rs.getDouble("Gia"),
                        rs.getString("MoTa"),
                        rs.getInt("SoLuongTon"),
                        rs.getInt("MaDanhMuc")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(); // Đảm bảo bạn có hàm này
        }
        return list;
    }
public List<Product> getProductsByCidWithPagination(String categoryId, int offset, int limit) {
    List<Product> list = new ArrayList<>();
    String sql = "SELECT * FROM sanpham WHERE MaDanhMuc = ? LIMIT ? OFFSET ?";
    try {
        conn = DBContext.getConnection();
        ps = conn.prepareStatement(sql);
        ps.setString(1, categoryId);
        ps.setInt(2, limit);
        ps.setInt(3, offset);
        rs = ps.executeQuery();
        while (rs.next()) {
            list.add(new Product(
                    rs.getInt("MaSanPham"), rs.getString("TenSanPham"), rs.getString("HinhAnh"),
                    rs.getDouble("Gia"), rs.getString("MoTa"), rs.getInt("SoLuongTon"),
                    rs.getInt("MaDanhMuc")
            ));
        }
} catch (Exception e) {
        e.printStackTrace();
    } finally {
        closeResources();
    }
    return list;
}

/**
 * HÀM MỚI 5: Đếm tổng số sản phẩm THEO TÌM KIẾM.
 */
public int getTotalProductCountBySearch(String searchQuery) {
    String sql = "SELECT COUNT(*) FROM sanpham WHERE TenSanPham LIKE ?";
    try {
        conn = DBContext.getConnection();
        ps = conn.prepareStatement(sql);
        ps.setString(1, "%" + searchQuery + "%");
        rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        closeResources();
    }
    return 0;
}

/**
 * HÀM MỚI 6: Lấy sản phẩm THEO TÌM KIẾM có phân trang.
 */
public List<Product> getProductsBySearchWithPagination(String searchQuery, int offset, int limit) {
    List<Product> list = new ArrayList<>();
    String sql = "SELECT * FROM sanpham WHERE TenSanPham LIKE ? LIMIT ? OFFSET ?";
    try {
        conn = DBContext.getConnection();
        ps = conn.prepareStatement(sql);
        ps.setString(1, "%" + searchQuery + "%");
        ps.setInt(2, limit);
        ps.setInt(3, offset);
        rs = ps.executeQuery();
        while (rs.next()) {
            list.add(new Product(
                    rs.getInt("MaSanPham"), rs.getString("TenSanPham"), rs.getString("HinhAnh"),
                    rs.getDouble("Gia"), rs.getString("MoTa"), rs.getInt("SoLuongTon"),
                    rs.getInt("MaDanhMuc")
            ));
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        closeResources();
    }
    return list;
}
/**
     * HÀM MỚI: Lấy Top N sản phẩm BÁN CHẠY NHẤT (dựa vào tổng số lượng).
     * @param limit Số lượng sản phẩm
     * @return Danh sách sản phẩm
     */
    public List<Product> getTopBestSellingProducts(int limit) {
        List<Product> list = new ArrayList<>();
        
        // SỬA LỖI: Đảm bảo tên bảng là "sanpham" và "chitietdonhang" (viết thường)
        String query = "SELECT sp.*, SUM(ct.SoLuong) AS TongDaBan " +
                       "FROM sanpham sp " +
                       "JOIN chitietdonhang ct ON sp.MaSanPham = ct.MaSanPham " +
                       "GROUP BY sp.MaSanPham, sp.TenSanPham, sp.HinhAnh, sp.Gia, sp.MoTa, sp.SoLuongTon, sp.MaDanhMuc " +
                       "ORDER BY TongDaBan DESC " +
                       "LIMIT ?";
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(rs.getInt("MaSanPham"),
                        rs.getString("TenSanPham"),
                        rs.getString("HinhAnh"),
                        rs.getDouble("Gia"),
                        rs.getString("MoTa"),
                        rs.getInt("SoLuongTon"),
                        rs.getInt("MaDanhMuc")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }
    // ... (Các hàm cũ giữ nguyên)

    // =================================================================
    // [MỚI] HÀM LỌC TỔNG HỢP (DANH MỤC + TÊN + GIÁ) - ĐẾM TỔNG SỐ
    // =================================================================
    public int countFilteredProducts(String categoryId, String search, String priceFrom, String priceTo) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM sanpham WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (categoryId != null && !categoryId.isEmpty() && !categoryId.equals("all")) {
            sql.append(" AND MaDanhMuc = ?");
            params.add(categoryId);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND TenSanPham LIKE ?");
            params.add("%" + search + "%");
        }
        if (priceFrom != null && !priceFrom.isEmpty()) {
            sql.append(" AND Gia >= ?");
            params.add(Double.parseDouble(priceFrom));
        }
        if (priceTo != null && !priceTo.isEmpty()) {
            sql.append(" AND Gia <= ?");
            params.add(Double.parseDouble(priceTo));
        }

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
    }

    // =================================================================
    // [MỚI] HÀM LỌC TỔNG HỢP (DANH MỤC + TÊN + GIÁ) - LẤY DỮ LIỆU & PHÂN TRANG
    // =================================================================
    public List<Product> filterProducts(String categoryId, String search, String priceFrom, String priceTo, int offset, int limit) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM sanpham WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // 1. Xây dựng điều kiện WHERE
        if (categoryId != null && !categoryId.isEmpty() && !categoryId.equals("all")) {
            sql.append(" AND MaDanhMuc = ?");
            params.add(categoryId);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND TenSanPham LIKE ?");
            params.add("%" + search + "%");
        }
        if (priceFrom != null && !priceFrom.isEmpty()) {
            sql.append(" AND Gia >= ?");
            params.add(Double.parseDouble(priceFrom));
        }
        if (priceTo != null && !priceTo.isEmpty()) {
            sql.append(" AND Gia <= ?");
            params.add(Double.parseDouble(priceTo));
        }

        // 2. Thêm Phân trang (MySQL)
        // Nếu bạn dùng SQL Server, hãy đổi đoạn này thành OFFSET... FETCH NEXT...
        sql.append(" ORDER BY MaSanPham DESC LIMIT ? OFFSET ?"); 
        params.add(limit);
        params.add(offset);

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(rs.getInt("MaSanPham"),
                        rs.getString("TenSanPham"),
                        rs.getString("HinhAnh"),
                        rs.getDouble("Gia"),
                        rs.getString("MoTa"),
                        rs.getInt("SoLuongTon"),
                        rs.getInt("MaDanhMuc")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }
 private void closeResources() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}


