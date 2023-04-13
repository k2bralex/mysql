USE book_storage;

# Вывести фамилии всех клиентов, которые заказали книгу Булгакова «Мастер и Маргарита».
SELECT c.name_client
FROM client c
         JOIN buy b on c.client_id = b.client_id
         JOIN buy_book bb on b.buy_id = bb.buy_id
         JOIN book b2 on b2.book_id = bb.book_id
         JOIN author a on a.author_id = b2.author_id
WHERE b2.title = 'Мастер и Маргарита'
  AND a.name_author = 'Булгаков М.А.';


# Вывести все заказы Баранова Павла (id заказа, какие книги, по какой цене и в каком количестве
# он заказал) в отсортированном по номеру заказа и названиям книг виде.
SELECT bb.buy_id, bk.title, bk.price, bb.amount
FROM buy b
         JOIN buy_book bb on b.buy_id = bb.buy_id
         JOIN book bk on bb.book_id = bk.book_id
         JOIN client c on c.client_id = b.client_id
WHERE c.name_client = 'Баранов Павел'
ORDER BY bb.buy_id, bk.title;


# Посчитать, сколько раз была заказана каждая книга, для книги вывести ее автора
# (нужно посчитать, в каком количестве заказов фигурирует каждая книга).  Вывести
# фамилию и инициалы автора, название книги, последний столбец назвать Количество.
# Результат отсортировать сначала  по фамилиям авторов, а потом по названиям книг.
SELECT a.name_author, b.title, COALESCE(COUNT(bb.buy_book_id), 0) AS Количество
FROM book b
         LEFT JOIN buy_book bb on b.book_id = bb.book_id
         JOIN author a on b.author_id = a.author_id
GROUP BY a.name_author, b.title
ORDER BY a.name_author, b.title;


# Вывести города, в которых живут клиенты, оформлявшие заказы в интернет-магазине.
# Указать количество заказов в каждый город, этот столбец назвать Количество. Информацию
# вывести по убыванию количества заказов, а затем в алфавитном порядке по названию городов.
SELECT ct.name_city, COALESCE(COUNT(b.buy_id), 0) AS Количество
FROM city ct
         LEFT JOIN client c on ct.city_id = c.city_id
         JOIN buy b on c.client_id = b.client_id
GROUP BY ct.name_city
ORDER BY Количество DESC, ct.name_city;


# Вывести номера всех оплаченных заказов и даты, когда они были оплачены.
SELECT buy_id, date_step_end
FROM buy_step
WHERE step_id = 1
  AND date_step_end IS NOT NULL;


# Вывести информацию о каждом заказе: его номер, кто его сформировал (фамилия пользователя)
# и его стоимость (сумма произведений количества заказанных книг и их цены), в
# отсортированном по номеру заказа виде. Последний столбец назвать Стоимость.
SELECT bb.buy_id, c.name_client, SUM(bk.price * bb.amount) AS Стоимость
FROM buy_book bb
         JOIN book bk on bb.book_id = bk.book_id
         JOIN buy b on bb.buy_id = b.buy_id
         JOIN client c on c.client_id = b.client_id
GROUP BY bb.buy_id, c.name_client
ORDER BY bb.buy_id;


# Вывести номера заказов (buy_id) и названия этапов,  на которых они в данный момент
# находятся. Если заказ доставлен –  информацию о нем не выводить. Информацию отсортировать
# по возрастанию buy_id.
SELECT bs.buy_id, s.name_step
FROM buy_step bs
         JOIN step s on s.step_id = bs.step_id
WHERE date_step_beg IS NOT NULL
  AND date_step_end IS NULL
ORDER BY bs.buy_id;


# В таблице city для каждого города указано количество дней, за которые заказ может быть
# доставлен в этот город (рассматривается только этап Транспортировка). Для тех заказов,
# которые прошли этап транспортировки, вывести количество дней за которое заказ реально
# доставлен в город. А также, если заказ доставлен с опозданием, указать количество
# дней задержки, в противном случае вывести 0. В результат включить номер заказа (buy_id),
# а также вычисляемые столбцы Количество_дней и Опоздание. Информацию вывести в
# отсортированном по номеру заказа виде.
SELECT bs.buy_id,
       DATEDIFF(bs.date_step_end, bs.date_step_beg) AS Количество_дней,
       IF(DATEDIFF(bs.date_step_end, bs.date_step_beg) > ct.days_delivery,
          DATEDIFF(bs.date_step_end, bs.date_step_beg) - ct.days_delivery,
          0)                                        AS Опоздание
FROM buy_step bs
         JOIN buy b on bs.buy_id = b.buy_id
         JOIN client c on c.client_id = b.client_id
         JOIN city ct on ct.city_id = c.city_id
WHERE step_id = 3
  AND bs.date_step_end IS NOT NULL
ORDER BY bs.buy_id;


# Выбрать всех клиентов, которые заказывали книги Достоевского, информацию вывести в
# отсортированном по алфавиту виде. В решении используйте фамилию автора, а не его id.
SELECT c.name_client
FROM author a
         JOIN book b on a.author_id = b.author_id
         JOIN buy_book bb on b.book_id = bb.book_id
         JOIN buy b2 on b2.buy_id = bb.buy_id
         JOIN client c on c.client_id = b2.client_id
WHERE a.name_author = 'Достоевский Ф.М.'
GROUP BY c.name_client
ORDER BY c.name_client;


# Вывести жанр (или жанры), в котором было заказано больше всего экземпляров книг,
# указать это количество. Последний столбец назвать Количество.
SELECT g.name_genre, SUM(bb.amount) AS Количество
FROM buy_book bb
         JOIN book b on b.book_id = bb.book_id
         JOIN genre g on g.genre_id = b.genre_id
GROUP BY g.name_genre
HAVING Количество = (SELECT MAX(sum_amount) AS max_sum_amount
                     FROM (SELECT SUM(b2.amount) as sum_amount
                           FROM buy_book b2
                                    JOIN book b3 on b2.book_id = b3.book_id
                                    JOIN genre g2 on g2.genre_id = b3.genre_id
                           GROUP BY g2.name_genre) AS q1);
