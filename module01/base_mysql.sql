CREATE DATABASE stepik;

USE stepik;

CREATE TABLE book
(
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title   VARCHAR(50),
    author  VARCHAR(30),
    price   DECIMAL(8, 2),
    amount  INT
);

INSERT INTO book
VALUES (1, 'Мастер и Маргарита', 'Булгаков М.А.', 670.99, 3);

INSERT INTO book
VALUES (2, 'Белая гвардия', 'Булгаков М.А.', 540.50, 5),
       (3, 'Идиот', 'Достоевский Ф.М.', 460.00, 10),
       (4, 'Братья Карамазовы', 'Достоевский Ф.М.', 799.01, 2);

INSERT INTO book
VALUES (5, 'Игрок', 'Достоевский Ф.М.', 480.50, 10),
       (6, 'Стихотворения и поэмы', 'Есенин С.А', 650.50, 15);


SELECT *
FROM book;

SELECT author, title, price
FROM book;

SELECT title AS Название, author AS Автор
FROM book;

SELECT title, amount, amount * 1.65 AS pack
FROM book;

SELECT title,
       author,
       amount,
       ROUND((price * 0.7), 2) AS new_price
FROM book;

SELECT author,
       title,
       ROUND(IF(author = 'Булгаков М.А.', price * 1.1, IF(author = 'Есенин С.А.', price * 1.05, price)), 2)
           AS new_price
FROM book;

SELECT author, title, price
FROM book
WHERE amount < 10;

SELECT title, author, price, amount
FROM book
WHERE (price < 500 OR price > 600)
  AND (price * amount) > 5000;

SELECT title, author
FROM book
WHERE (price BETWEEN 540.50 AND 800)
  AND (amount IN (2, 3, 5, 7));

SELECT author, title
FROM book
WHERE amount BETWEEN 2 AND 14
ORDER BY author DESC, title;

SELECT title, author
FROM book
WHERE title LIKE '%_ %_'
  AND author LIKE '%С.%'
ORDER BY title;

SELECT DISTINCT amount
FROM book;

SELECT amount
FROM book
GROUP BY amount;

SELECT author                AS Автор,
       COUNT(DISTINCT title) AS Различных_книг,
       SUM(amount)           AS Количество_экземпляров
FROM book
GROUP BY author;

SELECT author,
       MIN(price) AS Минимальная_цена,
       MAX(price) AS Максимальная_цена,
       AVG(price) AS Средняя_цена
FROM book
GROUP BY author;

SELECT author,
       SUM(amount * price)                             AS Стоимость,
       ROUND((SUM((amount * price * 0.18) / 1.18)), 2) AS НДС,
       ROUND((SUM((amount * price) / 1.18)), 2)        AS Стоимость_без_НДС
FROM book
GROUP BY author;

SELECT MIN(price)             AS Минимальная_цена,
       MAX(price)             AS Максимальная_цена,
       ROUND((AVG(price)), 2) AS Средняя_цена
FROM book;

SELECT ROUND((AVG(price)), 2)          AS Средняя_цена,
       ROUND((SUM(price * amount)), 2) AS Стоимость
FROM book
WHERE amount BETWEEN 5 AND 14;

SELECT author, SUM(price * amount) AS Стоимость
FROM book
WHERE title NOT IN ('Идиот', 'Белая гвардия')
GROUP BY author
HAVING SUM(book.price * amount) > 5000
ORDER BY Стоимость DESC;

SELECT author, title, price
FROM book
WHERE price <= (SELECT AVG(price) FROM book)
ORDER BY price DESC;

SELECT author, title, price
FROM book
WHERE price - (SELECT MIN(price) FROM book) <= 150
ORDER BY price;

SELECT author, title, amount
FROM book
WHERE amount IN (SELECT amount
                 FROM book
                 GROUP BY amount
                 HAVING COUNT(amount) < 2);

SELECT author, title, price
FROM book
WHERE price < ANY (SELECT MIN(price)
                   FROM book
                   GROUP BY author);

SELECT title,
       author,
       amount,
       (
               (SELECT MAX(amount) FROM book) - amount
           ) AS Заказ
FROM book
WHERE amount <> (SELECT MAX(amount) FROM book)




