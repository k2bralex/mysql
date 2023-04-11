USE stepik;

CREATE TABLE traffic_violation
(
    violation_id INT PRIMARY KEY AUTO_INCREMENT,
    violation    VARCHAR(50),
    sum_fine     DECIMAL(8, 2)
);

INSERT INTO traffic_violation(violation, sum_fine)
VALUES ('Превышение скорости(от 40 до 60)', 1000.00),
       ('Превышение скорости(от 20 до 40)', 500.00),
       ('Проезд на запрещающий сигнал', 1000.00);

CREATE TABLE payment
(
    payment_id     INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    name           VARCHAR(30),
    number_plate   VARCHAR(6),
    violation      VARCHAR(50),
    date_violation DATE,
    date_payment   DATE
);

INSERT INTO payment(name, number_plate, violation, date_violation, date_payment)
VALUES ('Яковлев Г.Р.', 'Т330ТТ', 'Превышение скорости(от 20 до 40)', '2020-01-12', '2020-01-22'),
       ('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', '2020-02-14', '2020-03-06'),
       ('Яковлев Г.Р.', 'Т330ТТ', 'Проезд на запрещающий сигнал', '2020-03-03', '2020-03-23');

CREATE TABLE fine
(
    fine_id        INT PRIMARY KEY AUTO_INCREMENT,
    name           VARCHAR(30),
    number_plate   VARCHAR(6),
    violation      VARCHAR(50),
    sum_fine       DECIMAL(8, 2),
    date_violation DATE,
    date_payment   DATE
);

INSERT INTO fine(name, number_plate, violation, sum_fine, date_violation, date_payment)
VALUES ('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', 500.00, '2020-01-12', '2020-01-17'),
       ('Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', 1000.00, '2020-01-14', '2020-02-27'),
       ('Яковлев Г.Р.', 'Т330ТТ', 'Превышение скорости(от 20 до 40)', 500.00, '2020-01-23', '2020-02-23'),
       ('Яковлев Г.Р.', 'М701АА', 'Превышение скорости(от 20 до 40)', null, '2020-01-12', null),
       ('Колесов С.П.', 'К892АХ', 'Превышение скорости(от 20 до 40)', null, '2020-02-01', null);

INSERT INTO fine(name, number_plate, violation, sum_fine, date_violation, date_payment)
VALUES ('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', null, '2020-02-14', null),
       ('Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', null, '2020-02-23', null),
       ('Яковлев Г.Р.', 'Т330ТТ', 'Проезд на запрещающий сигнал', null, '2020-03-03', null);

/*DROP TABLE fine;*/

UPDATE fine AS f, traffic_violation AS tv
SET f.sum_fine = tv.sum_fine
WHERE f.violation = tv.violation
  AND f.sum_fine IS NULL;

#Вывести фамилию, номер машины и нарушение только для тех водителей, которые на одной машине нарушили
# одно и то же правило   два и более раз. При этом учитывать все нарушения, независимо от того оплачены
# они или нет. Информацию отсортировать в алфавитном порядке, сначала по фамилии водителя, потом по
# номеру машины и, наконец, по нарушению.
SELECT name, number_plate, violation
FROM fine
GROUP BY name, number_plate, violation
HAVING COUNT(*) >= 2
ORDER BY name, number_plate, violation;


# в таблице fine увеличить в два раза сумму неоплаченных штрафов для отобранных на предыдущем шаге записей.
UPDATE fine AS f, (SELECT name, number_plate, violation
                   FROM fine
                   GROUP BY name, number_plate, violation
                   HAVING COUNT(*) >= 2) qi
SET f.sum_fine = f.sum_fine * 2
WHERE f.name = qi.name
  AND f.number_plate = qi.number_plate
  AND f.violation = qi.violation
  AND f.date_payment IS NULL;


# в таблицу fine занести дату оплаты соответствующего штрафа из таблицы payment;
# уменьшить начисленный штраф в таблице fine в два раза  (только для тех штрафов, информация о которых
# занесена в таблицу payment) , если оплата произведена не позднее 20 дней со дня нарушения.
UPDATE fine AS f, payment AS p
SET f.date_payment = p.date_payment,
    f.sum_fine     = IF(DATEDIFF(p.date_payment, f.date_violation) <= 20, f.sum_fine / 2, f.sum_fine)
WHERE f.name = p.name
  AND f.number_plate = p.number_plate
  AND f.violation = p.violation
  AND f.date_payment IS NULL;

#Создать новую таблицу back_payment, куда внести информацию о неоплаченных штрафах
# (Фамилию и инициалы водителя, номер машины, нарушение, сумму штрафа  и  дату нарушения) из таблицы fine.
CREATE TABLE back_payment AS
SELECT name, number_plate, violation, sum_fine, date_violation
FROM fine
WHERE date_payment IS NULL;

#Удалить из таблицы fine информацию о нарушениях, совершенных раньше 1 февраля 2020 года.
DELETE FROM fine
WHERE date_violation < '2020-02-01';
