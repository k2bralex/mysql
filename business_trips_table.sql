USE stepik;

CREATE TABLE trip
(
    trip_id    INT PRIMARY KEY AUTO_INCREMENT,
    name       VARCHAR(30),
    city       VARCHAR(25),
    per_diem   DECIMAL(8, 2),
    date_first DATE,
    date_last  DATE
);

INSERT INTO trip(name, city, per_diem, date_first, date_last)
VALUES ('Баранов П.Е.', 'Москва', '700', '2020-01-12', '2020-01-17'),
       ('Абрамова К.А.', 'Владивосток', '450', '2020-01-14', '2020-01-27'),
       ('Семенов И.В.', 'Москва', '700', '2020-01-23', '2020-01-31'),
       ('Ильиных Г.Р.', 'Владивосток', '450', '2020-01-12', '2020-02-02'),
       ('Колесов С.П.', 'Москва', '700', '2020-02-01', '2020-02-06'),
       ('Баранов П.Е.', 'Москва', '700', '2020-02-14', '2020-02-22'),
       ('Абрамова К.А.', 'Москва', '700', '2020-02-23', '2020-03-01'),
       ('Лебедев Т.К.', 'Москва', '700', '2020-03-03', '2020-03-06'),
       ('Колесов С.П.', 'Новосибирск', '450', '2020-02-27', '2020-03-12'),
       ('Семенов И.В.', 'Санкт-Петербург', '700', '2020-03-29', '2020-04-05'),
       ('Абрамова К.А.', 'Москва', '700', '2020-04-06', '2020-04-14'),
       ('Баранов П.Е.', 'Новосибирск', '450', '2020-04-18', '2020-05-04'),
       ('Лебедев Т.К.', 'Томск', '450', '2020-05-20', '2020-05-31'),
       ('Семенов И.В.', 'Санкт-Петербург', '700', '2020-06-01', '2020-06-03'),
       ('Абрамова К.А.', 'Санкт-Петербург', '700', '2020-05-28', '2020-06-04'),
       ('Федорова А.Ю.', 'Новосибирск', '450', '2020-05-25', '2020-06-04'),
       ('Колесов С.П.', 'Новосибирск', '450', '2020-06-03', '2020-06-12'),
       ('Федорова А.Ю.', 'Томск', '450', '2020-06-20', '2020-06-26'),
       ('Абрамова К.А.', 'Владивосток', '450', '2020-07-02', '2020-07-13'),
       ('Баранов П.Е.', 'Воронеж', '450', '2020-07-19', '2020-07-25');

SELECT name, city, per_diem, date_first, date_last
FROM trip
WHERE name LIKE '_%а _._.'
ORDER BY date_last DESC;

SELECT DISTINCT name
FROM trip
WHERE city = 'Москва'
ORDER BY name;

SELECT city, COUNT(name) AS Количество
FROM trip
GROUP BY city
ORDER BY city;

SELECT city, COUNT(name) AS Количество
FROM trip
GROUP BY city
ORDER BY Количество DESC
LIMIT 2;

SELECT name, city, DATEDIFF(date_last, date_first) + 1 AS Длительность
FROM trip
WHERE city NOT IN ('Москва', 'Санкт-Петербург')
ORDER BY Длительность DESC, city DESC;

SELECT name, city, date_first, date_last
FROM trip
WHERE DATEDIFF(date_last, date_first) = (SELECT MIN(DATEDIFF(date_last, date_first))
                                         FROM trip);

SELECT MIN(DATEDIFF(date_last, date_first))
FROM trip
GROUP BY name;

SELECT name, city, date_first, date_last
FROM trip
WHERE MONTH(date_first) = MONTH(date_last)
ORDER BY city, name;

SELECT MONTHNAME(date_first) AS Месяц,
       COUNT(date_first) AS Количество
FROM trip
GROUP BY MONTHNAME(date_first)
ORDER BY Количество DESC, Месяц;

SELECT name, city, date_first,
       per_diem * (DATEDIFF(date_last, date_first) + 1) AS Сумма
FROM trip
WHERE MONTH(date_first) IN (2,3)
ORDER BY name, Сумма DESC;

SELECT name, SUM(per_diem * (DATEDIFF(date_last, date_first) + 1)) AS Сумма
FROM trip
WHERE name IN (SELECT name FROM trip GROUP BY name HAVING COUNT(name)> 3)
GROUP BY name
ORDER BY Сумма DESC;




