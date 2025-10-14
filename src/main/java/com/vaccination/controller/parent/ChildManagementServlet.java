package com.vaccination.controller.parent;

import com.vaccination.dao.ChildDAO;
import com.vaccination.model.Child;
import com.vaccination.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/parent/children/*")
public class ChildManagementServlet extends HttpServlet {
    private ChildDAO childDAO = new ChildDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"PARENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            List<Child> children = childDAO.findByParentId(user.getUserId());
            request.setAttribute("children", children);
            request.getRequestDispatcher("/views/parent/children-list.jsp").forward(request, response);
        } else if (pathInfo.equals("/add")) {
            request.getRequestDispatcher("/views/parent/child-add.jsp").forward(request, response);
        } else if (pathInfo.equals("/view")) {
            int childId = Integer.parseInt(request.getParameter("id"));
            Child child = childDAO.findById(childId);
            
            if (child != null && child.getParentId() == user.getUserId()) {
                request.setAttribute("child", child);
                request.getRequestDispatcher("/views/parent/child-view.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/parent/children");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"PARENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String pathInfo = request.getPathInfo();
        
        if (pathInfo != null && pathInfo.equals("/add")) {
            String fullName = request.getParameter("fullName");
            String dateOfBirth = request.getParameter("dateOfBirth");
            String gender = request.getParameter("gender");
            String bloodType = request.getParameter("bloodType");
            String medicalHistory = request.getParameter("medicalHistory");
            String allergies = request.getParameter("allergies");
            String weightStr = request.getParameter("weight");
            String heightStr = request.getParameter("height");

            if (fullName == null || dateOfBirth == null || gender == null) {
                request.setAttribute("error", "Full name, date of birth, and gender are required");
                request.getRequestDispatcher("/views/parent/child-add.jsp").forward(request, response);
                return;
            }

            Child child = new Child();
            child.setParentId(user.getUserId());
            child.setFullName(fullName);
            child.setDateOfBirth(LocalDate.parse(dateOfBirth));
            child.setGender(gender);
            child.setBloodType(bloodType);
            child.setMedicalHistory(medicalHistory);
            child.setAllergies(allergies);
            child.setActive(true);

            if (weightStr != null && !weightStr.trim().isEmpty()) {
                child.setWeight(new BigDecimal(weightStr));
            }

            if (heightStr != null && !heightStr.trim().isEmpty()) {
                child.setHeight(new BigDecimal(heightStr));
            }

            if (childDAO.createChild(child)) {
                response.sendRedirect(request.getContextPath() + "/parent/dashboard");
            } else {
                request.setAttribute("error", "Failed to add child. Please try again.");
                request.getRequestDispatcher("/views/parent/child-add.jsp").forward(request, response);
            }
        }
    }
}
