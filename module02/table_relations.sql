USE stepik;

CREATE TABLE author
(
    author_id   INT PRIMARY KEY AUTO_INCREMENT,
    name_author VARCHAR(50)
);

INSERT INTO author(name_author)
VALUES ('Булгаков М.А.'),
       ('Достоевский Ф.М.'),
       ('Есенин С.А.'),
       ('Пастернак Б.Л.'),
       ('Лермонтов М.Ю.');

CREATE TABLE genre
(
    genre_id   INT PRIMARY KEY AUTO_INCREMENT,
    name_genre VARCHAR(30)
);

INSERT INTO genre(name_genre)
VALUES ('Роман'),
       ('Поэзия'),
       ('Приключения');

CREATE TABLE book
(
    book_id   INT PRIMARY KEY AUTO_INCREMENT,
    title     VARCHAR(50),
    price     DECIMAL(8, 2),
    amount    INT,
    author_id INT NOT NULL,
    genre_id  INT,
    FOREIGN KEY (author_id) REFERENCES author (author_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id) ON DELETE SET NULL
);

INSERT INTO book(title, author_id, genre_id, price, amount)
VALUES ('Мастер и Маргарита', 1, 1, 670.99, 3),
       ('Белая гвардия', 1, 1, 540.50, 5),
       ('Идиот', 2, 1, 460.00, 10),
       ('Братья Карамазовы', 2, 1, 799.01, 3),
       ('Игрок', 2, 1, 480.50, 10),
       ('Стихотворения и поэмы', 3, 2, 650.00, 15),
       ('Черный человек', 3, 2, 570.20, 6),
       ('Лирика', 4, 2, 518.99, 2);

SELECT title, name_genre, price
FROM genre g
         JOIN book b on g.genre_id = b.genre_id
WHERE b.amount > 8
ORDER BY price DESC;

SELECT name_genre
FROM genre g
         LEFT JOIN book b on g.genre_id = b.genre_id
WHERE b.title IS NULL;

CREATE TABLE city
(
    city_id   INT PRIMARY KEY AUTO_INCREMENT,
    name_city VARCHAR(25)
);

INSERT INTO city(name_city)
VALUES ('Москва'),
       ('Санкт-Петербург'),
       ('Владивосток');

SELECT name_city, name_author, (DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND()*365) DAY)) AS Дата
FROM city, author
ORDER BY name_city, 3 DESC;

SELECT name_genre, title, name_author
FROM book b
    INNER JOIN author a on a.author_id = b.author_id
    INNER JOIN genre g on b.genre_id = g.genre_id
WHERE g.name_genre LIKE '%роман%'
ORDER BY title;


