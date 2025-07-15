package model;

import java.util.Date;

public class User {

    private int userId;
    private String fullName;
    private String passwordHash;
    private String email;
    private String phoneNumber;
    private String address;
    private int roleId;
    private boolean status;
    private Date createdAt;
    private Date dateOfBirth;
    private String gender;
    private String roleName;
    private Role role;
    
     
    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public User() {
    }

    public User(int userId, String fullName, String passwordHash, String email, String phoneNumber, String address, int roleId, boolean status, Date createdAt, Date dateOfBirth, String gender) {
        this.userId = userId;
        this.fullName = fullName;
        this.passwordHash = passwordHash;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.address = address;
        this.roleId = roleId;
        this.status = status;
        this.createdAt = createdAt;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
    }

    public User(int userId, String fullName, String email, String phoneNumber, String address, String roleName) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.address = address;
        this.roleName = roleName;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    @Override
    public String toString() {
        return "User{"
                + "userId=" + userId
                + ", fullName='" + fullName + '\''
                + ", email='" + email + '\''
                + ", phoneNumber='" + phoneNumber + '\''
                + ", address='" + address + '\''
                + ", roleId=" + roleId
                + ", status=" + status
                + ", createdAt=" + createdAt
                + ", dateOfBirth=" + dateOfBirth
                + ", gender='" + gender + '\''
                + ", roleName='" + roleName + '\''
                + ", role=" + (role != null ? role.getRoleName() : "null")
                + '}';
    }
}
