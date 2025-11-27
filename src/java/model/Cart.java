/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;



import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Cart {
    private Map<Integer, CartItem> items;   
    
    public Cart() {
        this.items = new HashMap<>();
    }

    public Map<Integer, CartItem> getItems() {
        return items;
    }

    public void setItems(Map<Integer, CartItem> items) {
        this.items = items;
    }

    // Thêm sản phẩm vào giỏ hoặc cập nhật số lượng nếu đã tồn tại
    public void addItem(CartItem item) {
        int productId = item.getProduct().getMaSanPham();
        if (items.containsKey(productId)) {
            // Sản phẩm đã có trong giỏ, tăng số lượng
            CartItem existingItem = items.get(productId);
            existingItem.setQuantity(existingItem.getQuantity() + item.getQuantity());
        } else {
            // Sản phẩm chưa có, thêm mới
            items.put(productId, item);
        }
    }
  // Lấy tổng số lượng sản phẩm trong giỏ
  
    // Cập nhật số lượng sản phẩm
    public void updateItem(int productId, int quantity) {
        if (items.containsKey(productId)) {
            if (quantity > 0) {
                items.get(productId).setQuantity(quantity);
            } else {
                // Nếu số lượng <= 0 thì xóa sản phẩm
                removeItem(productId);
            }
        }
    }
    // Lấy tổng số lượng sản phẩm trong giỏ
    public int getTotalItems() {
        int total = 0;
        // Duyệt qua tất cả các CartItem trong giỏ
        for (CartItem item : items.values()) {
            // Cộng dồn số lượng của từng item
            total += item.getQuantity();
        }
        return total;
    }
    // Xóa sản phẩm khỏi giỏ hàng
    public void removeItem(int productId) {
        items.remove(productId);
    }

    // Tính tổng tiền của toàn bộ giỏ hàng
    public double getTotalCartPrice() {
        double total = 0;
        for (CartItem item : items.values()) {
            total += item.getTotalPrice();
        }
        return total;
    }
}

