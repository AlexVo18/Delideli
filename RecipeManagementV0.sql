CREATE DATABASE RecipeManagement
-- DROP DATABASE RecipeManagement

USE RecipeManagement

-- CREATE TABLE
CREATE TABLE Category (
  id          int IDENTITY, 
  title       varchar(50) NOT NULL, 
  description text NULL, 
  PRIMARY KEY (id));

CREATE TABLE Cuisine (
  id          int IDENTITY, 
  title       varchar(50) NOT NULL, 
  description text NULL, 
  PRIMARY KEY (id));

CREATE TABLE Diet (
  id    int IDENTITY, 
  title varchar(50) NOT NULL, 
  PRIMARY KEY (id));

CREATE TABLE Direction (
  recipe_id   int NOT NULL, 
  description ntext NOT NULL, 
  PRIMARY KEY (recipe_id));

CREATE TABLE FavoriteRecipe (
  id        int IDENTITY, 
  user_id   int NOT NULL, 
  recipe_id int NOT NULL, 
  PRIMARY KEY (id));

CREATE TABLE Ingredient (
  id    int IDENTITY, 
  title varchar(50) NOT NULL, 
  PRIMARY KEY (id));

CREATE TABLE IngredientDetail (
  id            int IDENTITY, 
  description   ntext NOT NULL, 
  ingredient_id int NOT NULL, 
  recipe_id     int NOT NULL, 
  PRIMARY KEY (id));

CREATE TABLE Level (
  id   int IDENTITY, 
  type varchar(20) NOT NULL, 
  PRIMARY KEY (id));

CREATE TABLE News (
  id               int IDENTITY, 
  title            varchar(100) NOT NULL, 
  description      ntext NOT NULL, 
  image            varchar(255), 
  create_at        date NOT NULL, 
  update_at        date NULL, 
  user_id          int NOT NULL, 
  news_category_id int NOT NULL, 
  PRIMARY KEY (id));

CREATE TABLE NewsCategory (
  id    int IDENTITY, 
  title varchar(50) NOT NULL, 
  PRIMARY KEY (id));

CREATE TABLE Notification (
  id                   int IDENTITY, 
  title                varchar(255) NOT NULL, 
  description          ntext NOT NULL, 
  send_date            datetime NOT NULL, 
  is_read              bit NOT NULL, 
  link                 varchar(255) NULL, 
  user_id              int NOT NULL, 
  notification_type_id int NOT NULL, 
  recipe_id            int NULL, 
  plan_id              int NULL, 
  PRIMARY KEY (id));

CREATE TABLE NotificationType (
  id    int IDENTITY NOT NULL, 
  sender varchar(50) NOT NULL,
  cate varchar(50) NOT NULL, 
  image varchar(255) NOT NULL, 
  PRIMARY KEY (id));

CREATE TABLE Nutrition (
  recipe_id int NOT NULL, 
  calories  int NOT NULL, 
  fat       int NOT NULL, 
  carbs     int NOT NULL, 
  protein   int NOT NULL, 
  PRIMARY KEY (recipe_id));

CREATE TABLE [Plan] (
  id          int IDENTITY NOT NULL, 
  name        nvarchar(255) NOT NULL, 
  description ntext NULL, 
  start_at    date NOT NULL, 
  note        ntext NULL, 
  end_at      date NOT NULL, 
  status      bit NOT NULL, 
  user_id     int NOT NULL, 
  diet_id     int NOT NULL, 
  isDaily	  bit NOT NULL,
  PRIMARY KEY (id));

CREATE TABLE Week (
  id       int IDENTITY NOT NULL, 
  start_at date NOT NULL, 
  plan_id  int NOT NULL,
  is_sync bit NOT NULL default 1,
  is_template bit NOT NULL default 0,
  PRIMARY KEY (id));

CREATE TABLE [Date] (
  id      int IDENTITY, 
  [date]  date NULL, 
  week_id int NULL, 
  plan_id int NOT NULL,
  is_sync bit NOT NULL default 1,
  is_template bit NOT NULL default 0,
  PRIMARY KEY (id));

CREATE TABLE Recipe (
  id          int IDENTITY, 
  title       varchar(100) NOT NULL, 
  description ntext NOT NULL, 
  prep_time   int NOT NULL, 
  cook_time   int NOT NULL, 
  servings    int NOT NULL, 
  create_at   datetime NOT NULL, 
  update_at   datetime NULL, 
  status      int NOT NULL, -- 1: private, 2: pending, 3: approved, 4: rejected
  cuisine_id  int NOT NULL, 
  category_id int NOT NULL, 
  user_id     int NOT NULL, 
  level_id    int NOT NULL, 
  PRIMARY KEY (id));

CREATE TABLE Meal (
  id           int IDENTITY NOT NULL, 
  start_time   time(7) NOT NULL, 
  date_id      int NOT NULL, 
  recipe_id    int NOT NULL, 
  isNotified   bit NULL, 
  PRIMARY KEY (id));

CREATE TABLE RecipeDiet (
  id        int IDENTITY, 
  recipe_id int NOT NULL, 
  diet_id   int NOT NULL, 
  PRIMARY KEY (id));

CREATE TABLE RecipeImage (
  id        int IDENTITY, 
  image     varchar(255) NOT NULL, 
  recipe_id int NOT NULL, 
  thumbnail bit NOT NULL, 
  PRIMARY KEY (id));

CREATE TABLE Review (
  id        int IDENTITY, 
  rating    int NOT NULL, 
  content   varchar(max) NOT NULL, 
  create_at date NOT NULL, 
  update_at date NULL, 
  recipe_id int NOT NULL, 
  user_id   int NOT NULL, 
  PRIMARY KEY (id));

CREATE TABLE Role (
  id    int IDENTITY, -- 1: user; 2: adminstrator; 3: moderator
  title varchar(50) NOT NULL, 
  PRIMARY KEY (id));

CREATE TABLE Suggestion (
  id      int IDENTITY, 
  title   varchar(100) NOT NULL,
  status  bit NOT NULL, -- 1: chosen, 0: none
  user_id int NOT NULL, 
  PRIMARY KEY (id));

CREATE TABLE SuggestionRecipe (
  id            int IDENTITY, 
  suggestion_id int NOT NULL, 
  recipe_id     int NOT NULL, 
  PRIMARY KEY (id));

CREATE TABLE [User] (
  id              int IDENTITY, 
  user_name       varchar(50) NOT NULL UNIQUE, 
  email           varchar(50) NOT NULL UNIQUE, 
  password        varchar(255) NOT NULL, 
  avatar          varchar(255) NULL,
  token           nvarchar(50) NULL,
  status          bit NOT NULL, 
  create_at       date NOT NULL, 
  role_id         int NOT NULL, 
  user_setting_id int NOT NULL, 
  PRIMARY KEY (id));

CREATE TABLE UserDetail (
  user_id    int NOT NULL, 
  first_name varchar(16) NULL, 
  last_name  varchar(16) NULL, 
  specialty  varchar(255) NULL, 
  birthdate  date NULL, 
  bio        text NULL, 
  PRIMARY KEY (user_id));

CREATE TABLE UserSetting (
  id    int IDENTITY, 
  theme bit DEFAULT 0 NOT NULL, 
  PRIMARY KEY (id));

----------------------------------------------------------------------------------------------
-- CONSTRAINT
ALTER TABLE IngredientDetail ADD CONSTRAINT FKIngredient433169 FOREIGN KEY (ingredient_id) REFERENCES Ingredient (id);
ALTER TABLE IngredientDetail ADD CONSTRAINT FKIngredient521171 FOREIGN KEY (recipe_id) REFERENCES Recipe (id) ON DELETE CASCADE;
ALTER TABLE Direction ADD CONSTRAINT FKDirection289054 FOREIGN KEY (recipe_id) REFERENCES Recipe (id) ON DELETE CASCADE;
ALTER TABLE Recipe ADD CONSTRAINT FKRecipe521984 FOREIGN KEY (cuisine_id) REFERENCES Cuisine (id);
ALTER TABLE Recipe ADD CONSTRAINT FKRecipe108387 FOREIGN KEY (category_id) REFERENCES Category (id);
ALTER TABLE [User] ADD CONSTRAINT FKUser87814 FOREIGN KEY (role_id) REFERENCES Role (id);
ALTER TABLE FavoriteRecipe ADD CONSTRAINT FKFavoriteRe739133 FOREIGN KEY (user_id) REFERENCES [User] (id) ON DELETE CASCADE;
ALTER TABLE FavoriteRecipe ADD CONSTRAINT FKFavoriteRe133735 FOREIGN KEY (recipe_id) REFERENCES Recipe (id) ON DELETE CASCADE;
ALTER TABLE UserDetail ADD CONSTRAINT FKUserDetail97184 FOREIGN KEY (user_id) REFERENCES [User] (id) ON DELETE CASCADE;
ALTER TABLE Review ADD CONSTRAINT FKReview398834 FOREIGN KEY (recipe_id) REFERENCES Recipe (id) ON DELETE CASCADE;
ALTER TABLE Review ADD CONSTRAINT FKReview967357 FOREIGN KEY (user_id) REFERENCES [User] (id) ON DELETE CASCADE;
ALTER TABLE Recipe ADD CONSTRAINT FKRecipe533064 FOREIGN KEY (user_id) REFERENCES [User] (id);
ALTER TABLE RecipeImage ADD CONSTRAINT FKRecipeImag612429 FOREIGN KEY (recipe_id) REFERENCES Recipe (id) ON DELETE CASCADE;
ALTER TABLE Recipe ADD CONSTRAINT FKRecipe610596 FOREIGN KEY (level_id) REFERENCES Level (id);
ALTER TABLE [User] ADD CONSTRAINT FKUser837455 FOREIGN KEY (user_setting_id) REFERENCES UserSetting (id);
ALTER TABLE News ADD CONSTRAINT FKNews59142 FOREIGN KEY (user_id) REFERENCES [User] (id) ON DELETE CASCADE;
ALTER TABLE News ADD CONSTRAINT FKNews424367 FOREIGN KEY (news_category_id) REFERENCES NewsCategory (id);

--ALTER TABLE Recipe ADD CONSTRAINT FKRecipe972634 FOREIGN KEY (diet_id) REFERENCES Diet (id);
--ALTER TABLE PlanRecipe ADD CONSTRAINT FKPlanRecipe784025 FOREIGN KEY (plan_id) REFERENCES [Plan] (id) ON DELETE CASCADE;
--ALTER TABLE PlanRecipe ADD CONSTRAINT FKPlanRecipe103198 FOREIGN KEY (recipe_id) REFERENCES Recipe (id) ON DELETE CASCADE;
--ALTER TABLE [Plan] ADD CONSTRAINT FKPlan993519 FOREIGN KEY (user_id) REFERENCES [User] (id) ON DELETE CASCADE;
--ALTER TABLE PlanRecipe ADD CONSTRAINT FKPlanRecipe990492 FOREIGN KEY (meals_type_id) REFERENCES MealsType (id);

ALTER TABLE [Plan] ADD CONSTRAINT FKPlan993519 FOREIGN KEY (user_id) REFERENCES [User] (id);
ALTER TABLE Week ADD CONSTRAINT FKWeek716159 FOREIGN KEY (plan_id) REFERENCES [Plan] (id);
ALTER TABLE [Date] ADD CONSTRAINT FKDate677202 FOREIGN KEY (week_id) REFERENCES Week (id);
ALTER TABLE Meal ADD CONSTRAINT FKMeal836095 FOREIGN KEY (date_id) REFERENCES [Date] (id);
ALTER TABLE Meal ADD CONSTRAINT FKMeal695020 FOREIGN KEY (recipe_id) REFERENCES Recipe (id);
ALTER TABLE RecipeDiet ADD CONSTRAINT FKRecipeDiet407769 FOREIGN KEY (recipe_id) REFERENCES Recipe (id);
ALTER TABLE RecipeDiet ADD CONSTRAINT FKRecipeDiet397993 FOREIGN KEY (diet_id) REFERENCES Diet (id);
ALTER TABLE [Plan] ADD CONSTRAINT FKPlan566909 FOREIGN KEY (diet_id) REFERENCES Diet (id);
ALTER TABLE [Date] ADD CONSTRAINT FKDate285574 FOREIGN KEY (plan_id) REFERENCES [Plan] (id);
ALTER TABLE Notification ADD CONSTRAINT FKNotificati678176 FOREIGN KEY (notification_type_id) REFERENCES NotificationType (id);
ALTER TABLE Nutrition ADD CONSTRAINT FKNutrition229296 FOREIGN KEY (recipe_id) REFERENCES Recipe (id);
ALTER TABLE Notification ADD CONSTRAINT FKNotificati70343 FOREIGN KEY (user_id) REFERENCES [User] (id);
ALTER TABLE Notification ADD CONSTRAINT FKNotificati535055 FOREIGN KEY (recipe_id) REFERENCES Recipe (id);
ALTER TABLE Notification ADD CONSTRAINT FKNotificati145772 FOREIGN KEY (plan_id) REFERENCES [Plan] (id);

ALTER TABLE Suggestion ADD CONSTRAINT FKSuggestion265127 FOREIGN KEY (user_id) REFERENCES [User] (id);
ALTER TABLE SuggestionRecipe ADD CONSTRAINT FKSuggestion202726 FOREIGN KEY (suggestion_id) REFERENCES Suggestion (id);
ALTER TABLE SuggestionRecipe ADD CONSTRAINT FKSuggestion435895 FOREIGN KEY (recipe_id) REFERENCES Recipe (id);

ALTER TABLE Review ADD CONSTRAINT check_rating CHECK (rating >= 0 AND rating <= 5);

----------------------------------------------------------------------------------------------
-- INSERT
INSERT INTO Role(title) 
VALUES ('User'),
('Administrator'),
('Moderator');

INSERT INTO UserSetting(theme) 
VALUES 
(0),
(1);

INSERT INTO [User] (user_name, email, password, avatar,create_at, role_id, status, user_setting_id)
VALUES 
('tuannub', 'tuan@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-01', 3, 1, 1),
('alexvo', 'tri@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-02', 3, 1, 1),
('khangbui', 'khang@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-02', 1, 1, 1),
('khoaly', 'khoa@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-05-22', 2, 1, 1),
('hoangminh', 'minh@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-02', 1, 1, 1),
('ducquyen', 'quyen@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-03', 1, 1, 1),
('minhco', 'co@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-04', 1, 1, 1),
('minhnguyen', 'nguyen@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-04', 1, 1, 1),
('nhatminh', 'minhcuibap@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-04', 1, 1, 1),
('hungtran', 'hung@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-05', 1, 1, 1),
('tranthanh', 'leto@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-05', 1, 1, 1),
('vannhat', 'nhat@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-13', 1, 1, 1),
('hoabinh', 'binh@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-13', 1, 1, 1),
('trongnghia', 'nghia@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-13', 1, 1, 1),
('thanhphong', 'phong@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-13', 1, 1, 1),
('minhnhat', 'nhatminh@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-13', 1, 1, 1),
('nhatkhanh', 'khanh@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-13', 1, 1, 1),
('nhuttien', 'tien@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-13', 1, 1, 1),
('vietphuong', 'phuong@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-13', 1, 1, 1),
('minhquoc', 'quoc@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-13', 1, 1, 1),
('tantai', 'tai@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-13', 1, 1, 1),
('phuocthinh', 'thinh@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-13', 1, 1, 1),
('vietquan', 'quan@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-13', 1, 1, 1),
('caothang', 'thang@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-13', 1, 1, 1),
('nguyentrung', 'trung@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-13', 1, 1, 1),
('vietquang', 'quang@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-13', 1, 1, 1),
('phuongkiet', 'kiet@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-13', 1, 1, 1),
('minhdang', 'dang@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'profile-pic.svg', '2023-06-13', 1, 1, 1);

INSERT INTO UserDetail(user_id, first_name, last_name, specialty, bio) 
VALUES 
(1, 'tuan', 'tieu', '', ''),
(2, 'tri', 'vo', '', ''),
(3, 'khang', 'bui', '', ''),
(4, 'khoa', 'ly', '', ''),
(5, 'minh', 'nguyen', '', ''),
(6, 'quyen', 'tran', '', ''),
(7, 'co', 'truong', '', ''),
(8, 'nguyen', 'nguyen', '', ''),
(9, 'minh', 'dinh', '', ''),
(10, 'hung', 'tran', '', ''),
(11, 'thanh', 'nguyen', '', ''),
(12, 'nhat', 'le', '', ''),
(13, 'binh', 'le', '', ''),
(14, 'nghia', 'nguyen', '', ''),
(15, 'phong', 'ngo', '', ''),
(16, 'minh', 'nhat', '', ''),
(17, 'khanh', 'tran', '', ''),
(18, 'tien', 'tran', '', ''),
(19, 'phuong', 'do', '', ''),
(20, 'quoc', 'tran', '', ''),
(21, 'tai', 'vo', '', ''),
(22, 'thinh', 'tran', '', ''),
(23, 'quan', 'nguyen', '', ''),
(24, 'thang', 'pham', '', ''),
(25, 'nguyen', 'ho', '', ''),
(26, 'quang', 'nguyen', '', ''),
(27, 'kiet', 'nguyen', '', ''),
(28, 'dang', 'vu', '', '');

INSERT INTO Category(title) 
VALUES ('Breakfast'),
('Lunch'),
('Snack'),
('Dinner'),
('Soup');

INSERT INTO Diet(title) 
VALUES
('Healthy'),
('Low-Fat'),
('Weight-Loss'),
('Diet');

INSERT INTO Cuisine(title) 
VALUES
('Mexican'),
('Canadian'),
('Chinese'),
('French'),
('German'),
('Indian'),
('Indonesian'),
('Italian'),
('Japanese'),
('Korean'),
('Spanish'),
('Thai'),
('Vietnamese'),
('Other');

INSERT INTO Level(type) 
VALUES ('Easy'),
('Medium'),
('Hard');

INSERT INTO Ingredient(title) 
VALUES 
('Vegetables'),
('Fruits'),
('Grains'),
('Meat'),
('Seafood'),
('Dairy'),
('Spicy'),
('Egg'),
('Other');


INSERT INTO Recipe(title, description, prep_time, cook_time, servings, create_at, cuisine_id, category_id, user_id, level_id, status)
VALUES
-- 1
('Vietnamese Fresh Spring Rolls', 
'These Vietnamese spring rolls are a refreshing change from the usual fried variety and have become a family favorite. They are a great summertime appetizer and delicious dipped in one or both of the sauces.', 
45, 5, 8, '2023-05-22', 13, 3, 1, 2, 3),
-- 2
('Wonton Soup', 
'Wonton soup is a simple, light, Chinese classic with pork-filled dumplings in seasoned chicken broth. Whether in soup or fried, wontons always add delicious, hearty flavor to any dish!', 
30, 10, 6, '2023-05-25', 3, 5, 2, 1, 3),
-- 3
('Onigiri (Japanese Rice Balls)', 
'This easy onigiri recipe is also fun to make! These rice balls are a staple of Japanese lunchboxes (bento). 
You can put almost anything in these rice balls; try substituting grilled salmon, pickled plums, beef, pork, turkey, or tuna with mayonnaise.', 
20, 20, 4, '2023-05-25', 9, 1, 3, 2, 3),
-- 4
('Worlds Best Pasta Sauce', 
'This pasta sauce is excellent in lasagna or as a meat sauce.', 
15, 100, 16, '2023-05-25', 8, 4, 1, 3, 3),
-- 5
('Restaurant Style Egg Drop Soup', 
'This chicken egg drop soup is born from a love of the soup, many trips to my favorite Chinese restaurant, and many questions. This variation is the result. Simplicity is the key. The soup can be reheated or frozen and reheated.', 
10, 10, 4, '2023-06-02', 3, 5, 2, 1, 3),
-- 6
('Jays Signature Pizza Crust', 
'This thick crust pizza dough recipe yields a crust that is soft and doughy on the inside and slightly crusty on the outside. Cover it with your favorite sauce and toppings to make a delicious pizza.', 
30, 75, 15, '2023-06-02', 8, 3, 3, 2, 3),
-- 7
('Homemade Chicken Soup', 
'This homemade chicken soup recipe is well worth making — its good for the body and the soul. How is it that plain chicken and vegetables simmered together can taste so satisfying? You dont have to be sick to deserve to enjoy it!', 
15, 90, 10, '2023-06-03', 3, 5, 1, 1, 2),
-- 8
('Parchment Baked Salmon', 
'Cooking salmon in parchment paper is the best way to steam with great taste.', 
15, 25, 2, '2023-06-03', 9, 4, 2, 1, 2),

-- 9
('Apple Pie Filling', 
'Freezer apple pie filling. With this recipe, you can treat your family with pies year-round.', 
20, 140, 40, '2023-06-03', 14, 3, 3, 2, 2),

-- 10
('Fiesta Slow Cooker Shredded Chicken Tacos', 
'This chicken tacos recipe is easy to make in a slow cooker. Spoon the filling into warm tortillas for a very tasty meal.', 
10, 360, 8, '2023-06-30', 1, 3, 5, 2, 3),

-- 11
('Mango Salsa', 
'A very tasty mango salsa that is great served over fish. My favorite is any fish blackened with Cajun seasoning and then topped with this salsa. Also great for dipping chips.', 
15, 30, 8, '2023-06-30', 1, 2, 5, 1, 3),

-- 12
('Macarons (French Macaroons)', 
'Macarons are made with finely ground almonds, confectioners sugar, and egg whites. They are the most delicious soft cookies with crispy edges. I finally perfected the technique and wanted to share it. Pipe your choice of filling or frosting on a cookie and sandwich another cookie on top.', 
30, 10, 16, '2023-06-30', 4, 3, 6, 1, 4),

-- 13
('Cream of Mushroom Soup', 
'For this cream of mushroom soup you can use common button mushrooms, or add other delicious varieties. Experiment and have fun, all will be good.', 
20, 30, 6, '2023-06-30', 5, 5, 7, 1, 3),

-- 14
('Fresh Orange Juice', 
'Fresh orange juice takes a little work, but it tastes much better than orange juice from concentrate. I came up with this recipe in response to a request about how to make fresh-squeezed orange juice. You may also use a citrus reamer to do this. If you want less pulp, use a hand juicer with a strainer.', 
5, 5, 3, '2023-06-30', 13, 3, 8, 1, 3),

-- 15
('Oat Milk', 
'Creamy, full-bodied vegan milk made with oats and dates. This is a perfect solution for your coffee, cereal, or just satisfying that cookie-dunking craving. Using quick oats reduces preparation time. Cover and store in the refrigerator for up to 1 week. Shake before use.', 
5, 40, 2, '2023-06-30', 13, 1, 9, 1, 3),

-- 16
('Baked Kale Chips', 
'These crispy oven-baked kale chips are a great homemade snack. You cannot stop at just eating one, just like potato chips. Great for parties, too.', 
10, 20, 6, '2023-06-30', 2, 3, 10, 2, 3),

-- 17
('Quick Beef Stir-Fry', 
'Quick and easy beef stir-fry. I make this on my busiest weeknights.', 
15, 10, 4, '2023-07-13', 3, 4, 8, 2, 4),

-- 18
('Thit Kho (Caramelized Pork Belly)', 
'Thit kho tau (or thit kho for short) is a very popular dish in Vietnamese households for everyday eating, but its also traditionally served during Tết, the Vietnamese Lunar New Year. The longer you cook the pork belly, the more tender it becomes. If you make this dish ahead of time, the fat will congeal on the surface, making it easier to remove and a little healthier! This also allows the flavors to meld a little more. Serve with rice.', 
20, 75, 6, '2023-07-13', 13, 2, 3, 3, 3),

-- 19
('Vietnamese Grilled Lemongrass Chicken', 
'This lemongrass chicken is marinated, then grilled until juicy and tender. Garnish with rice paper, lettuce, cucumber, bean sprouts, mint, and ground peanuts.', 
10, 10, 4, '2023-07-13', 13, 2, 6, 2, 3),

-- 20
('Chicken Katsu', 
'Chicken katsu is Japanese-style fried chicken. This is my family recipe and can also be used to make tonkatsu by using pork cutlets instead of chicken. Serve with white rice and tonkatsu sauce.', 
15, 10, 4, '2023-07-13', 9, 4, 1, 2, 4)

INSERT INTO Nutrition(recipe_id, calories, fat, carbs, protein) 
VALUES 
(1, 82, 1, 16, 3),
(2, 195, 6, 21, 13),
(3, 744, 3, 159, 14),
(4, 157, 9, 12, 10),
(5, 76, 4, 4, 5),
(6, 119, 2, 22, 3),
(7, 152, 9, 4, 13),
(8, 175, 7, 6, 25),
(9, 129, 0, 33, 0),
(10, 71, 1, 2, 11),
(11, 21, 0, 5, 0),
(12, 92, 1, 18, 3),
(13, 148, 11, 9, 5),
(14, 50, 0, 12, 1),
(15, 177, 3, 34, 6),
(16, 58, 3, 8, 3),
(17, 268, 16, 9, 23),
(18, 410, 26, 16, 27),
(19, 308, 19, 4, 29),
(20, 297, 11, 22, 31);

INSERT INTO RecipeDiet(recipe_id, diet_id) 
VALUES 
(1, 2),
(2, 2),
(3, 3),
(4, 1),
(5, 3),
(6, 1),
(7, 3),
(8, 1),
(8, 3),
(9, 2),
(10, 2),
(11, 1),
(11, 2),
(12, 1),
(12, 2),
(13, 1),
(13, 3),
(14, 1),
(14, 4),
(15, 1),
(15, 4),
(16, 4),
(17, 1),
(17, 4),
(18, 4),
(19, 3);

INSERT INTO RecipeImage(image, thumbnail, recipe_id) 
VALUES 
('vietnamese_spring_rolls.jpg', 1, 1),
('vietnamese_spring_rolls.jpg', 0, 1),

('Wonton_Soup.jpg', 1, 2),
('Wonton_Soup.jpg', 0, 2),

('Onigiri.jpg', 1, 3),
('Onigiri.jpg', 0, 3),

('pasta2.jpeg', 1, 4),
('pasta.jpg', 0, 4),

('egg-soup.jpg', 1, 5),
('egg-soup.jpg', 0, 5),

('pizza-crust.jpg', 1, 6),
('pizza-crust.jpg', 0, 6),

('chicken-soup.jpg', 1, 7),
('chicken-soup.jpg', 0, 7),

('parchment-baked-salmon.jpg', 1, 8),
('parchment-baked-salmon.jpg', 0, 8),

('apple-pie.jpg', 1, 9),
('apple-pie.jpg', 0, 9),

('fiesta-slow-cooker-shredded-chicken-tacos.jpg', 1, 10),
('fiesta-slow-cooker-shredded-chicken-tacos.jpg', 0, 10),

('mango-salsa.jpg', 1, 11),
('mango-salsa.jpg', 0, 11),

('macarons.jpg', 1, 12),
('macarons.jpg', 0, 12),

('mushroom-soup.jpg', 1, 13),
('mushroom-soup.jpg', 0, 13),

('orange-juice.jpg', 1, 14),
('orange-juice.jpg', 0, 14),

('oat-milk.jpg', 1, 15),
('oat-milk.jpg', 0, 15),

('baked-kale-chips.jpg', 1, 16),
('baked-kale-chips.jpg', 0, 16),

('beef-stir-fry.jpg', 1, 17),
('beef-stir-fry.jpg', 0, 17),

('thit-kho.jpg', 1, 18),
('thit-kho.jpg', 0, 18),

('vietnamese-grilled-lemongrass-chicken.jpg', 1, 19),
('vietnamese-grilled-lemongrass-chicken.jpg', 0, 19),

('chicken-katsu.jpg', 1, 20),
('chicken-katsu.jpg', 0, 20);;

INSERT INTO Direction(description, recipe_id) 
VALUES 
('<ol>
	<li>
	<p>Fill a large pot with lightly salted water and bring to a rolling boil; stir in vermicelli pasta and return to a boil. Cook pasta uncovered, stirring occasionally, until the pasta is tender yet firm to the bite, 3 to 5 minutes.</p>
	</li>
	<li>
	<p>Fill a large bowl with warm water. Dip one wrapper into the hot water for 1 second to soften. Lay wrapper flat; place 2 shrimp halves in a row across the center, add some vermicelli, lettuce, mint, cilantro, and basil, leaving about 2 inches uncovered on each side. Fold uncovered sides inward, then tightly roll the wrapper, beginning at the end with lettuce. Repeat with remaining ingredients.</p>
	</li>
	<li>
	<p>For the sauces: Mix water, lime juice, sugar, fish sauce, garlic, and chili sauce in a small bowl until well combined. Mix hoisin sauce and peanuts in a separate small bowl.</p>
	</li>
	<li>
	<p>Serve rolled spring rolls with fish sauce and hoisin sauce mixtures.</p>
	</li>
</ol>', 1),

('<ol>
	<li>
	<p>Make the wontons: Mix pork, shrimp, rice wine, soy sauce, brown sugar, green onions, and ginger together in a large bowl until well combined. Let stand for 25 to 30 minutes.</p>
	</li>
	<li>
	<p>Spoon about 1 teaspoon filling onto the center of a wonton wrapper. Moisten all four wrapper edges with water and fold over filling to make a triangle; press the edges firmly to seal. Bring left and right corners together above filling; overlap the tips of these corners, moisten with water, and press together to seal. Repeat until all wrappers have been filled and sealed.</p>
	</li>
	<li>
	<p>Make the soup: Bring chicken stock to a rolling boil in a pot. Gently drop in wontons and cook for 5 minutes.</p>
	</li>
	<li>
	<p>Ladle into bowls and garnish with green onions.</p>
	</li>
</ol>', 2),

('<ol>
	<li>
	<p>Wash rice in a mesh strainer until water runs clear. Combine washed rice and 4 1/2 cups water in a saucepan. Bring to a boil over high heat, stirring occasionally. Reduce heat to low; cover, and simmer rice until water is absorbed, 15 to 20 minutes. Let rice rest for 15 minutes to continue to steam and become tender. Allow cooked rice to cool.</p>
	</li>
	<li>
	<p>Combine remaining 1 cup water with salt in a small bowl; use to dampen hands before handling rice. Divide cooked rice into 8 equal portions. Use one portion of rice for each onigiri.</p>
	</li>
	<li>
	<p>Divide one portion of rice in two. Create a dimple in rice and fill with a heaping teaspoon of bonito flakes. Cover with remaining portion of rice and press lightly to enclose filling inside rice ball. Gently press rice to shape into a triangle; wrap with a strip of nori and sprinkle with sesame seeds. Repeat with remaining portions of rice.</p>
	</li>
</ol>', 3),

('<ol>
	<li>
	<p>Cook sausage, beef, onion, and garlic in a large pot or Dutch oven over medium heat until browned; drain fat.</p>
	</li>
	<li>
	<p>Stir in crushed tomatoes, tomato sauce, tomato paste, and water. Mix in sugar, basil, Italian seasoning, fennel seed, salt, and pepper.</p>
	</li>
	<li>
	<p>Cover and simmer, stirring occasionally, until cooked through, about 1 1/2 hours.</p>
	</li>
</ol>', 4),

('<ol>
	<li>
	<p>Reserve 3/4 cup of chicken broth, and pour the rest into a large saucepan. Stir in chives, salt, and ginger; bring to a rolling boil. Stir reserved 3/4 cup of broth and cornstarch until smooth. Set aside.</p>
	</li>
	<li>
	<p>Whisk eggs and egg yolk together in a small bowl with a fork. Using a fork, drizzle eggs, a little at a time, into boiling broth. Eggs will cook immediately. Stir in cornstarch mixture gradually until soup reaches desired consistency.</p>
	</li>
</ol>', 5),

('<ol>
	<li>
	<p>Stir together warm water, yeast, and brown sugar in a large mixing bowl; let sit for 10 minutes.</p>
	</li>
	<li>
	<p>Stir oil and salt into yeast mixture. Mix in 2 1/2 cups flour until incorporated. Turn dough out onto a clean, floured surface. Knead dough, adding remaining flour, a little at a time, until dough is no longer sticky. Place dough into an oiled bowl.</p>
	</li>
	<li>
	<p>Cover with a towel and let rise until doubled in size, about 1 hour.</p>
	</li>
	<li>
	<p>Punch down dough and form it into a tight ball. Allow dough to relax for 1 minute before rolling out.</p>
	</li>
	<li>
	<p>Preheat the oven to 425 degrees F (220 degrees C).</p>
	</li>
	<li>
	<p>If baking dough on a pizza stone, place toppings on dough and bake immediately. If baking dough on a pan, lightly oil the pan and let dough rise for 15 to 20 minutes before topping and baking it.</p>
	</li>
	<li>
	<p>Bake in the preheated oven until cheese is melted and crust is golden brown, 15 to 20 minutes.</p>
	</li>
</ol>', 6),

('<ol>
	<li>
	<p>Place chicken, carrots, celery, and onion in a large soup pot; add enough cold water to cover. Bring to a boil over medium heat; reduce heat to low and simmer, uncovered, until meat falls off of the bone, about 90 minutes. Skim off foam every so often, as needed.</p>
	</li>
	<li>
	<p>Remove chicken from the pot and let sit until cool enough to handle; chop meat into pieces, and discard skin and bones.</p>
	</li>
	<li>
	<p>Strain out vegetables, reserving the stock; rinse the soup pot and return the stock to the pot. Chop vegetables into smaller pieces; return chopped chicken and vegetables to the pot.</p>
	</li>
	<li>
	<p>Warm soup until heated through; season with salt, pepper, and chicken bouillon to taste.</p>
	</li>
</ol>', 7),

('<ol>
	<li>
	<p>Preheat the oven to 400 degrees F (200 degrees C). Move an oven rack to the lowest position.</p>
	</li>
	<li>
	<p>Place salmon fillet, skin-side down, in the middle of a large piece of parchment paper; season with salt and black pepper. Cut two 3-inch slits into fillet with a sharp knife. Stuff chopped basil leaves into the slits. Spray fillet with cooking spray and arrange lemon slices on top.</p>
	</li>
	<li>
	<p>Fold the edges of parchment paper over fillet several times to seal it into an airtight packet. Place sealed packet onto a baking sheet.</p>
	</li>
	<li>
	<p>Bake in the preheated oven on the bottom rack until salmon flakes easily and flesh is pink and opaque with an interior of slightly darker pink color, about 25 minutes. An instant-read thermometer inserted into the thickest part of fillet should read at least 145 degrees F (65 degrees C). To serve, cut open the parchment paper and remove lemon slices before plating.</p>
	</li>
</ol>', 8),

('<ol>
	<li>
	<p>Place apples in a bowl. Toss apples with lemon juice in a large bowl and set aside.</p>
	</li>
	<li>
	<p>Pour water into a Dutch oven over medium heat. Combine sugar, cornstarch, cinnamon, salt, and nutmeg in a bowl; add to water, stir well, and bring to a boil. Boil for 2 minutes, constantly stirring.</p>
	</li>
	<li>
	<p>Add apples and return to a boil. Reduce heat, cover, and simmer until apples are tender, 6 to 8 minutes. Cool for 30 minutes.</p>
	</li>
	<li>
	<p>Ladle into 5 freezer containers, leaving 1/2 inch of headspace. Cool at room temperature no longer than 1 1/2 hours.</p>
	</li>
	<li>
	<p>Seal and freeze. Can be stored for up to 12 months.</p>
	</li>
	<li>
	<p>Enjoy!</p>
	</li>
</ol>', 9),

('<ol>
	<li>
	<p>Combine chicken broth and taco seasoning mix in a bowl.</p>
	</li>
	<li>
	<p>Place chicken in a slow cooker. Pour chicken broth mixture over chicken.</p>
	</li>
	<li>
	<p>Cook on Low for 6 to 8 hours. Shred chicken.</p>
	</li>
</ol>', 10),

('<ol>
	<li>
	<p>Gather ingredients.</p>
	</li>
	<li>
	<p>Place mango, red bell pepper, green onion, jalapeño, cilantro, lime juice, and lemon juice in a medium bowl.</p>
	</li>
	<li>
	<p>Mix ingredients well to combine. Cover and let sit at least 30 minutes before serving.</p>
	</li>
	<li>
	<p>Serve with chips.</p>
	</li>
</ol>', 11),

('<ol>
	<li>
	<p>Line a baking sheet with a silicone baking mat.</p>
	</li>
	<li>
	<p>Beat egg whites in the bowl of a stand mixer fitted with a whisk attachment until foamy. Add white sugar and beat until egg whites are glossy, fluffy, and hold soft peaks.</p>
	</li>
	<li>
	<p>Sift confectioners sugar and ground almonds in a separate bowl; quickly fold almond mixture into egg whites, about 30 strokes.</p>
	</li>
	<li>
	<p>Spoon a small amount of batter into a plastic bag with a small corner cut off and pipe a test disk of batter, about 1 1/2 inches in diameter, onto the prepared baking sheet. If the disk of batter holds a peak instead of flattening immediately, gently fold batter a few more times and retest.</p>
	</li>
	<li>
	<p>When batter is mixed enough to flatten immediately into an even disk, spoon into a pastry bag fitted with a plain round tip. Pipe batter onto the baking sheet in rounds, leaving space between the disks. Let piped cookies stand out at room temperature until they form a hard skin on top, about 1 hour.</p>
	</li>
	<li>
	<p>Preheat the oven to 285 degrees F (140 degrees C).</p>
	</li>
	<li>
	<p>Bake cookies in preheated oven until set but not browned, about 10 minutes.</p>
	</li>
	<li>
	<p>Let cookies cool completely before filling, about 30 minutes.</p>
	</li>
</ol>', 12),

('<ol>
	<li>
	<p>Simmer mushrooms, broth, onion, and thyme in a large heavy saucepan until vegetables are tender, 10 to 15 minutes.</p>
	</li>
	<li>
	<p>Carefully transfer the hot mixture to a blender or food processor. Cover and hold lid down with a potholder; pulse until creamy but still with some chunks of vegetable.</p>
	</li>
	<li>
	<p>Melt butter in the same saucepan. Whisk in flour until smooth. Whisk in salt and pepper. Slowly whisk in half-and-half and mushroom mixture.</p>
	</li>
	<li>
	<p>Bring soup to a boil and cook, stirring constantly, until thickened.</p>
	</li>
	<li>
	<p>Stir in sherry. Taste and season with salt and pepper if needed.</p>
	</li>
</ol>', 13),

('<ol>
	<li>
	<p>Lightly smack each orange on the counter. Cut each orange in half and squeeze juice into a glass.</p>
	</li>
</ol>', 14),

('<ol>
	<li>
	<p>Soak oats in enough cool water to cover them. Cover and set aside for 30 minutes.</p>
	</li>
	<li>
	<p>Drain the oats using a mesh colander. Combine oats, 3 cups water, and dates in a large bowl. Allow to sit undisturbed until skin on the dates softens, 10 to 15 minutes.</p>
	</li>
	<li>
	<p>Transfer oat mixture to a blender. Pulse the mixture a few times and then leave on medium-high speed until completely smooth, about 1 minute. Drain oat milk through a nut bag or cheesecloth to remove all solids. Serve cold or warm.</p>
	</li>
</ol>', 15),

('<ol>
	<li>
	<p>Gather all ingredients.</p>
	</li>
	<li>
	<p>Preheat an oven to 300 degrees F (150 degrees C). Line a rimmed baking sheet with parchment paper.</p>
	</li>
	<li>
	<p>With a knife or kitchen shears carefully remove kale leaves from the thick stems and tear into bite size pieces.</p>
	</li>
	<li>
	<p>Wash and thoroughly dry kale with a salad spinner.</p>
	</li>
	<li>
	<p>Drizzle kale leaves with olive oil and toss to combine. Spread out in an even layer on the baking sheet without overlapping and sprinkle with salt.</p>
	</li>
	<li>
	<p>Bake until the edges start to brown but are not burnt, 20 to 30 minutes.</p>
	</li>
	<li>
	<p>Enjoy!</p>
	</li>
</ol>', 16),

('<ol>
	<li>
	<p>Gather all ingredients.</p>
	</li>
	<li>
	<p>Heat vegetable oil in a large wok or skillet over medium-high heat; cook and stir beef until browned, 3 to 4 minutes.</p>
	</li>
	<li>
	<p>Move beef to the side of the wok and add broccoli, bell pepper, carrots, green onion, and garlic to the center of the wok. Cook and stir vegetables for 2 minutes.</p>
	</li>
	<li>
	<p>Stir beef into vegetables and season with soy sauce and sesame seeds. Continue to cook and stir until vegetables are tender, about 2 more minutes.</p>
	</li>
	<li>
	<p>Serve hot and enjoy!</p>
	</li>
</ol>', 17),

('<ol>
	<li>
	<p>Slice pork belly into 1-inch pieces layered with skin, fat, and meat.</p>
	</li>
	<li>
	<p>Heat sugar in a large wok or pot over medium heat until it melts and caramelizes into a light brown syrup, about 5 minutes. Add pork and increase the heat to high. Cook and stir to render some of the pork fat, 3 to 5 minutes.</p>
	</li>
	<li>
	<p>Stir shallots and garlic into the wok. Add fish sauce and black pepper; stir until pork is evenly coated. Pour in coconut water and bring to a boil. Add hard-boiled eggs and reduce the heat to low. Cover and simmer, checking occasionally and adding a little water if the liquid evaporates too much, until pork is tender, about 1 hour.</p>
	</li>
	<li>
	<p>Remove from the heat and let stand for about 10 minutes. Skim fat from the surface of the dish.</p>
	</li>
</ol>', 18),

('<ol>
	<li>
	<p>Mix together canola oil, lemongrass, lemon juice, soy sauce, brown sugar, garlic, and fish sauce in a glass bowl until sugar is dissolved; add chicken and turn to coat in marinade.</p>
	</li>
	<li>
	<p>Marinate chicken in the refrigerator for 20 minutes to 1 hour.</p>
	</li>
	<li>
	<p>Preheat grill for medium heat and lightly oil the grate.</p>
	</li>
	<li>
	<p>Remove chicken thighs from marinade; shake to remove excess. Discard remaining marinade.</p>
	</li>
	<li>
	<p>Cook chicken on the preheated grill until no longer pink in the center and juices run clear, 3 to 5 minutes per side. An instant-read thermometer inserted into the center should read at least 165 degrees F (74 degrees C).</p>
	</li>
</ol>', 19),

('<ol>
	<li>
	<p>Season chicken breasts on both sides with salt and pepper. Place flour, beaten egg, and panko crumbs into separate shallow dishes. Coat chicken breasts in flour, shaking off any excess; dip into egg, and then press into panko crumbs until well coated on both sides.</p>
	</li>
	<li>
	<p>Heat oil in a large skillet over medium-high heat. Place chicken in the hot oil, and fry until golden brown, 3 or 4 minutes per side. Transfer to a paper towel-lined plate to drain.</p>
	</li>
</ol>', 20)

INSERT INTO IngredientDetail(description, ingredient_id, recipe_id) 
VALUES 
('2 ounces rice vermicelli', 3, 1),
('8 rice wrappers (8.5 inch diameter)', 3, 1),
('8 large cooked shrimp - peeled, deveined and cut in half', 5, 1),
('2 leaves lettuce, chopped', 1, 1),
('3 tablespoons chopped fresh mint leaves', 1, 1),
('3 tablespoons chopped fresh cilantro', 1, 1),
('1 tablespoons chopped fresh Thai basil', 9, 1),

('1/2 pound boneless pork loin, coarsely chopped', 4, 2),
('2 ounces peeled shrimp, finely chopped', 5, 2),
('1 tablespoon Chinese rice wine', 3, 2),
('2 leaves lettuce, chopped', 1, 2),
('1 tablespoon light soy sauce', 7, 2),
('1 teaspoon brown sugar', 7, 2),
('1 teaspoon finely chopped green onions', 1, 2),
('1 teaspoon chopped fresh ginger root', 1, 2),
('24 (3.5 inch square) wonton wrappers', 9, 2),
('3 cups chicken stock', 9, 2),
('2 tablespoons finely chopped green onions', 1, 2),

('4 cups uncooked short-grain white rice', 3, 3),
('5 cups water, divided', 9, 3),
('1/4 teaspoon salt', 7, 3),
('1 cup bonito shavings (dry fish flakes)', 5, 3),
('2 sheets nori (dry seaweed), cut into 1/2-inch strips', 9, 3),
('2 tablespoons sesame seeds', 9, 3),

('1 pound sweet Italian sausage, sliced', 9, 4),
('3/4 pound lean ground beef', 4, 4),
('1 cup minced onion', 1, 4),
('2 cloves garlic, crushed', 1, 4),
('1 can crushed tomatoes', 1, 4),
('2 cans tomato sauce', 9, 4),
('2 cans tomato paste', 9, 4),
('1/2 cup water', 9, 4),
('2 tablespoons white sugar', 7, 4),
('1 teaspoon dried basil', 9, 4),
('1/2 teaspoon fennel seed', 3, 4),
('1/2 teaspoon salt', 7, 4),
('1/4 teaspoon ground black pepper', 9, 4),

('4 cups chicken broth, divided', 4, 5),
('2 tablespoons chopped fresh chives', 1, 5),
('1/4 teaspoon salt', 7, 5),
('1/8 teaspoon ground ginger', 1, 5),
('1 tablespoons cornstarch', 9, 5),
('2 eggs', 8, 5),
('1 egg yolk', 8, 5),

('1 cups warm water (110 degrees F/45 degrees C)', 9, 6),
('2 teaspoons active dry yeast', 9, 6),
('1/2 teaspoon brown sugar', 7, 6),
('2 tablespoons olive oil', 9, 6),
('1 teaspoon salt', 9, 6),
('3 cups all-purpose flour, divided', 9, 6),

('1 (3 pound) whole chicken', 4, 7),
('4 carrots, halved', 1, 7),
('4 stalks celery, halved', 1, 7),
('1 large onion, halved', 1, 7),
('Water to cover', 9, 7),
('Salt and pepper to taste', 7, 7),
('1 teaspoon chicken bouillon granules (Optional)', 7, 7),

('1 (8 ounce) salmon fillet', 5, 8),
('Salt and ground black pepper to taste', 7, 8),
('1/4 cup chopped basil leaves', 1, 8),
('Olive oil cooking spray', 9, 8),
('1 lemon, thinly sliced', 2, 8),

('18 cups thinly sliced apples', 2, 9),
('3 tablespoons lemon juice', 2, 9),
('10 cups water', 9, 9),
('4 1/2 cups white sugar', 7, 9),
('1 cup cornstarch', 7, 9),
('2 teaspoons ground cinnamon', 9, 9),
('1 teaspoon salt', 7, 9),
('1/4 teaspoon ground nutmeg', 9, 9),

('1 cup chicken broth', 4, 10),
('3 tablespoons taco seasoning mix', 7, 10),
('1 pound skinless, boneless chicken breasts', 4, 10),

('1 mango - peeled, seeded, and chopped', 1, 11),
('¼ cup finely chopped red bell pepper', 2, 11),
('1 green onion, chopped', 1, 11),
('1 fresh jalapeño chile pepper, finely chopped', 7, 11),
('2 tablespoons chopped cilantro', 1, 11),
('2 tablespoons lime juice', 2, 11),
('1 tablespoon lemon juice', 4, 11),

('3 egg whites', 8, 12),
('¼ cup white sugar', 6, 12),
('1 ⅔ cups confectioners sugar', 6, 12),
('1 cup finely ground almonds', 3, 12),

('5 cups sliced fresh mushrooms', 1, 13),
('1 ½ cups chicken broth', 4, 13),
('½ cup chopped onion', 1, 13),
('⅛ teaspoon dried thyme', 9, 13),
('3 tablespoons butter', 6, 13),
('3 tablespoons all-purpose flour', 3, 13),
('¼ teaspoon salt', 9, 13),
('¼ teaspoon ground black pepper', 9, 13),
('1 tablespoon sherry', 9, 13),

('4 oranges', 2, 14),

('1 cup quick-cooking oats', 3, 15),
('3 cups waterr', 9, 15),
('2 small dates, pitted', 2, 15),

('1 bunch kale', 1, 16),
('1 tablespoon olive oil', 9, 16),
('1 teaspoon flaked sea salt', 9, 16),

('2 tablespoons vegetable oil', 1, 17),
('1 pound beef sirloin, cut into 2-inch strips', 4, 17),
('1 1/2 cups fresh broccoli florets', 1, 17),
('1 red bell pepper, cut into matchsticks', 1, 17),
('2 carrots, thinly sliced', 1, 17),
('1 green onion, chopped', 1, 17),
('1 teaspoon minced garlic', 9, 17),
('2 tablespoons soy sauce', 9, 17),
('2 tablespoons sesame seeds, toasted', 3, 17),

('2 pounds pork belly, trimmed', 4, 18),
('2 tablespoons white sugar', 9, 18),
('5 shallots, sliced', 9, 18),
('3 cloves garlic, chopped', 9, 18),
('3 tablespoons fish sauce', 7, 18),
('13 fluid ounces coconut water', 9, 18),
('6 hard-boiled eggs, peeled', 8, 18),

('2 tablespoons canola oil', 9, 19),
('2 tablespoons finely chopped lemongrass', 9, 19),
('1 tablespoon lemon juice', 2, 19),
('2 teaspoons soy sauce', 7, 19),
('2 teaspoons light brown sugar', 9, 19),
('2 teaspoons minced garlic', 9, 19),
('1 teaspoon fish sauce', 7, 19),
('1 1/2 pounds chicken thighs, or more to taste, pounded to an even thickness', 4, 19),

('4 skinless, boneless chicken breast halves - pounded to 1/2 inch thickness', 4, 20),
('2 tablespoons all-purpose flour', 9, 20),
('1 egg, beaten', 8, 20),
('1 cup panko bread crumbs', 9, 20),
('1 cup oil for frying, or as needed', 7, 20);

INSERT INTO Review(rating, content, create_at, recipe_id, user_id) 
VALUES 
(4, 'A DELISH recipe. Amazing taste, texture. Took me longer than instructions said, 
but otherwise one of the best meals ever!', '2023-05-22', 1, 1),
(5, 'Great recipe. True tastes of Vietnam', '2023-05-22', 1, 2),
(5, 'I have been using this recipe for years and its my absolute favorite. It has eventually become a family favorite.', '2023-05-22', 1, 3),

(5, 'It it really good but it could use a little bit more flavor, but anyone could add that lol', '2023-05-25', 2, 1),
(2, 'The filling was not very good. I followed the recipe but the pork and shrimp mixture was coarse and overpowered the 
delicate wonton wrappers. The base of the soup was delicious, I need to find a better meat filling.', '2023-05-25', 2, 2),
(4, 'Added mushrooms, shallots, bok choy to the broth.', '2023-05-25', 2, 3),

(5, 'It was super easy to make and tasted amazing', '2023-05-25', 3, 1),
(4, 'Love these! It is a little difficult to wrap them up, but just practice that makes them perfect. They were eaten within minutes!', '2023-05-25', 3, 2),
(4, 'Making ornigiri was a great way for us to use up extra sushi rice & fillings after we had rolled all the nori sheets that came in a pkg into sushi rolls. 
Thanks! Now I have lunch for tomorrow,too!! :D', '2023-05-25', 3, 3),

(4, 'This is delicious with the addition of my mother’s secret pasta sauce ingredient, rosemary. Adds that special “something”. 
If you don’t care for the little needles, it is possible to find pre-minced dried rosemary.', '2023-05-25', 4, 1),
(5, 'My whole family loved this recipe. The only changes I made was to add more garlic and onion, and in place of the water 
I used Campbell chicken and roasted garlic stock. Will make again and again!', '2023-05-25', 4, 2),
(5, 'I replaced canned crushed tomatoes with diced fresh tomatoes. Made it with cheese & spinach ravioli. Came out very well.', '2023-05-25', 4, 3),

(5, 'Deeeelicious! Tastes just like I remember at the Chinese restaurant.', '2023-06-02', 5, 1),
(5, 'Tasted like I bought it from a fancy restaurant! Everyone loved it and was gone so fast! Now that I have the ingredients, I’m definitely going to make more and share.', '2023-06-02', 5, 2),
(5, 'Excellent recipe. Great flavor. Rivals any restaurant soup. I did however use three full eggs. I don’t know what else to say it was just amazing.', '2023-06-02', 5, 3),

(5, 'Easy pizza crust! It reminds me a little of a focaccia-like crust great for a homemade pizza. I’ve probably used this recipe at least 50 times and it always comes out the same way. Family favorite!', '2023-06-02', 6, 1),
(5, 'Very good, nice and puffy. Taste is great! sometimes I use bread flour. Comes out a little chewier.', '2023-06-02', 6, 2),
(5, 'My go-to pizza dough.', '2023-06-02', 6, 3),

(5, 'Delicious and way too easy to make.', '2023-06-03', 7, 1),
(5, 'This is just a really nice basic chicken soup recipe. I added some leftover cauliflower to it and used veg broth since that is what I had on hand. Also made very small dumplings in it. Good flavor and easy meal to make!', '2023-06-03', 7, 2),
(4, 'This is basically how I make . . also add some dehydrated vegetables.', '2023-06-03', 7, 3),

(5, 'Yum! didn’t change a thing. Will make again', '2023-06-03', 8, 1),
(5, 'I will never cook Salmon any other way again. I stuffed mine with fresh dill instead of basil.', '2023-06-03', 8, 2),
(3, 'Still too dry and this was my second attempt. I’ll take Damon’s advice next time. I did reduce the time by one minute, but it was not enough.', '2023-06-03', 8, 3),

(5, '5 cups of water is plenty. I added a little more cinnamon and a pinch of cloves. Ive made this recipe before and it always turns out great!', '2023-06-03', 9, 1),
(5, 'Super easy, I used 5 cups of water and it came out perfect.', '2023-06-03', 9, 2),
(5, 'Excellect way to preserve apples for winter apple pies', '2023-06-03', 9, 3),

(5, 'I made this for my Parents(my Mom is real critical) & my Son they all loved it & I made it exactly like the recipe said to do the Chicken was real easy to shred & real tender', '2023-06-30', 10, 6),
(5, 'Very tasty and easy to make. My grandkids love it!', '2023-06-30', 10, 8),
(5, 'Simply delicious!! Shredded cheese and green olives slices on top!! Hmm', '2023-06-30', 10, 10),

(5, 'It is absolutely wonderful! I will NEVER eat anything else on my hamburger. It is easy to make, 10 minutes at the most. Peeling and slicing the mango is the longest part of this recipe and letting the flavors meld together.', '2023-06-30', 11, 8),
(5, 'This was very good with Pork chops. I did omit the Cilantro because we had a few people with adverse reactions to it. I also, changed to red Onion. Everyone loved it and asked for the recipe!', '2023-06-30', 11, 7),
(5, 'Good base recipe. I used red onion in place of green. 4 diced sweet multi color peppers in place of bell pepper. Added up to a Tb of finely chopped cilantro.', '2023-06-30', 11, 9),

(5, 'I’ve made them twice. First time following the recipe but WAY too sweet! I only out 1 cup of confectioners sugar and added 1/4 c extra almond flour. The semi sweet chips and cream for filling. Much better.', '2023-06-30', 12, 10),
(4, 'I think it could be better but it was still really good!', '2023-06-30', 12, 12),
(1, 'I have baked these twice and the inside did not get done either time. Both times the shell formed but the inside didnt cook. It was gooey and inedible. I followed the recipe to the letter even weighing the ingredients. I will not be trying this recipe again. Very disappointed.', '2023-06-30', 12, 11),

(5, 'It was delicious! I did not have sherry so I substituted a splash of Pinot Noir. I served it with a crusty Sourdough bread and topped it with chopped chives. Very yummy!', '2023-06-30', 13, 10),
(4, 'Soup came out delicious made exactly as lifted and I love it.', '2023-06-30', 13, 14),
(4, 'This was tasty but I used 2% milk. Would make again with the half and half for a more creamy taste. Also was a little bland so I think I’d add some garlic and more salt next time. Maybe more thyme too.', '2023-06-30', 13, 18),

(5, 'You can extract more juice per orange if you microwave the orange first for about 10 seconds', '2023-06-30', 14, 11),
(5, 'This recipe was good and easy to follow with one simple direction. It says to use 4 oranges for 3 servings, but you should add more oranges than in the directions. I recommend to add ice.', '2023-06-30', 14, 13),
(5, 'Super easy and super delicious! I also added some tangerines.', '2023-06-30', 14, 16),

(5, 'Delightfully simple! My batch yielded a whole quart!', '2023-06-30', 15, 5),
(4, 'Easy good substitute for milk.', '2023-06-30', 15, 10),

(5, 'It was easy to make. Tastes great too! I used the suggestion to bake for 12 minutes at 300 degrees. Will be making this a lot more!', '2023-06-30', 16, 9),
(5, 'Definitely needs to be completely dry before baking. I did 250 degrees at 25 minutes and it came out pretty good.', '2023-06-30', 16, 18),

(5, 'So easy and simple ant the taste was amazing 🤩.', '2023-07-13', 17, 11),
(5, 'I used a Beef Chuck Roast cut into 2 inch strips. It was really good. Saved myself a little money Too!', '2023-07-13', 17, 6),

(5, 'This is really great! I do add about a tbsp or two of hoisin sauce to give it colour. It tastes the best immediately but if you put it in the fridge overnight you can take out the cooled fat easily the next morning.', '2023-07-13', 18, 7),
(4, 'Easy, used thin cut pork belly without skin, subbed onion for shallot, thickened sauce with corn starch', '2023-07-13', 18, 16),

(5, 'This is so good! We used lemon balm from our garden and it was wonderful.', '2023-07-13', 19, 12),
(5, 'My picky kids ate this like candy. It was delicious and very simple to make. I did not have the fish sauce so I subbed a little bit of sesame oil.', '2023-07-13', 19, 7),

(5, 'This recipe is fantastic!! Perfectly cooked chicken breast with a delicious crunch. This is going to go in my regular rotation. ', '2023-07-13', 20, 5),
(5, 'We made this with aquafaba cause we ran out of eggs and it was great! Would probably be even better with eggs. Yum!', '2023-07-13', 20, 14);

INSERT INTO FavoriteRecipe(user_id, recipe_id) 
VALUES 
(6, 2),
(3, 6),
(8, 1),
(3, 8),
(7, 9),
(5, 8),
(3, 16),
(5, 2),
(3, 9),
(9, 15);

INSERT INTO NotificationType(sender, image, cate)
VALUES
('Content Team', 'assets/delideli-website-favicon-color.png', 'reject'),
('Content Team', 'assets/delideli-website-favicon-color.png', 'approve'),
('Your Plan', 'assets/delideli-website-favicon-color.png', 'planDetail'),
('Your Plan', 'assets/delideli-website-favicon-color.png', 'planConfirm'),
('Delideli', 'assets/delideli-website-favicon-color.png', 'system');

-- Suggestion
INSERT INTO Suggestion(title, status, user_id) 
VALUES 
('Popular', 1, 4),
('Similar', 0, 4);

INSERT INTO SuggestionRecipe(suggestion_id, recipe_id) 
VALUES 
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(2, 5),
(2, 6);

INSERT INTO NewsCategory(title) 
VALUES 
('CELEBRITY & ENTERTAINMENT'),
('COOKS TO FOLLOW'),
('GIFT GUIDES'),
('PRODUCT REVIEWS AND BUYING GUIDES'),
('RECALLS'),
('TRENDS');

    
INSERT INTO News(title, description, image, create_at, update_at,user_id, news_category_id) 
VALUES 
('Gordon Ramsay Favorite Cheap and Easy Recipe Works For Breakfast, Lunch, or Dinner', 
'<p>If you&#39;ve&nbsp;<a href="https://www.allrecipes.com/article/how-to-grocery-shop-from-your-own-pantry-to-save-money/">shopped for groceries</a>&nbsp;at least once in the last year, you&#39;ve probably noticed a big difference in your receipt. The cost of what the&nbsp;<a href="https://www.ers.usda.gov/data-products/food-price-outlook/summary-findings" rel="noopener" target="_blank">USDA</a>&nbsp;deems &quot;food at home&quot; (AKA grocery store purchases) jumped 11.3 percent from January 2022 to January 2023. No wonder the interest in our&nbsp;<a href="https://www.allrecipes.com/recipes/15522/everyday-cooking/budget-cooking/">budget cooking</a>&nbsp;section has spiked!</p>

<p>While Gordon Ramsay is a celebrity chef and has access to some of the world&#39;s best tools and ingredients to cook with, he understands what it&#39;s like to try to stick to a food budget while feeding a family. In fact, it&#39;s something he often keeps in mind while creating recipes for his&nbsp;<a href="https://www.gordonramsay.com/gr/about-gordon/books/" rel="noopener" target="_blank">cookbooks</a>, his digital series (including the just-launched&nbsp;<a href="https://www.youtube.com/playlist?list=PLTzMGnJjrsSyNWF_zSbXKlvDYYPGun925" rel="noopener" target="_blank"><em>Next Level Kitchen</em></a>), his&nbsp;<a href="https://www.gordonramsay.com/gr/the-gordon-ramsay-masterclass/" rel="noopener" target="_blank">MasterClass</a>, and while coaching contestants on his TV shows.</p>

<p>We recently spoke with Ramsay about how to cook affordably and efficiently, even if you don&#39;t have a kitchen as world-class as the top level on FOX&#39;s<em>&nbsp;<a href="https://www.fox.com/next-level-chef/about-the-show/" rel="noopener" target="_blank">Next Level Chef</a></em>. In the show, contestants compete on one of three &quot;floors&quot; of kitchens, where the first floor is a bare-bones set-up in terms of tools and foods, and the top is similar to a gourmet restaurant kitchen.</p>

<p>Equipment-wise, if you have &quot;an excellent non-stick pan, a great knife, a saucepan, cutting board, and sheet tray,&quot; Ramsay says, you&#39;ll be off and running. Ramsay has three top tips for contestants on that first floor&mdash;or any cook at home who wants to whip up more affordable meals:</p>

<ul>
	<li>Use staple&nbsp;<a href="https://www.allrecipes.com/gallery/budget-friendly-dinners-using-pantry-ingredients/">ingredients you have in your cupboard</a></li>
	<li>Don&#39;t be afraid of&nbsp;<a href="https://www.allrecipes.com/gallery/frozen-food-dinners/">frozen ingredients</a></li>
	<li>Get&nbsp;<a href="https://www.allrecipes.com/gallery/best-foods-for-leftovers/">creative with your leftovers</a></li>
</ul>

<p>One example of this concept in practice is the recipe below, which is Ramsay&#39;s riff on huevos rancheros that&#39;s inspired by a trip to Oaxaca, Mexico. It features&nbsp;<a href="https://www.allrecipes.com/article/budget-friendly-pantry-staples/">pantry staples</a>&nbsp;(canned black beans, canned tomatoes, spices), refrigerator mainstays (eggs, butter, cheese), and leftovers (grab any extra vegetables kicking around your crisper drawer after making the rest of your&nbsp;<a href="https://www.allrecipes.com/gallery/cheap-dinner-ideas-under-2-dollars/">dinners for the week</a>).</p>

<p>The result is a &quot;a delicious breakfast recipe that&#39;s so versatile you can use it for breakfast, brunch, or dinner! It&#39;s really simple but has complex flavors and you can add and subtract ingredients for whatever staples you have at home,&quot; Ramsay says.</p>

<h3>Gordon&#39;s Huevos Rancheros</h3>

<p>Makes 2 servings</p>

<p><strong>Huevos Rancheros</strong></p>

<ul>
	<li>4 ounces chorizo, diced</li>
	<li>1 small zucchini, diced</li>
	<li>1 small red bell pepper, diced</li>
	<li>1 small yellow onion, diced</li>
	<li>Kosher salt</li>
	<li>Freshly ground black pepper</li>
	<li>1 to 2 tablespoons olive oil</li>
	<li>2 tablespoons chopped cilantro</li>
	<li>2 tablespoons smoked chipotle hot sauce</li>
	<li>3 tablespoons canned chopped tomatoes</li>
	<li>1 lime, zested</li>
</ul>

<p><strong>Black Beans</strong></p>

<ul>
	<li>2 tablespoons olive oil</li>
	<li>1 15-ounce can black beans, drained</li>
	<li>Kosher salt</li>
</ul>

<p><strong>Fried Eggs</strong></p>

<ul>
	<li>2 tablespoons butter</li>
	<li>1 tablespoon olive oil</li>
	<li>4 eggs</li>
	<li>2 teaspoons paprika</li>
	<li>Kosher salt</li>
	<li>Freshly ground black pepper</li>
</ul>

<p><strong>Assembly</strong></p>

<ul>
	<li>4 small corn tortillas</li>
	<li>1 avocado, diced</li>
	<li>4 ounces crumbled feta or cotija</li>
</ul>

<ol>
	<li>
	<p>Make the sauce: In a large skillet over medium heat, add the chorizo and cook until the fat begins to render.</p>
	</li>
	<li>
	<p>To the pan, add the zucchini, red pepper and onion. Season the mixture with salt and pepper and stir to combine. If the pan seems dry and your chorizo does not render enough fat, add a little oil to the pan to coat the vegetables and help them to caramelize.</p>
	</li>
	<li>
	<p>Add the cilantro and hot sauce and stir to combine.</p>
	</li>
	<li>
	<p>Stir in the chopped tomatoes and finish with lime zest. Continue cooking until the vegetables have softened and the mixture has thickened.</p>
	</li>
	<li>
	<p>Cook the beans: In a small skillet over medium heat, add the oil. Once the oil is shimmering, add the beans and cook until slightly crispy on the outside and soft on the inside. Season the beans with salt.</p>
	</li>
	<li>
	<p>Fry the eggs: In a small skillet over medium high heat, add the butter and oil. Once the butter has melted completely. Add the eggs to the pan and cook until the whites have cooked through. Season with paprika, salt and pepper.</p>
	</li>
	<li>
	<p>Assemble: Grill the tortillas and divide between two plates. Layer each plate with the vegetables, beans, eggs, avocado and cheese.</p>
	</li>
</ol>','gordon-ramsay-go-to-meal.jpg', '2023-05-30', '2023-05-30', 4, 1),
-- 
('Our Top New Recipe Last Week Will Change the Way You Make Tacos', 
'<p>I&rsquo;ve never met a taco I didn&rsquo;t like. From&nbsp;<a href="https://www.allrecipes.com/recipe/261299/zesty-carnitas-tacos/">slow-roasted pork tacos</a>&nbsp;to ground beef tacos made with store-bought seasoning and hard shells, I&rsquo;ll eat &lsquo;em all. And the next time I make tacos, I&rsquo;m turning to our top recipe from last week:&nbsp;<a href="https://www.allrecipes.com/fried-beef-tacos-recipe-7511180">Fried Beef Tacos</a>.</p>

<p>These tacos have been trending on&nbsp;<a href="https://www.tiktok.com/@theshayspence/video/7227998093877267755?lang=en" target="_blank">TikTok</a>, and for good reason. Instead of the usual method of cooking your filling and then loading up a tortilla, you press the raw meat into the tortilla before pan-frying it. The result? A snackable taco with a super crisp exterior and a tender, savory middle.</p>

<h2>Is an Arizona Taco the Same as a Taco Dorado?</h2>

<p>According to some TikTok users, these tacos are sometimes referred to as &quot;Arizona Tacos.&quot; But, they&rsquo;re better known as &quot;Tacos Dorados,&quot; or golden tacos, thanks to the color they get after frying.&nbsp;</p>

<p>Tacos dorados are essentially the original version of the hard shell taco and have been made in Mexico for generations upon generations. You&rsquo;ll find them folded like a book as in this recipe, or rolled into a log (you might know the rolled-up version as a&nbsp;<a href="https://www.allrecipes.com/recipe/69067/chicken-taquitos/">taquito</a>).&nbsp;</p>

<p>No matter what you call them or where you&rsquo;re from, they&rsquo;re a family favorite. One TikTok user said, &quot;I&rsquo;m from Arizona &amp; grew up with these! We call these Grandma&rsquo;s tacos because my grandma made them all the time, then my mom did &amp; now I do for my kids!&rdquo; Another user said, &ldquo;We grew up with these tacos back in the 70s, in Southern California.&rdquo;</p>

<h2>Our Best Tips for Making Tacos Dorados</h2>

<ul>
	<li>When filling tortillas, only press the meat mixture onto half of each tortilla to avoid overstuffing, and to make it easier to fold over the empty half while the taco cooks.</li>
	<li>Frying the tacos in oil adds plenty of grease; use lean ground sirloin to avoid extra grease.</li>
	<li>Have an instant-read thermometer on hand&mdash;temping the meat at the center of the taco will give you the most accurate reading (shoot for at least 160 degrees F or 70 degrees C).</li>
	<li>Don&rsquo;t forego a paper towel-lined plate. It&#39;s a must for soaking up the extra grease.&nbsp;</li>
	<li>This recipe is pretty flexible. You can easily swap flour tortillas for corn (just cook them at a lower temperature), add shredded cheese to your meat mixture, or swap the ground beef for ground chicken or pork.&nbsp;</li>
</ul>

<h2>More Fried Taco Trends We Love For Summer</h2>

<p>Tacos dorados aren&rsquo;t the only fried tacos in the game. If you love the idea of a crisp tortilla but want a different protein or flavor combo, check out some of these options:</p>

<ul>
	<li><strong><a href="https://www.allrecipes.com/recipe/255921/honduran-style-crispy-fried-tacos/">Honduran-Style Crispy Fried Tacos</a>:&nbsp;</strong>These tacos are filled with seasoned, shredded chicken, rolled, and fried before getting doused in a quick tomato sauce.&nbsp;</li>
	<li><strong><a href="https://www.allrecipes.com/recipe/258427/fried-shrimp-tacos/">Fried Shrimp Tacos</a>:&nbsp;</strong>Veggie- and shrimp-filled tacos with a spicy salsa to top it off? Yes, please. The frying method on this one is almost identical to our Fried Beef Tacos.</li>
	<li><strong><a href="https://www.allrecipes.com/smash-burger-taco-recipe-7485747">Smash Burger Taco</a>:&nbsp;</strong>Can&rsquo;t decide if you&rsquo;re craving a burger or a taco? Get the best of both worlds with this recipe. After mounding a portion of hot beef on a hot griddle, cover with a tortilla, press like a smash burger, flip, top with cheese and toppings, and fold in half.&nbsp;</li>
</ul>', 'fried-beef-tacos.jpg', '2023-07-01', '2023-07-01', 4, 6),
--
('Hundreds of Bags of Lay’s Potato Chips Recalled Across 4 States', 
'<p><a href="https://www.fda.gov/safety/recalls-market-withdrawals-safety-alerts/frito-lay-issues-allergy-alert-undeclared-milk-lays-classic-potato-chips-distributed-connecticut" target="_blank">Frito-Lay has issued a recall for multiple bags of its Lay&rsquo;s Classic Potato Chips</a>&nbsp;because the chips may contain milk ingredients that the packaging does not disclose. After a customer complaint, Lay&rsquo;s tested the chips and found that they may have milk ingredient contamination from Lay&#39;s Sour Cream &amp; Onion Flavored Potato Chips.</p>

<p>Those with milk allergies or sensitivities are warned not to consume the recalled chips, as it may cause severe or life-threatening allergic reactions.</p>

<p>LAY&#39;S/ALLRECIPES</p>

<p>The recalled Lay&rsquo;s potato chips were sold in Connecticut, Maine, Massachusetts, and New Hampshire at club stores, grocery stores, and convenience stores throughout those states. Customers could have purchased these chips as early as April 16.</p>

<p>You&rsquo;ll know you have one of the recalled bags if the label features&nbsp;<em>both</em>&nbsp;of the following: the specified &quot;Guaranteed Fresh&quot; date and one of the manufacturing codes listed below. The recalled products include:</p>

<ul>
	<li><strong>13-ounce Lay&rsquo;s Classic Party Size Potato Chips</strong></li>
	<li>UPC: 028400310413</li>
	<li>Guaranteed Fresh Date: 18 Jul 2023, 766310622</li>
	<li>Manufacturing Code: 105 04:55, 105 04:56, 105 04:57, 105&nbsp;04:58, 105 04:59, 105 05:00, 105 05:01, and 105 05:02</li>
	<li><strong>15 ⅝-ounce Lay&rsquo;s Classic Mix and Match Potato Chips</strong></li>
	<li>UPC: 0028400720151</li>
	<li>Guaranteed Fresh Date: 18 Jul 2023, 766310618</li>
	<li>Manufacturing Codes: 105 04:55, 105 04:56, 105 04:57, 105&nbsp;04:58, 105 04:59, 105 05:00, 105 05:01, and 105 05:02</li>
</ul>

<p>No other Lay&rsquo;s chips or bag sizes are impacted by this recall. You can find label photos on the&nbsp;<a href="https://www.fda.gov/safety/recalls-market-withdrawals-safety-alerts/frito-lay-issues-allergy-alert-undeclared-milk-lays-classic-potato-chips-distributed-connecticut" target="_blank">U.S. Food &amp; Drug Administration&rsquo;s website</a>.&nbsp;</p>

<p>While there haven&rsquo;t been any allergic reactions reported after consuming the recalled potato chips, if you have a milk allergy or sensitivity, you should not consume this product; instead, throw it away.&nbsp;If you do not have a milk allergy or sensitivity, you do not need to discard the recalled Lay&rsquo;s Classic Potato Chips, as they are safe to consume otherwise.&nbsp;</p>

<p>If you have any questions regarding this recall, you can contact Frito-Lay directly at 1-800-352-4477.</p>
', 'lays.jpg', '2023-07-01', '2023-07-01', 4, 5);

----------------------------------------------------------------------------------------------
