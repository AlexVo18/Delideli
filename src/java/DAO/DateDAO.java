/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DTO.DateDTO;
import Utils.DBUtils;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

/**
 *
 * @author Daiisuke
 */
public class DateDAO {

    public static ArrayList<DateDTO> getAllDateByPlanID(int plan_id) {
        Connection con = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        ArrayList<DateDTO> result = new ArrayList<>();

        String sql = "SELECT * FROM [Date]\n"
                + "WHERE [plan_id] = ?";

        try {
            con = DBUtils.getConnection();
            if (con != null) {
                stm = con.prepareStatement(sql);
                stm.setInt(1, plan_id);

                rs = stm.executeQuery();
                while (rs.next()) {
                    int id = rs.getInt("id");
                    Date date = rs.getDate("date");
                    int week_id = rs.getInt("week_id");
                    plan_id = rs.getInt("plan_id");

                    DateDTO planDate = new DateDTO(id, date, week_id, plan_id);
                    result.add(planDate);
                }
            }
        } catch (SQLException ex) {
            System.out.println("Query error - getPlanIdByUserIdAndDate: " + ex.getMessage());
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stm != null) {
                    stm.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException ex) {
                System.out.println("Error closing database resources: " + ex.getMessage());
            }
        }
        return result;
    }

    public static boolean insertAllDatesWithinAWeek(Date start_date, Date end_date, int week_id, int plan_id) {
        Connection con = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        int effectRows = 0;

        String sql = "INSERT INTO [Date](date, week_id, plan_id)\n"
                + "VALUES (?, ?, ?)";

        try {
            con = DBUtils.getConnection();
            if (con != null) {

                List<Date> dates = new ArrayList<>();

                // Iterate through calendar
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(start_date);

                // Iterate from start_date until end_date, we add each date into a list.
                while (!calendar.getTime().after(end_date)) {
                    Date currentDate = new Date(calendar.getTime().getTime()); // Convert java.util.Date to java.sql.Date
                    dates.add(currentDate);
                    calendar.add(Calendar.DAY_OF_MONTH, 1);
                }

                // Insert each date into the database
                for (Date date : dates) {
                    stm = con.prepareStatement(sql);
                    stm.setDate(1, date);
                    stm.setInt(2, week_id);
                    stm.setInt(3, plan_id);
                    effectRows = stm.executeUpdate();
                }

                if (effectRows > 0) {
                    return true;
                }
            }
        } catch (SQLException ex) {
            System.out.println("Query error - insertAllDatesWithinAWeek: " + ex.getMessage());
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stm != null) {
                    stm.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException ex) {
                System.out.println("Error closing database resources: " + ex.getMessage());
            }
        }
        return false;
    }

    public static boolean insertDate(Date date, int week_id, int plan_id) {
        Connection con = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        int effectRows = 0;

        String sql = "INSERT INTO [Date](date, week_id, plan_id)\n"
                + "VALUES (?, ?, ?)";

        try {
            con = DBUtils.getConnection();
            if (con != null) {

                stm = con.prepareStatement(sql);
                stm.setDate(1, date);
                stm.setInt(2, week_id);
                stm.setInt(3, plan_id);
                effectRows = stm.executeUpdate();

                if (effectRows > 0) {
                    return true;
                }
            }
        } catch (SQLException ex) {
            System.out.println("Query error - insertAllDatesWithinAWeek: " + ex.getMessage());
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stm != null) {
                    stm.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException ex) {
                System.out.println("Error closing database resources: " + ex.getMessage());
            }
        }
        return false;
    }

    public static boolean updateDate(int date_id, Date new_date) {
        Connection con = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        int effectRows = 0;

        String sql = "UPDATE [Date]\n"
                + "SET date = ?\n"
                + "WHERE id = ? ";

        try {
            con = DBUtils.getConnection();
            if (con != null) {

                stm = con.prepareStatement(sql);
                stm.setDate(1, new_date);
                stm.setInt(2, date_id);
                effectRows = stm.executeUpdate();

                if (effectRows > 0) {
                    return true;
                }
            }
        } catch (SQLException ex) {
            System.out.println("Query error - updateDate: " + ex.getMessage());
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stm != null) {
                    stm.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException ex) {
                System.out.println("Error closing database resources: " + ex.getMessage());
            }
        }
        return false;
    }

}
