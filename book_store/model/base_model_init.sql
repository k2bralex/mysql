DROP DATABASE IF EXISTS book_storage;

CREATE DATABASE book_storage;

USE book_storage;

CREATE TABLE author
(
    author_id   INT PRIMARY KEY AUTO_INCREMENT,
    name_author VARCHAR(30)
);

CREATE TABLE genre
(
    genre_id   INT PRIMARY KEY AUTO_INCREMENT,
    name_genre VARCHAR(20)
);

CREATE TABLE book
(
    book_id   INT PRIMARY KEY AUTO_INCREMENT,
    title     VARCHAR(50),
    author_id INT,
    FOREIGN KEY (author_id) REFERENCES author (author_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    genre_id  INT,
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    price     DECIMAL(8, 2),
    amount    INT
);

CREATE TABLE city
(
    city_id       INT PRIMARY KEY AUTO_INCREMENT,
    name_city     VARCHAR(30),
    days_delivery INT
);

CREATE TABLE client
(
    client_id   INT PRIMARY KEY AUTO_INCREMENT,
    name_client VARCHAR(30),
    city_id     INT,
    FOREIGN KEY (city_id) REFERENCES city (city_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    email       VARCHAR(30)
);

CREATE TABLE buy
(
    buy_id          INT PRIMARY KEY AUTO_INCREMENT,
    buy_description VARCHAR(100),
    client_id       INT,
    FOREIGN KEY (client_id) REFERENCES client (client_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE buy_book
(
    buy_book_id INT PRIMARY KEY AUTO_INCREMENT,
    buy_id      INT,
    FOREIGN KEY (buy_id) REFERENCES buy (buy_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    book_id     INT,
    FOREIGN KEY (book_id) REFERENCES book (book_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    amount      INT
);

CREATE TABLE step
(
    step_id   INT PRIMARY KEY AUTO_INCREMENT,
    name_step VARCHAR(30)
);

CREATE TABLE buy_step
(
    buy_step_id   INT PRIMARY KEY AUTO_INCREMENT,
    buy_id        INT,
    FOREIGN KEY (buy_id) REFERENCES buy (buy_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    step_id       INT,
    FOREIGN KEY (step_id) REFERENCES step (step_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    date_step_beg DATE,
    date_step_end DATE
);

DROP TABLE IF EXISTS buy_archive;

CREATE TABLE buy_archive
(
    buy_archive_id INT PRIMARY KEY AUTO_INCREMENT,
    buy_id         INT,
    client_id      INT,
    book_id        INT,
    date_payment   DATE,
    price          DECIMAL(8, 2),
    amount         INT
);