package model;

import java.util.Date;

public class Notification {

    private int notificationId;
    private int userId;
    private String title;
    private String message;
    private Date createdAt;
    private boolean isRead;
    private boolean isSentEmail;

    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setIsRead(boolean isRead) {
        this.isRead = isRead;
    }

    public boolean isSentEmail() {
        return isSentEmail;
    }

    public void setIsSentEmail(boolean isSentEmail) {
        this.isSentEmail = isSentEmail;
    }
}
