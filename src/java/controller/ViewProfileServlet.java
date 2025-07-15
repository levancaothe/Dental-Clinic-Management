package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.User;

public class ViewProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        if (userIdStr == null || userIdStr.isEmpty()) {
            request.getRequestDispatcher("viewProfile.jsp").forward(request, response);
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserById(userId);

            if (user == null) {
                request.setAttribute("error", "Không tìm thấy người dùng với UserID: " + userId);
            } else {
                request.setAttribute("user", user);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "UserID không hợp lệ!");
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi lấy thông tin người dùng: " + e.getMessage());
        }

        request.getRequestDispatcher("viewProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
