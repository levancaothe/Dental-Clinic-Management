package controller.customer;

import dao.AppointmentDAO;
import dao.ServiceDAO;
import dao.UserDAO;
import model.Appointment;
import model.Service;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

public class PatientEditBookingServlet extends HttpServlet {

    private boolean isValidAppointmentTime(Date appointmentDate) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(appointmentDate);
        int hour = cal.get(Calendar.HOUR_OF_DAY);
        int minute = cal.get(Calendar.MINUTE);
        int totalMinutes = hour * 60 + minute;
        return (totalMinutes >= 420 && totalMinutes <= 690) || (totalMinutes >= 840 && totalMinutes <= 1020);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int appointmentId = Integer.parseInt(request.getParameter("id"));
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            AppointmentDAO dao = new AppointmentDAO();
            Appointment appointment = dao.getAppointmentById(appointmentId);
            if (appointment == null || currentUser == null || appointment.getCustomerId() != currentUser.getUserId()) {
                response.sendRedirect("PatientAppointmentListServlet");
                return;
            }
            ServiceDAO serviceDao = new ServiceDAO();
            UserDAO userDao = new UserDAO();
            request.setAttribute("appointment", appointment);
            request.setAttribute("services", serviceDao.getAllServices());
            request.setAttribute("doctors", userDao.getUsersByDefaultOrder("Bác sĩ"));
            request.setAttribute("patientName", currentUser.getFullName());
            request.getRequestDispatcher("customer/patient-edit-booking.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect("PatientAppointmentListServlet");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String doctorIdRaw = request.getParameter("doctorId");
            String dateStr = request.getParameter("appointmentDate");
            String note = request.getParameter("note") != null ? request.getParameter("note").trim() : "";
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            Date appointmentDate = sdf.parse(dateStr);
            Date now = new Date();

            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            AppointmentDAO dao = new AppointmentDAO();
            Appointment appointment = dao.getAppointmentById(id);

            if (appointment == null || currentUser == null || appointment.getCustomerId() != currentUser.getUserId()) {
                response.sendRedirect("PatientAppointmentListServlet");
                return;
            }

            request.setAttribute("appointment", appointment);
            request.setAttribute("note", note);
            request.setAttribute("appointmentDate", dateStr);
            request.setAttribute("doctorId", doctorIdRaw);
            request.setAttribute("serviceId", serviceId);
            request.setAttribute("patientName", currentUser.getFullName());

            StringBuilder error = new StringBuilder();

            if (!note.isEmpty()) {
                if (note.length() > 255) {
                    error.append("Ghi chú không được vượt quá 255 ký tự.\n");
                }
                if (!Character.isLetter(note.charAt(0))) {
                    error.append("Ghi chú phải bắt đầu bằng chữ cái.\n");
                }
                if (note.matches(".*<[^>]+>.*")) {
                    error.append("Không được nhập thẻ HTML vào ghi chú.\n");
                }
                for (int i = 0; i < note.length() - 2; i++) {
                    if (note.charAt(i) == note.charAt(i + 1) && note.charAt(i) == note.charAt(i + 2)) {
                        error.append("Không được nhập 3 ký tự giống nhau liên tiếp trong ghi chú.\n");
                        break;
                    }
                }
            }

            if (appointmentDate.before(now)) {
                error.append("Không thể đặt lịch trong quá khứ.\n");
            } else if (!isValidAppointmentTime(appointmentDate)) {
                error.append("Chọn khung giờ hợp lệ: 07:00–11:30 hoặc 14:00–17:00.\n");
            }

            if (error.length() > 0) {
                ServiceDAO serviceDao = new ServiceDAO();
                UserDAO userDao = new UserDAO();
                request.setAttribute("error", error.toString());
                request.setAttribute("services", serviceDao.getAllServices());
                request.setAttribute("doctors", userDao.getUsersByDefaultOrder("Bác sĩ"));
                request.getRequestDispatcher("customer/patient-edit-booking.jsp").forward(request, response);
                return;
            }

            int doctorId = (doctorIdRaw == null || doctorIdRaw.isEmpty()) ? -1 : Integer.parseInt(doctorIdRaw);
            appointment.setServiceId(serviceId);
            appointment.setDoctorId(doctorId);
            appointment.setAppointmentDate(appointmentDate);
            appointment.setNote(note);
            dao.updateAppointmentByPatient(appointment);

            response.sendRedirect("PatientAppointmentListServlet");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("customer/patient-edit-booking.jsp").forward(request, response);
        }
    }
}
