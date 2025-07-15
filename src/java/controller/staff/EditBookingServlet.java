package controller.staff;

import dao.AppointmentDAO;
import dao.ServiceDAO;
import dao.UserDAO;
import model.Appointment;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;

public class EditBookingServlet extends HttpServlet {

    private boolean isValidAppointmentTime(Date appointmentDate) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(appointmentDate);
        int hour = cal.get(Calendar.HOUR_OF_DAY);
        int minute = cal.get(Calendar.MINUTE);
        int totalMinutes = hour * 60 + minute;
        return (totalMinutes >= 420 && totalMinutes <= 690) || (totalMinutes >= 840 && totalMinutes <= 1020);
    }

    private boolean hasThreeSameChars(String note) {
        for (int i = 0; i < note.length() - 2; i++) {
            if (note.charAt(i) == note.charAt(i + 1) && note.charAt(i) == note.charAt(i + 2)) {
                return true;
            }
        }
        return false;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        AppointmentDAO appDao = new AppointmentDAO();
        Appointment app = appDao.getAppointmentById(id);
        UserDAO userDao = new UserDAO();
        ServiceDAO serviceDao = new ServiceDAO();

        request.setAttribute("appointment", app);
        request.setAttribute("customers", userDao.getUsersByDefaultOrder("Khách hàng"));
        request.setAttribute("doctors", userDao.getUsersByDefaultOrder("Bác sĩ"));
        request.setAttribute("services", serviceDao.getAllServices());

        request.setAttribute("appointmentStatus", app.getStatus());

        request.setAttribute("status", getValue(request, "status"));
        request.setAttribute("dateFilter", getValue(request, "date"));
        request.setAttribute("sortBy", getValue(request, "sortBy"));
        request.setAttribute("keyword", getValue(request, "keyword"));
        request.setAttribute("page", getValue(request, "page", "1"));

        request.getRequestDispatcher("staff/edit-booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String status = getValue(request, "status");
        String dateFilter = getValue(request, "date");
        String sortBy = getValue(request, "sortBy");
        String keyword = getValue(request, "keyword");
        String page = getValue(request, "page", "1");

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));

            String appointmentStatusParam = request.getParameter("appointmentStatus");
            int statusValue = (appointmentStatusParam != null && !appointmentStatusParam.trim().isEmpty())
                    ? Integer.parseInt(appointmentStatusParam)
                    : 0;

            String note = request.getParameter("note") != null ? request.getParameter("note").trim() : "";
            String dateStr = request.getParameter("appointmentDate");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            Date appointmentDate = sdf.parse(dateStr);

            Appointment app = new Appointment();
            app.setAppointmentId(id);
            app.setCustomerId(customerId);
            app.setDoctorId(doctorId);
            app.setServiceId(serviceId);
            app.setAppointmentDate(appointmentDate);
            app.setStatus(statusValue);
            app.setNote(note);

            if (!isValidAppointmentTime(appointmentDate)) {
                request.setAttribute("error", "Vui lòng chọn khung giờ hợp lệ: 07:00–11:30 hoặc 14:00–17:00");
                setRequestFilters(request, app, status, dateFilter, sortBy, keyword, page);
                doGet(request, response);
                return;
            }

            if (!note.isEmpty()) {
                if (note.length() > 255) {
                    request.setAttribute("error", "Ghi chú không được vượt quá 255 ký tự.");
                } else if (!Character.isLetter(note.charAt(0))) {
                    request.setAttribute("error", "Ghi chú phải bắt đầu bằng chữ cái.");
                } else if (note.matches(".*<[^>]+>.*")) {
                    request.setAttribute("error", "Không được nhập thẻ HTML vào ghi chú.");
                } else if (hasThreeSameChars(note)) {
                    request.setAttribute("error", "Không được nhập 3 ký tự giống nhau liên tiếp trong ghi chú.");
                }
                if (request.getAttribute("error") != null) {
                    setRequestFilters(request, app, status, dateFilter, sortBy, keyword, page);
                    doGet(request, response);
                    return;
                }
            }

            AppointmentDAO dao = new AppointmentDAO();
            List<Appointment> sameSlotAppointments = dao.getAppointmentsByDoctorAndTime(doctorId, appointmentDate);
            sameSlotAppointments.removeIf(a -> a.getAppointmentId() == id);
            boolean hasConflict = sameSlotAppointments.stream().anyMatch(a -> a.getStatus() == 0);

            if (hasConflict && statusValue == 0) {
                SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                StringBuilder msg = new StringBuilder("Đã có ca khám đang xử lý trong khung giờ này:<br>");
                for (Appointment a : sameSlotAppointments) {
                    if (a.getStatus() == 0) {
                        msg.append("- ").append(df.format(a.getAppointmentDate())).append("<br>");
                    }
                }
                request.setAttribute("error", msg.toString());
                setRequestFilters(request, app, status, dateFilter, sortBy, keyword, page);
                doGet(request, response);
                return;
            }

            dao.updateAppointment(app);

            String redirectURL = "ViewBookingServlet"
                    + "?status=" + URLEncoder.encode(status, "UTF-8")
                    + "&date=" + URLEncoder.encode(dateFilter, "UTF-8")
                    + "&sortBy=" + URLEncoder.encode(sortBy, "UTF-8")
                    + "&keyword=" + URLEncoder.encode(keyword, "UTF-8")
                    + "&page=" + page;

            response.sendRedirect(redirectURL);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi cập nhật lịch khám: " + e.getMessage());
        }
    }

    private void setRequestFilters(HttpServletRequest request, Appointment app,
            String status, String dateFilter,
            String sortBy, String keyword, String page) {
        request.setAttribute("appointment", app);
        request.setAttribute("appointmentStatus", app.getStatus());
        request.setAttribute("status", status);
        request.setAttribute("dateFilter", dateFilter);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("keyword", keyword);
        request.setAttribute("page", page);
    }

    private String getValue(HttpServletRequest request, String param) {
        return getValue(request, param, "");
    }

    private String getValue(HttpServletRequest request, String param, String defaultValue) {
        String value = request.getParameter(param);
        return (value != null) ? value : defaultValue;
    }
}
