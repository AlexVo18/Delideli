/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet.User;

import DAO.DateDAO;
import DAO.PlanDAO;
import DAO.WeekDAO;
import DTO.PlanDTO;
import DTO.UserDTO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Daiisuke
 */
public class SychronizeTemplateServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        int plan_id = Integer.parseInt(request.getParameter("plan_id"));
        String checkbox_state = request.getParameter("checkbox_state");
        String dateIdsString = request.getParameter("date_ids");

        String[] dateIdsArray = dateIdsString.split(",");
        int[] dateIds = new int[dateIdsArray.length];
        for (int i = 0; i < dateIdsArray.length; i++) {
            dateIds[i] = Integer.parseInt(dateIdsArray[i]);
        }

        PlanDTO plan = PlanDAO.getPlanById(plan_id);
        if (plan != null) {

            if (plan.isDaily()) {

                for (int date_id : dateIds) {
                    if (checkbox_state.equalsIgnoreCase("checked")) {
                        DateDAO.updateSyncStatus(date_id, true);
                    } else {
                        DateDAO.updateSyncStatus(date_id, false);
                    }
                }
            }else{
                int weekId = WeekDAO.getWeekIdByDateId(dateIds[1]);
                if (checkbox_state.equalsIgnoreCase("checked")) {
                        WeekDAO.updateSyncStatus(weekId, true);
                    } else {
                        WeekDAO.updateSyncStatus(weekId, false);
                    }
            }

        }

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
