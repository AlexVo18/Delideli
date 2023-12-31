/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import DAO.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Daiisuke
 */
@WebServlet(name = "verify", urlPatterns = {"/verify"})
public class verify extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String receivedToken = (String) request.getParameter("token"); //url param emailConfirmServlet
        String userType = (String) request.getParameter("type");
        System.out.println("[SERVLET - verify]: Token received: " + receivedToken);
        System.out.println("[SERVLET - verify]: User received: " + userType);
        UserDAO userDAO = new UserDAO();

        Boolean verificationResult = userDAO.verifyToken(receivedToken);

        if (verificationResult && userType.equals("ForgotPassUser")) {
            System.out.println("[SERVLET - verify]: Token logged: " + receivedToken);
            HttpSession session = request.getSession();
            session.setAttribute("TOKENDB", receivedToken); //Send to ResetPassServlet as req
            RequestDispatcher rd = request.getRequestDispatcher("resetPassword.jsp");
            rd.forward(request, response);
        } else if (verificationResult && userType.equals("RegisterUser")) {
            System.out.println("[SERVLET - verify]: Token logged: " + receivedToken);
            userDAO.updateStatus(receivedToken);
            response.sendRedirect("TriggerAppServlet");
        } else {
            response.sendRedirect("expiredToken.html");
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
