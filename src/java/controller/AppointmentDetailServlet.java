package controller;

import dao.AppointmentDAO;
import dao.UserDAO;
import dao.ServiceDAO;
import model.Appointment;
import model.User;
import model.Service;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AppointmentDetailServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int appointmentId = Integer.parseInt(request.getParameter("id"));
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            UserDAO userDAO = new UserDAO();
            ServiceDAO serviceDAO = new ServiceDAO();

            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);

            if (appointment != null) {
                User patient = userDAO.getUserById(appointment.getCustomerId());
                User doctor = userDAO.getUserById(appointment.getDoctorId());
                Service service = serviceDAO.getServiceById(appointment.getServiceId());

                request.setAttribute("appointment", appointment);
                request.setAttribute("patient", patient);
                request.setAttribute("doctor", doctor);
                request.setAttribute("service", service);
                request.getRequestDispatcher("appointment-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect("error.jsp?message=Không tìm thấy lịch khám với ID " + appointmentId);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("error.jsp?message=ID không hợp lệ");
        } catch (Exception e) {
            response.sendRedirect("error.jsp?message=Lỗi hệ thống: " + e.getMessage());
        }
    }
}
