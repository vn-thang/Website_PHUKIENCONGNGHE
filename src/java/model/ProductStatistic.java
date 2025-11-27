/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;



// Lớp này dùng để chứa dữ liệu thống kê
public class ProductStatistic {
    private String productName;
    private int totalSold;

    public ProductStatistic(String productName, int totalSold) {
        this.productName = productName;
        this.totalSold = totalSold;
    }

    // Getters
    public String getProductName() {
        return productName;
    }

    public int getTotalSold() {
        return totalSold;
    }
}

