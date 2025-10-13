package com.vaccination.controller;

import com.vaccination.dao.VaccineDAO;
import com.vaccination.dao.CenterDAO;
import com.vaccination.model.Vaccine;
import com.vaccination.model.Center;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet({"/", "/home"})
public class HomeServlet extends HttpServlet {
    private VaccineDAO vaccineDAO = new VaccineDAO();
    private CenterDAO centerDAO = new CenterDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Vaccine> vaccines = vaccineDAO.getAllVaccines();
        List<Center> centers = centerDAO.getAllCenters();

        request.setAttribute("vaccines", vaccines);
        request.setAttribute("centers", centers);

        request.getRequestDispatcher("/views/guest/home.jsp").forward(request, response);
    }
}
