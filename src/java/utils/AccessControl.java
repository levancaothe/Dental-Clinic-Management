package utils;

import jakarta.servlet.http.HttpSession;
import java.util.List;

public class AccessControl {

    public static boolean hasPermission(HttpSession session, String permissionName) {
        List<String> permissions = (List<String>) session.getAttribute("permissions");
        return permissions != null && permissions.contains(permissionName);
    }
}
