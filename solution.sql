CREATE TABLE restaurant (
  id integer PRIMARY KEY,
  name varchar(30),
  description text,
  review_score decimal(2,1),
  phone text,
  hours text
);

INSERT INTO restaurant VALUES (
  1,
  'Bytes of China',
  'Delectable Chinese Cuisine',
  3.9,
  '6175551212',
  'Mon - Fri 9:00 am to 9:00 pm, Weekends 10:00 am to 11:00 pm'
);

CREATE TABLE address (
  id integer PRIMARY KEY,
  restaurant_id integer REFERENCES restaurant(id) UNIQUE,
  street_number integer,
  street_name text,
  city text,
  state varchar(2),
  web text
);

INSERT INTO address VALUES (
  1,
  1,
  '2020',
  'Busy Street',
  'Chinatown',
  'MA',
  'http://bit.ly/BytesOfChina'
  
);

SELECT constraint_name, table_name, column_name
FROM information_schema.key_column_usage
WHERE table_name = 'restaurant';

SELECT constraint_name, table_name, column_name
FROM information_schema.key_column_usage
WHERE table_name = 'address';

CREATE TABLE category (
  id varchar(2) PRIMARY KEY,
  name text,
  description text
);

INSERT INTO category VALUES (
  'C',
  'Chicken',
  null
);

INSERT INTO category VALUES (
  'LS',
  'Luncheon Specials',
  'Served with Hot and Sour Soup or Egg Drop Soup and Fried or Steamed Rice  between 11:00 am and 3:00 pm from Monday to Friday.'
);

INSERT INTO category VALUES (
  'HS',
  'House Specials',
  null
);


SELECT constraint_name, table_name, column_name
FROM information_schema.key_column_usage
WHERE table_name = 'category';

CREATE TABLE dish (
  id integer PRIMARY KEY,
  name text,
  description text,
  spicy boolean
);

INSERT INTO dish VALUES (
  1,
  'Chicken with Broccoli',
  'Diced chicken stir-fried with succulent broccoli florets',
  false
);

INSERT INTO dish VALUES (
  2,
  'Sweet and Sour Chicken',
  'Marinated chicken with tangy sweet and sour sauce together with pineapples and green peppers',
  false
);

INSERT INTO dish VALUES (
  3,
  'Chicken Wings',
  'Finger-licking mouth-watering entree to spice up any lunch or dinner',
  true
);

INSERT INTO dish VALUES (
  4,
  'Beef with Garlic Sauce',
  'Sliced beef steak marinated in garlic sauce for that tangy flavor',
  true
);

INSERT INTO dish VALUES (
  5,
  'Fresh Mushroom with Snow Peapods and Baby Corns',
  'Colorful entree perfect for vegetarians and mushroom lovers',
  false
);

INSERT INTO dish VALUES (
  6,
  'Sesame Chicken',
  'Crispy chunks of chicken flavored with savory sesame sauce',
  false
);

INSERT INTO dish VALUES (
  7,
  'Special Minced Chicken',
  'Marinated chicken breast sauteed with colorful vegetables topped with pine nuts and shredded lettuce.',
  false
);

INSERT INTO dish VALUES (
  8,
  'Hunan Special Half & Half',
  'Shredded beef in Peking sauce and shredded chicken in garlic sauce',
  true
);

SELECT constraint_name, table_name, column_name
FROM information_schema.key_column_usage
WHERE table_name = 'dish';

CREATE TABLE review (
  id integer PRIMARY KEY,
  score decimal(2,1),
  content varchar(300),
  date_of text,
  restaurant_id integer REFERENCES restaurant(id)
);

INSERT INTO review VALUES (
  1,
  5.0,
  'Would love to host another birthday party at Bytes of China!',
  '05-22-2020',
  1
);

INSERT INTO review VALUES (
  2,
  4.5,
  'Other than a small mix-up, I would give it a 5.0!',
  '04-01-2020',
  1
);

INSERT INTO review VALUES (
  3,
  3.9,
  'A reasonable place to eat for lunch, if you are in a rush!',
  '03-15-2020',
  1
);

SELECT constraint_name, table_name, column_name
FROM information_schema.key_column_usage
WHERE table_name = 'review';

CREATE TABLE categories_dishes (
  category_id varchar(2) REFERENCES category(id),
  dish_id integer REFERENCES dish(id),
  price money,
  PRIMARY KEY (category_id, dish_id)
);

INSERT INTO categories_dishes VALUES (
  'C',
  1,
  6.95
);

INSERT INTO categories_dishes VALUES (
  'C',
  3,
  6.95
);

INSERT INTO categories_dishes VALUES (
  'LS',
  1,
  8.95
);

INSERT INTO categories_dishes VALUES (
  'LS',
  4,
  8.95
);

INSERT INTO categories_dishes VALUES (
  'LS',
  5,
  8.95
);

INSERT INTO categories_dishes VALUES (
  'HS',
  6,
  15.95
);

INSERT INTO categories_dishes VALUES (
  'HS',
  7,
  16.95
);

INSERT INTO categories_dishes VALUES (
  'HS',
  8,
  17.95
);


SELECT constraint_name, table_name, column_name
FROM information_schema.key_column_usage
WHERE table_name = 'categories_dishes';


/* NEW SECTION */

SELECT 
  restaurant.name,
  address.street_number,
  address.street_name,
  restaurant.phone
FROM restaurant, address
WHERE restaurant.id = address.restaurant_id;

SELECT 
  restaurant.name AS restaurant,
  MAX(review.score) AS best_rating
FROM restaurant, review
WHERE restaurant.id = review.restaurant_id
GROUP BY 1;

SELECT 
  category.name AS category,
  dish.name AS dish_name,
  cd.price
FROM dish, category, categories_dishes AS cd
WHERE dish.id = cd.dish_id
  AND category.id = cd.category_id
ORDER BY category;

SELECT
  dish.name AS spicy_dish_name,
  category.name AS category,
  cd.price
FROM dish, category, categories_dishes AS cd
WHERE dish.id = cd.dish_id
  AND category.id = cd.category_id
  AND dish.spicy = true;

SELECT 
  categories_dishes.dish_id,
  dish.name AS dish_name,
  COUNT(dish_id) AS dish_count
FROM categories_dishes, dish
WHERE dish.id = categories_dishes.dish_id
GROUP BY 1, 2
HAVING COUNT(dish_id) > 1;

SELECT 
  review.content,
  review.score AS best_rating
FROM review
WHERE review.score = 
  (SELECT MAX(review.score) FROM review);



