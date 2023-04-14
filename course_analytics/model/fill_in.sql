USE course_analytics;

INSERT INTO module (module_name)
VALUES ('Основы реляционной модели и SQL'),
       ('Запросы SQL к связанным таблицам');

INSERT INTO lesson(lesson_name, module_id, lesson_position)
VALUES ('Отношение(таблица)', 1, 1),
       ('Выборка данных', 1, 2),
       ('Таблица "Командировки", запросы на выборку', 1, 6),
       ('Вложенные запросы', 1, 4);

INSERT INTO step(step_name, step_type, lesson_id, step_position)
VALUES ('Структура уроков курса', 'text', 1, 1),
       ('Содержание урока', 'text', 1, 2),
       ('Реляционная модель, основные положения', 'table', 1, 3),
       ('Отношение, реляционная модель', 'choice', 1, 4);

INSERT INTO keyword(keyword_name)
VALUES ('SELECT'),
       ('FROM');

SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO step_keyword (step_id, keyword_id) VALUE (38, 1);
INSERT INTO step_keyword (step_id, keyword_id) VALUE (81, 3);

INSERT INTO student(student_name)
VALUES ('student_1'),
       ('student_2');

INSERT INTO step_student (step_id, student_id, attempt_time, submission_time, result)
VALUES (10, 52, 1598291444, 1598291490, 'correct'),
       (10, 11, 1593291995, 1593292031, 'correct'),
       (10, 19, 1591017571, 1591017743, 'wrong'),
       (10, 4, 1590254781, 1590254800, 'correct');

SET FOREIGN_KEY_CHECKS = 1;