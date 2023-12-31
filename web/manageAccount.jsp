<%-- 
    Document   : manageAccount
    Created on : Jun 4, 2023, 3:55:06 PM
    Author     : Admin
--%>

<%@page import="DAO.AdminDAO"%>
<%@page import="DTO.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Delideli</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!--      Bootstrap         -->
        <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>
        <!--      CSS         -->
        <link rel="stylesheet" href="./styles/adminStyle.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link
            href="https://fonts.googleapis.com/css2?family=Fira+Sans+Extra+Condensed:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">
    </head>
    <body>

        <div class="container-fluid">
            <%
                ArrayList<UserDTO> listAcc = (ArrayList) request.getAttribute("listAcc");
                ArrayList<UserDTO> listAccSearched = (ArrayList) request.getAttribute("listAccSearched");
                int endPage = (Integer) request.getAttribute("endPage");
                String tag = (String) request.getAttribute("tag");
                if (tag.equals("")) {
                    tag = "0";
                }
                String currentRole = request.getParameter("role");
                if (currentRole == null) {
                    currentRole = "all";
                }
                String[] tmp = {"Deactivated", "Active"};
            %>

            <div class="row">
                <%
                    UserDTO user = (UserDTO) session.getAttribute("user");
                    if (user == null || user.getRole() == 1) {
                        response.sendRedirect("error.jsp");
                    } else if (user.getRole() == 2) {
                %>

                <nav class="nav-left-bar col-md-2">
                    <a class="logo" href="">
                        <img src="assets/Logo3.svg" alt="">
                    </a>
                    <div>
                        <a href="AdminController?action=adminDashboard" >
                            <img src="./assets/public-unchosen-icon.svg" alt="">
                            Dashboard
                        </a>
                    </div>
                    <div>
                        <a href="AdminController?action=manageAccount" class="active">
                            <img src="./assets/user-icon.svg" alt="">
                            User
                        </a>
                    </div>
                    <div>
                        <a href="AdminController?action=manageRecipe">
                            <img src="./assets/post-unchosen-icon.svg" alt="">
                            Recipe
                        </a>
                    </div>
                    <div>
                        <a href="AdminController?action=manageSuggestion">
                            <img src="./assets/content-unchosen-icon.svg" alt="">
                            Content
                        </a>
                    </div>
                    <div>
                        <a href="AdminController?action=manageNews">
                            <img src="./assets/news-unchosen-icon.svg" alt="">
                            News
                        </a>
                    </div>
                    <div>
                        <a href="adminBroadcast.jsp">
                            <img src="./assets/broadcast-unchosen-icon.svg" alt="">
                            Broadcast
                        </a>
                    </div>
                    <div>
                        <a href="MainController?action=logout">
                            <img src="./assets/leave-icon.svg" alt="">
                            Logout
                        </a>
                    </div>
                </nav>

                <div class="col-md-10 recipe">

                    <nav class="navbar">
                        <div class="nav-top-bar">
                            <div class="nav-top-bar-account dropdown">
                                <img src="./assets/profile-pic.svg" alt="">
                                <div>
                                    <p><%= user.getUserName()%></p>
                                    <p>Admin</p>
                                </div>
                            </div>
                        </div>
                    </nav>

                    <%
                    } else if (user.getRole() == 3) {
                    %>
                    <nav class="nav-left-bar col-md-2">
                        <a class="logo" href="">
                            <img src="assets/Logo3.svg" alt="">
                        </a>
                        <div>
                            <a href="AdminController?action=manageAccount" class="active">
                                <img src="./assets/user-icon.svg" alt="">
                                User
                            </a>
                        </div>
                        <div>
                            <a href="AdminController?action=manageRecipe">
                                <img src="./assets/post-unchosen-icon.svg" alt="">
                                Recipe
                            </a>
                        </div>
                        <div>
                            <a href="AdminController?action=manageSuggestion">
                                <img src="./assets/content-unchosen-icon.svg" alt="">
                                Content
                            </a>
                        </div>
                        <div>
                            <a href="AdminController?action=manageNews">
                                <img src="./assets/news-unchosen-icon.svg" alt="">
                                News
                            </a>
                        </div>
                        <div>
                            <a href="MainController?action=logout">
                                <img src="./assets/leave-icon.svg" alt="">
                                Logout
                            </a>
                        </div>
                    </nav>

                    <div class="col-md-10 recipe">
                        <nav class="navbar">
                            <div class="nav-top-bar">
                                <div class="nav-top-bar-account dropdown">
                                    <img src="./assets/profile-pic.svg" alt="">
                                    <div>
                                        <p><%= user.getUserName()%></p>
                                        <p>Moderator</p>
                                    </div>
                                </div>
                            </div>
                        </nav>
                        <%
                            }
                        %>

                        <div class="user-header">
                            Users List
                        </div>
                        <div class="nav-top-bar-search">
                            <form action="AdminController" method="post" class="nav-top-bar-search-user">
                                <button type="submit" name="action" value="searchAccount"><img src="assets/search-icon.svg" alt=""></button>
                                <input type="text" name="txtSearch" placeholder="Who are you searching for ?">
                                <input type="hidden" value="<%= currentRole%>" name="currentRole">
                                <input type="hidden" value="<%= tag%>" name="tag">
                            </form>
                            <form action="AdminController?action=manageAccount" method="post" class="nav-top-bar-search-filter">
                                <select name="role">
                                    <option value="user">User</option>
                                    <option value="admin">Admin</option>
                                    <option value="moderator">Moderator</option>
                                    <option value="all">All</option>
                                </select>
                                <button type="submit" value="Filter" class="filter-table-button">
                                    Filter
                                </button>
                            </form>
                        </div>

                        <!--      User List         -->
                        <%
                            int currentPage = 1;

                            String currentPageParam = request.getParameter("page");
                            if (currentPageParam != null && !currentPageParam.isEmpty()) {
                                currentPage = Integer.parseInt(currentPageParam);
                            }
                        %>

                        <%
                            if (listAcc != null && !listAcc.isEmpty()) {
                        %>
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>No.</th>
                                    <th>User Name</th>
                                    <th>Role</th>
                                    <th>Email</th>
                                    <th>Create at</th>
                                    <th>Status</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <%
                                    int count = 1;
                                    for (UserDTO u : listAcc) {
                                %>
                                <tr>
                                    <td><%= count%></td>
                                    <td class="recipe-and-user-link"><a href="AdminController?action=showUserDetail&username=<%= u.getUserName()%>"><%= u.getUserName()%></a></td>
                                    <td><%= AdminDAO.getRoleByRoleId(u.getRole())%></td>
                                    <td><%= u.getEmail()%></td>
                                    <td><%= u.getCreateAt()%></td>
                                    <td><%= tmp[u.getStatus()]%></td>
                                    <td class="user-action-button">
                                        <form action="AdminController?username=<%= u.getUserName()%>" method="post" class="activate-acc-button">
                                            <input type="hidden" value="<%= currentRole%>" name="currentRole">
                                            <input type="hidden" value="<%= tag%>" name="tag">
                                            <%
                                                if (tmp[u.getStatus()].equals("Deactivated")) {
                                                    if (user.getRole() != 1) {
                                            %>
                                            <button type="submit" value="activateAcc" name="action">Activate</button>
                                            <%
                                                }
                                            } else if ((user.getRole() == 2 && u.getRole() != 2) || (user.getRole() == 3 && u.getRole() == 1)) {
                                            %>
                                            <button type="submit" value="deactivateAcc" name="action">Deactivate</button>
                                            <%
                                                }
                                            %>
                                        </form>
    <!--                                    <form action="MainController?username=<%= u.getUserName()%>" method="post" class="delete-acc-button">
                                            <input type="hidden" value="<%= currentRole%>" name="currentRole">
                                            <input type="hidden" value="<%= tag%>" name="tag">
                                            <button type="submit" data-bs-toggle="modal" data-bs-target="#userListModal" name="action" value="deleteAcc">Delete</button>
                                            <div class="modal fade" id="userListModal" tabindex="-1" aria-labelledby="userListModalLabel" aria-hidden="true">
                                                <div class="popup-confirm">
                                                    <div class="modal-dialog">
                                                        <div class="modal-content">
                                                            <div class="modal-header">
                                                                <h1 class="modal-title fs-5" id="exampleModalLabel">CONFIRMATION</h1>
                                                            </div>
                                                            <div class="modal-body">
                                                                Pressing delete will remove this user from this site forever, are you sure you still want to delete them ?
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No, I changed my mind</button>
                                                                <button type="button" class="btn popup-confirm-btn">Yes, delete them</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>-->
                                    </td>
                                </tr>
                                <%
                                        count++;
                                    }
                                %>
                            </tbody>
                        </table>

                        <div class="table-redirect">
                            <%
                                for (int i = 1; i <= endPage; i++) {
                            %>
                            <a class="<%= (new Integer(tag) == i) ? "table-redirect-active-link" : ""%>" href="AdminController?action=manageAccount&index=<%= i%>&role=<%= currentRole%>"><%= i%></a>
                            <%
                                }
                            %>
                        </div>
                        <% } else if (listAccSearched
                                != null && listAccSearched.size()
                                > 0) {
                        %>
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>No.</th>
                                    <th>User name</th>
                                    <th>Role</th>
                                    <th>Email</th>
                                    <th>Created</th>
                                    <th>Status</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <%
                                    int count = 1;
                                    for (UserDTO u : listAccSearched) {
                                %>
                                <tr>
                                    <td><%= count%></td>
                                    <td><a href="AdminController?action=showUserDetail&username=<%= u.getUserName()%>"><%= u.getUserName()%></a></td>
                                    <td><%= AdminDAO.getRoleByRoleId(u.getRole())%></td>
                                    <td><%= u.getEmail()%></td>
                                    <td><%= u.getCreateAt()%></td>
                                    <td><%= tmp[u.getStatus()]%></td>
                                    <td class="user-action-button">
                                        <form action="AdminController?username=<%= u.getUserName()%>" method="post" class="activate-acc-button">
                                            <input type="hidden" value="<%= currentRole%>" name="currentRole">
                                            <input type="hidden" value="<%= tag%>" name="tag">
                                            <%
                                                if (tmp[u.getStatus()].equals("Deactivated")) {
                                            %>
                                            <button type="submit" value="activateAcc" name="action">Activate</button>
                                            <%
                                            } else {
                                            %>
                                            <button type="submit" value="deactivateAcc" name="action">Deactivate</button>
                                            <%
                                                }
                                            %>
                                        </form>
    <!--                                    <form action="MainController?username=<%= u.getUserName()%>" method="post" class="delete-acc-button">
                                            <input type="hidden" value="<%= currentRole%>" name="currentRole">
                                            <input type="hidden" value="<%= tag%>" name="tag">
                                            <button type="submit" data-bs-toggle="modal" data-bs-target="#userListModal" name="action" value="deleteAcc">Delete</button>
                                            <div class="modal fade" id="userListModal" tabindex="-1" aria-labelledby="userListModalLabel" aria-hidden="true">
                                                <div class="popup-confirm">
                                                    <div class="modal-dialog">
                                                        <div class="modal-content">
                                                            <div class="modal-header">
                                                                <h1 class="modal-title fs-5" id="exampleModalLabel">CONFIRMATION</h1>
                                                            </div>
                                                            <div class="modal-body">
                                                                Pressing delete will remove this user from this site forever, are you sure you still want to delete them ?
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No, I changed my mind</button>
                                                                <button type="button" class="btn popup-confirm-btn">Yes, delete them</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>-->
                                    </td>
                                </tr>
                                <%
                                        count++;
                                    }
                                %>
                            </tbody>
                        </table>
                        <div class="table-redirect">
                            <%
                                for (int i = 1; i <= endPage; i++) {
                                    String pageUrl = "AdminController?action=manageAccount&page=" + i + "&role=" + currentRole;
                            %>
                            <a class="<%= (currentPage == i) ? "table-redirect-active-link" : ""%>" href="<%= pageUrl%>"><%= i%></a>
                            <%
                                    }
                                }
                            %>
                        </div>

                    </div>
                </div>
            </div>

            <script src="./script/userListScript.js"></script>
    </body>
</html>
