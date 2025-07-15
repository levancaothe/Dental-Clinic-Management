package model;

import java.security.Permission;

public class RolePermission {
    private int roleID;
    private int permissionID;
    
    private Role role;
    private Permission permission;
    
    public RolePermission() {
    }
    
    public RolePermission(int roleID, int permissionID) {
        this.roleID = roleID;
        this.permissionID = permissionID;
    }
    
    public int getRoleID() {
        return roleID;
    }
    
    public void setRoleID(int roleID) {
        this.roleID = roleID;
    }
    
    public int getPermissionID() {
        return permissionID;
    }
    
    public void setPermissionID(int permissionID) {
        this.permissionID = permissionID;
    }
    
    public Role getRole() {
        return role;
    }
    
    public void setRole(Role role) {
        this.role = role;
    }
    
    public Permission getPermission() {
        return permission;
    }
    
    public void setPermission(Permission permission) {
        this.permission = permission;
    }
    
    @Override
    public String toString() {
        return "RolePermission{" + "roleID=" + roleID + ", permissionID=" + permissionID + '}';
    }
}
