package dao;

import dal.DBContext;
import model.Service;
import java.sql.*;
import java.util.*;

public class ServiceDAO extends DBContext {

    public List<Service> getAllServices() {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT ServiceID, ServiceName, Description, Price, Status FROM Services WHERE Status = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Service s = new Service();
                s.setServiceId(rs.getInt("ServiceID"));
                s.setServiceName(rs.getString("ServiceName"));
                s.setDescription(rs.getString("Description"));
                s.setPrice(rs.getBigDecimal("Price"));
                s.setStatus(rs.getBoolean("Status"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Service getServiceById(int id) {
        String sql = "SELECT * FROM Services WHERE ServiceID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Service(
                        rs.getInt("ServiceID"),
                        rs.getString("ServiceName"),
                        rs.getString("Description"),
                        rs.getBigDecimal("Price"),
                        rs.getBoolean("Status")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insertService(Service s) {
        String sql = "INSERT INTO Services (ServiceName, Description, Price, Status) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, s.getServiceName());
            ps.setString(2, s.getDescription());
            ps.setBigDecimal(3, s.getPrice());
            ps.setBoolean(4, s.isStatus());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateService(Service s) {
        String sql = "UPDATE Services SET ServiceName = ?, Description = ?, Price = ?, Status = ? WHERE ServiceID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, s.getServiceName());
            ps.setString(2, s.getDescription());
            ps.setBigDecimal(3, s.getPrice());
            ps.setBoolean(4, s.isStatus());
            ps.setInt(5, s.getServiceId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xoá dịch vụ theo ID
    public void deleteService(int id) {
        String sql = "DELETE FROM Services WHERE ServiceID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy danh sách dịch vụ có phân trang
    public List<Service> getServicesByPage(int page, int pageSize) {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT * FROM Services ORDER BY ServiceID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Service s = new Service(
                        rs.getInt("ServiceID"),
                        rs.getString("ServiceName"),
                        rs.getString("Description"),
                        rs.getBigDecimal("Price"),
                        rs.getBoolean("Status")
                );
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm tổng số dịch vụ
    public int countServices() {
        String sql = "SELECT COUNT(*) FROM Services";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy toàn bộ, kể cả dịch vụ ngừng hoạt động (tuỳ chọn)
    public List<Service> getAllIncludingInactive() {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT * FROM Services ORDER BY ServiceID";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Service s = new Service(
                        rs.getInt("ServiceID"),
                        rs.getString("ServiceName"),
                        rs.getString("Description"),
                        rs.getBigDecimal("Price"),
                        rs.getBoolean("Status")
                );
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Service> searchSortServices(String keyword, String sort) {
        List<Service> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Services WHERE 1=1 ");

        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND ServiceName LIKE ? ");
        }

        switch (sort) {
            case "name_asc":
                sql.append("ORDER BY ServiceName ASC ");
                break;
            case "price_asc":
                sql.append("ORDER BY Price ASC ");
                break;
            case "price_desc":
                sql.append("ORDER BY Price DESC ");
                break;
            default:
                sql.append("ORDER BY ServiceID ASC ");
                break;
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(paramIndex++, "%" + keyword + "%");
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Service s = new Service(
                        rs.getInt("ServiceID"),
                        rs.getString("ServiceName"),
                        rs.getString("Description"),
                        rs.getBigDecimal("Price"),
                        rs.getBoolean("Status")
                );
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Integer> getServiceUsageStatistics() {
        Map<String, Integer> stats = new LinkedHashMap<>();
        String sql = "SELECT s.ServiceName, COUNT(a.AppointmentID) AS UsageCount "
                + "FROM Services s LEFT JOIN Appointments a ON s.ServiceID = a.ServiceID "
                + "GROUP BY s.ServiceName ORDER BY s.ServiceName";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                stats.put(rs.getString("ServiceName"), rs.getInt("UsageCount"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    public List<Map<String, Object>> getServiceUsageStatisticsFull() {
        List<Map<String, Object>> stats = new ArrayList<>();
        String sql = "SELECT s.ServiceName, s.Status, COUNT(a.AppointmentID) AS UsageCount "
                + "FROM Services s LEFT JOIN Appointments a ON s.ServiceID = a.ServiceID "
                + "GROUP BY s.ServiceName, s.Status ORDER BY s.ServiceName";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("name", rs.getString("ServiceName"));
                item.put("count", rs.getInt("UsageCount"));
                item.put("status", rs.getBoolean("Status"));
                stats.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }
}
