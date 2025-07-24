package dao;

import dal.DBContext;
import model.Appointment;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;

public class AppointmentDAO extends DBContext {

    public void createAppointment(Appointment app) {
        String sql = "INSERT INTO Appointments (CustomerID, DoctorID, ServiceID, AppointmentDate, Status, Note) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, app.getCustomerId());
            ps.setInt(2, app.getDoctorId());
            ps.setInt(3, app.getServiceId());
            ps.setTimestamp(4, new Timestamp(app.getAppointmentDate().getTime()));
            ps.setInt(5, app.getStatus());
            ps.setString(6, app.getNote());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean isDoctorBusy(int doctorId, java.util.Date appointmentDate) {
        String sql = "SELECT COUNT(*) FROM Appointments "
                + "WHERE DoctorID = ? AND CAST(AppointmentDate AS DATE) = CAST(? AS DATE) "
                + "AND ABS(DATEDIFF(MINUTE, AppointmentDate, ?)) < 30 AND Status = 0";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            Timestamp ts = new Timestamp(appointmentDate.getTime());
            ps.setInt(1, doctorId);
            ps.setTimestamp(2, ts);
            ps.setTimestamp(3, ts);
            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //Trả về các lịch ĐANG XỬ LÝ của bác sĩ trong NGÀY
    public List<Appointment> getAppointmentsOfDoctorInDay(int doctorId, java.util.Date date) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM Appointments WHERE DoctorID = ? AND CAST(AppointmentDate AS DATE) = CAST(? AS DATE) AND Status = 0";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ps.setTimestamp(2, new Timestamp(date.getTime()));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractAppointment(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy các lịch khám trùng ngày và giờ với bác sĩ
    public List<Appointment> getAppointmentsByDoctorAndTime(int doctorId, java.util.Date time) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM Appointments "
                + "WHERE DoctorID = ? "
                + "AND CAST(AppointmentDate AS DATE) = CAST(? AS DATE) "
                + "AND ABS(DATEDIFF(MINUTE, AppointmentDate, ?)) < 30";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            Timestamp ts = new Timestamp(time.getTime());
            ps.setInt(1, doctorId);
            ps.setTimestamp(2, ts);
            ps.setTimestamp(3, ts);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment a = new Appointment();
                a.setAppointmentId(rs.getInt("AppointmentID"));
                a.setCustomerId(rs.getInt("CustomerID"));
                a.setDoctorId(rs.getInt("DoctorID"));
                a.setServiceId(rs.getInt("ServiceID"));
                a.setAppointmentDate(rs.getTimestamp("AppointmentDate"));
                a.setStatus(rs.getInt("Status"));
                a.setNote(rs.getString("Note"));
                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //Trả về true nếu ca trùng thời điểm là "Hoàn tất" hoặc không có
    public boolean isDoctorAvailable(int doctorId, java.util.Date appointmentDate) {
        String sql = "SELECT Status FROM Appointments "
                + "WHERE DoctorID = ? AND CAST(AppointmentDate AS DATE) = CAST(? AS DATE) "
                + "AND ABS(DATEDIFF(MINUTE, AppointmentDate, ?)) < 30";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            Timestamp ts = new Timestamp(appointmentDate.getTime());
            ps.setInt(1, doctorId);
            ps.setTimestamp(2, ts);
            ps.setTimestamp(3, ts);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int status = rs.getInt("Status");
                return status == 1;
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM Appointments";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment a = new Appointment();
                a.setAppointmentId(rs.getInt("AppointmentID"));
                a.setCustomerId(rs.getInt("CustomerID"));
                a.setDoctorId(rs.getInt("DoctorID"));
                a.setServiceId(rs.getInt("ServiceID"));
                a.setAppointmentDate(rs.getTimestamp("AppointmentDate"));
                a.setStatus(rs.getInt("Status"));
                a.setNote(rs.getString("Note"));
                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Appointment> getAppointmentsInSameSlot(java.util.Date appointmentDate) {
        List<Appointment> list = new ArrayList<>();
        String sql = """
        SELECT * FROM Appointments
        WHERE CAST(AppointmentDate AS DATE) = CAST(? AS DATE)
          AND DATEPART(HOUR, AppointmentDate) = DATEPART(HOUR, ?)
          AND DATEPART(MINUTE, AppointmentDate) = DATEPART(MINUTE, ?)
    """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            Timestamp ts = new Timestamp(appointmentDate.getTime());
            ps.setTimestamp(1, ts);
            ps.setTimestamp(2, ts);
            ps.setTimestamp(3, ts);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractAppointment(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Appointment> getAppointmentsByPage(int page, int pageSize, List<Appointment> appointmentList) {
        List<Appointment> paginatedList = new ArrayList<>();
        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, appointmentList.size());
        if (start < appointmentList.size()) {
            for (int i = start; i < end; i++) {
                paginatedList.add(appointmentList.get(i));
            }
        }
        return paginatedList;
    }

    public Appointment getAppointmentById(int id) {
        String sql = "SELECT * FROM Appointments WHERE AppointmentID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractAppointment(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateAppointment(Appointment app) {
        String sql = "UPDATE Appointments SET CustomerID=?, DoctorID=?, ServiceID=?, AppointmentDate=?, Status=?, Note=? WHERE AppointmentID=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, app.getCustomerId());
            ps.setInt(2, app.getDoctorId());
            ps.setInt(3, app.getServiceId());
            ps.setTimestamp(4, new Timestamp(app.getAppointmentDate().getTime()));
            ps.setInt(5, app.getStatus());
            ps.setString(6, app.getNote());
            ps.setInt(7, app.getAppointmentId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Appointment> getFilteredAppointments(String status, String startDate, String endDate) {
        List<Appointment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Appointments WHERE 1=1");

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ?");
        }
        if (startDate != null && !startDate.trim().isEmpty() && endDate != null && !endDate.trim().isEmpty()) {
            sql.append(" AND AppointmentDate BETWEEN ? AND ?");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int i = 1;
            if (status != null && !status.trim().isEmpty()) {
                ps.setInt(i++, Integer.parseInt(status.trim()));
            }
            if (startDate != null && !startDate.trim().isEmpty() && endDate != null && !endDate.trim().isEmpty()) {
                ps.setDate(i++, java.sql.Date.valueOf(startDate.trim()));
                ps.setDate(i++, java.sql.Date.valueOf(endDate.trim()));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractAppointment(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Appointment> sortAppointmentsByCustomerNameAZ(String status, String fromDate, String toDate) {
        List<Appointment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT a.*, u.FullName, CASE WHEN CHARINDEX(' ', REVERSE(u.FullName)) > 0 ")
                .append("THEN SUBSTRING(u.FullName, LEN(u.FullName) - CHARINDEX(' ', REVERSE(u.FullName)) + 2, LEN(u.FullName)) ")
                .append("ELSE u.FullName END AS LastName ")
                .append("FROM Appointments a JOIN Users u ON a.CustomerID = u.UserID WHERE 1=1");

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND a.Status = ?");
        }

        if (fromDate != null && !fromDate.trim().isEmpty() && toDate != null && !toDate.trim().isEmpty()) {
            sql.append(" AND CAST(a.AppointmentDate AS DATE) BETWEEN ? AND ?");
        } else if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append(" AND CAST(a.AppointmentDate AS DATE) >= ?");
        } else if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append(" AND CAST(a.AppointmentDate AS DATE) <= ?");
        }

        sql.append(" ORDER BY LastName ASC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int i = 1;
            if (status != null && !status.trim().isEmpty()) {
                ps.setInt(i++, Integer.parseInt(status.trim()));
            }
            if (fromDate != null && !fromDate.trim().isEmpty() && toDate != null && !toDate.trim().isEmpty()) {
                ps.setDate(i++, java.sql.Date.valueOf(fromDate.trim()));
                ps.setDate(i++, java.sql.Date.valueOf(toDate.trim()));
            } else if (fromDate != null && !fromDate.trim().isEmpty()) {
                ps.setDate(i++, java.sql.Date.valueOf(fromDate.trim()));
            } else if (toDate != null && !toDate.trim().isEmpty()) {
                ps.setDate(i++, java.sql.Date.valueOf(toDate.trim()));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractAppointment(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Appointment> sortAppointmentsByDate(String status, String fromDate, String toDate) {
        List<Appointment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Appointments WHERE 1=1");

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ?");
        }

        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append(" AND CAST(AppointmentDate AS DATE) >= ?");
        }

        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append(" AND CAST(AppointmentDate AS DATE) <= ?");
        }

        sql.append(" ORDER BY AppointmentDate ASC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int i = 1;

            if (status != null && !status.trim().isEmpty()) {
                ps.setInt(i++, Integer.parseInt(status.trim()));
            }

            if (fromDate != null && !fromDate.trim().isEmpty()) {
                ps.setDate(i++, java.sql.Date.valueOf(fromDate.trim()));
            }

            if (toDate != null && !toDate.trim().isEmpty()) {
                ps.setDate(i++, java.sql.Date.valueOf(toDate.trim()));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractAppointment(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Tìm kiếm theo tên bệnh nhân
    public List<Appointment> searchAppointmentsByCustomerName(String keyword, String status, String date, String sortBy) {
        List<Appointment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT a.*, u.FullName, CASE WHEN CHARINDEX(' ', REVERSE(u.FullName)) > 0 ")
                .append("THEN SUBSTRING(u.FullName, LEN(u.FullName) - CHARINDEX(' ', REVERSE(u.FullName)) + 2, LEN(u.FullName)) ")
                .append("ELSE u.FullName END AS LastName ")
                .append("FROM Appointments a JOIN Users u ON a.CustomerID = u.UserID WHERE u.FullName LIKE ?");
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND a.Status = ?");
        }
        if (date != null && !date.trim().isEmpty()) {
            sql.append(" AND CAST(a.AppointmentDate AS DATE) = ?");
        }
        if ("name".equalsIgnoreCase(sortBy)) {
            sql.append(" ORDER BY LastName ASC");
        } else if ("date".equalsIgnoreCase(sortBy)) {
            sql.append(" ORDER BY a.AppointmentDate ASC");
        } else {
            sql.append(" ORDER BY a.AppointmentID");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int i = 1;
            ps.setString(i++, "%" + keyword.trim() + "%");
            if (status != null && !status.trim().isEmpty()) {
                ps.setInt(i++, Integer.parseInt(status.trim()));
            }
            if (date != null && !date.trim().isEmpty()) {
                ps.setDate(i++, java.sql.Date.valueOf(date.trim()));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractAppointment(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Appointment> searchAppointmentsByCustomerName(String keyword, String status, String fromDate, String toDate, String sortBy) {
        List<Appointment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT a.*, u.FullName, CASE WHEN CHARINDEX(' ', REVERSE(u.FullName)) > 0 ")
                .append("THEN SUBSTRING(u.FullName, LEN(u.FullName) - CHARINDEX(' ', REVERSE(u.FullName)) + 2, LEN(u.FullName)) ")
                .append("ELSE u.FullName END AS LastName ")
                .append("FROM Appointments a JOIN Users u ON a.CustomerID = u.UserID WHERE u.FullName LIKE ?");

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND a.Status = ?");
        }

        if ((fromDate != null && !fromDate.trim().isEmpty()) && (toDate != null && !toDate.trim().isEmpty())) {
            sql.append(" AND CAST(a.AppointmentDate AS DATE) BETWEEN ? AND ?");
        } else if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append(" AND CAST(a.AppointmentDate AS DATE) >= ?");
        } else if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append(" AND CAST(a.AppointmentDate AS DATE) <= ?");
        }

        if ("name".equalsIgnoreCase(sortBy)) {
            sql.append(" ORDER BY LastName ASC");
        } else if ("date".equalsIgnoreCase(sortBy)) {
            sql.append(" ORDER BY a.AppointmentDate ASC");
        } else {
            sql.append(" ORDER BY a.AppointmentID");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int i = 1;
            ps.setString(i++, "%" + keyword.trim() + "%");

            if (status != null && !status.trim().isEmpty()) {
                ps.setInt(i++, Integer.parseInt(status.trim()));
            }

            if ((fromDate != null && !fromDate.trim().isEmpty()) && (toDate != null && !toDate.trim().isEmpty())) {
                ps.setDate(i++, java.sql.Date.valueOf(fromDate.trim()));
                ps.setDate(i++, java.sql.Date.valueOf(toDate.trim()));
            } else if (fromDate != null && !fromDate.trim().isEmpty()) {
                ps.setDate(i++, java.sql.Date.valueOf(fromDate.trim()));
            } else if (toDate != null && !toDate.trim().isEmpty()) {
                ps.setDate(i++, java.sql.Date.valueOf(toDate.trim()));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractAppointment(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private Appointment extractAppointment(ResultSet rs) throws SQLException {
        Appointment a = new Appointment();
        a.setAppointmentId(rs.getInt("AppointmentID"));
        a.setCustomerId(rs.getInt("CustomerID"));
        a.setDoctorId(rs.getInt("DoctorID"));
        a.setServiceId(rs.getInt("ServiceID"));
        a.setAppointmentDate(rs.getTimestamp("AppointmentDate"));
        a.setStatus(rs.getInt("Status"));
        a.setNote(rs.getString("Note"));
        return a;
    }

    public void createAppointmentByPatient(Appointment app) {
        String sql = "INSERT INTO Appointments (CustomerID, DoctorID, ServiceID, AppointmentDate, Status, Note) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, app.getCustomerId());

            if (app.getDoctorId() <= 0) {
                ps.setNull(2, java.sql.Types.INTEGER);
            } else {
                ps.setInt(2, app.getDoctorId());
            }

            ps.setInt(3, app.getServiceId());
            ps.setTimestamp(4, new Timestamp(app.getAppointmentDate().getTime()));
            ps.setInt(5, app.getStatus());
            ps.setString(6, app.getNote());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                System.out.println("✅ Appointment inserted (DoctorID: " + (app.getDoctorId() <= 0 ? "NULL" : app.getDoctorId()) + ")");
            } else {
                System.out.println("❌ Insert failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateAppointmentByPatient(Appointment app) {
        String sql = "UPDATE Appointments SET ServiceID = ?, AppointmentDate = ?, Note = ? WHERE AppointmentID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, app.getServiceId());
            ps.setTimestamp(2, new Timestamp(app.getAppointmentDate().getTime()));
            ps.setString(3, app.getNote());
            ps.setInt(4, app.getAppointmentId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Appointment> getAppointmentsByCustomer(int customerId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM Appointments WHERE CustomerID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment a = new Appointment();
                a.setAppointmentId(rs.getInt("AppointmentID"));
                a.setCustomerId(rs.getInt("CustomerID"));
                a.setDoctorId(rs.getInt("DoctorID"));
                a.setServiceId(rs.getInt("ServiceID"));
                a.setAppointmentDate(rs.getTimestamp("AppointmentDate"));
                a.setStatus(rs.getInt("Status"));
                a.setNote(rs.getString("Note"));
                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Integer> getAppointmentStatistics() {
        Map<String, Integer> stats = new LinkedHashMap<>();
        String sql = "SELECT Status, COUNT(*) AS Count FROM Appointments GROUP BY Status";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int statusCode = rs.getInt("Status");
                int count = rs.getInt("Count");

                String statusLabel;
                switch (statusCode) {
                    case 0:
                        statusLabel = "Chờ xác nhận";
                        break;
                    case 1:
                        statusLabel = "Đã xác nhận";
                        break;
                    case 2:
                        statusLabel = "Đã khám";
                        break;
                    case 3:
                        statusLabel = "Đã hủy";
                        break;
                    default:
                        statusLabel = "Không xác định";
                }
                stats.put(statusLabel, count);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    public int getTotalAppointments() {
        String sql = "SELECT COUNT(*) FROM Appointments";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Appointment> getAppointmentsOfDoctorInDayAllStatus(int doctorId, java.util.Date date, String statusFilter) {
        List<Appointment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT a.AppointmentID, a.CustomerID, a.DoctorID, a.ServiceID, a.AppointmentDate, a.Status, a.Note, "
                + "u.FullName AS CustomerName, s.ServiceName "
                + "FROM Appointments a "
                + "JOIN Users u ON a.CustomerID = u.UserID "
                + "JOIN Services s ON a.ServiceID = s.ServiceID "
                + "WHERE a.DoctorID = ? AND CAST(a.AppointmentDate AS DATE) = CAST(? AS DATE)"
        );
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND a.Status = ?");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            ps.setInt(1, doctorId);
            ps.setTimestamp(2, new Timestamp(date.getTime()));
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                ps.setInt(3, Integer.parseInt(statusFilter));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment a = new Appointment();
                a.setAppointmentId(rs.getInt("AppointmentID"));
                a.setCustomerId(rs.getInt("CustomerID"));
                a.setDoctorId(rs.getInt("DoctorID"));
                a.setServiceId(rs.getInt("ServiceID"));
                a.setAppointmentDate(rs.getTimestamp("AppointmentDate"));
                a.setStatus(rs.getInt("Status"));
                a.setNote(rs.getString("Note"));
                a.setCustomerName(rs.getString("CustomerName"));
                a.setServiceName(rs.getString("ServiceName"));

                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Kiểm tra bệnh nhân có lịch trùng khung giờ không (±30 phút), kể cả với bác sĩ khác
    public boolean isPatientBusy(int customerId, java.util.Date appointmentDate) {
        String sql = "SELECT COUNT(*) FROM Appointments "
                + "WHERE CustomerID = ? AND CAST(AppointmentDate AS DATE) = CAST(? AS DATE) "
                + "AND ABS(DATEDIFF(MINUTE, AppointmentDate, ?)) < 30 AND Status IN (0,1)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            Timestamp ts = new Timestamp(appointmentDate.getTime());
            ps.setInt(1, customerId);
            ps.setTimestamp(2, ts);
            ps.setTimestamp(3, ts);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Appointment> getFilteredAppointmentsByCustomer(
            int customerId, String status, java.util.Date fromDate, java.util.Date toDate, String sortOrder
    ) {
        List<Appointment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Appointments WHERE CustomerID = ?");

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ").append(status.trim());
        }
        if (fromDate != null) {
            sql.append(" AND AppointmentDate >= ?");
        }
        if (toDate != null) {
            sql.append(" AND AppointmentDate <= ?");
        }

        if ("asc".equalsIgnoreCase(sortOrder)) {
            sql.append(" ORDER BY AppointmentDate ASC");
        } else if ("desc".equalsIgnoreCase(sortOrder)) {
            sql.append(" ORDER BY AppointmentDate DESC");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int index = 1;
            ps.setInt(index++, customerId);
            if (fromDate != null) {
                ps.setTimestamp(index++, new Timestamp(fromDate.getTime()));
            }
            if (toDate != null) {
                ps.setTimestamp(index++, new Timestamp(toDate.getTime()));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractAppointment(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
