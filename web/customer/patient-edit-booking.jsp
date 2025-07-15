<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Appointment, dao.UserDAO, dao.ServiceDAO, model.Service, model.User" %>
<%
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    if (appointment == null) {
        response.sendRedirect("PatientAppointmentListServlet");
        return;
    }
    UserDAO userDao = new UserDAO();
    ServiceDAO serviceDao = new ServiceDAO();
    Service service = serviceDao.getServiceById(appointment.getServiceId());
    User doctor = userDao.getUserById(appointment.getDoctorId());
    String error = (String) request.getAttribute("error");
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chỉnh sửa lịch khám</title>
        <link rel="stylesheet" href="css/style_k.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
        <style>
            .error-message {
                color: red;
                font-weight: bold;
                margin-bottom: 15px;
                text-align: center;
                white-space: pre-line;
            }
            .banner {
                background-color: #d0f0fd;
                padding: 15px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                box-shadow: 0 2px 6px rgba(0,0,0,0.05);
            }
            .banner img {
                width: 60px;
                height: 60px;
                object-fit: contain;
            }
            .banner a:not(.logo-box a) {
                font-weight: bold;
                color: #0078B4;
                text-decoration: none;
                border: 1px solid #64ccff;
                padding: 8px 16px;
                border-radius: 8px;
                background-color: white;
                transition: all 0.3s ease;
            }
            .banner a:not(.logo-box a):hover {
                background-color: #64ccff;
                color: white;
            }
            .btn-r {
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <div class="banner">
            <div class="logo-box">
                <a href="customer/dashboard.jsp">
                    <img src="https://img.tripi.vn/cdn-cgi/image/width=700,height=700/https://gcs.tripi.vn/public-tripi/tripi-feed/img/474089BGn/mau-logo-rang-vang-tach-nen_045001529.png" alt="Logo"/>
                </a>
            </div>
            <div style="display: flex; gap: 12px;">
                <a href="javascript:history.back()" class="btn-back"><i class="fas fa-arrow-left"></i></a>
                <a href="customer/dashboard.jsp" class="btn"><i class="fas fa-home"></i></a>
            </div>
        </div>

        <div class="content">
            <div class="form-container">
                <div class="header">Chỉnh sửa lịch khám</div>
                <div class="form-body">
                    <% if (error != null) { %>
                    <div class="error-message"><%= error.replaceAll("\n", "<br>") %></div>
                    <% } %>
                    <form action="PatientEditBookingServlet" method="post">
                        <input type="hidden" name="id" value="<%= appointment.getAppointmentId() %>">

                        <label for="serviceId">Dịch vụ:</label>
                        <select name="serviceId" required>
                            <% for (Service s : serviceDao.getAllServices()) { %>
                            <option value="<%= s.getServiceId() %>" <%= s.getServiceId() == appointment.getServiceId() ? "selected" : "" %>>
                                <%= s.getServiceName() %>
                            </option>
                            <% } %>
                        </select>

                        <label for="appointmentDate">Ngày khám:</label>
                        <input type="datetime-local" name="appointmentDate" value="<%= sdf.format(appointment.getAppointmentDate()) %>" required>

                        <label for="note">Ghi chú:</label>
                        <textarea name="note" maxlength="255"><%= appointment.getNote() != null ? appointment.getNote() : "" %></textarea>
                        <div id="note-error" class="error-message" style="display: none;"></div>

                        <div class="buttons">
                            <button type="submit" class="btn">Cập nhật</button>
                            <a href="PatientAppointmentListServlet" class="btn-r">Quay lại</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <footer>
            Nụ cười của bạn – Sứ mệnh của chúng tôi!
        </footer>

        <script>
            const noteInput = document.querySelector("textarea[name='note']");
            const noteError = document.getElementById("note-error");
            const form = document.querySelector("form");

            function validateNote() {
                const note = noteInput.value.trim();
                noteError.style.display = "none";
                noteError.innerText = "";

                if (note === "")
                    return true;

                if (note.length > 255) {
                    showError("Ghi chú không được vượt quá 255 ký tự.");
                    return false;
                }
                if (!/^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừửữựỳỵỷỹỶỸỴỲỴỶỸỴ]/.test(note)) {
                    showError("Ghi chú phải bắt đầu bằng chữ cái.");
                    return false;
                }
                if (/<[^>]*>/.test(note)) {
                    showError("Không được nhập thẻ HTML vào ghi chú.");
                    return false;
                }
                if (/(.)\1\1/.test(note)) {
                    showError("Không được nhập 3 ký tự giống nhau liên tiếp trong ghi chú.");
                    return false;
                }

                return true;
            }

            function showError(message) {
                noteError.innerText = message;
                noteError.style.display = "block";
            }

            form.addEventListener("submit", function (e) {
                if (!validateNote()) {
                    e.preventDefault();
                }
            });

            noteInput.addEventListener("input", function () {
                if (validateNote()) {
                    noteError.style.display = "none";
                }
            });
        </script>
    </body>
</html>