package dao;

import dal.DBContext;
import model.Role;
import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Permission;

public class UserDAO extends DBContext {

    private static final String CUSTOMER_ROLE = "Khách hàng";

    private Connection connection;
    private PreparedStatement pstm;
    private ResultSet rs;

    public UserDAO() {
        this.connection = super.connection;
    }

    public User login(String email, String password) {
        try {
            String sql = "SELECT u.*, r.RoleName FROM Users u "
                    + "JOIN Roles r ON u.RoleID = r.RoleID "
                    + "WHERE u.Email = ? AND u.PasswordHash = ?";
            pstm = connection.prepareStatement(sql);
            pstm.setString(1, email);
            pstm.setString(2, password);
            rs = pstm.executeQuery();
            if (rs.next()) {
                return createUserFromResultSet(rs); // ✔ Đây là đúng
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources();
        }
        return null;
    }

    public boolean updatePassword(String email, String newPassword) {
        try {
            String sql = "UPDATE Users SET PasswordHash = ? WHERE Email = ? AND Status = 1";
            pstm = connection.prepareStatement(sql);
            pstm.setString(1, newPassword);
            pstm.setString(2, email);
            int rowsAffected = pstm.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources();
        }
        return false;
    }

    //xử lí đăng ký tài khoản
    public void insertUser(User user) throws SQLException {
        if (connection == null) {
            throw new SQLException("Database connection is null. Please check DBContext configuration or database availability.");
        }
        String sql = "INSERT INTO Users (FullName, Email, PasswordHash, PhoneNumber, Address, RoleID, Status, DateOfBirth, Gender) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash()); // theo class User
            ps.setString(4, user.getPhoneNumber());
            if (user.getAddress() != null && !user.getAddress().isEmpty()) {
                ps.setString(5, user.getAddress());
            } else {
                ps.setNull(5, java.sql.Types.NVARCHAR);
            }
            ps.setInt(6, user.getRoleId());
            ps.setBoolean(7, user.isStatus());

            if (user.getDateOfBirth() != null) {
                ps.setDate(8, new java.sql.Date(user.getDateOfBirth().getTime()));
            } else {
                ps.setNull(8, java.sql.Types.DATE);
            }

            ps.setString(9, user.getGender());

            ps.executeUpdate();
        }
    }

    public boolean isEmailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE Email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    // Kiểm tra vai trò của người dùng (Chỉ khách hàng RoleID = 1)
    public boolean isCustomer(int userId) {
        String sql = "SELECT RoleID FROM Users WHERE UserID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("RoleID") == 1;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }

    public User getUserById(int userId) {
        String sql = "SELECT u.*, r.RoleName FROM Users u LEFT JOIN Roles r ON u.RoleID = r.RoleID WHERE u.UserID = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("UserID"));
                    user.setFullName(rs.getString("FullName"));
                    user.setEmail(rs.getString("Email"));
                    user.setPhoneNumber(rs.getString("PhoneNumber"));
                    user.setAddress(rs.getString("Address"));
                    user.setRoleId(rs.getInt("RoleID"));
                    user.setStatus(rs.getBoolean("Status"));
                    user.setCreatedAt(rs.getDate("CreatedAt"));
                    user.setDateOfBirth(rs.getDate("DateOfBirth"));
                    user.setGender(rs.getString("Gender"));
                    user.setRoleName(rs.getString("RoleName"));
                    return user;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error fetching user by ID " + userId + ": " + e.getMessage());
        }
        return null;
    }

    // Phương thức lấy danh sách người dùng với phân trang
    public List<User> getUsersByPage(int page, int pageSize, String roleFilter, List<User> userList) {
        List<User> paginatedList = new ArrayList<>();
        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, userList.size());

        if (start < userList.size()) {
            for (int i = start; i < end; i++) {
                paginatedList.add(userList.get(i));
            }
        }
        return paginatedList;
    }

    public List<User> getUsersByDefaultOrder(String roleFilter) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT u.UserID, u.FullName, u.Email, u.PhoneNumber, u.Address, r.RoleName ")
                .append("FROM Users u ")
                .append("JOIN Roles r ON u.RoleID = r.RoleID ");

        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append("WHERE r.RoleName = ? ");
        }

        sql.append("ORDER BY u.UserID");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            if (roleFilter != null && !roleFilter.isEmpty()) {
                ps.setString(1, roleFilter);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new User(
                            rs.getInt("UserID"),
                            rs.getString("FullName"),
                            rs.getString("Email"),
                            rs.getString("PhoneNumber"),
                            rs.getString("Address"),
                            rs.getString("RoleName")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Phương thức sắp xếp người dùng theo tên (A-Z)
    public List<User> sortUsersByNameAZ(String roleFilter) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT u.UserID, u.FullName, u.Email, u.PhoneNumber, u.Address, r.RoleName, ")
                .append("CASE WHEN CHARINDEX(' ', REVERSE(u.FullName)) > 0 ")
                .append("THEN SUBSTRING(u.FullName, LEN(u.FullName) - CHARINDEX(' ', REVERSE(u.FullName)) + 2, LEN(u.FullName)) ")
                .append("ELSE u.FullName END AS FirstName ")
                .append("FROM Users u ")
                .append("JOIN Roles r ON u.RoleID = r.RoleID ");

        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append("WHERE r.RoleName = ? ");
        }

        sql.append("ORDER BY FirstName ASC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            if (roleFilter != null && !roleFilter.isEmpty()) {
                ps.setString(1, roleFilter);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new User(
                            rs.getInt("UserID"),
                            rs.getString("FullName"),
                            rs.getString("Email"),
                            rs.getString("PhoneNumber"),
                            rs.getString("Address"),
                            rs.getString("RoleName")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Phương thức tìm kiếm người dùng theo FullName hoặc Email
    public List<User> searchUsers(String keyword, String roleFilter, String sortBy) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT u.UserID, u.FullName, u.Email, u.PhoneNumber, u.Address, r.RoleName, ")
                .append("CASE WHEN CHARINDEX(' ', REVERSE(u.FullName)) > 0 ")
                .append("THEN SUBSTRING(u.FullName, LEN(u.FullName) - CHARINDEX(' ', REVERSE(u.FullName)) + 2, LEN(u.FullName)) ")
                .append("ELSE u.FullName END AS FirstName ")
                .append("FROM Users u ")
                .append("JOIN Roles r ON u.RoleID = r.RoleID ")
                .append("WHERE (u.FullName LIKE ? OR u.Email LIKE ?)");

        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append(" AND r.RoleName = ?");
        }

        if ("name".equalsIgnoreCase(sortBy)) {
            sql.append(" ORDER BY FirstName ASC");
        } else {
            sql.append(" ORDER BY u.UserID");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            if (roleFilter != null && !roleFilter.isEmpty()) {
                ps.setString(3, roleFilter);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new User(
                            rs.getInt("UserID"),
                            rs.getString("FullName"),
                            rs.getString("Email"),
                            rs.getString("PhoneNumber"),
                            rs.getString("Address"),
                            rs.getString("RoleName")
                    ));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error searching users: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Phương thức đếm tổng số người dùng theo tìm kiếm
    public int getTotalUsersWithSearch(String keyword, String roleFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Users u JOIN Roles r ON u.RoleID = r.RoleID ");
        sql.append("WHERE (u.FullName LIKE ? OR u.Email LIKE ?)");
        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append(" AND r.RoleName = ?");
        }
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            if (roleFilter != null && !roleFilter.isEmpty()) {
                ps.setString(3, roleFilter);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error counting users with search: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    //Thống kê số lượng
    public int getTotalUsers(String roleFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Users u JOIN Roles r ON u.RoleID = r.RoleID");
        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append(" WHERE r.RoleName = ?");
        }
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            if (roleFilter != null && !roleFilter.isEmpty()) {
                ps.setString(1, roleFilter);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public User getUserByEmail(String email) {
        try {
            String sql = "SELECT u.*, r.RoleName FROM Users u "
                    + "JOIN Roles r ON u.RoleID = r.RoleID "
                    + "WHERE u.Email = ? AND u.Status = 1";
            pstm = connection.prepareStatement(sql);
            pstm.setString(1, email);
            rs = pstm.executeQuery();
            if (rs.next()) {
                return createUserFromResultSet(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources();
        }
        return null;
    }

    // Lấy danh sách khách hàng theo thứ tự mặc định (theo UserID)
    public List<User> getCustomersByDefaultOrder() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.UserID, u.FullName, u.Email, u.PhoneNumber, u.Address, r.RoleName, u.Gender, u.DateOfBirth "
                + "FROM Users u "
                + "JOIN Roles r ON u.RoleID = r.RoleID "
                + "WHERE r.RoleName = ? "
                + "ORDER BY u.UserID";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, CUSTOMER_ROLE);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("UserID"));
                    user.setFullName(rs.getString("FullName"));
                    user.setEmail(rs.getString("Email"));
                    user.setPhoneNumber(rs.getString("PhoneNumber"));
                    user.setAddress(rs.getString("Address"));
                    user.setRoleName(rs.getString("RoleName"));
                    user.setGender(rs.getString("Gender"));
                    user.setDateOfBirth(rs.getDate("DateOfBirth"));
                    list.add(user);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error fetching customers by default order: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Sắp xếp khách hàng theo tên (A-Z)
    public List<User> sortCustomersByNameAZ() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.UserID, u.FullName, u.Email, u.PhoneNumber, u.Address, r.RoleName, u.Gender, u.DateOfBirth, "
                + "CASE WHEN CHARINDEX(' ', REVERSE(u.FullName)) > 0 "
                + "THEN SUBSTRING(u.FullName, LEN(u.FullName) - CHARINDEX(' ', REVERSE(u.FullName)) + 2, LEN(u.FullName)) "
                + "ELSE u.FullName END AS FirstName "
                + "FROM Users u "
                + "JOIN Roles r ON u.RoleID = r.RoleID "
                + "WHERE r.RoleName = ? "
                + "ORDER BY FirstName ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, CUSTOMER_ROLE);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("UserID"));
                    user.setFullName(rs.getString("FullName"));
                    user.setEmail(rs.getString("Email"));
                    user.setPhoneNumber(rs.getString("PhoneNumber"));
                    user.setAddress(rs.getString("Address"));
                    user.setRoleName(rs.getString("RoleName"));
                    user.setGender(rs.getString("Gender"));
                    user.setDateOfBirth(rs.getDate("DateOfBirth"));
                    list.add(user);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error sorting customers by name: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Tìm kiếm khách hàng theo FullName hoặc Email
    public List<User> searchCustomers(String keyword, String sortBy) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT u.UserID, u.FullName, u.Email, u.PhoneNumber, u.Address, r.RoleName, u.Gender, u.DateOfBirth, ")
                .append("CASE WHEN CHARINDEX(' ', REVERSE(u.FullName)) > 0 ")
                .append("THEN SUBSTRING(u.FullName, LEN(u.FullName) - CHARINDEX(' ', REVERSE(u.FullName)) + 2, LEN(u.FullName)) ")
                .append("ELSE u.FullName END AS FirstName ")
                .append("FROM Users u ")
                .append("JOIN Roles r ON u.RoleID = r.RoleID ")
                .append("WHERE (u.FullName LIKE ? OR u.Email LIKE ?) ")
                .append("AND r.RoleName = ? ");

        if ("name".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY FirstName ASC");
        } else {
            sql.append("ORDER BY u.UserID");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, CUSTOMER_ROLE);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("UserID"));
                    user.setFullName(rs.getString("FullName"));
                    user.setEmail(rs.getString("Email"));
                    user.setPhoneNumber(rs.getString("PhoneNumber"));
                    user.setAddress(rs.getString("Address"));
                    user.setRoleName(rs.getString("RoleName"));
                    user.setGender(rs.getString("Gender"));
                    user.setDateOfBirth(rs.getDate("DateOfBirth"));
                    list.add(user);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error searching customers: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateProfile(User user) throws SQLException {
        if (connection == null) {
            throw new SQLException("Database connection is null. Please check DBContext configuration or database availability.");
        }
        String sql = "UPDATE Users SET FullName = ?, PhoneNumber = ?, Address = ?, DateOfBirth = ?, Gender = ? WHERE UserID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhoneNumber());

            if (user.getAddress() != null && !user.getAddress().isEmpty()) {
                ps.setString(3, user.getAddress());
            } else {
                ps.setNull(3, java.sql.Types.NVARCHAR);
            }

            if (user.getDateOfBirth() != null) {
                ps.setDate(4, new java.sql.Date(user.getDateOfBirth().getTime()));
            } else {
                ps.setNull(4, java.sql.Types.DATE);
            }

            ps.setString(5, user.getGender());
            ps.setInt(6, user.getUserId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.UserID, u.FullName, u.Email, u.PasswordHash, u.PhoneNumber, u.Address, u.RoleID, u.Status, u.Gender, r.RoleName "
                + "FROM Users u LEFT JOIN Roles r ON u.RoleID = r.RoleID";
        try {
            if (connection == null) {
                throw new SQLException("Database connection is null. Please check DBContext configuration or database availability.");
            }
            pstm = connection.prepareStatement(sql);
            rs = pstm.executeQuery();
            while (rs.next()) {
                User user = new User(
                        rs.getInt("UserID"),
                        rs.getString("FullName"),
                        rs.getString("PasswordHash"),
                        rs.getString("Email"),
                        rs.getString("PhoneNumber"),
                        rs.getString("Address"),
                        rs.getInt("RoleID"),
                        rs.getBoolean("Status"),
                        null, // createdAt (not retrieved)
                        null, // dateOfBirth (not retrieved)
                        rs.getString("Gender")
                );
                user.setRoleName(rs.getString("RoleName"));
                list.add(user);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, "Error fetching all users", ex);
        } finally {
            closeResources();
        }
        return list;
    }

    public List<User> getUsersByRole(int roleId) {
        List<User> users = new ArrayList<>();
        try {
            String sql = "SELECT u.*, r.RoleName FROM Users u "
                    + "JOIN Roles r ON u.RoleID = r.RoleID "
                    + "WHERE u.RoleID = ?";
            pstm = connection.prepareStatement(sql);
            pstm.setInt(1, roleId);
            rs = pstm.executeQuery();
            while (rs.next()) {
                users.add(createUserFromResultSet(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources();
        }
        return users;
    }

    public List<User> getAllEmployees() {
        List<User> users = new ArrayList<>();
        try {
            String sql = "SELECT u.*, r.RoleName FROM Users u "
                    + "JOIN Roles r ON u.RoleID = r.RoleID "
                    + "WHERE u.RoleID IN (1, 2)";
            pstm = connection.prepareStatement(sql);
            rs = pstm.executeQuery();
            while (rs.next()) {
                users.add(createUserFromResultSet(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources();
        }
        return users;
    }

    //Cập nhật trạng thái tài khoản (Active / Deactive)
    public boolean updateUserStatus(int userId, boolean isActive) {
        try {
            String sql = "UPDATE Users SET Status = ? WHERE UserID = ?";
            pstm = connection.prepareStatement(sql);
            pstm.setBoolean(1, isActive);
            pstm.setInt(2, userId);
            int rowsAffected = pstm.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources();
        }
        return false;
    }

    // Đếm tổng số user
    public int countAllUsers() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Users";
        try {
            pstm = connection.prepareStatement(sql);
            rs = pstm.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return count;
    }
    
    // Đếm theo RoleId (ví dụ: 1 - Customer, 2 - Staff, 3 - Doctor)
    public int countUsersByRole(int roleId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Users WHERE RoleID = ?";
        try {
            pstm = connection.prepareStatement(sql);
            pstm.setInt(1, roleId);
            rs = pstm.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return count;
    }

    private User createUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("UserID"));
        user.setFullName(rs.getString("FullName"));
        user.setEmail(rs.getString("Email"));
        user.setPasswordHash(rs.getString("PasswordHash"));
        user.setPhoneNumber(rs.getString("PhoneNumber"));
        user.setAddress(rs.getString("Address"));
        user.setRoleId(rs.getInt("RoleID"));
        user.setStatus(rs.getBoolean("Status"));
        user.setCreatedAt(rs.getTimestamp("CreatedAt"));
        user.setDateOfBirth(rs.getDate("DateOfBirth"));
        user.setGender(rs.getString("Gender"));
        user.setRoleName(rs.getString("RoleName"));
        Role role = new Role();
        role.setRoleID(rs.getInt("RoleID"));
        role.setRoleName(rs.getString("RoleName"));
        user.setRole(role);
        return user;
    }

    private void closeResources() {
        try {
            if (rs != null) {
                rs.close();
            }
            if (pstm != null) {
                pstm.close();
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public List<Permission> getPermissionsByUserId(int userId) {
        List<Permission> list = new ArrayList<>();
        String sql = "SELECT p.PermissionID, p.PermissionName FROM Users u "
                + "JOIN RolePermissions rp ON u.RoleID = rp.RoleID "
                + "JOIN Permissions p ON rp.PermissionID = p.PermissionID "
                + "WHERE u.UserID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Permission(rs.getInt("PermissionID"), rs.getString("PermissionName")));
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<User> getUsersByRoleId(int roleId) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE RoleID = ? AND Status = 1"; // Lấy nhân viên đang hoạt động
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("UserID"));
                u.setFullName(rs.getString("FullName"));
                u.setEmail(rs.getString("Email"));
                u.setPhoneNumber(rs.getString("PhoneNumber"));
                u.setAddress(rs.getString("Address"));
                u.setRoleId(rs.getInt("RoleID"));
                u.setStatus(rs.getBoolean("Status"));
                u.setCreatedAt(rs.getTimestamp("CreatedAt"));
                u.setDateOfBirth(rs.getDate("DateOfBirth"));
                u.setGender(rs.getString("Gender"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<User> getInternalUsers(String keyword, String sortBy) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT u.UserID, u.FullName, u.Email, u.PhoneNumber, u.Status, r.RoleName, ")
                .append("CASE WHEN CHARINDEX(' ', REVERSE(u.FullName)) > 0 ")
                .append("THEN SUBSTRING(u.FullName, LEN(u.FullName) - CHARINDEX(' ', REVERSE(u.FullName)) + 2, LEN(u.FullName)) ")
                .append("ELSE u.FullName END AS FirstName ")
                .append("FROM Users u JOIN Roles r ON u.RoleID = r.RoleID ")
                .append("WHERE u.RoleID IN (2, 3) ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (u.FullName LIKE ? OR u.Email LIKE ?) ");
        }

        if ("name".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY FirstName ASC");
        } else {
            sql.append("ORDER BY u.UserID");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(paramIndex++, kw);
                ps.setString(paramIndex++, kw);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("UserID"));
                u.setFullName(rs.getString("FullName"));
                u.setEmail(rs.getString("Email"));
                u.setPhoneNumber(rs.getString("PhoneNumber"));
                u.setStatus(rs.getBoolean("Status"));
                u.setRoleName(rs.getString("RoleName"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
