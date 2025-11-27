package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Category;

public class CategoryDAO {
    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;

    /**
     * Lấy tất cả các danh mục từ CSDL.
     * @return Danh sách các đối tượng Category.
     */
    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        // SỬA LỖI: Tên bảng là "danhmuc" (viết thường)
        String query = "SELECT * FROM danhmuc"; 
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Category(
                        rs.getInt("MaDanhMuc"),
                        rs.getString("TenDanhMuc"))
                );
            }
        } catch (SQLException e) {
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
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

