<%-- 
    Document   : banner.jsp
    Created on : Jun 23, 2023, 1:44:39 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <link href="https://fonts.googleapis.com/css2?family=Fira+Sans+Extra+Condensed:wght@300;400;500;600;700&display=swap"
              rel="stylesheet">
    </head>
    <body>
        <div id="carouselExampleAutoplaying" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-inner">
                <a class="carousel-item active" href="#" data-bs-interval="4000">
                    <div class="banner-content">
                        <p>All new</p>
                        <p>Perfect Breakfast</p>
                        <p>Try out our new recipes for an easy and delicious breakfast that everybody can enjoy</p>
                    </div>
                    <img src="./pictures/banner.svg" class="d-block w-100" alt="...">
                </a>
                <a class="carousel-item" href="#" data-bs-interval="4000">
                    <div class="banner-content ">
                        <p>All new</p>
                        <p>It's fry-day!</p>
                        <p>Get yourself some all new fried recipes so you can oil up for your next perfect weekend</p>
                    </div>
                    <img src="./pictures/fried-banner.svg" class="d-block w-100 " alt="...">
                </a>
                <a class="carousel-item" href="#" data-bs-interval="4000">
                    <div class="banner-content ">
                        <p>All new</p>
                        <p>Pasta La Vista, baby!</p>
                        <p>Try out these new pasta recipes that are so good it will make you pasta way</p>
                    </div>
                    <img src="./pictures/pasta-banner.svg" class="d-block w-100" alt="...">
                </a>
                <a class="carousel-item" href="#" data-bs-interval="4000">
                    <div class="banner-content ">
                        <p>All new</p>
                        <p>Udon know anything!</p>
                        <p>That's why we've prepared for you some delicious Japanese recipes to try out</p>
                    </div>
                    <img src="./pictures/udon-banner.svg" class="d-block w-100" alt="...">
                </a>
            </div>
        </div>
        
        
        <script src="bootstrap/js/bootstrap.min.js" ></script>
    </body>
</html>
