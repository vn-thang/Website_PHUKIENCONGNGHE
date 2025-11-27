/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;



import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Map;
import model.Cart;
import model.CartItem;
import model.Product;
import model.User;

public class CartDAO {
    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;

    /**
     * Lấy giỏ hàng của người dùng từ CSDL.
     * @param userId ID của người dùng
     * @return một đối tượng Cart
     */
    public Cart getCartByUserId(int userId) {
        Cart cart = new Cart();
        String query = "SELECT gh.MaSanPham, gh.SoLuong, sp.TenSanPham, sp.HinhAnh, sp.Gia " +
                       "FROM giohang gh JOIN sanpham sp ON gh.MaSanPham = sp.MaSanPham " +
                       "WHERE gh.MaNguoiDung = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Product product = new Product();
                product.setMaSanPham(rs.getInt("MaSanPham"));
                product.setTenSanPham(rs.getString("TenSanPham"));
                product.setHinhAnh(rs.getString("HinhAnh"));
                product.setGia(rs.getDouble("Gia"));
                
                CartItem item = new CartItem(product, rs.getInt("SoLuong"));
                cart.addItem(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return cart;
    }
    
    /**
     * Lưu hoặc cập nhật một sản phẩm trong giỏ hàng của người dùng vào CSDL.
     * Sử dụng câu lệnh INSERT ... ON DUPLICATE KEY UPDATE để tự động thêm mới hoặc cập nhật.
     * @param userId ID người dùng
     * @param productId ID sản phẩm
     * @param quantity Số lượng
     */
    public void saveOrUpdateItem(int userId, int productId, int quantity) {
        String query = "INSERT INTO giohang (MaNguoiDung, MaSanPham, SoLuong) VALUES (?, ?, ?) " +
                       "ON DUPLICATE KEY UPDATE SoLuong = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            ps.setInt(4, quantity); // Dành cho phần UPDATE
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
    }

    /**
     * Xóa một sản phẩm khỏi giỏ hàng trong CSDL.
     * @param userId ID người dùng
     * @param productId ID sản phẩm
     */
    public void removeItem(int userId, int productId) {
        String query = "DELETE FROM giohang WHERE MaNguoiDung = ? AND MaSanPham = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
    }
    
    /**
     * Xóa toàn bộ giỏ hàng của người dùng (thường dùng sau khi đặt hàng).
     * @param userId ID người dùng
     */
    public void clearCart(int userId) {
        String query = "DELETE FROM giohang WHERE MaNguoiDung = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
    }

    private void closeResources() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

