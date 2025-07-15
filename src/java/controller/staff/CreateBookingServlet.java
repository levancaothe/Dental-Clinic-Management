package controller.staff;

import dao.AppointmentDAO;
import model.Appointment;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;

public class CreateBookingServlet extends HttpServlet {

    private boolean isValidAppointmentTime(Date appointmentDate) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(appointmentDate);
        int totalMinutes = cal.get(Calendar.HOUR_OF_DAY) * 60 + cal.get(Calendar.MINUTE);
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String note = Optional.ofNullable(request.getParameter("note")).orElse("").trim();
            String dateStr = request.getParameter("appointmentDate");
            String appointmentIdParam = request.getParameter("appointmentId");

            String status = request.getParameter("status");
            String keyword = request.getParameter("keyword");
            String sortBy = request.getParameter("sortBy");
            String page = request.getParameter("page");
            String filterDate = request.getParameter("date");

            request.setAttribute("customerId", customerId);
            request.setAttribute("doctorId", doctorId);
            request.setAttribute("serviceId", serviceId);
            request.setAttribute("note", note);
            request.setAttribute("appointmentDate", dateStr);
            request.setAttribute("appointmentId", appointmentIdParam);
            request.setAttribute("status", status);
            request.setAttribute("keyword", keyword);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("page", page);
            request.setAttribute("date", filterDate);

            Date appointmentDate = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(dateStr);
            Date now = new Date();

            if (doctorId <= 0) {
                request.setAttribute("error", "Bắt buộc phải chọn bác sĩ.");
                request.getRequestDispatcher("staff/create-booking.jsp").forward(request, response);
                return;
            }
            if (appointmentDate.before(now)) {
                request.setAttribute("error", "Không thể đặt lịch trong quá khứ.");
                request.getRequestDispatcher("staff/create-booking.jsp").forward(request, response);
                return;
            }
            if (!isValidAppointmentTime(appointmentDate)) {
                request.setAttribute("error", "Vui lòng chọn trong các khung giờ: 07:00–11:30 hoặc 14:00–17:00");
                request.getRequestDispatcher("staff/create-booking.jsp").forward(request, response);
                return;
            }
            if (!note.isEmpty()) {
                if (note.length() > 255) {
                    request.setAttribute("error", "Ghi chú không được vượt quá 255 ký tự.");
                } else if (!Character.isLetterOrDigit(note.charAt(0))) {
                    request.setAttribute("error", "Ghi chú không được bắt đầu bằng ký tự đặc biệt.");
                } else if (note.matches(".*<[^>]+>.*")) {
                    request.setAttribute("error", "Không được nhập thẻ HTML vào ghi chú.");
                } else if (!Character.isLetter(note.charAt(0))) {
                    request.setAttribute("error", "Ghi chú phải bắt đầu bằng chữ cái.");
                } else if (hasThreeSameChars(note)) {
                    request.setAttribute("error", "Không được nhập 3 ký tự giống nhau liên tiếp trong ghi chú.");
                }
                if (request.getAttribute("error") != null) {
                    request.getRequestDispatcher("staff/create-booking.jsp").forward(request, response);
                    return;
                }
            }

            AppointmentDAO dao = new AppointmentDAO();
            List<Appointment> sameTimeAppointments = dao.getAppointmentsByDoctorAndTime(doctorId, appointmentDate);
            boolean hasConflict = sameTimeAppointments.stream()
                    .anyMatch(a -> a.getStatus() != 1 && a.getStatus() != 2);

            if (hasConflict) {
                List<Appointment> overlaps = dao.getAppointmentsOfDoctorInDay(doctorId, appointmentDate);
                overlaps.sort(Comparator.comparing(Appointment::getAppointmentDate));
                StringBuilder message = new StringBuilder("Các ca khám của bác sĩ trong ngày:\n");
                SimpleDateFormat displayFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                for (Appointment ap : overlaps) {
                    message.append("- ").append(displayFormat.format(ap.getAppointmentDate())).append("\n");
                }
                request.setAttribute("appointmentsOfDoctorInDay", overlaps);
                request.setAttribute("error", message.toString());
                request.getRequestDispatcher("staff/create-booking.jsp").forward(request, response);
                return;
            }

            Appointment app = new Appointment();
            app.setCustomerId(customerId);
            app.setDoctorId(doctorId);
            app.setServiceId(serviceId);
            app.setAppointmentDate(appointmentDate);
            app.setStatus(0);
            app.setNote(note);

            if (appointmentIdParam != null && !appointmentIdParam.trim().isEmpty()) {
                app.setAppointmentId(Integer.parseInt(appointmentIdParam));
                dao.updateAppointment(app);
            } else {
                dao.createAppointment(app);
            }

            StringBuilder redirectUrl = new StringBuilder("ViewBookingServlet?success=true");
            if (status != null) {
                redirectUrl.append("&status=").append(URLEncoder.encode(status, "UTF-8"));
            }
            if (keyword != null) {
                redirectUrl.append("&keyword=").append(URLEncoder.encode(keyword, "UTF-8"));
            }
            if (sortBy != null) {
                redirectUrl.append("&sortBy=").append(URLEncoder.encode(sortBy, "UTF-8"));
            }
            if (page != null) {
                redirectUrl.append("&page=").append(URLEncoder.encode(page, "UTF-8"));
            }
            if (filterDate != null) {
                redirectUrl.append("&date=").append(URLEncoder.encode(filterDate, "UTF-8"));
            }
            response.sendRedirect(redirectUrl.toString());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi đặt lịch: " + e.getMessage());
            request.getRequestDispatcher("staff/create-booking.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");
        String sortBy = request.getParameter("sortBy");
        String page = request.getParameter("page");
        String filterDate = request.getParameter("date");

        request.setAttribute("status", status);
        request.setAttribute("keyword", keyword);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("page", page);
        request.setAttribute("date", filterDate);

        try {
            dao.ServiceDAO serviceDAO = new dao.ServiceDAO();
            List<model.Service> services = serviceDAO.getAllServices();
            request.setAttribute("services", services);

            if ("assign".equalsIgnoreCase(action) && idParam != null) {
                int appointmentId = Integer.parseInt(idParam);
                AppointmentDAO dao = new AppointmentDAO();
                Appointment app = dao.getAppointmentById(appointmentId);
                if (app == null) {
                    request.setAttribute("error", "Không tìm thấy lịch khám.");
                } else {
                    request.setAttribute("appointmentId", app.getAppointmentId());
                    request.setAttribute("customerId", app.getCustomerId());
                    request.setAttribute("serviceId", app.getServiceId());
                    request.setAttribute("appointmentDate",
                            new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(app.getAppointmentDate()));
                    request.setAttribute("note", app.getNote());
                    request.setAttribute("assignMode", true);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu lịch khám.");
        }

        request.getRequestDispatcher("staff/create-booking.jsp").forward(request, response);
    }
}
