<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.text.SimpleDateFormat" %>
<%@ page import="dao.UserDAO, dao.ServiceDAO" %>
<%@ page import="model.Service, model.User, model.Appointment" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    UserDAO userDao = new UserDAO();
    ServiceDAO serviceDao = new ServiceDAO();
    List<User> doctors = userDao.getUsersByDefaultOrder("Bác sĩ");
    List<Service> services = serviceDao.getAllServices();

    String error = (String) request.getAttribute("error");
    List<Appointment> overlaps = (List<Appointment>) request.getAttribute("appointmentsOfDoctorInDay");

    String note = (String) request.getAttribute("note");
    String appointmentDate = (String) request.getAttribute("appointmentDate");
    String doctorIdStr = (String) request.getAttribute("doctorId");
    Integer serviceIdAttr = (Integer) request.getAttribute("serviceId");

    SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đặt lịch khám</title>
        <link rel="stylesheet" href="css/style_k.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <style>
            .banner .logo-link {
                display: inline-block;
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
            .banner .logo-link:hover {
                background: none;
                color: inherit;
                cursor: pointer;
            }
            .error-message {
                color: #d8000c;
                text-align: center;
                padding: 12px 16px;
                margin-bottom: 15px;
                border-radius: 4px;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div class="banner bn">
            <div class="logo-box">
                <a href="customer/dashboard.jsp" class="btn">
                    <img src="https://img.tripi.vn/cdn-cgi/image/width=700,height=700/https://gcs.tripi.vn/public-tripi/tripi-feed/img/474089BGn/mau-logo-rang-vang-tach-nen_045001529.png" alt="Logo"/>
                </a>
            </div>
            <div style="display: flex; gap: 12px;">
                <a href="javascript:history.back()" class="btn-back">
                    <i class="fas fa-arrow-left"></i>
                </a>
                <a href="customer/dashboard.jsp" class="btn">
                    <i class="fas fa-home"></i>
                </a>
            </div>
        </div>

        <div class="content">
            <div class="form-container">
                <div class="header">Đặt lịch khám</div>
                <div class="form-body">
                    <% if (error != null) { %>
                    <div class="error-message"><%= error.replaceAll("\n", "<br>") %></div>
                    <% } %>

                    <% if (overlaps != null && !overlaps.isEmpty()) { %>
                    <div class="info-message">
                        <strong>Các ca khám khác của bác sĩ trong ngày:</strong>
                        <ul>
                            <% for (Appointment ap : overlaps) { %>
                            <li><%= df.format(ap.getAppointmentDate()) %></li>
                                <% } %>
                        </ul>
                    </div>
                    <% } %>

                    <form action="PatientCreateBookingServlet" method="post">
                        <label for="serviceId">Dịch vụ:</label>
                        <select name="serviceId" required>
                            <% for (Service s : services) { %>
                            <option value="<%= s.getServiceId() %>" 
                                    <%= (serviceIdAttr != null && serviceIdAttr == s.getServiceId()) ? "selected" : "" %>>
                                <%= s.getServiceName() %>
                            </option>
                            <% } %>
                        </select>

                        <label for="doctorId">Bác sĩ (tuỳ chọn):</label>
                        <select name="doctorId">
                            <option value="">-- Chưa chọn --</option>
                            <% for (User d : doctors) { %>
                            <option value="<%= d.getUserId() %>" 
                                    <%= (doctorIdStr != null && doctorIdStr.equals(String.valueOf(d.getUserId()))) ? "selected" : "" %>>
                                <%= d.getFullName() %>
                            </option>
                            <% } %>
                        </select>

                        <label for="appointmentDate">Ngày khám:</label>
                        <input type="datetime-local" name="appointmentDate" required 
                               value="<%= appointmentDate != null ? appointmentDate : "" %>">

                        <label for="note">Ghi chú:</label>
                        <textarea name="note" rows="3" maxlength="255"><%= note != null ? note : "" %></textarea>
                        <div id="note-error" class="error-message" style="display:none;"></div>


                        <div class="buttons">
                            <button type="submit" class="btn">Xác nhận</button>
                            <button type="reset" class="btn-r">Xoá tất cả</button>
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
                if (!/^[a-zA-Z]/.test(note)) {
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