<%-- 
    Document   : login
    Created on : May 23, 2023, 7:55:44 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
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
        <link href="https://fonts.googleapis.com/css2?family=Fira+Sans+Extra+Condensed:wght@300;400;500&display=swap"
              rel="stylesheet">
    </head>
    <body>
        <!--         The navigation bar       -->
        <%@include file="header.jsp" %>

        
        <!--        Log in Form         -->
        <div class="blank-background">
            <div class="container user-form">
                <form class="row" action="MainController" method="post">
                    <div class="col-md-6 user-form-picture-left">
                        <img src="pictures/form-picture.jpg"/>
                    </div>
                    <div class="col-md-6 user-form-content">
                        <div class="user-form-content-header">
                            SIGN IN
                        </div>
                        <div class="user-form-content-input">
                            <p>Email</p>
                            <input type="text" name="txtEmail"  required=""/>
                        </div>
                        <div class="user-form-content-input">
                            <p>Password</p>
                            <input type="password" name="txtPass" required="" />
                        </div>

                        <%
                            String recipeID = request.getParameter("recipeID");
                            //Prevent from nulling.
                            if (recipeID != null) {
                        %>
                        <input type="hidden" name="recipeID" value="<%= recipeID%>" />
                        <%
                            }
                        %>
                        <p class="error-popup">${requestScope.errorList[0]}</p>
                        <button type="submit" value="login" name="action" class="user-form-content-button">SIGN IN</button>
                        <a href="forgotPassword.jsp" class="user-form-content-forgot">
                            Forgot password?
                        </a>
                        <div class="user-form-content-sign-up">
                            Don't have an account? Sign up <a href="registration.jsp">here</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>



        <!--         Footer       -->
        <%@include file="footer.jsp" %>
        
        <script src="bootstrap/js/bootstrap.min.js" ></script>
    </body>
</html>
