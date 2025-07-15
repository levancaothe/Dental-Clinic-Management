package dao;

import dal.DBContext;
import model.Notification;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO extends DBContext {

    //Thêm mới một thông báo
    public void insertNotification(Notification noti) {
        String sql = "INSERT INTO Notifications (UserID, Title, Message, CreatedAt, IsRead, IsSentEmail) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, noti.getUserId());
            ps.setString(2, noti.getTitle());
            ps.setString(3, noti.getMessage());
            ps.setTimestamp(4, new Timestamp(noti.getCreatedAt().getTime()));
            ps.setBoolean(5, noti.isRead());
            ps.setBoolean(6, noti.isSentEmail());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    //Lấy tất cả thông báo của user
    public List<Notification> getAllByUserId(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE UserID = ? ORDER BY CreatedAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractNotification(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //Lấy thông báo chưa đọc
    public List<Notification> getUnreadByUserId(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE UserID = ? AND IsRead = 0 ORDER BY CreatedAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractNotification(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    //Đánh dấu tất cả là đã đọc
    public void markAllAsRead(int userId) {
        String sql = "UPDATE Notifications SET IsRead = 1 WHERE UserID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    //Đánh dấu một thông báo là đã đọc
    public void markAsReadById(int notificationId, int userId) {
        String sql = "UPDATE Notifications SET IsRead = 1 WHERE NotificationID = ? AND UserID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //Đếm số lượng thông báo chưa đọc
    public int countUnreadByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM Notifications WHERE UserID = ? AND IsRead = 0";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    //Hàm hỗ trợ tái sử dụng tạo Notification từ ResultSet
    private Notification extractNotification(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setNotificationId(rs.getInt("NotificationID"));
        n.setUserId(rs.getInt("UserID"));
        n.setTitle(rs.getString("Title"));
        n.setMessage(rs.getString("Message"));
        n.setCreatedAt(rs.getTimestamp("CreatedAt"));
        n.setIsRead(rs.getBoolean("IsRead"));
        n.setIsSentEmail(rs.getBoolean("IsSentEmail"));
        return n;
    }
}
