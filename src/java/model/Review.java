/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author Thang
 */
public class Review {
    private int maDanhGia;
    private int maNguoiDung;
    private int maSanPham;
    private int soSao;
    private String noiDung;
    private Date ngayDanhGia;
    private String tenUser; // Để hiện tên người bình luận (Join bảng)

    public Review() {}

    public Review(int maDanhGia, int maAccount, int maSanPham, int soSao, String noiDung, Date ngayDanhGia, String tenUser) {
        this.maDanhGia = maDanhGia;
        this.maNguoiDung = maAccount;
        this.maSanPham = maSanPham;
        this.soSao = soSao;
        this.noiDung = noiDung;
        this.ngayDanhGia = ngayDanhGia;
        this.tenUser = tenUser;
    }

    // Getters
    public int getMaDanhGia() { return maDanhGia; }
    public int getMaAccount() { return maNguoiDung; }
    public int getMaSanPham() { return maSanPham; }
    public int getSoSao() { return soSao; }
    public String getNoiDung() { return noiDung; }
    public Date getNgayDanhGia() { return ngayDanhGia; }
    public String getTenUser() { return tenUser; }

    // Setters
    public void setMaDanhGia(int maDanhGia) { this.maDanhGia = maDanhGia; }
    public void setMaAccount(int maAccount) { this.maNguoiDung = maAccount; }
    public void setMaSanPham(int maSanPham) { this.maSanPham = maSanPham; }
    public void setSoSao(int soSao) { this.soSao = soSao; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }
    public void setNgayDanhGia(Date ngayDanhGia) { this.ngayDanhGia = ngayDanhGia; }
    public void setTenUser(String tenUser) { this.tenUser = tenUser; }
}
