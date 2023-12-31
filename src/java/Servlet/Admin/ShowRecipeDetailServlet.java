/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet.Admin;

import DAO.DirectionDAO;
import DTO.DirectionDTO;
import DAO.IngredientDetailDAO;
import DTO.IngredientDetailDTO;
import DAO.NutritionDAO;
import DTO.NutritionDTO;
import DAO.RecipeDAO;
import DTO.RecipeDTO;
import DTO.UserDTO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Admin
 */
public class ShowRecipeDetailServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
           String id = request.getParameter("id");

            RecipeDTO recipe = RecipeDAO.getRecipeByRecipeId(new Integer(id));
            request.setAttribute("recipe", recipe);

            String imgPath = RecipeDAO.getImageByRecipeId(new Integer(id)).getImgPath();
            request.setAttribute("imgPath", imgPath);

            String thumbnailPath = RecipeDAO.getThumbnailByRecipeId(recipe.getId()).getThumbnailPath();
            request.setAttribute("thumbnailPath", thumbnailPath);

            UserDTO owner = RecipeDAO.getRecipeOwnerByRecipeId(new Integer(id));
            request.setAttribute("owner", owner);

            int totalReview = RecipeDAO.getTotalReviewByRecipeId(new Integer(id));
            request.setAttribute("totalReview", totalReview);

            double avgRating = RecipeDAO.getRatingByRecipeId(new Integer(id));
            request.setAttribute("avgRating", avgRating);

            ArrayList<IngredientDetailDTO> ingredientDetailList = IngredientDetailDAO.getIngredientDetailByRecipeId(new Integer(id));
            request.setAttribute("ingredientDetailList", ingredientDetailList);

            NutritionDTO nutrition = NutritionDAO.getNutrition(new Integer(id));
            request.setAttribute("nutrition", nutrition);

            DirectionDTO direction = DirectionDAO.getDirectionByRecipeId(new Integer(id));
            request.setAttribute("direction", direction);

            request.getRequestDispatcher("showRecipeDetail.jsp").forward(request, response);

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
