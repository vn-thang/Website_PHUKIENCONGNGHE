/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.util.List;
/**
 *
 * @author Thang
 */
public class ChuDeBot {
    private int maChuDe;
    private String tenChuDe;
    private String loaiHanhDong; // 'CHAT' hoặc 'TIM_KIEM'
    private String giaTriPhanHoi;
    private List<String> listTuKhoa;
    public ChuDeBot() {
    }

    public ChuDeBot(int maChuDe, String tenChuDe, String loaiHanhDong, String giaTriPhanHoi) {
        this.maChuDe = maChuDe;
        this.tenChuDe = tenChuDe;
        this.loaiHanhDong = loaiHanhDong;
        this.giaTriPhanHoi = giaTriPhanHoi;
    }

    // Getters
    public int getMaChuDe() { return maChuDe; }
    public String getTenChuDe() { return tenChuDe; }
    public String getLoaiHanhDong() { return loaiHanhDong; }
    public String getGiaTriPhanHoi() { return giaTriPhanHoi; }
    public List<String> getListTuKhoa() { return listTuKhoa; }
    // Setters
    public void setMaChuDe(int maChuDe) { this.maChuDe = maChuDe; }
    public void setTenChuDe(String tenChuDe) { this.tenChuDe = tenChuDe; }
    public void setLoaiHanhDong(String loaiHanhDong) { this.loaiHanhDong = loaiHanhDong; }
    public void setGiaTriPhanHoi(String giaTriPhanHoi) { this.giaTriPhanHoi = giaTriPhanHoi; }
    public void setListTuKhoa(List<String> listTuKhoa) { this.listTuKhoa = listTuKhoa; }
}
