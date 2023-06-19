/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Suggestion;

import Recipe.RecipeDTO;
import Utils.DBUtils;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.TreeMap;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Admin
 */
public class SuggestionDAO {

    private static final String DATE_FORMAT = "yyyy-MM-dd";

    public static TreeMap<String, Integer> getSuggestionMap() {
        TreeMap<String, Integer> map = new TreeMap<String, Integer>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();

            if (cn != null) {
                String sql = "SELECT title, COUNT(recipe_id) as total FROM Suggestion s\n"
                        + "INNER JOIN SuggestionRecipe sg\n"
                        + "ON s.id = sg.suggestion_id\n"
                        + "GROUP BY title";

                PreparedStatement pst = cn.prepareStatement(sql);
                ResultSet rs = pst.executeQuery();
                if (rs != null) {
                    while (rs.next()) {
                        String title = rs.getString("title");
                        int total = rs.getInt("total");

                        map.put(title, total);
                    }
                }
                rs.close();
                pst.close();
                cn.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public static int getSuggestionIdFromSuggestionRecipe(String title) {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();

            if (cn != null) {
                String sql = "SELECT suggestion_id FROM SuggestionRecipe \n"
                        + "WHERE suggestion_id IN (SELECT id FROM Suggestion WHERE title = ?)";

                PreparedStatement pst = cn.prepareStatement(sql);
                pst.setString(1, title);
                ResultSet rs = pst.executeQuery();
                if (rs != null) {
                    while (rs.next()) {
                        result = rs.getInt("suggestion_id");
                    }
                }

                pst.close();
                cn.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public static int deleteSuggestionRecipe(int suggestionId) {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();

            if (cn != null) {
                String sql = "DELETE FROM SuggestionRecipe \n"
                        + "WHERE suggestion_id = ?";

                PreparedStatement pst = cn.prepareStatement(sql);
                pst.setInt(1, suggestionId);
                result = pst.executeUpdate();
                pst.close();
                cn.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public static int deleteSuggestionRecipeByRecipeId(int suggestionId, int recipeId) {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();

            if (cn != null) {
                String sql = "DELETE FROM SuggestionRecipe \n"
                        + "WHERE suggestion_id = ? AND recipe_id = ?";

                PreparedStatement pst = cn.prepareStatement(sql);
                pst.setInt(1, suggestionId);
                pst.setInt(2, recipeId);
                result = pst.executeUpdate();
                pst.close();
                cn.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public static int deleteSuggestion(String title) {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();

            if (cn != null) {
                String sql = "DELETE FROM Suggestion \n"
                        + "WHERE title = ?";

                PreparedStatement pst = cn.prepareStatement(sql);
                pst.setString(1, title);
                result = pst.executeUpdate();
                pst.close();
                cn.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public static int insertSuggestionList(int suggestionId, int recipeId) {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "INSERT INTO SuggestionRecipe(suggestion_id, recipe_id) \n"
                    + "VALUES (?, ?)";
            PreparedStatement pst = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pst.setInt(1, suggestionId);
            pst.setInt(2, recipeId);

            result = pst.executeUpdate();
//            ResultSet generatedKeys = pst.getGeneratedKeys();
//
//            if (generatedKeys.next()) {
//                generatedId = generatedKeys.getInt(1);
//            }
//
//            generatedKeys.close();
            pst.close();
            cn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    public static boolean checkSuggestionExist(String title) {
        boolean result = false;
        String oldTitle = "";
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT * FROM Suggestion WHERE title = ?";
            PreparedStatement pst = cn.prepareStatement(sql);
            pst.setString(1, title);

            ResultSet rs = pst.executeQuery();
            if (rs != null && rs.next()) {
                oldTitle = rs.getString("title");
            }
            cn.close();
            if (oldTitle.equalsIgnoreCase(title)) {
                return true;
            }

            pst.close();
            cn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
    
    public static int getTotalRecipeBySuggestion(int suggestionId) {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT COUNT(recipe_id) as total FROM SuggestionRecipe WHERE suggestion_id = ?";
            PreparedStatement pst = cn.prepareStatement(sql);
            pst.setInt(1, suggestionId);

            ResultSet rs = pst.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    result = rs.getInt("total");
                }
            }

            pst.close();
            cn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    public static int updateSuggestionRecipe(int suggestionId, int recipeId) {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "UPDATE SuggestionRecipe SET recipe_id = ?\n"
                    + "WHERE suggestion_id = ?";
            PreparedStatement pst = cn.prepareStatement(sql);
            pst.setInt(1, recipeId);
            pst.setInt(2, suggestionId);

            pst.executeUpdate();

            pst.close();
            cn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    public static int insertSuggestion(String title, int userId) {
        int generatedId = -1;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "INSERT INTO Suggestion(title, user_id) \n"
                    + "VALUES (?, ?)";
            PreparedStatement pst = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pst.setString(1, title);
            pst.setInt(2, userId);

            pst.executeUpdate();
            ResultSet generatedKeys = pst.getGeneratedKeys();

            if (generatedKeys.next()) {
                generatedId = generatedKeys.getInt(1);
            }

            generatedKeys.close();
            pst.close();
            cn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return generatedId;
    }

    public static RecipeDTO fromString(String string) {
        String[] parts = string.split(",");

        SimpleDateFormat dateFormat = new SimpleDateFormat(DATE_FORMAT);

        RecipeDTO recipe = new RecipeDTO();
        recipe.setId(Integer.parseInt(parts[0]));
        recipe.setTitle(parts[1]);
        recipe.setDescription(parts[2]);
        recipe.setPrep_time(Integer.parseInt(parts[3]));
        recipe.setCook_time(Integer.parseInt(parts[4]));
        recipe.setServings(Integer.parseInt(parts[5]));

        try {
            java.util.Date utilDate = dateFormat.parse(parts[6]);
            java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
            recipe.setCreate_at(sqlDate);
        } catch (ParseException ex) {
            Logger.getLogger(SuggestionDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        try {
            java.util.Date utilDate = dateFormat.parse(parts[7]);
            java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
            recipe.setUpdate_at(sqlDate);
        } catch (ParseException ex) {
            Logger.getLogger(SuggestionDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        recipe.setCuisine_id(Integer.parseInt(parts[8]));
        recipe.setCategory_id(Integer.parseInt(parts[9]));
        recipe.setUser_id(Integer.parseInt(parts[10]));
        recipe.setLevel_id(Integer.parseInt(parts[11]));
        recipe.setStatus(Integer.parseInt(parts[12]));

        return recipe;
    }

    public static ArrayList<String> getAllSuggestion() {
        ArrayList<String> result = new ArrayList<>();
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();

            if (cn != null) {
                String sql = "SELECT * FROM Suggestion ";

                PreparedStatement pst = cn.prepareStatement(sql);
                ResultSet rs = pst.executeQuery();
                if (rs != null) {
                    while (rs.next()) {
//                        int id = rs.getInt("id");
                        String title = rs.getString("title");
//                        int userId = rs.getInt("user_id");

//                        SuggestionDTO suggestion = new SuggestionDTO(id, title, userId);
                        result.add(title);
                    }
                }
                rs.close();
                pst.close();
                cn.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    public static ArrayList<RecipeDTO> getAllRecipesBySuggestion(String suggestion) {
        ArrayList<RecipeDTO> result = new ArrayList<>();
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();

            if (cn != null) {
                String sql = "SELECT * FROM Recipe WHERE id IN (SELECT recipe_id FROM SuggestionRecipe sg\n"
                        + "JOIN Suggestion s\n"
                        + "ON sg.suggestion_id = s.id\n"
                        + "WHERE s.title = ? AND status = 3)";

                PreparedStatement pst = cn.prepareStatement(sql);
                pst.setString(1, suggestion);
                ResultSet rs = pst.executeQuery();
                if (rs != null) {
                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String title = rs.getString("title");
                        String description = rs.getString("description");
                        int prep_time = rs.getInt("prep_time");
                        int cook_time = rs.getInt("cook_time");
                        int servings = rs.getInt("servings");
                        Date create_at = rs.getDate("create_at");
                        Date update_at = rs.getDate("update_at");
                        int cuisin_id = rs.getInt("cuisine_id");
                        int category_id = rs.getInt("category_id");
                        int user_id = rs.getInt("user_id");
                        int level_id = rs.getInt("level_id");
                        int status = rs.getInt("status");

                        RecipeDTO recipe = new RecipeDTO(id, title, description, prep_time,
                                cook_time, servings, create_at, update_at, cuisin_id,
                                category_id, user_id, level_id, status);
                        result.add(recipe);
                    }
                }
                rs.close();
                pst.close();
                cn.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    public static void main(String[] args) {
        System.out.println(SuggestionDAO.deleteSuggestionRecipe(4));
    }
}
