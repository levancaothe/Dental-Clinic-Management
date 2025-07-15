package filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebFilter("/*")
public class AccessFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String uri = req.getRequestURI();      
        HttpSession session = req.getSession(false);

        System.out.println("[AccessFilter] URI: " + uri);

        if (uri.contains("/css/") || uri.contains("/js/") || uri.contains("/image/")
                || uri.endsWith("login.jsp") || uri.endsWith("/login")
                || uri.endsWith("register.jsp") || uri.endsWith("/RegisterServlet")
                || uri.endsWith("forgot-password.jsp") || uri.endsWith("/forgot-password")
                || uri.endsWith("/home.jsp") || uri.endsWith("/home")
                || uri.endsWith("/logout") || uri.endsWith(".png")
                || uri.endsWith(".jpg") || uri.endsWith(".ico")
                || uri.contains("/fonts/") || uri.contains("/error")) {
            chain.doFilter(request, response);
            return;
        }

        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        if (Boolean.TRUE.equals(session.getAttribute("justLoggedIn"))) {
            System.out.println("[AccessFilter] Bỏ qua kiểm tra quyền vì vừa đăng nhập");
            session.removeAttribute("justLoggedIn");
            chain.doFilter(request, response);
            return;
        }

        @SuppressWarnings("unchecked")
        List<String> permissions = (List<String>) session.getAttribute("permissions");

        if (uri.contains("/admin/") && !hasPermission(permissions, "Truy cập Admin Dashboard")) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        if (uri.contains("/ManageAccountStatusServlet")
                && !hasPermission(permissions, "Quản lý trạng thái tài khoản")) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (uri.contains("/InternalUserListServlet")
                && !hasPermission(permissions, "Xem danh sách nhân sự")) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (uri.contains("/AppointmentStatisticsServlet")
                && !hasPermission(permissions, "Xem thống kê đặt lịch")) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (uri.contains("/ServiceStatisticsServlet")
                && !hasPermission(permissions, "Xem thống kê dịch vụ")) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        if (uri.contains("/staff/") && !hasPermission(permissions, "Truy cập Staff Dashboard")) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        if (uri.contains("/doctor/") && !hasPermission(permissions, "Truy cập Doctor Dashboard")) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        if (uri.contains("/DoctorScheduleServlet")
                && !hasPermission(permissions, "Xem lịch hẹn")) { // <-- Sửa ở đây
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        if (uri.contains("/customer/") && !hasPermission(permissions, "Truy cập Customer Dashboard")) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
       
        chain.doFilter(request, response);
    }

    private boolean hasPermission(List<String> permissions, String name) {
        if (permissions == null) {
            System.out.println("[AccessFilter] permissions = null khi kiểm tra quyền: " + name);
            return false;
        }
        boolean ok = permissions.stream().anyMatch(p -> name.equalsIgnoreCase(p));
        System.out.println("[AccessFilter] Kiểm tra quyền '" + name + "': " + ok);
        return ok;
    }
}
