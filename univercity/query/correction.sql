USE university;

# Создать вспомогательную таблицу applicant,  куда включить id образовательной программы,
# id абитуриента, сумму баллов абитуриентов (столбец itog) в отсортированном сначала по
# id образовательной программы, а потом по убыванию суммы баллов виде (использовать запрос
# из предыдущего урока).
DROP TABLE IF EXISTS applicant;

CREATE TABLE applicant AS
SELECT pe.program_id, pe.enrollee_id, SUM(result) AS itog
FROM program_enrollee pe
         JOIN enrollee e on e.enrollee_id = pe.enrollee_id
         JOIN program_subject ps on pe.program_id = ps.program_id
         JOIN subject s on s.subject_id = ps.subject_id
         JOIN enrollee_subject es on e.enrollee_id = es.enrollee_id AND s.subject_id = es.subject_id
GROUP BY pe.program_id, pe.enrollee_id
ORDER BY pe.program_id, itog DESC;

SELECT *
FROM applicant;


# Из таблицы applicant, созданной на предыдущем шаге, удалить записи, если абитуриент на выбранную
# образовательную программу не набрал минимального балла хотя бы по одному предмету (использовать
# запрос из предыдущего урока).
DELETE
FROM applicant
    USING applicant
              JOIN enrollee_subject es on applicant.enrollee_id = es.enrollee_id
              JOIN program_subject ps on applicant.program_id = ps.program_id AND
                                         ps.subject_id = es.subject_id
              JOIN subject s on s.subject_id = ps.subject_id
WHERE result < min_result;

SELECT *
FROM applicant;


# Повысить итоговые баллы абитуриентов в таблице applicant на значения дополнительных
# баллов (использовать запрос из предыдущего урока).
UPDATE applicant JOIN (SELECT enrollee_id, COALESCE(SUM(bonus), 0) AS Бонус
                       FROM enrollee_achievement
                                LEFT JOIN achievement USING (achievement_id)
                       GROUP BY enrollee_id) AS t USING (enrollee_id)
SET itog = itog + Бонус;

SELECT *
FROM applicant;


# Поскольку при добавлении дополнительных баллов, абитуриенты по каждой образовательной
# программе могут следовать не в порядке убывания суммарных баллов, необходимо создать
# новую таблицу applicant_order на основе таблицы applicant. При создании таблицы
# данные нужно отсортировать сначала по id образовательной программы, потом по убыванию
# итогового балла. А таблицу applicant, которая была создана как вспомогательная,
# необходимо удалить.
DROP TABLE IF EXISTS applicant_order;

CREATE TABLE applicant_order
AS
SELECT program_id, enrollee_id, itog
FROM applicant
ORDER BY program_id, itog DESC;

DROP TABLE applicant;

# Включить в таблицу applicant_order новый столбец str_id целого типа , р
# асположить его перед первым.
ALTER TABLE applicant_order
    ADD str_id INT FIRST;


# Занести в столбец str_id таблицы applicant_order нумерацию абитуриентов,
# которая начинается с 1 для каждой образовательной программы.
SET @row_num := 1;
SET @num_pr := 0;
UPDATE applicant_order
SET str_id = IF(program_id = @num_pr, @row_num := @row_num + 1, @row_num := 1 AND @num_pr := @num_pr + 1);


# Создать таблицу student,  в которую включить абитуриентов, которые могут быть рекомендованы
# к зачислению  в соответствии с планом набора. Информацию отсортировать сначала в алфавитном
# порядке по названию программ, а потом по убыванию итогового балла
DROP TABLE IF EXISTS student;

CREATE TABLE student
AS
SELECT name_program, name_enrollee, itog
FROM applicant_order ao
         JOIN enrollee e on ao.enrollee_id = e.enrollee_id
         JOIN program p on ao.program_id = p.program_id
WHERE str_id <=plan
ORDER BY name_program, itog DESC;

SELECT * FROM student;