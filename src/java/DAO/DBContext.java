/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    // Thay đổi các thông số này cho phù hợp với cấu hình XAMPP của bạn
    private static final String HOSTNAME = "localhost";
    private static final String PORT = "3306";
    private static final String DBNAME = "phukiencongnghe"; // Tên database bạn đã tạo
    private static final String USERNAME = "root";
    private static final String PASSWORD = ""; // Mật khẩu root của XAMPP mặc định là rỗng

    /**
     * Lấy kết nối đến cơ sở dữ liệu MySQL.
     * @return một đối tượng Connection.
     * @throws SQLException
     */
    public static Connection getConnection() throws SQLException {
        Connection conn = null;
        try {
            // Nạp driver MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Chuỗi kết nối
            String url = "jdbc:mysql://" + HOSTNAME + ":" + PORT + "/" + DBNAME;
            
            // Tạo kết nối
            conn = DriverManager.getConnection(url, USERNAME, PASSWORD);
            
            System.out.println("Kết nối CSDL thành công!");

        } catch (ClassNotFoundException e) {
            System.err.println("Không tìm thấy MySQL JDBC Driver!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Kết nối CSDL thất bại!");
            e.printStackTrace();
            throw e; // Ném lại exception để lớp gọi nó có thể xử lý
        }
        return conn;
    }
    
    // Bạn có thể thêm một phương thức main để test kết nối ngay tại đây
    public static void main(String[] args) {
        try {
            Connection conn = getConnection();
            if (conn != null) {
                System.out.println("Test kết nối thành công.");
                conn.close();
            }
        } catch (SQLException e) {
            System.err.println("Test kết nối thất bại.");
        }
    }
}

