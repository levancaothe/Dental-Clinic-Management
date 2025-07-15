package dao;

import dal.DBContext;
import model.Permission;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PermissionDAO extends DBContext {

    // Lấy toàn bộ quyền
    public List<Permission> getAllPermissions() {
        List<Permission> list = new ArrayList<>();
        String sql = "SELECT PermissionID, PermissionName FROM Permissions";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Permission p = new Permission();
                p.setPermissionID(rs.getInt("PermissionID"));
                p.setPermissionName(rs.getString("PermissionName"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy danh sách quyền theo roleId
    public List<Permission> getPermissionsByRoleId(int roleId) {
        List<Permission> list = new ArrayList<>();
        String sql = """
            SELECT p.PermissionID, p.PermissionName
            FROM RolePermissions rp
            JOIN Permissions p ON rp.PermissionID = p.PermissionID
            WHERE rp.RoleID = ?
        """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, roleId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Permission p = new Permission();
                p.setPermissionID(rs.getInt("PermissionID"));
                p.setPermissionName(rs.getString("PermissionName"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Gán quyền cho Role
    public void assignPermissionToRole(int roleId, int permissionId) {
        String sql = "INSERT INTO RolePermissions (RoleID, PermissionID) VALUES (?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, roleId);
            ps.setInt(2, permissionId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xoá quyền khỏi Role
    public void removePermissionFromRole(int roleId, int permissionId) {
        String sql = "DELETE FROM RolePermissions WHERE RoleID = ? AND PermissionID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, roleId);
            ps.setInt(2, permissionId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
