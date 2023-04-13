USE online_testing;

# В таблицу attempt включить новую попытку для студента Баранова Павла по дисциплине «Основы
# баз данных». Установить текущую дату в качестве даты выполнения попытки.
INSERT INTO attempt(student_id, subject_id, date_attempt, result)
VALUES ((SELECT student_id FROM student WHERE name_student = 'Баранов Павел'),
        (SELECT subject_id FROM subject WHERE name_subject = 'Основы баз данных'),
        (NOW()),
        null);


# Случайным образом выбрать три вопроса (запрос) по дисциплине, тестирование по которой
# собирается проходить студент, занесенный в таблицу attempt последним, и добавить их в
# таблицу testing. id последней попытки получить как максимальное значение id из таблицы attempt.
INSERT INTO testing (attempt_id, question_id)
SELECT attempt_id, question_id
FROM question
         JOIN subject s on question.subject_id = s.subject_id
         JOIN attempt a on s.subject_id = a.subject_id
WHERE attempt_id = (SELECT MAX(attempt_id) FROM attempt)
  AND question_id IN (SELECT question_id
                      FROM question)
ORDER BY RAND()
LIMIT 3;


# Студент прошел тестирование (то есть все его ответы занесены в таблицу testing), далее
# необходимо вычислить результат(запрос) и занести его в таблицу attempt для соответствующей
# попытки.  Результат попытки вычислить как количество правильных ответов, деленное на 3
# (количество вопросов в каждой попытке) и умноженное на 100. Результат округлить до целого.
UPDATE attempt
SET result = (SELECT (SUM(is_correct) / 3 * 100) AS res
              FROM testing t
                       JOIN answer a on a.answer_id = t.answer_id
              WHERE attempt_id = (SELECT MAX(attempt_id) FROM testing))
WHERE attempt.attempt_id = (SELECT MAX(attempt_id) FROM testing);


# Удалить из таблицы attempt все попытки, выполненные раньше 1 мая 2020 года.
# Также удалить и все соответствующие этим попыткам вопросы из таблицы testing
DELETE FROM attempt
WHERE TIMESTAMP(date_attempt) < TIMESTAMP('2020-05-01')



