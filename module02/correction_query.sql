DROP TABLE IF EXISTS `author`;
CREATE TABLE author (
      author_id INT PRIMARY KEY AUTO_INCREMENT,
      name_author VARCHAR(50)
      )ENGINE='InnoDB' AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
insert into author (name_author) value
('Булгаков М.А.'),
('Достоевский Ф.М.'),
('Есенин С.А.'),
('Пастернак Б.Л.'),
('Лермонтов М.Ю.');

DROP TABLE IF EXISTS `genre`;
CREATE TABLE genre (
      genre_id INT PRIMARY KEY AUTO_INCREMENT,
      name_genre VARCHAR(50)
      )ENGINE='InnoDB' AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
insert into genre (name_genre) value
('Роман'),
('Поэзия'),
('Приключения');
DROP TABLE IF EXISTS book;
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8,2),
    amount INT,
    FOREIGN KEY (author_id) REFERENCES author (author_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id) ON DELETE SET NULL
);


INSERT INTO book (title, author_id, genre_id, price, amount) VALUES
    ('Мастер и Маргарита', 1, 1, 670.99,3),
    ('Белая гвардия',1,1,540.50,12),
    ('Идиот',2,1,460.00,13),
    ('Братья Карамазовы',2,1,799.01,3),
    ('Игрок',2,1,480.50,10),
    ('Стихотворения и поэмы',3,2,650.00,15),
    ('Черный человек',3,2,570.20,12),
    ('Лирика',4,2,518.99,2)