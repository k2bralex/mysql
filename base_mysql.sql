CREATE DATABASE stepik;

USE stepik;

CREATE TABLE book(
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author VARCHAR(30),
    price DECIMAL(8,2),
    amount INT
);

INSERT INTO book
VALUES (
    1, 'Мастер и Маргарита', 'Булгаков М.А.', 670.99, 3
       );

INSERT INTO book
VALUES
    (2, 'Белая гвардия', 'Булгаков М.А.', 540.50, 5),
    (3, 'Идиот', 'Достоевский Ф.М.', 460.00, 10),
    (4, 'Братья Карамазовы', 'Достоевский Ф.М.', 799.01, 2);


SELECT * FROM book;

SELECT author, title, price FROM book;

SELECT title AS Название, author AS Автор FROM book;

SELECT title, amount, amount * 1.65 AS pack FROM book;

SELECT