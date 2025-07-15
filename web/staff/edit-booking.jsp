<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User, model.Service, model.Appointment" %>
<%@ page import="dao.UserDAO, dao.ServiceDAO" %>
<!DOCTYPE html>
<%
    User currentUser = (User) session.getAttribute("user");
    String dashboardUrl = "#";
    if (currentUser != null) {
        int role = currentUser.getRoleId();
        switch (role) {
            case 1: dashboardUrl = "admin/dashboard.jsp"; break;
            case 2: dashboardUrl = "staff/dashboard.jsp"; break;
            case 3: dashboardUrl = "doctor/dashboard.jsp"; break;
            case 4: dashboardUrl = "customer/dashboard.jsp"; break;
        }
    }

    Appointment appointment = (Appointment) request.getAttribute("appointment");
    List<User> doctors = (List<User>) request.getAttribute("doctors");
    List<User> customers = (List<User>) request.getAttribute("customers");
    List<Service> services = (List<Service>) request.getAttribute("services");

    String error = (String) request.getAttribute("error");

    String statusFilter = request.getAttribute("status") != null ? (String) request.getAttribute("status") : "";
    String dateFilter = request.getAttribute("dateFilter") != null ? (String) request.getAttribute("dateFilter") : "";
    String sortBy = request.getAttribute("sortBy") != null ? (String) request.getAttribute("sortBy") : "";
    String keyword = request.getAttribute("keyword") != null ? (String) request.getAttribute("keyword") : "";
    String pageNum = request.getAttribute("page") != null ? (String) request.getAttribute("page") : "1";

    String noteValue = appointment.getNote() != null ? appointment.getNote() : "";
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
    String formattedDate = sdf.format(appointment.getAppointmentDate());
%>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chỉnh sửa lịch khám</title>
        <link href="./css/style_k.css" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
        <style>
            .bn {
                flex-wrap: wrap;
            }
            .error-message {
                color: red;
                text-align: center;
                margin-top: 10px;
                font-weight: bold;
                white-space: pre-line;
            }
            .banner .logo-link img {
                width: 60px;
                height: 60px;
                object-fit: contain;
            }
            .banner .logo-link {
                border: none;
                background: none;
                padding: 0;
            }
        </style>
    </head>
    <body>
        <div class="banner">
            <div class="logo-box">
                <a href="<%= dashboardUrl %>" class="logo-link">
                    <img src="https://img.tripi.vn/cdn-cgi/image/width=700,height=700/https://gcs.tripi.vn/public-tripi/tripi-feed/img/474089BGn/mau-logo-rang-vang-tach-nen_045001529.png" alt="Logo"/>
                </a>
            </div>
            <div style="display: flex; gap: 12px;">
                <a href="javascript:history.back()" class="btn-back">
                    <i class="fas fa-arrow-left"></i>
                    <a href="<%= dashboardUrl %>" class="btn">
                        <i class="fas fa-home"></i>
                    </a>
            </div>
        </div>

        <div class="content">
            <div class="form-container">
                <div class="header">Chỉnh sửa lịch khám</div>
                <div class="form-body">
                    <% if (error != null) { %>
                    <div class="error-message"><%= error %></div>
                    <% } %>
                    <form action="EditBookingServlet" method="post" onsubmit="return validateNote();">

                        <input type="hidden" name="status" value="<%= statusFilter %>">
                        <input type="hidden" name="date" value="<%= dateFilter %>">
                        <input type="hidden" name="sortBy" value="<%= sortBy %>">
                        <input type="hidden" name="keyword" value="<%= keyword %>">
                        <input type="hidden" name="page" value="<%= pageNum %>">

                        <input type="hidden" name="id" value="<%= appointment.getAppointmentId() %>">

                        <label for="customerId">Bệnh nhân:</label>
                        <input type="hidden" name="customerId" value="<%= appointment.getCustomerId() %>"/>
                        <span>
                            <% for (User u : customers) {
                                if (u.getUserId() == appointment.getCustomerId()) {
                                    out.print(u.getFullName());
                                    break;
                                }
                            } %>
                        </span>

                        <label for="doctorId">Bác sĩ:</label>
                        <select name="doctorId" required>
                            <% for (User u : doctors) { %>
                            <option value="<%= u.getUserId() %>" <%= u.getUserId() == appointment.getDoctorId() ? "selected" : "" %>>
                                <%= u.getFullName() %>
                            </option>
                            <% } %>
                        </select>

                        <label for="serviceId">Dịch vụ:</label>
                        <select name="serviceId" required>
                            <% for (Service s : services) { %>
                            <option value="<%= s.getServiceId() %>" <%= s.getServiceId() == appointment.getServiceId() ? "selected" : "" %>>
                                <%= s.getServiceName() %>
                            </option>
                            <% } %>
                        </select>

                        <label for="appointmentDate">Ngày khám:</label>
                        <input type="datetime-local" name="appointmentDate" required value="<%= formattedDate %>">

                        <label for="appointmentStatus">Trạng thái:</label>
                        <select name="appointmentStatus" required>
                            <option value="0" <%= appointment.getStatus() == 0 ? "selected" : "" %>>Đang xử lý</option>
                            <option value="1" <%= appointment.getStatus() == 1 ? "selected" : "" %>>Hoàn tất</option>
                            <option value="2" <%= appointment.getStatus() == 2 ? "selected" : "" %>>Đã huỷ</option>
                        </select>

                        <label for="note">Ghi chú:</label>
                        <textarea name="note" id="note" rows="4" maxlength="255"><%= noteValue %></textarea>
                        <span class="error-message" id="noteError" style="display:none;"></span>

                        <div class="buttons">
                            <button type="submit" class="btn">Cập nhật</button>
                            <button type="reset" class="btn-r">Xoá tất cả</button>
                            <button type="button" class="btn-r"
                                    onclick="window.location.href = 'ViewBookingServlet?status=<%= statusFilter %>&date=<%= dateFilter %>&sortBy=<%= sortBy %>&keyword=<%= keyword %>&page=<%= pageNum %>'">
                                Thoát
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <footer>
            Nụ cười của bạn – Sứ mệnh của chúng tôi!
        </footer>

        <script>
            const noteInput = document.getElementById("note");
            const noteError = document.getElementById("noteError");

            function validateNoteLive() {
                const note = noteInput.value.trim();

                if (note === "") {
                    hideNoteError();
                    return;
                }

                if (note.length > 255) {
                    showNoteError("Ghi chú không được vượt quá 255 ký tự.");
                } else if (/^[^a-zA-Z0-9]/.test(note)) {
                    showNoteError("Ghi chú không được bắt đầu bằng ký tự đặc biệt.");
                } else if (/<[^>]*>/.test(note)) {
                    showNoteError("Không được nhập thẻ HTML vào ghi chú.");
                } else if (!/[a-zA-Z]/.test(note.charAt(0))) {
                    showNoteError("Ghi chú phải bắt đầu bằng chữ cái.");
                } else if (/(.)\1\1/.test(note)) {
                    showNoteError("Không được nhập 3 ký tự giống nhau liên tiếp trong ghi chú.");
                } else {
                    hideNoteError();
                }
            }

            function showNoteError(msg) {
                noteInput.classList.add("is-invalid");
                noteError.textContent = msg;
                noteError.style.display = "block";
            }

            function hideNoteError() {
                noteInput.classList.remove("is-invalid");
                noteError.textContent = "";
                noteError.style.display = "none";
            }

            // Kiểm tra khi đang nhập
            noteInput.addEventListener("input", validateNoteLive);

            function validateNote() {
                const note = noteInput.value.trim();

                if (note === "")
                    return true;

                if (
                        note.length > 255 ||
                        /^[^a-zA-Z0-9]/.test(note) ||
                        /<[^>]*>/.test(note) ||
                        !/[a-zA-Z]/.test(note.charAt(0)) ||
                        /(.)\1\1/.test(note)
                        ) {
                    return false;
                }

                return true;
            }
        </script>
    </body>
</html>