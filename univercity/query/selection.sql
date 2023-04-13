USE university;

# Вывести абитуриентов, которые хотят поступать на образовательную программу
# «Мехатроника и робототехника» в отсортированном по фамилиям виде.
SELECT name_enrollee
FROM enrollee
         JOIN program_enrollee USING (enrollee_id)
         JOIN program USING (program_id)
WHERE name_program = 'Мехатроника и робототехника'
ORDER BY name_enrollee;


# Вывести образовательные программы, на которые для поступления необходим предмет «Информатика».
# Программы отсортировать в обратном алфавитном порядке.
SELECT name_program
FROM program_subject
         JOIN subject s on s.subject_id = program_subject.subject_id
         JOIN program p on p.program_id = program_subject.program_id
WHERE name_subject = 'Информатика'
ORDER BY name_program DESC;


# Выведите количество абитуриентов, сдавших ЕГЭ по каждому предмету, максимальное,
# минимальное и среднее значение баллов по предмету ЕГЭ. Вычисляемые столбцы назвать
# Количество, Максимум, Минимум, Среднее. Информацию отсортировать по названию предмета
# в алфавитном порядке, среднее значение округлить до одного знака после запятой.
SELECT name_subject,
       COUNT(enrollee_id)      AS Количество,
       MAX(result)             AS Максимум,
       MIN(result)             AS Минимум,
       ROUND((AVG(result)), 1) AS Среднее
FROM enrollee_subject es
         JOIN subject s on s.subject_id = es.subject_id
GROUP BY name_subject
ORDER BY name_subject;


# Вывести образовательные программы, для которых минимальный балл ЕГЭ по каждому предмету
# больше или равен 40 баллам. Программы вывести в отсортированном по алфавиту виде.
SELECT name_program
FROM program p
WHERE p.program_id IN (SELECT program_id, subject_id  FROM program_subject WHERE min_result >= 40)
GROUP BY name_program
ORDER BY name_program;