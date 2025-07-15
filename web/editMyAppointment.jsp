<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Appointment" %>
<%@ page import="dao.ServiceDAO" %>
<%@ page import="model.Service" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    Appointment app = (Appointment) request.getAttribute("appointment");
    ServiceDAO sdao = new ServiceDAO();
    List<Service> services = sdao.getAllServices();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
%>
<html>
    <head>
        <title>Sửa lịch hẹn</title>
    </head>
    <body>
        <h2>Sửa lịch hẹn</h2>
        <form action="PatientEditBookingServlet" method="post">
            <input type="hidden" name="id" value="<%= app.getAppointmentId() %>">

            <label>Dịch vụ:</label>
            <select name="serviceId">
                <% for (Service s : services) { %>
                <option value="<%= s.getServiceId() %>" <%= s.getServiceId() == app.getServiceId() ? "selected" : "" %>>
                    <%= s.getServiceName() %>
                </option>
                <% } %>
            </select><br>

            <label>Ngày khám:</label>
            <input type="datetime-local" name="appointmentDate" value="<%= sdf.format(app.getAppointmentDate()) %>" required><br>

            <label>Ghi chú:</label>
            <textarea name="note" maxlength="255"><%= app.getNote() %></textarea><br>

            <input type="submit" value="Cập nhật">
        </form>
    </body>
</html>