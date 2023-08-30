<%-- 
    Document   : addRecipeToPlan
    Created on : Jun 22, 2023, 9:08:19 AM
    Author     : Walking Bag
--%>

<%@page import="Utils.DateNameChanger"%>
<%@page import="DTO.WeekDTO"%>
<%@page import="java.time.temporal.ChronoUnit"%>
<%@page import="java.util.Calendar"%>
<%@page import="DAO.DateDAO"%>
<%@page import="DTO.DateDTO"%>
<%@page import="DTO.NutritionDTO"%>
<%@page import="DTO.DisplayRecipeDTO"%>
<%@page import="DAO.DietDAO"%>
<%@page import="DTO.DietDTO"%>
<%@page import="DAO.RecipeDAO"%>
<%@page import="DTO.RecipeDTO"%>
<%@page import="DAO.MealDAO"%>
<%@page import="DTO.MealDTO"%>
<%@page import="DTO.PlanDTO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <title>Delideli</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!--      Bootstrap         -->
        <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>
        <!--      CSS         -->
        <link rel="stylesheet" href="./styles/userStyle.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link
            href="https://fonts.googleapis.com/css2?family=Fira+Sans+Extra+Condensed:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">

        <script>
            function setRecipeId(button, recipeId) {
                document.getElementById("recipeIdInput" + recipeId).value = recipeId;
            }
        </script>
    </head>

    <body>

        <%
            PlanDTO plan = (PlanDTO) request.getAttribute("plan");
            WeekDTO week = (WeekDTO) request.getAttribute("week");
            String selectedDate = (String) request.getAttribute("selectedDate");
            boolean SEARCH_PLAN_REAL = (boolean) request.getAttribute("SEARCH_PLAN_REAL");
            ArrayList<DateDTO> planDate = (ArrayList<DateDTO>) request.getAttribute("planDate");
            ArrayList<DateDTO> allPlanDate = (ArrayList<DateDTO>) request.getAttribute("allPlanDate");
            boolean error = (boolean) request.getAttribute("max_meal_error");
            LocalDate currentDate = LocalDate.now();
            java.sql.Date startDateSQL = plan.getStart_at();
            LocalDate startLocalDate = startDateSQL.toLocalDate();

            // This exist only to redirect page based on selected date.
            int distanceInDays = (int) ChronoUnit.DAYS.between(startLocalDate, currentDate);

            String distanceInDaysParam = request.getParameter("distanceInDays");
            if (distanceInDaysParam != null) {
                distanceInDays = Integer.parseInt(distanceInDaysParam);
            }

            //Weekly (hard-code week id)
            ArrayList<DateDTO> weeklyDate = (ArrayList<DateDTO>) DateDAO.getAllDateByPlanIDAndWeekID(plan.getId(), week.getId());
        %>

        <!--         The navigation bar       -->
        <%@include file="header.jsp" %>

        <!--         Recipe Plan       -->
        <div class="blank-background">
            <div class="container">
                <div class="row plan">  
                    <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="home.jsp">Home</a></li>
<!--                            <li class="breadcrumb-item"><a href="UserController?action=editPlan&id=<%= plan.getId()%>&isSearch=false"> Plan - <%= plan.getName()%> </a></li>-->
                            <li class="breadcrumb-item"><a href="UserController?action=planManagement&userId=<%=user.getId()%>"> Plans List </a></li> 
                            <li class="breadcrumb-item" aria-current="page"><a href="UserController?action=getPlanDetailById&id=<%= plan.getId()%>"> <%= plan.getName()%> </a></li>
                            <li class="breadcrumb-item current-link" aria-current="page">Edit</li>
                        </ol>
                    </nav>
                    <div class="edit-plan-header">
                        <p>Edit Plan</p>
                        <p>Edit, add or remove recipes from your plan to fit more with your eating schedule</p>
                    </div>



                    <% for (DateDTO dateList : planDate) {%>
                    <input type="hidden" class="dateIdInput" name="date_id" value="<%= dateList.getId()%>" />
                    <% }%>

                    <script>
                        function activateSync(checkbox, planId) {
                            var xhr = new XMLHttpRequest();
                            var url = "SychronizeTemplateServlet";
                            var parameterValue = checkbox.checked ? "checked" : "unchecked";

                            var dateIdInputs = document.getElementsByClassName("dateIdInput");
                            var dateIds = [];
                            for (var i = 0; i < dateIdInputs.length; i++) {
                                dateIds.push(dateIdInputs[i].value);
                            }

                            var params = "plan_id=" + planId + "&checkbox_state=" + parameterValue + "&date_ids=" + dateIds.join(',');

                            xhr.open("GET", url + "?" + params, true);
                            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

                            xhr.onreadystatechange = function () {
                                if (xhr.readyState === XMLHttpRequest.DONE) {
                                    if (xhr.status === 200) {
                                        console.log("AJAX request success.");
                                    } else {
                                        console.error("AJAX request failed.");
                                    }
                                }
                            };
                            xhr.send();
                        }
                    </script>

                    <div class="plan-navbar">
                        <div>
                            <form action="UserController">
                                <input name="id" value="<%= plan.getId()%>" hidden="">
                                <% if (plan.isDaily()) { %>
                                <input name="isDaily" value="true" hidden="">
                                <button type="submit" class="plan-navbar-remove" name="action" value="loadEditDailyTemplate" >
                                    Template
                                </button>
                                <% } else { %>
                                <input name="isDaily" value="false" hidden="">
                                <button type="submit" class="plan-navbar-remove" name="action" value="loadEditWeeklyTemplate" >
                                    Template
                                </button>
                                <% }%>
                            </form>


                            <%
                                // Lazy get 1 isSync .3.
                                boolean isSync = false;
                                for (DateDTO dateList : planDate) {
                                    isSync = dateList.isSync();
                                    break;
                                }
                            %>

                            <div class="sync-checkbox">
                                <input type="checkbox" id="isSync" name="isSync" value="1" <%= isSync ? "checked" : ""%> onchange="activateSync(this, <%= plan.getId()%>)">
                                <label for="isSync">Sync with template</label>
                            </div>

                        </div>

                        <div>

                            <button type="button" class="plan-navbar-remove" data-bs-toggle="modal"  data-bs-target="#removeAllRecipes">
                                Remove All Recipes
                            </button>
                            <!-- Modal -->
                            <div class="modal fade" id="removeAllRecipes" tabindex="-1"
                                 aria-labelledby="removeAllRecipesModalLabel" aria-hidden="true">
                                <form action="UserController" method="POST" class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h1 class="modal-title fs-5" id="removeAllRecipesModalLabel">Remove All Recipes</h1>
                                        </div>
                                        <div class="modal-body">
                                            Are you sure you want to remove all recipes in this plan ?
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">No, I changed my mind</button>

                                            <input type="hidden" name="plan_id" value="<%= plan.getId()%>" />
                                            <input type="hidden" name="plan_id" value="<%= plan.getId()%>" />
                                            <% for (DateDTO dateList : planDate) {%>
                                            <input type="hidden" class="dateIdInput" name="date_id" value="<%= dateList.getId()%>" />
                                            <% }%>
                                            <input type="hidden" name="distanceInDays" value="<%= distanceInDays%>" />
                                            <input type="hidden" name="isTemplate" value="false" />
                                            <% if (plan.isDaily()) { %>
                                            <input type="hidden" name="isDaily" value="true" />
                                            <%} else {%>
                                            <input type="hidden" name="selectedDate" value="<%= selectedDate%>" />
                                            <input type="hidden" name="isDaily" value="false" />
                                            <%}%>

                                            <button type="submit" name="action" value="removeAllRecipeConfirmed" class="remove-recipe-from-plan-button">Yes, remove all of them</button>
                                        </div>
                                    </div>  
                                </form>
                            </div>


                        </div>




                        <!-- <button class="plan-navbar-edit">
                                <a href="userViewPlan.html"><img src="./assets/leave.svg" alt=""></a>
                            </button> -->
                    </div>
                    <%
                        String minDate = allPlanDate.get(0).getDate().toLocalDate().toString();
                        String maxDate = allPlanDate.get(allPlanDate.size() - 1).getDate().toLocalDate().toString();
                        if (plan.isDaily()) {
                    %>
                    <div class="date-changer"> 
                        <input type="date" name="dateChanger" id="dateInput" min="<%= allPlanDate.get(0).getDate()%>" max="<%= allPlanDate.get(allPlanDate.size() - 1).getDate()%>" onchange="updateDate(this.value)">
                    </div>
                    <script>
                        function updateDate(dateValue) {
                            var distanceInDays = 0;

                            var selectedDate = new Date(dateValue);
                            var startDate = new Date("<%= allPlanDate.get(0).getDate()%>");

                            var distanceInTime = Math.abs(selectedDate.getTime() - startDate.getTime());
                            var distanceInDays = Math.ceil(distanceInTime / (1000 * 3600 * 24));

                            console.log("Distance between selected date and start date:", distanceInDays, "days");

                            var servletURL = "PlanEditServlet?id=" + <%= plan.getId()%> + "&distanceInDays=" + distanceInDays;
                            window.location.href = servletURL;
                        }
                    </script>
                    <%
                    } else {
                    %>
                    <div class="date-changer"> 
                        <input type="date" name="dateChanger" id="dateInput" min="<%= minDate%>" max="<%= maxDate%>" onchange="sendDateToServlet()">
                    </div>
                    <script>
                        function sendDateToServlet() {
                            var selectedDate = new Date(document.getElementById("dateInput").value);
                            var servletURL = "PlanEditServlet?id=<%= plan.getId()%>&selectedDate=" + selectedDate.toISOString() + "&isSearch=false";
                            window.location.href = servletURL;
                        }
                    </script>
                    <%
                        }
                    %>
                    <div class=" plan-table">
                        <%
                            for (DateDTO dateList : planDate) {
                                SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM d", Locale.ENGLISH);
                                String formattedDate = DateNameChanger.formatDateWithOrdinalIndicator(dateList.getDate(), dateFormat);
                                ArrayList<MealDTO> breakfastMeals = MealDAO.getAllMealsTimeBased(plan.getId(), dateList.getId(), true, false, false);
                                ArrayList<MealDTO> lunchMeals = MealDAO.getAllMealsTimeBased(plan.getId(), dateList.getId(), false, true, false);
                                ArrayList<MealDTO> dinnerMeals = MealDAO.getAllMealsTimeBased(plan.getId(), dateList.getId(), false, false, true);
                                ArrayList<NutritionDTO> recipeNutrition = MealDAO.getSumNutritionValuesByDateId(dateList.getId());
                        %>
                        <div class="row plan-table-week">
                            <div class="col-md-12 plan-table-week-day">
                                <%
                                    SimpleDateFormat dayOfWeekFormat = new SimpleDateFormat("EEEE");
                                    String dayOfWeek = dayOfWeekFormat.format(dateList.getDate());
                                %>
                                <%= dayOfWeek%> (<%= formattedDate%>)
                            </div>
                            <div class="col-md-3 plan-table-week-column">
                                <div class="plan-table-week-nutrition-header">Total Nutrition</div>
                                <%
                                    for (NutritionDTO nutrition : recipeNutrition) {
                                %>
                                <div class="plan-table-week-nutrition">
                                    <p class="plan-table-calories">Calories: <%= nutrition.getCalories()%></p>
                                    <p class="plan-table-protein">Proteins: <%= nutrition.getProtein()%> g</p>
                                    <p class="plan-table-carb">Carbs: <%= nutrition.getCarbs()%> g</p>
                                    <p class="plan-table-fat">Fats: <%= nutrition.getFat()%> g</p>
                                </div>
                                <%
                                    }
                                %>
                            </div>

                            <%
                                //DateDTO date = DateDAO.getDateByPlanID(plan.getId());
                            %>

                            <div class="col-md-3 plan-table-week-column">
                                <div class="plan-table-week-header">Morning</div>

                                <div class="plan-table-week-recipe">
                                    <% if (breakfastMeals != null && breakfastMeals.size() != 0) {
                                            for (MealDTO list : breakfastMeals) {
                                                RecipeDTO recipe = RecipeDAO.getRecipeByRecipeId(list.getRecipe_id());
                                                String modalId = "recipeNutritionModal" + list.getId();
                                    %>
                                    <button class="plan-table-week-recipe-content" type="button" data-bs-toggle="modal" data-bs-target="#<%= modalId%>">
                                        <div class="plan-table-week-recipe-content-image">
                                            <img src="ServletImageLoader?identifier=<%= RecipeDAO.getThumbnailByRecipeId(recipe.getId()).getThumbnailPath()%>" alt="">
                                        </div>
                                        <div class="plan-table-week-recipe-content-des">
                                            <p class="plan-table-week-recipe-content-des-title"><%= recipe.getTitle()%></p>
                                            <% SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm a");
                                                String formattedTime = timeFormat.format(list.getStart_time());
                                            %>
                                            <p class="plan-table-week-recipe-content-des-time"><%= formattedTime%></p>
                                        </div>
                                    </button>

                                    <!-- Modal -->
                                    <div class="modal fade" id="<%= modalId%>" tabindex="-1" aria-labelledby="recipeNutritionModalLabel" aria-hidden="true">
                                        <form action="UserController" method="POST" class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h1 class="modal-title fs-5" id="exampleModalLabel"><%= recipe.getTitle()%></h1>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body recipe-nutriton-modal">
                                                    <a class="recipe-nutriton-modal-image" href="MainController?action=getRecipeDetailById&id=<%= recipe.getId()%>" target="_blank">
                                                        <img src="ServletImageLoader?identifier=<%= RecipeDAO.getThumbnailByRecipeId(recipe.getId()).getThumbnailPath()%>" alt="">
                                                        <h3><%= recipe.getTitle()%></h3>
                                                    </a>

                                                    <div class="row recipe-nutrtion-modal-time">
                                                        <div class="col-md-6">
                                                            <div >Start time: </div>
                                                            <br>
                                                            <div><%= formattedTime%></div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div>Chose time again: <span>(Optional)</span></div>
                                                            <input type="time" id="start_time" name="start_time" class="start-time-input" value="<%= list.getStart_time()%>">

                                                        </div>
                                                    </div>
                                                </div>
                                                <!--                                                <div class="modal-body recipe-nutriton-modal">
                                                                                                    <label for="start_time">Chose the time again if you want:</label>
                                                                                                    <input type="time" id="start_time" name="start_time" class="start-time-input" value="<%= list.getStart_time()%>">
                                                                                                </div>-->

                                                <div class="plan-table">
                                                    <% for (DateDTO dateAList : planDate) {%>
                                                    <input type="hidden" id="recipeIdInput<%= list.getId()%>" name="recipe_id" value="<%= list.getId()%>">
                                                    <input type="hidden" name="plan_id" value="<%= plan.getId()%>" />
                                                    <input type="hidden" name="week_id" value="<%= dateList.getWeek_id()%>" />
                                                    <input type="hidden" name="plan_start" value="<%= plan.getStart_at()%>" />
                                                    <input type="hidden" name="date_id" value="<%= dateList.getId()%>" />
                                                    <input type="hidden" name="distanceInDays" value="<%= distanceInDays%>" />
                                                    <input type="hidden" name="isTemplate" value="false" />
                                                    <%if (plan.isDaily()) {%>
                                                    <input type="hidden" name="isDaily" value="true" />
                                                    <% } else {%>
                                                    <input type="hidden" name="selectedDate" value="<%= selectedDate%>" />
                                                    <input type="hidden" name="isDaily" value="false" />
                                                    <% }%>
                                                    <% }%>
                                                </div>

                                                <input type="hidden" id="recipeIdInput<%= list.getId()%>" name="meal_id" value="<%= list.getId()%>">

                                                <div class="modal-footer">
                                                    <button type="submit" id="changeTimeBtn" name="action" value="editStartTimeRecipe" class="add-recipe-to-plan-modal-button" 
                                                            data-recipeid="<%= list.getId()%>" onclick="setRecipeId(this, '<%= list.getId()%>')">Change time</button>

                                                    <button type="submit" name="action" value="removePlanRecipe" class="remove-recipe-from-plan-button" 
                                                            data-recipeid="<%= list.getId()%>" onclick="setRecipeId(this, '<%= list.getId()%>')">Remove</button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>

                                    <%
                                        }
                                    } else {
                                    %>
                                    <button class="plan-table-week-recipe-add" onclick="scrollToSection('addSection')">
                                        <div>
                                            <img src="./assets/add-icon.svg" alt="">
                                        </div>
                                    </button>
                                    <% }%>
                                </div>
                            </div>


                            <div class="col-md-3 plan-table-week-column">
                                <div class="plan-table-week-header">Afternoon</div>

                                <div class="plan-table-week-recipe">
                                    <% if (lunchMeals != null && lunchMeals.size() != 0) {
                                            for (MealDTO list : lunchMeals) {
                                                RecipeDTO recipe = RecipeDAO.getRecipeByRecipeId(list.getRecipe_id());
                                                String modalId = "recipeNutritionModal" + list.getId();
                                    %>
                                    <button class="plan-table-week-recipe-content" type="button" data-bs-toggle="modal" data-bs-target="#<%= modalId%>">
                                        <div class="plan-table-week-recipe-content-image">
                                            <img src="ServletImageLoader?identifier=<%= RecipeDAO.getThumbnailByRecipeId(recipe.getId()).getThumbnailPath()%>" alt="">
                                        </div>
                                        <div class="plan-table-week-recipe-content-des">
                                            <p class="plan-table-week-recipe-content-des-title"><%= recipe.getTitle()%></p>
                                            <% SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm a");
                                                String formattedTime = timeFormat.format(list.getStart_time());
                                            %>
                                            <p class="plan-table-week-recipe-content-des-time"><%= formattedTime%></p>
                                        </div>
                                    </button>

                                    <!-- Modal -->
                                    <div class="modal fade" id="<%= modalId%>" tabindex="-1" aria-labelledby="recipeNutritionModalLabel" aria-hidden="true">
                                        <form action="UserController" method="POST" class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h1 class="modal-title fs-5" id="exampleModalLabel"><%= recipe.getTitle()%></h1>
                                                    <h1 class="modal-title fs-5" id="exampleModalLabel">Start time: <%= list.getStart_time()%></h1>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body recipe-nutriton-modal">
                                                    <div class="recipe-nutriton-modal-image">
                                                        <img src="ServletImageLoader?identifier=<%= RecipeDAO.getThumbnailByRecipeId(recipe.getId()).getThumbnailPath()%>" alt="">
                                                    </div>
                                                </div>

                                                <div class="modal-body recipe-nutriton-modal">
                                                    <label for="start_time">Chose the time again if you want:</label>
                                                    <input type="time" id="start_time_afternoon" name="start_time" class="start-time-input" value="<%= list.getStart_time()%>">
                                                </div>

                                                <div class="plan-table">
                                                    <% for (DateDTO dateAList : planDate) {%>
                                                    <input type="hidden" id="recipeIdInput<%= list.getId()%>" name="recipe_id" value="<%= list.getId()%>">
                                                    <input type="hidden" name="plan_id" value="<%= plan.getId()%>" />
                                                    <input type="hidden" name="week_id" value="<%= dateList.getWeek_id()%>" />
                                                    <input type="hidden" name="plan_start" value="<%= plan.getStart_at()%>" />
                                                    <input type="hidden" name="date_id" value="<%= dateList.getId()%>" />
                                                    <input type="hidden" name="distanceInDays" value="<%= distanceInDays%>" />
                                                    <input type="hidden" name="isTemplate" value="false" />
                                                    <%if (plan.isDaily()) {%>
                                                    <input type="hidden" name="isDaily" value="true" />
                                                    <% } else {%>
                                                    <input type="hidden" name="selectedDate" value="<%= selectedDate%>" />
                                                    <input type="hidden" name="isDaily" value="false" />
                                                    <% }%>
                                                    <% }%>
                                                </div>

                                                <input type="hidden" id="recipeIdInput<%= list.getId()%>" name="meal_id" value="<%= list.getId()%>">

                                                <div class="modal-footer">
                                                    <button type="submit" id="changeTimeAfternoonBtn" name="action" value="editStartTimeRecipe" class="remove-recipe-from-plan-button" 
                                                            data-recipeid="<%= list.getId()%>" onclick="setRecipeId(this, '<%= list.getId()%>')"
                                                            >Change time</button>
                                                    <button type="submit" name="action" value="removePlanRecipe" class="remove-recipe-from-plan-button" data-recipeid="<%= list.getId()%>" onclick="setRecipeId(this, '<%= list.getId()%>')">Remove</button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>

                                    <%
                                        }
                                    } else {
                                    %>
                                    <button class="plan-table-week-recipe-add" onclick="scrollToSection('addSection')">
                                        <div>
                                            <img src="./assets/add-icon.svg" alt="">
                                        </div>
                                    </button>
                                    <% } %>
                                </div>
                            </div>



                            <div class="col-md-3 plan-table-week-column">
                                <div class="plan-table-week-header">Night</div>

                                <div class="plan-table-week-recipe">
                                    <% if (dinnerMeals != null && dinnerMeals.size() != 0) {
                                            for (MealDTO list : dinnerMeals) {
                                                RecipeDTO recipe = RecipeDAO.getRecipeByRecipeId(list.getRecipe_id());
                                                String modalId = "recipeNutritionModal" + list.getId();
                                    %>
                                    <button class="plan-table-week-recipe-content" type="button" data-bs-toggle="modal" data-bs-target="#<%= modalId%>">
                                        <div class="plan-table-week-recipe-content-image">
                                            <img src="ServletImageLoader?identifier=<%= RecipeDAO.getThumbnailByRecipeId(recipe.getId()).getThumbnailPath()%>" alt="">
                                        </div>
                                        <div class="plan-table-week-recipe-content-des">
                                            <p class="plan-table-week-recipe-content-des-title"><%= recipe.getTitle()%></p>
                                            <% SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm a");
                                                String formattedTime = timeFormat.format(list.getStart_time());
                                            %>
                                            <p class="plan-table-week-recipe-content-des-time"><%= formattedTime%></p>
                                        </div>
                                    </button>

                                    <!-- Modal -->
                                    <div class="modal fade" id="<%= modalId%>" tabindex="-1" aria-labelledby="recipeNutritionModalLabel" aria-hidden="true">
                                        <form action="UserController" method="POST" class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h1 class="modal-title fs-5" id="exampleModalLabel"><%= recipe.getTitle()%></h1>
                                                    <h1 class="modal-title fs-5" id="exampleModalLabel">Start time: <%= list.getStart_time()%></h1>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body recipe-nutriton-modal">
                                                    <div class="recipe-nutriton-modal-image">
                                                        <img src="ServletImageLoader?identifier=<%= RecipeDAO.getThumbnailByRecipeId(recipe.getId()).getThumbnailPath()%>" alt="">
                                                    </div>
                                                </div>

                                                <div class="modal-body recipe-nutriton-modal">
                                                    <label for="start_time">Chose the time again if you want:</label>
                                                    <input type="time" id="start_time_night" name="start_time" class="start-time-input" value="<%= list.getStart_time()%>">
                                                </div>

                                                <div class="plan-table">
                                                    <% for (DateDTO dateAList : planDate) {%>
                                                    <input type="hidden" id="recipeIdInput<%= list.getId()%>" name="recipe_id" value="<%= list.getId()%>">
                                                    <input type="hidden" name="plan_id" value="<%= plan.getId()%>" />
                                                    <input type="hidden" name="week_id" value="<%= dateList.getWeek_id()%>" />
                                                    <input type="hidden" name="plan_start" value="<%= plan.getStart_at()%>" />
                                                    <input type="hidden" name="date_id" value="<%= dateList.getId()%>" />
                                                    <input type="hidden" name="distanceInDays" value="<%= distanceInDays%>" />
                                                    <input type="hidden" name="isTemplate" value="false" />
                                                    <%if (plan.isDaily()) {%>
                                                    <input type="hidden" name="isDaily" value="true" />
                                                    <% } else {%>
                                                    <input type="hidden" name="selectedDate" value="<%= selectedDate%>" />
                                                    <input type="hidden" name="isDaily" value="false" />
                                                    <% }%>
                                                    <% }%>
                                                </div>

                                                <input type="hidden" id="recipeIdInput<%= list.getId()%>" name="meal_id" value="<%= list.getId()%>">

                                                <div class="modal-footer">
                                                    <button type="submit" id="changeTimeNightBtn" name="action" value="editStartTimeRecipe" class="remove-recipe-from-plan-button" 
                                                            data-recipeid="<%= list.getId()%>" onclick="setRecipeId(this, '<%= list.getId()%>')"
                                                            >Change time</button>
                                                    <button type="submit" name="action" value="removePlanRecipe" class="remove-recipe-from-plan-button" data-recipeid="<%= list.getId()%>" onclick="setRecipeId(this, '<%= list.getId()%>')">Remove</button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>

                                    <%
                                        }
                                    } else {
                                    %>
                                    <button class="plan-table-week-recipe-add" onclick="scrollToSection('addSection')">
                                        <div>
                                            <img src="./assets/add-icon.svg" alt="">
                                        </div>
                                    </button>
                                    <% } %>
                                </div>
                            </div>



                        </div>
                        <%
                            }
                        %>
                    </div>





                </div>






                <!-- Add recipe -->
                <div class="row add-recipe-to-plan-section" id="addSection">
                    <% if (SEARCH_PLAN_REAL) { %>
                    <script>
                        window.onload = function () {
                            const scrollTarget = document.getElementById("scrollTarget");
                            scrollTarget.scrollIntoView({behavior: 'smooth'});
                        }
                    </script>
                    <% }%>
                    <div class="add-recipe-to-plan">
                        <div class="edit-plan-header">
                            <p>Add Section</p>
                            <p>Add recipes based on the type of plan that you have chosen</p>
                        </div>
                        <div class="add-recipe-to-plan-search-bar">
                            <form action="UserController" method="post">
                                <button type="submit" name="action" value="recipePlanSearch">
                                    <img src="assets/search-icon.svg" alt="">
                                </button>
                                <input type="text" name="txtsearch" placeholder="What recipes are you searching for ?">
                                <input type="hidden" name="isPlan" value="true" />
                                <input type="hidden" name="planId" value="<%= plan.getId()%>"/>
                                <input type="hidden" name="user_id" value="<%= user.getId()%>"/>
                                <input type="hidden" name="dietId" value="<%= plan.getDiet_id()%>"/>
                                <input type="hidden" name="distanceInDays" value="<%= distanceInDays%>" />
                                <input type="hidden" name="isTemplate" value="false" />
                                <%if (plan.isDaily()) {%>
                                <input type="hidden" name="isDaily" value="true" />
                                <% } else {%>
                                <input type="hidden" name="selectedDate" value="<%= selectedDate%>" />
                                <input type="hidden" name="isDaily" value="false" />
                                <% }%>

                                <select name="searchBy" id="">
                                    <option value="Public" selected="selected">Public</option>
                                    <option value="Personal">Personal</option>
                                    <option value="Saved">Saved</option>
                                </select>
                            </form>
                        </div>
                    </div>
                    <div id="scrollTarget"></div> <!-- Added scrollTarget element -->




                    <div class="row add-recipe-to-plan-content">
                        <%
                            ArrayList<DisplayRecipeDTO> searchRecipesList = (ArrayList<DisplayRecipeDTO>) request.getAttribute("SEARCH_LIST");
                            if (searchRecipesList != null && !searchRecipesList.isEmpty()) {
                                for (DisplayRecipeDTO list : searchRecipesList) {
                                    ArrayList<NutritionDTO> recipeNutrition = RecipeDAO.getNutritionValuesByRecipeID(list.getId());
                        %>
                        <div href="" class=" col-md-3 add-recipe-to-plan-content-recipe">
                            <a href="MainController?action=getRecipeDetailById&id=<%= list.getId()%>" target="_blank">
                                <div class="add-recipe-to-plan-content-recipe-image">
                                    <img src="ServletImageLoader?identifier=<%= RecipeDAO.getThumbnailByRecipeId(list.getId()).getThumbnailPath()%>" alt="">
                                </div>
                                <div class="add-recipe-to-plan-content-recipe-title"><%= list.getTitle()%></div>

                                <%
                                    for (NutritionDTO nutrition : recipeNutrition) {
                                %>
                                <div class="add-recipe-to-plan-content-recipe-nutrients">
                                    <p class="plan-table-calories">Calories: <%= nutrition.getCalories()%></p>
                                    <p class="plan-table-protein">Proteins: <%= nutrition.getProtein()%> g</p>
                                    <p class="plan-table-carb">Carbs: <%= nutrition.getCarbs()%> g</p>
                                    <p class="plan-table-fat">Fats: <%= nutrition.getFat()%> g</p>
                                </div>
                                <%
                                    }
                                %>
                            </a>
                            <%

                            %>
                            <div class="add-recipe-to-plan-content-recipe-button">
<!--                                <button type="button" class="" data-bs-toggle="modal" data-bs-target="#addRecipeToPlan<%= list.getId()%>">
                                    Add
                                </button>
                                -->
                                <%
                                    if (plan.isDaily()) {
                                %>
                                <button type="button" class="" data-bs-toggle="modal" data-bs-target="#addMultiplesMealToPlan<%= list.getId()%>">
                                    Add
                                </button>  
                                <%
                                } else {
                                %>
                                <button type="button" class="" data-bs-toggle="modal" data-bs-target="#addWeeklyMealToPlan<%= list.getId()%>">
                                    Add
                                </button>
                                <%
                                    }
                                %>

                            </div>
                        </div>

                        <!-- Weekly Meal-->
                        <div class="modal fade" id="addWeeklyMealToPlan<%= list.getId()%>" tabindex="-1"
                             aria-labelledby="addRecipeToPlanModalLabel<%= list.getId()%>" aria-hidden="true">
                            <form action="UserController" method="post" class="modal-dialog add-recipe-to-plan-modal modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h1 class="modal-title fs-5" id="exampleModalLabel<%= list.getId()%>">Adding Weekly Meal To Plan</h1>
                                    </div>
                                    <div class="modal-body">
                                        <div>What day do you want to cook this recipe?</div>
                                        <div class="row choose-week-day">
                                            <% for (DateDTO dateList : weeklyDate) {
                                                    SimpleDateFormat dayOfWeekFormat = new SimpleDateFormat("EEEE");
                                                    String dayOfWeek = dayOfWeekFormat.format(dateList.getDate());

                                                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                                                    String formattedDate = dateFormat.format(dateList.getDate());

                                                    // Get the end date of the plan
                                                    Date endDate = plan.getEnd_at();
                                                    Calendar calendar = Calendar.getInstance();
                                                    calendar.setTime(dateList.getDate());

                                                    // Loop through the days between the selected day and the end date
                                                    //while (calendar.getTime().before(endDate) || calendar.getTime().equals(endDate)) {
                                            %>
                                            <div class="col-md-6">
                                                <div class="d-flex">
                                                    <input type="checkbox" id="date_id<%= dateList.getId()%>" name="date_id" value="<%= dateList.getId()%>">
                                                    <label for="dateOfWeek<%= dateList.getId()%>"> <%= dayOfWeek%> <span>(<%= formattedDate%>)</span> </label>
                                                </div>
                                            </div>

                                            <%

                                                    // Increment the calendar by 1 day
                                                    //calendar.add(Calendar.DAY_OF_MONTH, 1);
                                                    //dayOfWeek = dayOfWeekFormat.format(calendar.getTime());
                                                    //formattedDate = dateFormat.format(calendar.getTime());
                                                    //}
                                                }%>
                                        </div>
                                        <div class="row add-recipe-info-ingredient">
                                            <div class="draggable-container-time col-md-8 add-recipe-info-ingredient-content">
                                                <div class="add-recipe-info-header">Time <span>*</span></div>
                                                <div class="draggable-time-container">
                                                    <!-- Existing draggable time elements -->
                                                </div>
                                            </div>
                                            <div class="col-md-4 add-recipe-info-ingredient-button">
                                                <button type="button" id="btnToggleTime" style="display: none">
                                                    <img src="assets/drag-icon.svg" alt="">
                                                </button>
                                                <button type="button" id="btnAddTime">
                                                    Add Time
                                                </button>
                                            </div>
                                        </div>
                                        <br><br>

                                    </div>

                                    <div class="plan-table">
                                        <% for (DateDTO dateList : planDate) {%>
                                        <input type="hidden" id="recipeIdInput<%= list.getId()%>" name="recipe_id" value="<%= list.getId()%>">
                                        <input type="hidden" name="plan_id" value="<%= plan.getId()%>" />
                                        <!-- week id hard code here -->
                                        <input type="hidden" name="week_id" value="<%= week.getId()%>" />
                                        <input type="hidden" name="distanceInDays" value="<%= distanceInDays%>" />
                                        <input type="hidden" name="isTemplate" value="false" />
                                        <% if (plan.isDaily()) {%>
                                        <input type="hidden" name="isDaily" value="true" />
                                        <% }%>
                                        <input type="hidden" name="selectedDate" value="<%= selectedDate%>" />
                                        <input type="hidden" name="isDaily" value="false" />
                                        <% }%>
                                    </div>

                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                        <button type="submit" name="action" value="addPlanMultiplesMeal" class="add-recipe-to-plan-modal-button"
                                                data-recipeid="<%= list.getId()%>" onclick="setRecipeId(this, '<%= list.getId()%>');" disabled="" id="btnAddRecipe">Add</button>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <script>
                            document.addEventListener("DOMContentLoaded", function () {
                                const modal = document.getElementById("addWeeklyMealToPlan<%= list.getId()%>");

                                let draggablesTime = []; // Array to store draggable time elements
                                let dragTime = false; // Flag to track drag mode

                                // Function to toggle drag mode
                                function toggleDragModeTime(enableDragMode) {
                                    dragTime = enableDragMode;
                                    draggablesTime.forEach((draggable) => {
                                        draggable.draggable = dragTime;
                                        draggable.classList.toggle('drag-mode-disabled', !dragTime);
                                        draggable.style.cursor = dragTime ? 'grab' : 'default';
                                    });
                                }

                                // Function to create options for select element
                                function createOptions(selectElement, selectedOptions, selectedValue) {
                                    // Clear existing options by removing all children
                                    while (selectElement.firstChild) {
                                        selectElement.removeChild(selectElement.firstChild);
                                    }

                                    const timeOptions = [];
                                    for (let hour = 0; hour < 24; hour++) {
                                        const time = hour.toString().padStart(2, '0') + ':00'; // Format the time as HH:00
                                        if (!selectedOptions.includes(time)) {
                                            timeOptions.push(time);
                                        }
                                    }

                                    // Always include the selected time even if it's deleted from other elements
                                    if (selectedValue && !selectedOptions.includes(selectedValue)) {
                                        timeOptions.push(selectedValue);
                                    }

                                    for (let i = 0; i < timeOptions.length; i++) {
                                        const option = document.createElement('option');
                                        option.value = timeOptions[i];
                                        option.text = timeOptions[i];
                                        selectElement.appendChild(option);
                                    }

                                    selectElement.setAttribute('required', true); // Add the "required" attribute
                                }

                                // Function to check if any time is selected
                                function isAnyTimeOptionSelected() {
                                    const selectElements = modal.querySelectorAll('.timeList');
                                    const hasSelectedTimeOptions = Array.from(selectElements).some(select => select.value !== '');
                                    return hasSelectedTimeOptions || draggablesTime.length > 0;
                                }

                                // Function to update the "Add" button state
                                function updateAddButtonState() {
                                    const btnAddTime = modal.querySelector('#btnAddRecipe');
                                    btnAddTime.disabled = !isAnyTimeOptionSelected() || draggablesTime.length === 0;
                                }


                                // Add event listener to the toggle button
                                modal.querySelector("#btnToggleTime").addEventListener('click', () => {
                                    toggleDragModeTime(!dragTime); // Toggle the drag mode
                                });

                                // Add event listener to the add button
                                modal.querySelector("#btnAddTime").addEventListener('click', () => {
                                    if (!dragTime && draggablesTime.length < 6) { // Check the maximum limit
                                        const draggableContainer = modal.querySelector('.draggable-container-time');
                                        const selectedOptions = Array.from(draggableContainer.querySelectorAll('.timeList')).map(select => select.value);
                                        const newDraggable = document.createElement('p');
                                        newDraggable.classList.add('draggable-time');
                                        newDraggable.classList.add('draggable');
                                        newDraggable.draggable = dragTime;

                                        const newSelect = document.createElement('select');
                                        newSelect.classList.add('timeList');
                                        newSelect.name = 'timeId';
                                        // Pass the selected value of the current time element
                                        const selectedValue = selectedOptions.length === 0 ? '' : selectedOptions[selectedOptions.length - 1];
                                        createOptions(newSelect, selectedOptions, selectedValue);

                                        const deleteButton = document.createElement('button');
                                        deleteButton.type = 'button';
                                        deleteButton.classList.add('btnDeleteTime');

                                        const deleteImage = document.createElement('img');
                                        deleteImage.src = 'assets/close-icon.svg';
                                        deleteImage.alt = 'Delete';

                                        deleteButton.appendChild(deleteImage);
                                        deleteButton.addEventListener('click', () => {
                                            newDraggable.remove();
                                            draggablesTime = draggableContainer.querySelectorAll('.draggable-time'); // Update the draggable elements
                                            if (draggablesTime.length === 1) {
                                                disableDeleteButtons();
                                            }
                                        });

                                        newDraggable.appendChild(newSelect);
                                        newDraggable.appendChild(deleteButton);

                                        draggableContainer.appendChild(newDraggable);
                                        draggablesTime = draggableContainer.querySelectorAll('.draggable-time'); // Update the draggable elements

                                        enableDeleteButtons();
                                        updateAddButtonState();
                                    }
                                });


                                // Function to get the closest element during drag and drop
                                function getDragAfterElement(container, y) {
                                    const draggableElements = [...container.querySelectorAll('.draggable:not(.dragging)')];
                                    return draggableElements.reduce((closest, child) => {
                                        const box = child.getBoundingClientRect();
                                        const offset = y - box.top - box.height / 2;
                                        if (offset < 0 && offset > closest.offset) {
                                            return {offset: offset, element: child};
                                        } else {
                                            return closest;
                                        }
                                    }, {offset: Number.NEGATIVE_INFINITY}).element;
                                }

                                // Function to enable delete buttons
                                function enableDeleteButtons() {
                                    modal.querySelectorAll('.btnDeleteTime').forEach((button) => {
                                        button.addEventListener('click', () => {
                                            button.parentNode.remove();
                                            draggablesTime = draggableContainer.querySelectorAll('.draggable-time'); // Update the draggable elements
                                            if (draggablesTime.length === 1) {
                                                disableDeleteButtons();
                                            }
                                        });
                                    });
                                }

                                // Function to disable delete buttons
                                function disableDeleteButtons() {
                                    modal.querySelectorAll('.btnDeleteTime').forEach((button) => {
                                        button.disabled = true;
                                    });
                                }

                                modal.querySelectorAll('.timeList').forEach((selectElement) => {
                                    selectElement.addEventListener('change', () => {
                                        updateAddButtonState();
                                    });
                                });

                                // Add event listener to the modal's shown event
                                modal.addEventListener('shown.bs.modal', function () {
                                    const draggableContainer = modal.querySelector('.draggable-container-time');
                                    const btnToggleTime = modal.querySelector('#btnToggleTime');
                                    const btnAddTime = modal.querySelector('#btnAddTime');
                                    const btnDeleteTime = modal.querySelectorAll('.btnDeleteTime');

                                    draggablesTime = draggableContainer.querySelectorAll('.draggable-time');

                                    toggleDragModeTime(dragTime);

                                    btnToggleTime.addEventListener('click', () => {
                                        toggleDragModeTime(!dragTime);
                                    });

                                    btnAddTime.addEventListener('click', () => {
                                        // Rest of the code...
                                    });

                                    enableDeleteButtons();

                                    draggableContainer.addEventListener('dragover', (e) => {
                                        e.preventDefault();
                                        const afterElement = getDragAfterElement(draggableContainer, e.clientY);
                                        const draggable = document.querySelector('.dragging');
                                        if (afterElement == null) {
                                            draggableContainer.appendChild(draggable);
                                        } else {
                                            draggableContainer.insertBefore(draggable, afterElement);
                                        }
                                    });

                                    updateAddButtonState();
                                });

                                // Function to clear all select options in the modal
                                // Function to clear all select options in the modal
                                function clearSelectOptions() {
                                    const selectElements = modal.querySelectorAll('.timeList');
                                    selectElements.forEach((select) => {
                                        const selectedValue = select.value;
                                        const selectedOptions = Array.from(select.children).map(option => option.value);
                                        createOptions(select, selectedOptions, selectedValue);
                                    });
                                }


                                // Add event listener to the "Close" button
                                modal.querySelector("button[data-bs-dismiss='modal']").addEventListener('click', () => {
                                    clearSelectOptions();
                                });

                                // Add event listener to the modal's hidden event
                                modal.addEventListener('hidden.bs.modal', () => {
                                    clearSelectOptions();
                                });

                            });
                        </script>



                        <!-- Daily Meal-->
                        <div class="modal fade" id="addMultiplesMealToPlan<%= list.getId()%>" tabindex="-1"
                             aria-labelledby="addRecipeToPlanModalLabel<%= list.getId()%>" aria-hidden="true">
                            <form action="UserController" method="post" class="modal-dialog add-recipe-to-plan-modal modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h1 class="modal-title fs-5" id="exampleModalLabel<%= list.getId()%>">Adding Meal To Plan</h1>
                                    </div>
                                    <div class="modal-body">
                                        <div class="row choose-week-day flex-column">
                                            <% for (DateDTO dateList : planDate) {
                                                    SimpleDateFormat dayOfWeekFormat = new SimpleDateFormat("EEEE");
                                                    String dayOfWeek = dayOfWeekFormat.format(dateList.getDate());

                                                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                                                    String formattedDate = dateFormat.format(dateList.getDate());

                                                    // Get the end date of the plan
                                                    Date endDate = plan.getEnd_at();
                                                    Calendar calendar = Calendar.getInstance();
                                                    calendar.setTime(dateList.getDate());

                                                    // Loop through the days between the selected day and the end date
                                                    //while (calendar.getTime().before(endDate) || calendar.getTime().equals(endDate)) {
                                                    // Generate the checkboxes
                                            %>
                                            <!--                                            <div class="col-md-4">
                                                                                            <div class="d-flex">
                                                                                                <input type="checkbox" id="date_id<%= dateList.getId()%>" name="date_id" value="<%= formattedDate%>">
                                                                                                <label for="dateOfWeek<%= dateList.getId()%>"> <%= dayOfWeek%> (<%= formattedDate%>) </label>
                                                                                            </div>
                                                                                        </div>
                                            -->
                                            <%

                                                    // Increment the calendar by 1 day
                                                    //calendar.add(Calendar.DAY_OF_MONTH, 1);
                                                    //dayOfWeek = dayOfWeekFormat.format(calendar.getTime());
                                                    //formattedDate = dateFormat.format(calendar.getTime());
                                                    //}
                                                }%>
                                        </div>
                                        <div class="row add-recipe-info-ingredient">
                                            <div class="draggable-container-time col-md-8 add-recipe-info-ingredient-content">
                                                <div class="add-recipe-info-header">Time <span>*</span></div>
                                                <div class="draggable-time-container">
                                                    <!-- Existing draggable time elements -->
                                                </div>
                                            </div>
                                            <div class="col-md-4 add-recipe-info-ingredient-button">
                                                <button type="button" id="btnToggleTime" style="display: none">
                                                    <img src="assets/drag-icon.svg" alt="">
                                                </button>
                                                <button type="button" id="btnAddTime">
                                                    Add Time
                                                </button>
                                            </div>
                                        </div>
                                        <br><br>

                                    </div>

                                    <div class="plan-table">
                                        <% for (DateDTO dateList : planDate) {%>
                                        <input type="hidden" id="recipeIdInput<%= list.getId()%>" name="recipe_id" value="<%= list.getId()%>">
                                        <input type="hidden" name="plan_id" value="<%= plan.getId()%>" />
                                        <input type="hidden" name="week_id" value="<%= dateList.getWeek_id()%>" />
                                        <input type="hidden" name="plan_start" value="<%= plan.getStart_at()%>" />
                                        <input type="hidden" name="date_id" value="<%= dateList.getId()%>" />
                                        <input type="hidden" name="distanceInDays" value="<%= distanceInDays%>" />
                                        <input type="hidden" name="isTemplate" value="false" />
                                        <% if (plan.isDaily()) {%>
                                        <input type="hidden" name="isDaily" value="true" />
                                        <% }%>
                                        <input type="hidden" name="isDaily" value="false" />
                                        <input type="hidden" name="selectedDate" value="<%= selectedDate%>" />
                                        <% }%>
                                    </div>

                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                        <button type="submit" name="action" value="addPlanRecipe" class="add-recipe-to-plan-modal-button"
                                                data-recipeid="<%= list.getId()%>" onclick="setRecipeId(this, '<%= list.getId()%>');" disabled="" id="btnAddRecipe">Add</button>
                                    </div>
                                </div>
                            </form>
                        </div>


                        <script>
                            document.addEventListener("DOMContentLoaded", function () {
                                const modal = document.getElementById("addMultiplesMealToPlan<%= list.getId()%>");

                                let draggablesTime = []; // Array to store draggable time elements
                                let dragTime = false; // Flag to track drag mode

                                // Function to toggle drag mode
                                function toggleDragModeTime(enableDragMode) {
                                    dragTime = enableDragMode;
                                    draggablesTime.forEach((draggable) => {
                                        draggable.draggable = dragTime;
                                        draggable.classList.toggle('drag-mode-disabled', !dragTime);
                                        draggable.style.cursor = dragTime ? 'grab' : 'default';
                                    });
                                }

                                // Function to create options for select element
                                function createOptions(selectElement, selectedOptions, selectedValue) {
                                    // Clear existing options by removing all children
                                    while (selectElement.firstChild) {
                                        selectElement.removeChild(selectElement.firstChild);
                                    }

                                    const timeOptions = [];
                                    for (let hour = 0; hour < 24; hour++) {
                                        const time = hour.toString().padStart(2, '0') + ':00'; // Format the time as HH:00
                                        if (!selectedOptions.includes(time)) {
                                            timeOptions.push(time);
                                        }
                                    }

                                    // Always include the selected time even if it's deleted from other elements
                                    if (selectedValue && !selectedOptions.includes(selectedValue)) {
                                        timeOptions.push(selectedValue);
                                    }

                                    for (let i = 0; i < timeOptions.length; i++) {
                                        const option = document.createElement('option');
                                        option.value = timeOptions[i];
                                        option.text = timeOptions[i];
                                        selectElement.appendChild(option);
                                    }

                                    selectElement.setAttribute('required', true); // Add the "required" attribute
                                }

                                // Function to check if any time is selected
                                function isAnyTimeOptionSelected() {
                                    const selectElements = modal.querySelectorAll('.timeList');
                                    const hasSelectedTimeOptions = Array.from(selectElements).some(select => select.value !== '');
                                    return hasSelectedTimeOptions || draggablesTime.length > 0;
                                }

                                // Function to update the "Add" button state
                                function updateAddButtonState() {
                                    const btnAddTime = modal.querySelector('#btnAddRecipe');
                                    btnAddTime.disabled = !isAnyTimeOptionSelected() || draggablesTime.length === 0;
                                }


                                // Add event listener to the toggle button
                                modal.querySelector("#btnToggleTime").addEventListener('click', () => {
                                    toggleDragModeTime(!dragTime); // Toggle the drag mode
                                });

                                // Add event listener to the add button
                                modal.querySelector("#btnAddTime").addEventListener('click', () => {
                                    if (!dragTime && draggablesTime.length < 6) { // Check the maximum limit
                                        const draggableContainer = modal.querySelector('.draggable-container-time');
                                        const selectedOptions = Array.from(draggableContainer.querySelectorAll('.timeList')).map(select => select.value);
                                        const newDraggable = document.createElement('p');
                                        newDraggable.classList.add('draggable-time');
                                        newDraggable.classList.add('draggable');
                                        newDraggable.draggable = dragTime;

                                        const newSelect = document.createElement('select');
                                        newSelect.classList.add('timeList');
                                        newSelect.name = 'timeId';
                                        // Pass the selected value of the current time element
                                        const selectedValue = selectedOptions.length === 0 ? '' : selectedOptions[selectedOptions.length - 1];
                                        createOptions(newSelect, selectedOptions, selectedValue);

                                        const deleteButton = document.createElement('button');
                                        deleteButton.type = 'button';
                                        deleteButton.classList.add('btnDeleteTime');

                                        const deleteImage = document.createElement('img');
                                        deleteImage.src = 'assets/close-icon.svg';
                                        deleteImage.alt = 'Delete';

                                        deleteButton.appendChild(deleteImage);
                                        deleteButton.addEventListener('click', () => {
                                            newDraggable.remove();
                                            draggablesTime = draggableContainer.querySelectorAll('.draggable-time'); // Update the draggable elements
                                            if (draggablesTime.length === 1) {
                                                disableDeleteButtons();
                                            }
                                        });

                                        newDraggable.appendChild(newSelect);
                                        newDraggable.appendChild(deleteButton);

                                        draggableContainer.appendChild(newDraggable);
                                        draggablesTime = draggableContainer.querySelectorAll('.draggable-time'); // Update the draggable elements

                                        enableDeleteButtons();
                                        updateAddButtonState();
                                    }
                                });


                                // Function to get the closest element during drag and drop
                                function getDragAfterElement(container, y) {
                                    const draggableElements = [...container.querySelectorAll('.draggable:not(.dragging)')];
                                    return draggableElements.reduce((closest, child) => {
                                        const box = child.getBoundingClientRect();
                                        const offset = y - box.top - box.height / 2;
                                        if (offset < 0 && offset > closest.offset) {
                                            return {offset: offset, element: child};
                                        } else {
                                            return closest;
                                        }
                                    }, {offset: Number.NEGATIVE_INFINITY}).element;
                                }

                                // Function to enable delete buttons
                                function enableDeleteButtons() {
                                    modal.querySelectorAll('.btnDeleteTime').forEach((button) => {
                                        button.addEventListener('click', () => {
                                            button.parentNode.remove();
                                            draggablesTime = draggableContainer.querySelectorAll('.draggable-time'); // Update the draggable elements
                                            if (draggablesTime.length === 1) {
                                                disableDeleteButtons();
                                            }
                                        });
                                    });
                                }

                                // Function to disable delete buttons
                                function disableDeleteButtons() {
                                    modal.querySelectorAll('.btnDeleteTime').forEach((button) => {
                                        button.disabled = true;
                                    });
                                }

                                modal.querySelectorAll('.timeList').forEach((selectElement) => {
                                    selectElement.addEventListener('change', () => {
                                        updateAddButtonState();
                                    });
                                });

                                // Add event listener to the modal's shown event
                                modal.addEventListener('shown.bs.modal', function () {
                                    const draggableContainer = modal.querySelector('.draggable-container-time');
                                    const btnToggleTime = modal.querySelector('#btnToggleTime');
                                    const btnAddTime = modal.querySelector('#btnAddTime');
                                    const btnDeleteTime = modal.querySelectorAll('.btnDeleteTime');

                                    draggablesTime = draggableContainer.querySelectorAll('.draggable-time');

                                    toggleDragModeTime(dragTime);

                                    btnToggleTime.addEventListener('click', () => {
                                        toggleDragModeTime(!dragTime);
                                    });

                                    btnAddTime.addEventListener('click', () => {
                                        // Rest of the code...
                                    });

                                    enableDeleteButtons();

                                    draggableContainer.addEventListener('dragover', (e) => {
                                        e.preventDefault();
                                        const afterElement = getDragAfterElement(draggableContainer, e.clientY);
                                        const draggable = document.querySelector('.dragging');
                                        if (afterElement == null) {
                                            draggableContainer.appendChild(draggable);
                                        } else {
                                            draggableContainer.insertBefore(draggable, afterElement);
                                        }
                                    });

                                    updateAddButtonState();
                                });

                                // Function to clear all select options in the modal
                                // Function to clear all select options in the modal
                                function clearSelectOptions() {
                                    const selectElements = modal.querySelectorAll('.timeList');
                                    selectElements.forEach((select) => {
                                        const selectedValue = select.value;
                                        const selectedOptions = Array.from(select.children).map(option => option.value);
                                        createOptions(select, selectedOptions, selectedValue);
                                    });
                                }


                                // Add event listener to the "Close" button
                                modal.querySelector("button[data-bs-dismiss='modal']").addEventListener('click', () => {
                                    clearSelectOptions();
                                });

                                // Add event listener to the modal's hidden event
                                modal.addEventListener('hidden.bs.modal', () => {
                                    clearSelectOptions();
                                });

                            });
                        </script>

                        <%
                                }
                            } else {
                                System.out.println("The search list is null");
                            }
                        %>
                    </div>
                </div>

            </div>
        </div>
        <script>
            // Function to scroll to a specific section
            function scrollToSection(addSection) {
                const section = document.getElementById(addSection);
                section.scrollIntoView({behavior: 'smooth'});
            }
        </script>

        <!--         Footer       -->
        <%@include file="footer.jsp" %>


        <script src="bootstrap/js/bootstrap.min.js" ></script>
    </body>
</html>
