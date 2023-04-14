USE course_analytics;

# Отобрать все шаги, в которых рассматриваются вложенные запросы (то есть в названии шага
# упоминаются вложенные запросы). Указать к какому уроку и модулю они относятся. Для этого
# вывести 3 поля:
#
# в поле Модуль указать номер модуля и его название через пробел;
# в поле Урок указать номер модуля, порядковый номер урока (lesson_position) через точку
# и название урока через пробел;
# в поле Шаг указать номер модуля, порядковый номер урока (lesson_position) через точку,
# порядковый номер шага (step_position) через точку и название шага через пробел.
# Длину полей Модуль и Урок ограничить 19 символами, при этом слишком длинные надписи
# обозначить многоточием в конце (16 символов - это номер модуля или урока, пробел и
# название Урока или Модуля к ним присоединить "..."). Информацию отсортировать по
# возрастанию номеров модулей, порядковых номеров уроков и порядковых номеров шагов.
SELECT CONCAT((LEFT(CONCAT(m.module_id, ' ', module_name), 16)), '...')                             AS Модуль,
       CONCAT((LEFT((CONCAT(m.module_id, '.', l.lesson_position, ' ', l.lesson_name)), 16)), '...') AS Урок,
       CONCAT(m.module_id, '.', l.lesson_position, '.', step_position, ' ', s.step_name)            AS Шаг
FROM module m
         JOIN lesson l on m.module_id = l.module_id
         JOIN step s on l.lesson_id = s.lesson_id
WHERE step_name LIKE '%вложен%запрос%'
ORDER BY Модуль, Урок, Шаг;


# Еще одна возможность улучшить навигацию по курсу - это реализация поиска шагов по
# ключевым словам. Для этого необходимо создать таблицу с терминами keyword, а затем
# связать ее с таблицей step через вспомогательную таблицу step_keyword. Каждая запись
# этой таблицы - это id шага и id встречающегося на этом шаге ключевого слова.
DROP TABLE IF EXISTS step_keyword;

CREATE TABLE step_keyword
AS
SELECT step_id,
       keyword_id
FROM step s,
     keyword k
WHERE REGEXP_INSTR(s.step_name, CONCAT('\\b', k.keyword_name, '\\b'), 1, 1, 0, 'i') <> 0
ORDER BY keyword_id;

SELECT *
FROM step_keyword;


INSERT INTO step_keyword(step_id, keyword_id)
SELECT step_id, keyword_id
FROM step s,
     keyword k
WHERE REGEXP_INSTR(s.step_name, CONCAT('\\b', k.keyword_name, '\\b'), 1, 1, 0, 'i') <> 0
ORDER BY keyword_id;


# Реализовать поиск по ключевым словам. Вывести шаги, с которыми связаны ключевые слова
# MAX и AVG одновременно. Для шагов указать id модуля, позицию урока в модуле, позицию
# шага в уроке через точку, после позиции шага перед заголовком - пробел. Позицию шага
# в уроке вывести в виде двух цифр (если позиция шага меньше 10, то перед цифрой поставить 0).
# Столбец назвать Шаг. Информацию отсортировать по первому столбцу в алфавитном порядке.
SELECT CONCAT(m.module_id, '.',
              lesson_position, '.',
              LPAD(step_position, 2, '0'),
              ' ', step_name) AS Шаг
FROM step_keyword sk
         JOIN step s on sk.step_id = s.step_id
         JOIN lesson l on l.lesson_id = s.lesson_id
         JOIN module m on m.module_id = l.module_id
         JOIN keyword k on sk.keyword_id = k.keyword_id
WHERE sk.keyword_id IN (SELECT keyword_id
                        FROM keyword
                        WHERE k.keyword_name IN ('MAX', 'AVG'))
GROUP BY Шаг
HAVING COUNT(sk.keyword_id) = 2
ORDER BY Шаг;


# Посчитать, сколько студентов относится к каждой группе. Столбцы назвать Группа, Интервал,
# Количество. Указать границы интервала.
SELECT CASE
           WHEN rate <= 10 THEN 'I'
           WHEN rate <= 15 THEN 'II'
           WHEN rate <= 27 THEN 'III'
           ELSE 'IV'
           END                      AS Группа,
       CASE
           WHEN rate <= 10 THEN 'от 0 до 10'
           WHEN rate <= 15 THEN 'от 11 до 15'
           WHEN rate <= 27 THEN 'от 16 до 27'
           ELSE 'больше 27'
           END                      AS Интервал,
       COUNT(DISTINCT student_name) AS Количество
FROM (SELECT student_name, count(*) as rate
      FROM (SELECT student_name, step_id
            FROM student
                     INNER JOIN step_student USING (student_id)
            WHERE result = 'correct'
            GROUP BY student_name, step_id) query_in
      GROUP BY student_name
      ORDER BY 2) query_in_1
GROUP BY Группа, Интервал
ORDER BY Группа;


# Исправить запрос примера так: для шагов, которые  не имеют неверных ответов,  указать 100
# как процент успешных попыток, если же шаг не имеет верных ответов, указать 0. Информацию
# отсортировать сначала по возрастанию успешности, а затем по названию шага в алфавитном порядке.
WITH get_count_correct (st_n_c, count_correct)
         AS (SELECT step_name, count(*)
             FROM step
                      INNER JOIN step_student USING (step_id)
             WHERE result = 'correct'
             GROUP BY step_name),
     get_count_wrong (st_n_w, count_wrong)
         AS (SELECT step_name, count(*)
             FROM step
                      INNER JOIN step_student USING (step_id)
             WHERE result = 'wrong'
             GROUP BY step_name)
SELECT st_n_c                                                                      AS Шаг,
       COALESCE((ROUND(count_correct / (count_correct + count_wrong) * 100)), 100) AS Успешность
FROM get_count_correct
         LEFT JOIN get_count_wrong ON st_n_c = st_n_w
UNION
SELECT st_n_w                                                                    AS Шаг,
       COALESCE((ROUND(count_correct / (count_correct + count_wrong) * 100)), 0) AS Успешность
FROM get_count_correct
         RIGHT JOIN get_count_wrong ON st_n_c = st_n_w
ORDER BY 2, Шаг;


# Вычислить прогресс пользователей по курсу. Прогресс вычисляется как отношение верно
# пройденных шагов к общему количеству шагов в процентах, округленное до целого. В нашей
# базе данные о решениях занесены не для всех шагов, поэтому общее количество шагов
# определить как количество различных шагов в таблице step_student.
#
# Тем пользователям, которые прошли все шаги (прогресс = 100%) выдать "Сертификат с
# отличием". Тем, у кого прогресс больше или равен 80% - "Сертификат". Для остальных
# записей в столбце Результат задать пустую строку ("").
#
# Информацию отсортировать по убыванию прогресса, затем по имени пользователя в
# алфавитном порядке.
SET @max = (SELECT COUNT(DISTINCT step_id)
            FROM step_student);

SELECT s.student_name,
       ROUND(COUNT(DISTINCT step_id) / @max * 100) AS Прогресс,
       CASE
           WHEN ROUND(COUNT(DISTINCT step_id) / @max * 100) < 80 THEN ''
           WHEN ROUND(COUNT(DISTINCT step_id) / @max * 100) BETWEEN 80 AND 99 THEN 'Сертификат'
           ELSE 'Сертификат с отличием'
           END                                     AS Результат
FROM student s
         LEFT JOIN step_student ss on s.student_id = ss.student_id
WHERE result = 'correct'
GROUP BY s.student_name
ORDER BY 2 DESC, 1;


with table_1 as (select lesson_id, student_id, sum(submission_time - attempt_time) as время
                 from step
                          join step_student
                               using (step_id)
                 where submission_time - attempt_time <= 14400
                 group by lesson_id, student_id),
     table_2 as (select lesson_id, round(avg(время) / 3600, 2) as Среднее_время
                 from table_1
                 group by lesson_id)
select ROW_NUMBER() OVER (order by Среднее_время)                as Номер,
       concat(module_id, '.', lesson_position, ' ', lesson_name) as Урок,
       Среднее_время
from table_2
         join lesson
              using (lesson_id)
order by Среднее_время;



with tb1 as (select module_id as Модуль, student_name as Студент, count(distinct step_id) as Пройдено_шагов
             from student
                      join step_student
                           using (student_id)
                      join step
                           using (step_id)
                      join lesson
                           using (lesson_id)
             where result = 'correct'
             group by module_id, student_name)
select Модуль,
       Студент,
       Пройдено_шагов,
       round((Пройдено_шагов / max(Пройдено_шагов) over (partition by Модуль)) * 100, 1) as Относительный_рейтинг
from tb1
order by Модуль, Относительный_рейтинг desc, Студент;



with raw_table as (select student_id,
                          step_position,
                          lesson_id,
                          submission_time,
                          max(submission_time) over (partition by lesson_id, student_id) as Макс_время_отправки
                   from step_student
                            join step
                                 using (step_id)
                   where student_id in (select student_id
                                        from step_student
                                                 join step
                                                      using (step_id)
                                        where result = 'correct'
                                        group by student_id
                                        having count(distinct lesson_id) = 3)
                     and result = 'correct'),
     filter_table as (select student_id,
                             lesson_id,
                             from_unixtime(Макс_время_отправки) as Макс_время_отправки,
                             ifnull(ceiling((Макс_время_отправки - lag(Макс_время_отправки)
                                                                       over (partition by student_id order by Макс_время_отправки)) /
                                            86400), '-')        as Интервал
                      from raw_table
                      where submission_time = Макс_время_отправки),
     res_table as (select student_name                            as Студент,
                          concat(module_id, '.', lesson_position) as Урок,
                          Макс_время_отправки,
                          Интервал
                   from filter_table
                            join student
                                 using (student_id)
                            join lesson
                                 using (lesson_id))
select *
from res_table
order by Студент, Макс_время_отправки;


with res_tab as(
select student_name as Студент,
    concat(module_id,'.', lesson_position,'.', step_position) as Шаг,
    ROW_NUMBER() over(partition by step_id order by submission_time) as Номер_попытки,
    result as Результат,
        case when submission_time-attempt_time > 3600
             then (select avg(submission_time-attempt_time)
                    from step_student join student
                    on step_student.student_id = student.student_id and student_name='student_59'
                    where submission_time-attempt_time <= 3600)
            else submission_time-attempt_time
        end as timestamp_attempt,
        step_id,
        submission_time

from step_student join student
on step_student.student_id = student.student_id and student_name='student_59' join step
using(step_id) join lesson
using(lesson_id))
select Студент, Шаг, Номер_попытки, Результат,
    SEC_TO_TIME(round(timestamp_attempt)) as Время_попытки,
    round(timestamp_attempt/(sum(timestamp_attempt) over(partition by Шаг))*100,2) as Относительное_время
from res_tab
order by step_id, submission_time

