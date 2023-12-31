/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import DAO.RecipeDAO;
import DTO.DisplayRecipeDTO;
import DTO.RecipeDTO;
import DTO.UserDTO;
import Utils.NavigationBarUtils;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author khang
 */
public class SearchServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            String admin = request.getParameter("admin");
            String txtsearch = request.getParameter("txtsearch").toLowerCase();
            String searchBy = request.getParameter("searchBy").toLowerCase();

            //Search recipe for admin
            if (admin != null) {
                ArrayList<RecipeDTO> list = NavigationBarUtils.searchRecipes(txtsearch, searchBy);
                ArrayList<DisplayRecipeDTO> displayList = new ArrayList<>();
                for (RecipeDTO r : list) {
                    String thumbnailPath = RecipeDAO.getThumbnailByRecipeId(r.getId()).getThumbnailPath();
                    String category = RecipeDAO.getCategoryByRecipeId(r.getId());
                    double rating = RecipeDAO.getRatingByRecipeId(r.getId());
                    UserDTO owner = RecipeDAO.getRecipeOwnerByRecipeId(r.getId());

                    DisplayRecipeDTO d = new DisplayRecipeDTO(r.getId(), r.getTitle(), thumbnailPath, category, rating, owner);
                    displayList.add(d);
                }
                request.setAttribute("searchRecipesList", displayList);
                request.getRequestDispatcher("manageRecipe.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("searchRecipesList", null);
                session.setAttribute("ERROR_MSG", null);
                session.setAttribute("SUCCESS_MSG", null);

                if (txtsearch == null || txtsearch.equals("")) {
                    session.setAttribute("ERROR_MSG", "What do you want to eat? Please search");
                } else {
                    ArrayList<RecipeDTO> list = NavigationBarUtils.searchRecipes(txtsearch, searchBy);
                    ArrayList<DisplayRecipeDTO> displayList = new ArrayList<>();
                    for (RecipeDTO r : list) {
                        String thumbnailPath = RecipeDAO.getThumbnailByRecipeId(r.getId()).getThumbnailPath();
                        String category = RecipeDAO.getCategoryByRecipeId(r.getId());
                        double rating = RecipeDAO.getRatingByRecipeId(r.getId());
                        UserDTO owner = RecipeDAO.getRecipeOwnerByRecipeId(r.getId());

                        DisplayRecipeDTO d = new DisplayRecipeDTO(r.getId(), r.getTitle(), thumbnailPath, category, rating, owner);
                        displayList.add(d);
                    }
                    if (list.size() != 0) {
                        request.setAttribute("searchRecipesList", displayList);
                        session.setAttribute("SUCCESS_MSG", "Result of '" + txtsearch + "' in recipe's " + searchBy);
                    } else {
                        session.setAttribute("ERROR_MSG", "There is no '" + txtsearch + "' in recipe's " + searchBy);
                    }

                }
                request.getRequestDispatcher("searchResultPage.jsp").forward(request, response);
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
