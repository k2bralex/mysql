USE online_testing;

# Вывести студентов, которые сдавали дисциплину «Основы баз данных», указать дату попытки и результат.
# Информацию вывести по убыванию результатов тестирования.
SELECT name_student, date_attempt, result
FROM attempt
         JOIN student USING (student_id)
         JOIN subject USING (subject_id)
WHERE name_subject = 'Основы баз данных'
ORDER BY result DESC;


# Вывести, сколько попыток сделали студенты по каждой дисциплине, а также средний результат
# попыток, который округлить до 2 знаков после запятой. Под результатом попытки понимается
# процент правильных ответов на вопросы теста, который занесен в столбец result.
# В результат включить название дисциплины, а также вычисляемые столбцы Количество и
# Среднее. Информацию вывести по убыванию средних результатов.
SELECT s.name_subject,
       COUNT(a.attempt_id)     AS Количество,
       ROUND(AVG(a.result), 2) AS Среднее
FROM subject s
         LEFT JOIN attempt a on s.subject_id = a.subject_id
GROUP BY s.name_subject
ORDER BY Среднее DESC;


# Вывести студентов (различных студентов), имеющих максимальные результаты попыток.
# Информацию отсортировать в алфавитном порядке по фамилии студента. Максимальный
# результат не обязательно будет 100%, поэтому явно это значение в запросе не задавать.
SELECT s.name_student, a.result
FROM student s
         JOIN attempt a on s.student_id = a.student_id
WHERE a.result = (SELECT result
                  FROM student s2
                           JOIN attempt a2 on s2.student_id = a2.student_id
                  ORDER BY result DESC
                  LIMIT 1);


# Если студент совершал несколько попыток по одной и той же дисциплине, то вывести
# разницу в днях между первой и последней попыткой. В результат включить фамилию
# и имя студента, название дисциплины и вычисляемый столбец Интервал. Информацию
# вывести по возрастанию разницы. Студентов, сделавших одну попытку по дисциплине, не учитывать.
SELECT name_student, name_subject, DATEDIFF(MAX(a.date_attempt), MIN(a.date_attempt)) AS Интервал
FROM attempt a
         JOIN student s on s.student_id = a.student_id
         JOIN subject s2 on s2.subject_id = a.subject_id
WHERE a.student_id IN (SELECT student_id
                       FROM (SELECT student_id, COUNT(attempt_id) AS at_count
                             FROM attempt
                             GROUP BY student_id, subject_id
                             HAVING at_count > 1) q1)
GROUP BY name_student, name_subject
ORDER BY Интервал;


# Студенты могут тестироваться по одной или нескольким дисциплинам (не обязательно по всем).
# Вывести дисциплину и количество уникальных студентов (столбец назвать Количество),
# которые по ней проходили тестирование . Информацию отсортировать сначала по убыванию
# количества, а потом по названию дисциплины. В результат включить и дисциплины,
# тестирование по которым студенты еще не проходили, в этом случае указать количество студентов 0.
SELECT sb.name_subject, COUNT(DISTINCT a.student_id) AS Количество
FROM subject sb
         LEFT JOIN attempt a on sb.subject_id = a.subject_id
GROUP BY sb.name_subject
ORDER BY Количество DESC, sb.name_subject;


# Случайным образом отберите 3 вопроса по дисциплине «Основы баз данных». В результат
# включите столбцы question_id и name_question.
SELECT question_id, name_question
FROM question
         JOIN subject s on s.subject_id = question.subject_id
WHERE name_subject = 'Основы баз данных'
ORDER BY RAND()
LIMIT 3;


# Вывести вопросы, которые были включены в тест для Семенова Ивана по дисциплине
# «Основы SQL» 2020-05-17  (значение attempt_id для этой попытки равно 7). Указать,
# какой ответ дал студент и правильный он или нет (вывести Верно или Неверно). В результат
# включить вопрос, ответ и вычисляемый столбец  Результат.
SELECT name_question, a.name_answer, IF(a.is_correct = 0, 'Неверно', 'Верно') AS Результат
FROM testing t
         JOIN answer a on t.answer_id = a.answer_id
         JOIN question q on t.question_id = q.question_id
         JOIN attempt a2 on t.attempt_id = a2.attempt_id
WHERE a2.attempt_id = 7;


# Посчитать результаты тестирования. Результат попытки вычислить как количество правильных
# ответов, деленное на 3 (количество вопросов в каждой попытке) и умноженное на 100.
# Результат округлить до двух знаков после запятой. Вывести фамилию студента, название
# предмета, дату и результат. Последний столбец назвать Результат. Информацию отсортировать
# сначала по фамилии студента, потом по убыванию даты попытки.
SELECT name_student,
       name_subject,
       date_attempt,
       ROUND((SUM(is_correct) / 3 * 100), 2) AS Результат
FROM answer a
         JOIN testing t on t.answer_id = a.answer_id
         JOIN attempt a2 on a2.attempt_id = t.attempt_id
         JOIN student s on s.student_id = a2.student_id
         JOIN subject s2 on s2.subject_id = a2.subject_id
GROUP BY name_student, name_subject, date_attempt
ORDER BY name_student, date_attempt
        DESC;


# Для каждого вопроса вывести процент успешных решений, то есть отношение количества верных
# ответов к общему количеству ответов, значение округлить до 2-х знаков после запятой. Также
# вывести название предмета, к которому относится вопрос, и общее количество ответов на этот
# вопрос. В результат включить название дисциплины, вопросы по ней (столбец назвать Вопрос),
# а также два вычисляемых столбца Всего_ответов и Успешность. Информацию отсортировать
# сначала по названию дисциплины, потом по убыванию успешности, а потом по тексту вопроса
# в алфавитном порядке.
# Поскольку тексты вопросов могут быть длинными, обрезать их 30 символов и добавить
# многоточие "...".
SELECT q1.name_subject,
       IF(LENGTH(q1.name_question) < 60,
          q1.name_question,
          CONCAT((LEFT(q1.name_question, 30)), '...')) AS Вопрос,
       Всего_ответов,
       ROUND((corr_answ / Всего_ответов * 100), 2)     AS Успешность
FROM (SELECT name_subject, name_question, COUNT(a.answer_id) AS Всего_ответов, SUM(is_correct) AS corr_answ
      FROM testing t
               JOIN answer a on a.answer_id = t.answer_id
               JOIN question q on q.question_id = t.question_id
               JOIN subject s on s.subject_id = q.subject_id
      GROUP BY name_subject, name_question) q1
ORDER BY name_subject, Успешность DESC , Вопрос;