<%-- 
    Document   : resetPassword
    Created on : May 25, 2023, 4:14:20 PM
    Author     : Daiisuke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Delideli</title>
        <meta charset="utf-8" />
        <meta
            name="viewport"
            content="width=device-width, initial-scale=1" />
        <!--      Bootstrap         -->
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css"
            rel="stylesheet"
            integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ"
            crossorigin="anonymous" />
        <!--      CSS         -->
        <link
            rel="stylesheet"
            href="./styles/userStyle.css" />
        <link
            rel="preconnect"
            href="https://fonts.googleapis.com" />
        <link
            rel="preconnect"
            href="https://fonts.gstatic.com"
            crossorigin />
        <link
            href="https://fonts.googleapis.com/css2?family=Fira+Sans+Extra+Condensed:wght@300;400;500&display=swap"
            rel="stylesheet" />
    </head>

    <body>
        <div class="navigator-bar">
            <div class="container">
                <div class="row navigation-bar-first">
                    <a
                        href="homePage.html"
                        class="logo col-md-3">
                        <img
                            src="./assets/Logo2.png"
                            alt="" />
                    </a>
                    <div class="search-bar col-md-6">
                        <form
                            action=""
                            method="post"
                            class="search-bar-content">
                            <input
                                type="text"
                                placeholder="What are you searching for ?" />
                            <select
                                name=""
                                id="">
                                <option value="">TITLE</option>
                                <option value="">CATEGORY</option>
                                <option value="">INGREDIENT</option>
                                <option value="">CUISINES</option>
                            </select>
                            <button type="submit">
                                <img
                                    src="./assets/search-button.svg"
                                    alt="Search Icon" />
                            </button>
                        </form>
                    </div>
                    <div class="account col-md-3">
                        <span><a href="logIn.html">Sign in</a></span>
                        <span>|</span>
                        <span><a href="register.html">Register</a></span>
                    </div>
                </div>
                <div class="row navigation-bar-last">
                    <ul class="navigation-bar-content">
                        <li><a href="searchResultPage.html">CATEGORIES</a></li>
                        <li><a href="">INGREDIENTS</a></li>
                        <li><a href="">CUISINES</a></li>
                        <li><a href="">DIFFICULTIES</a></li>
                        <li><a href="">NEWS</a></li>
                        <li><a href="">ABOUT US</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <!--        Log in Form         -->
        <div class="blank-background">
            <div class="container">
                <div class="row form">
                    <header class="form-header col-md-12">
                        RESET PASSWORD
                    </header>
                    <div>
                        <form
                            action="MainController"
                            method="POST"
                            class="sign-in-form">
                            <div>
                                <p>
                                    <span>Enter Password</span> <span>*</span>
                                </p>
                                <input
                                    type="password"
                                    name="txtPassword"
                                    placeholder="Your password" />
                            </div>
                            <div>
                                <p>
                                    <span>Re-Enter Password</span>
                                    <span>*</span>
                                </p>
                                <input
                                    type="password"
                                    name="txtRePassword"
                                    placeholder="Your password" />
                                <p class="error-popup">${requestScope.PASS_INCORRECT}</p>
                            </div>
                            <button type='submit' value='updatePassByToken' name='action'>SAVE</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!--         Footer       -->
        <div class="footer">
            <div class="container">
                <div class="row">
                    <div class="website-social-media col-md-6">
                        <a
                            href="homePage.html"
                            class="website-social-media-logo">
                            <img
                                src="./assets/Logo2.png"
                                alt="" />
                        </a>
                        <div class="website-social-media-icons">
                            <span>Follow us:</span>
                            <a href="#"
                               ><img
                                    src="./assets/facebook-icon.svg"
                                    alt="Facebook Logo"
                                    /></a>
                            <a href="#"
                               ><img
                                    src="./assets/twitter-icon.svg"
                                    alt="Twitter Logo"
                                    /></a>
                        </div>
                    </div>
                    <nav class="navigation-bar-footer col-md-3">
                        <ul class="navigation-bar-footer-content">
                            <li><a href="">CATEGORIES</a></li>
                            <li><a href="">INGREDIENTS</a></li>
                            <li><a href="">CUISINES</a></li>
                            <li><a href="">DIFFICULTIES</a></li>
                            <li><a href="">NEWS</a></li>
                        </ul>
                    </nav>
                    <nav class="website-infomation-bar col-md-3">
                        <ul class="website-infomation-bar-content">
                            <li><a href="">About us</a></li>
                            <li><a href="">Privacy Policies</a></li>
                            <li><a href="">Term of Services</a></li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>

        <!--      Bootstrap for JS         -->
        <script
            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
        crossorigin="anonymous"></script>
    </body>
</html>

