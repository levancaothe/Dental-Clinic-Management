package controller.customer;

import dao.AppointmentDAO;
import dao.NotificationDAO;
import dao.UserDAO;
import model.Appointment;
import model.Notification;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

public class PatientCreateBookingServlet extends HttpServlet {

    private boolean isValidAppointmentTime(Date appointmentDate) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(appointmentDate);
        int hour = cal.get(Calendar.HOUR_OF_DAY);
        int minute = cal.get(Calendar.MINUTE);
        int totalMinutes = hour * 60 + minute;
        return (totalMinutes >= 420 && totalMinutes <= 690) || (totalMinutes >= 840 && totalMinutes <= 1020);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            int customerId = currentUser.getUserId();
            String doctorIdRaw = request.getParameter("doctorId");
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String note = request.getParameter("note") != null ? request.getParameter("note").trim() : "";
            String dateStr = request.getParameter("appointmentDate");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            Date appointmentDate = sdf.parse(dateStr);
            Date now = new Date();

            request.setAttribute("note", note);
            request.setAttribute("appointmentDate", dateStr);
            request.setAttribute("doctorId", doctorIdRaw);
            request.setAttribute("serviceId", serviceId);

            if (!note.isEmpty()) {
                if (note.length() > 255) {
                    request.setAttribute("error", "Ghi chú không được vượt quá 255 ký tự.");
                    request.getRequestDispatcher("customer/patient-create-booking.jsp").forward(request, response);
                    return;
                } else if (!Character.isLetter(note.charAt(0))) {
                    request.setAttribute("error", "Ghi chú phải bắt đầu bằng chữ cái.");
                    request.getRequestDispatcher("customer/patient-create-booking.jsp").forward(request, response);
                    return;
                } else if (note.matches(".*<[^>]+>.*")) {
                    request.setAttribute("error", "Không được nhập thẻ HTML vào ghi chú.");
                    request.getRequestDispatcher("customer/patient-create-booking.jsp").forward(request, response);
                    return;
                } else {
                    for (int i = 0; i < note.length() - 2; i++) {
                        if (note.charAt(i) == note.charAt(i + 1) && note.charAt(i) == note.charAt(i + 2)) {
                            request.setAttribute("error", "Không được nhập 3 ký tự giống nhau liên tiếp trong ghi chú.");
                            request.getRequestDispatcher("customer/patient-create-booking.jsp").forward(request, response);
                            return;
                        }
                    }
                }
            }

            if (appointmentDate.before(now)) {
                request.setAttribute("error", "Không thể đặt lịch trong quá khứ.");
                request.getRequestDispatcher("customer/patient-create-booking.jsp").forward(request, response);
                return;
            }

            if (!isValidAppointmentTime(appointmentDate)) {
                request.setAttribute("error", "Vui lòng chọn trong các khung giờ: 07:00–11:30 hoặc 14:00–17:00");
                request.getRequestDispatcher("customer/patient-create-booking.jsp").forward(request, response);
                return;
            }

            AppointmentDAO dao = new AppointmentDAO();
            int doctorId = (doctorIdRaw == null || doctorIdRaw.isEmpty()) ? -1 : Integer.parseInt(doctorIdRaw);

            if (doctorId > 0) {
                List<Appointment> sameTimeAppointments = dao.getAppointmentsByDoctorAndTime(doctorId, appointmentDate);
                boolean hasConflict = false;
                for (Appointment a : sameTimeAppointments) {
                    if (a.getStatus() != 1 && a.getStatus() != 2) {
                        hasConflict = true;
                        break;
                    }
                }
                if (hasConflict) {
                    List<Appointment> overlaps = dao.getAppointmentsOfDoctorInDay(doctorId, appointmentDate);
                    overlaps.sort(Comparator.comparing(Appointment::getAppointmentDate));
                    request.setAttribute("appointmentsOfDoctorInDay", overlaps);
                    request.setAttribute("error", "Bác sĩ đã có lịch trong khung giờ này.");
                    request.getRequestDispatcher("customer/patient-create-booking.jsp").forward(request, response);
                    return;
                }
            }

            if (dao.isPatientBusy(customerId, appointmentDate)) {
                request.setAttribute("error", "Bạn đã có lịch khám trong khung giờ này vui lòng chọn khung giờ khác!");
                request.getRequestDispatcher("customer/patient-create-booking.jsp").forward(request, response);
                return;
            }

            Appointment appointment = new Appointment();
            appointment.setCustomerId(customerId);
            appointment.setDoctorId(doctorId);
            appointment.setServiceId(serviceId);
            appointment.setAppointmentDate(appointmentDate);
            appointment.setStatus(0);
            appointment.setNote(note);
            dao.createAppointmentByPatient(appointment);

            UserDAO userDAO = new UserDAO();
            NotificationDAO notificationDAO = new NotificationDAO();
            List<User> staffList = userDAO.getUsersByRoleId(2);
            SimpleDateFormat displayFormat = new SimpleDateFormat("HH:mm dd/MM/yyyy");

            String message;
            if (doctorId == -1) {
                message = "Bệnh nhân " + currentUser.getFullName() + " vừa đặt lịch khám lúc "
                        + displayFormat.format(appointmentDate) + " và chưa chọn bác sĩ.";
            } else {
                String doctorName = userDAO.getUserById(doctorId).getFullName();
                message = "Bệnh nhân " + currentUser.getFullName() + " vừa đặt lịch khám với bác sĩ "
                        + doctorName + " lúc " + displayFormat.format(appointmentDate) + ".";
            }

            for (User staff : staffList) {
                Notification noti = new Notification();
                noti.setUserId(staff.getUserId());
                noti.setTitle("Lịch hẹn mới từ bệnh nhân");
                noti.setMessage(message);
                noti.setIsRead(false);
                noti.setIsSentEmail(false);
                noti.setCreatedAt(new Date());
                notificationDAO.insertNotification(noti);
            }

            response.sendRedirect("PatientAppointmentListServlet");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("customer/patient-create-booking.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            dao.ServiceDAO serviceDAO = new dao.ServiceDAO();
            List<model.Service> services = serviceDAO.getAllServices();
            request.setAttribute("services", services);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách dịch vụ: " + e.getMessage());
        }
        request.getRequestDispatcher("customer/patient-create-booking.jsp").forward(request, response);
    }
}
