USE stepik;

CREATE TABLE supply
(
    supply_id INT PRIMARY KEY AUTO_INCREMENT,
    title     VARCHAR(50),
    author    VARCHAR(30),
    price     DECIMAL(8, 2),
    amount    INT
);

INSERT INTO supply
VALUES (1, 'Лирика', 'Пастернак Б.Л.', 518.99, 2),
       (2, 'Черный человек', 'Есенин С.А.', 570.20, 6),
       (3, 'Белая гвардия', 'Булгаков М.А.', 540.50, 7),
       (4, 'Идиот', 'Достоевский Ф.М.', 360.80, 3);

INSERT INTO book(title, author, price, amount)
SELECT title, author, price, amount
FROM supply
WHERE author NOT IN ('Булгаков М.А.', 'Достоевский Ф.М.');

DELETE
FROM book
WHERE book_id > 8;

INSERT INTO book(title, author, price, amount)
SELECT title, author, price, amount
FROM supply
WHERE author NOT IN (SELECT author FROM book);

UPDATE book
SET price = price * 0.9
WHERE amount BETWEEN 5 AND 10;

ALTER TABLE book
    ADD buy INT;

UPDATE book
SET buy = amount
WHERE buy > amount;
UPDATE book
SET price = price * 0.9
WHERE buy = 0;

UPDATE book, supply
SET book.amount = book.amount + supply.amount,
    book.price  = (book.price + supply.price) / 2
WHERE book.author = supply.author
  AND book.title = supply.title;

DELETE
FROM supply
WHERE author IN (SELECT author FROM book GROUP BY author HAVING SUM(book.amount) > 10);

CREATE TABLE ordering AS
    (SELECT author, title, (SELECT AVG(amount) FROM book) AS amount
     FROM book
     WHERE amount < (SELECT AVG(amount) FROM book));


