USE stepik;

DROP TABLE IF EXISTS book CASCADE;
DROP TABLE IF EXISTS `author` CASCADE;
DROP TABLE IF EXISTS `genre` CASCADE;

CREATE TABLE author
(
    author_id   INT PRIMARY KEY AUTO_INCREMENT,
    name_author VARCHAR(50)
);


INSERT INTO author (name_author) VALUE
    ('Булгаков М.А.'),
    ('Достоевский Ф.М.'),
    ('Есенин С.А.'),
    ('Пастернак Б.Л.'),
    ('Лермонтов М.Ю.');

CREATE TABLE genre
(
    genre_id   INT PRIMARY KEY AUTO_INCREMENT,
    name_genre VARCHAR(50)
);

INSERT INTO genre (name_genre) VALUE
    ('Роман'),
    ('Поэзия'),
    ('Приключения');

CREATE TABLE book
(
    book_id   INT PRIMARY KEY AUTO_INCREMENT,
    title     VARCHAR(50),
    author_id INT NOT NULL,
    genre_id  INT,
    price     DECIMAL(8, 2),
    amount    INT,
    FOREIGN KEY (author_id) REFERENCES author (author_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id) ON DELETE SET NULL
);

INSERT INTO book (title, author_id, genre_id, price, amount)
VALUES ('Мастер и Маргарита', 1, 1, 670.99, 3),
       ('Белая гвардия', 1, 1, 540.50, 12),
       ('Идиот', 2, 1, 460.00, 13),
       ('Братья Карамазовы', 2, 1, 799.01, 3),
       ('Игрок', 2, 1, 480.50, 10),
       ('Стихотворения и поэмы', 3, 2, 650.00, 15),
       ('Черный человек', 3, 2, 570.20, 12),
       ('Лирика', 4, 2, 518.99, 2);


# Для книг, которые уже есть на складе (в таблице book), но по другой цене, чем в поставке
# (supply), необходимо в таблице book увеличить количество на значение, указанное в поставке,
# и пересчитать цену. А в таблице  supply обнулить количество этих книг

UPDATE book b
    JOIN author a on a.author_id = b.author_id
    JOIN supply s on b.title = s.title AND a.name_author = s.author
SET b.amount = b.amount + s.amount,
    s.amount = 0,
    b.price  = (b.price * b.amount + s.price * s.amount) / (b.amount + s.amount)
WHERE b.price <> s.price;


# Включить новых авторов в таблицу author с помощью запроса на добавление, а затем вывести
# все данные из таблицы author.  Новыми считаются авторы, которые есть в таблице supply,
# но нет в таблице author.
INSERT INTO author(name_author)
SELECT s.author
FROM supply s
         LEFT JOIN author a ON s.author = a.name_author
WHERE a.name_author IS NULL;


# Добавить новые книги из таблицы supply в таблицу book на основе сформированного выше запроса.
# Затем вывести для просмотра таблицу book.
INSERT INTO book(title, author_id, price, amount)
SELECT s.title, a.author_id, s.price, s.amount
FROM author a
         INNER JOIN supply s ON a.name_author = s.author
WHERE s.amount <> 0;


# Занести для книги «Стихотворения и поэмы» Лермонтова жанр «Поэзия»,
# а для книги «Остров сокровищ» Стивенсона - «Приключения». (Использовать два запроса).
UPDATE book b
    JOIN author a on b.author_id = a.author_id
SET b.genre_id = (SELECT genre_id FROM genre WHERE name_genre = 'Поэзия')
WHERE b.title = 'Стихотворения и поэмы'
  AND a.name_author = 'Лермонтов М.Ю.';

UPDATE book b
    JOIN author a on b.author_id = a.author_id
SET b.genre_id = (SELECT genre_id FROM genre WHERE name_genre = 'Приключения')
WHERE b.title = 'Остров сокровищ'
  AND a.name_author = 'Стивенсон Р.Л.';


# Удалить из таблицы author всех авторов, фамилия которых начинается на «Д»,
# а из таблицы book все книги этих авторов.
DELETE
FROM author
WHERE name_author LIKE 'Д%';


# Удалить всех авторов и все их книги, общее количество книг которых меньше 20.
DELETE
FROM author
WHERE author_id IN (SELECT author_id
                    FROM book
                    GROUP BY author_id
                    HAVING SUM(amount) < 20);


# Удалить все жанры, к которым относится меньше 4-х книг.
# В таблице book для этих жанров установить значение Null.
DELETE
FROM genre
WHERE genre_id IN (SELECT genre_id
                   FROM book
                   GROUP BY genre_id
                   HAVING COUNT(DISTINCT book_id) < 4);


# Удалить всех авторов, которые пишут в жанре "Поэзия". Из таблицы book удалить все книги этих авторов.
# В запросе для отбора авторов использовать полное название жанра, а не его id.
DELETE
FROM author
    USING author
              JOIN book b on author.author_id = b.author_id
              JOIN genre g on g.genre_id = b.genre_id
WHERE g.name_genre = 'Поэзия';
