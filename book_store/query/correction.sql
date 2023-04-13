USE book_storage;

# Включить нового человека в таблицу с клиентами. Его имя Попов Илья, его email
# popov@test, проживает он в Москве.
INSERT INTO client(name_client, city_id, email)
SELECT 'Попов Илья', city_id, 'popov@test'
FROM city
WHERE name_city = 'Москва';

SELECT *
FROM client;


# Создать новый заказ для Попова Ильи. Его комментарий для заказа:
# «Связаться со мной по вопросу доставки».
INSERT INTO buy(client_id, buy_description)
SELECT client_id, 'Связаться со мной по вопросу доставки'
FROM client
WHERE name_client = 'Попов Илья';


# В таблицу buy_book добавить заказ с номером 5. Этот заказ должен содержать книгу Пастернака
# «Лирика» в количестве двух экземпляров и книгу Булгакова «Белая гвардия» в одном экземпляре.
INSERT INTO buy_book(buy_id, book_id, amount)
SELECT 5, b.book_id, 2
FROM book b
         JOIN author a on a.author_id = b.author_id
WHERE title = 'Лирика'
  AND a.name_author = 'Пастернак Б.Л.';

INSERT INTO buy_book(buy_id, book_id, amount)
SELECT 5, b.book_id, 1
FROM book b
         JOIN author a on a.author_id = b.author_id
WHERE title = 'Белая гвардия'
  AND a.name_author = 'Булгаков М.А.';


# Количество тех книг на складе, которые были включены в заказ с номером 5,
# уменьшить на то количество, которое в заказе с номером 5  указано.
UPDATE book b, buy_book bb
SET b.amount = b.amount - bb.amount
WHERE b.book_id = bb.book_id
  AND bb.buy_id = 5;


# Создать счет (таблицу buy_pay) на оплату заказа с номером 5, в который включить
# название книг, их автора, цену, количество заказанных книг и  стоимость.
# Последний столбец назвать Стоимость. Информацию в таблицу занести в отсортированном
# по названиям книг виде.
CREATE TABLE buy_pay AS
SELECT title, name_author, price, bb.amount, price * bb.amount AS Стоимость
FROM book
         JOIN author a on book.author_id = a.author_id
         JOIN buy_book bb on book.book_id = bb.book_id
         JOIN buy b on b.buy_id = bb.buy_id
WHERE b.buy_id = 5
ORDER BY title;


# Создать общий счет (таблицу buy_pay) на оплату заказа с номером 5. Куда включить номер заказа,
# количество книг в заказе (название столбца Количество) и его общую стоимость
# (название столбца Итого). Для решения используйте ОДИН запрос.
DROP TABLE IF EXISTS buy_pay;

CREATE TABLE buy_pay AS
SELECT b.buy_id, SUM(bb.amount) AS Количество, SUM(price * bb.amount) AS Итого
FROM book
         JOIN buy_book bb on book.book_id = bb.book_id
         JOIN buy b on b.buy_id = bb.buy_id
WHERE b.buy_id = 5
GROUP BY b.buy_id
ORDER BY b.buy_id;


# В таблицу buy_step для заказа с номером 5 включить все этапы из таблицы step, которые
# должен пройти этот заказ. В столбцы date_step_beg и date_step_end всех записей занести Null.
INSERT INTO buy_step(buy_id, step_id, date_step_beg, date_step_end)
SELECT 5, step.step_id, null, null
FROM step,
     buy_step
GROUP BY step.step_id
ORDER BY step.step_id;


# В таблицу buy_step занести дату 12.04.2020 выставления счета на оплату заказа с номером 5.
# Правильнее было бы занести не конкретную, а текущую дату. Это можно сделать с помощью
# функции Now(). Но при этом в разные дни будут вставляться разная дата, и задание
# нельзя будет проверить, поэтому  вставим дату 12.04.2020.
UPDATE buy_step
SET date_step_beg = '2020-04-12'
WHERE buy_id = 5
  AND step_id = 1;


# Завершить этап «Оплата» для заказа с номером 5, вставив в столбец date_step_end дату
# 13.04.2020, и начать следующий этап («Упаковка»), задав в столбце date_step_beg для
# этого этапа ту же дату.
# Реализовать два запроса для завершения этапа и начала следующего. Они должны быть
# записаны в общем виде, чтобы его можно было применять для любых этапов, изменив
# только текущий этап. Для примера пусть это будет этап «Оплата».
UPDATE buy_step
SET date_step_end = IF(step_id = (SELECT step_id
                                  FROM step
                                  WHERE name_step = 'Оплата'),
                       '2020-04-13',
                       date_step_end
    ),
    date_step_beg = IF(step_id = (SELECT step_id
                                  FROM step
                                  WHERE name_step = 'Упаковка'),
                       '2020-04-13',
                       date_step_beg
        )
WHERE buy_id = 5;





