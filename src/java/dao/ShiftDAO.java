package dao;

import dal.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Shift;
import model.User;

public class ShiftDAO extends DBContext {

    // Thêm ca trực
    public void insertShift(Shift s) {
        String sql = "INSERT INTO Shifts (DoctorID, StartDateTime, EndDateTime, Description) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, s.getDoctorId());
            ps.setTimestamp(2, s.getStartDateTime());
            ps.setTimestamp(3, s.getEndDateTime());
            ps.setString(4, s.getDescription());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Cập nhật ca trực
    public void updateShift(Shift s) {
        String sql = "UPDATE Shifts SET DoctorID = ?, StartDateTime = ?, EndDateTime = ?, Description = ? WHERE ShiftID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, s.getDoctorId());
            ps.setTimestamp(2, s.getStartDateTime());
            ps.setTimestamp(3, s.getEndDateTime());
            ps.setString(4, s.getDescription());
            ps.setInt(5, s.getShiftId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Xoá ca trực theo ID
    public void deleteShift(int id) {
        String sql = "DELETE FROM Shifts WHERE ShiftID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Lấy toàn bộ ca trực kèm tên bác sĩ
    public List<Shift> getAllShiftsWithDoctorName() {
        List<Shift> list = new ArrayList<>();
        String sql = "SELECT s.ShiftID, s.DoctorID, u.FullName, s.StartDateTime, s.EndDateTime, s.Description "
                + "FROM Shifts s JOIN Users u ON s.DoctorID = u.UserID ORDER BY s.StartDateTime DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Shift s = new Shift(
                        rs.getInt("ShiftID"),
                        rs.getInt("DoctorID"),
                        rs.getTimestamp("StartDateTime"),
                        rs.getTimestamp("EndDateTime"),
                        rs.getString("Description")
                );
                s.setDoctorName(rs.getString("FullName")); // ánh xạ tên bác sĩ
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy ca trực theo ID
    public Shift getShiftById(int id) {
        String sql = "SELECT * FROM Shifts WHERE ShiftID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Shift(
                        rs.getInt("ShiftID"),
                        rs.getInt("DoctorID"),
                        rs.getTimestamp("StartDateTime"),
                        rs.getTimestamp("EndDateTime"),
                        rs.getString("Description")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
