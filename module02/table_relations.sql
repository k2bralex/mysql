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

SELECT name_city, name_author, (DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND() * 365) DAY)) AS Дата
FROM city,
     author
ORDER BY name_city, 3 DESC;


# Вывести информацию о книгах (жанр, книга, автор), относящихся к жанру, включающему слово
# «роман» в отсортированном по названиям книг виде.
SELECT name_genre, title, name_author
FROM book b
         INNER JOIN author a on a.author_id = b.author_id
         INNER JOIN genre g on b.genre_id = g.genre_id
WHERE g.name_genre LIKE '%роман%'
ORDER BY title;


#Посчитать количество экземпляров  книг каждого автора из таблицы author.  Вывести тех авторов,
#количество книг которых меньше 10, в отсортированном по возрастанию количества виде.
#Последний столбец назвать Количество.
SELECT name_author, SUM(amount) AS Количество
FROM author a
         LEFT JOIN book b on a.author_id = b.author_id
GROUP BY name_author
HAVING Количество < 10
    OR Количество IS NULL
ORDER BY Количество;


#Вывести в алфавитном порядке всех авторов, которые пишут только в одном жанре.
# Поскольку у нас в таблицах так занесены данные, что у каждого автора книги только в одном жанре,
# для этого запроса внесем изменения в таблицу book. Пусть у нас  книга Есенина «Черный человек»
# относится к жанру «Роман», а книга Булгакова «Белая гвардия» к «Приключениям» (эти изменения в
# таблицы уже внесены).
SELECT a.name_author
FROM author a
         JOIN book b ON a.author_id = b.author_id
         JOIN genre g on b.genre_id = g.genre_id
GROUP BY a.name_author
HAVING COUNT(DISTINCT g.name_genre) = 1;

INSERT INTO book(title, author_id, genre_id, price, amount)
VALUES ('Герой нашего времени', 5, 3, 570.59, 2),
       ('Доктор Живаго', 4, 3, 740.50, 5);


#Вывести информацию о книгах (название книги, фамилию и инициалы автора, название жанра, цену
#и количество экземпляров книги), написанных в самых популярных жанрах, в отсортированном в
#алфавитном порядке по названию книг виде. Самым популярным считать жанр, общее количество
#экземпляров книг которого на складе максимально.
SELECT title, name_author, name_genre, price, amount
FROM book b
         INNER JOIN genre g on b.genre_id = g.genre_id
         INNER JOIN author a on a.author_id = b.author_id
GROUP BY title, name_author, name_genre, price, amount, g.genre_id
HAVING g.genre_id IN (SELECT q1.genre_id
                      FROM (SELECT genre_id, SUM(amount) AS popular
                            FROM book b
                            GROUP BY genre_id) q1
                               INNER JOIN
                           (SELECT genre_id, SUM(amount) AS popular
                            FROM book b
                            GROUP BY genre_id
                            ORDER BY popular DESC
                            LIMIT 1) q2
                           ON q1.popular = q2.popular)
ORDER BY title;


#Если в таблицах supply  и book есть одинаковые книги,  вывести их название и автора.
#При этом учесть, что у нескольких авторов могут быть книги с одинаковым названием.
SELECT b.title, name_author
FROM book b
         JOIN author a USING (author_id)
         JOIN supply s ON b.title = s.title
    AND a.name_author = s.author;


#Если в таблицах supply  и book есть одинаковые книги, которые имеют равную цену,
# вывести их название и автора, а также посчитать общее количество экземпляров книг в
# таблицах supply и book,  столбцы назвать Название, Автор  и Количество.
SELECT b.title                       AS Название,
       a.name_author                 AS Автор,
       SUM(b.amount) + SUM(s.amount) AS Количество
FROM book b
         JOIN author a USING (author_id)
         JOIN supply s on b.price = s.price AND b.title = s.title
GROUP BY b.title, a.name_author;