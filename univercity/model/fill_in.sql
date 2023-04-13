USE university;

INSERT INTO department (`department_id`, `name_department`)
VALUES (1, 'Инженерная школа'),
       (2, 'Школа естественных наук');

INSERT INTO subject (`subject_id`, `name_subject`)
VALUES (1, 'Русский язык'),
       (2, 'Математика'),
       (3, 'Физика'),
       (4, 'Информатика');

INSERT INTO program (`program_id`, `name_program`, `department_id`, `plan`)
VALUES (1, 'Прикладная математика и информатика', 2, 2),
       (2, 'Математика и компьютерные науки', 2, 1),
       (3, 'Прикладная механика', 1, 2),
       (4, 'Мехатроника и робототехника', 1, 3);

INSERT INTO enrollee (`enrollee_id`, `name_enrollee`)
VALUES (1, 'Баранов Павел'),
       (2, 'Абрамова Катя'),
       (3, 'Семенов Иван'),
       (4, 'Яковлева Галина'),
       (5, 'Попов Илья'),
       (6, 'Степанова Дарья');

INSERT INTO achievement (`achievement_id`, `name_achievement`, `bonus`)
VALUES (1, 'Золотая медаль', 5),
       (2, 'Серебряная медаль', 3),
       (3, 'Золотой значок ГТО', 3),
       (4, 'Серебряный значок ГТО', 1);

INSERT INTO enrollee_achievement (`enrollee_achiev_id`, `enrollee_id`, `achievement_id`)
VALUES (1, 1, 2),
       (2, 1, 3),
       (3, 3, 1),
       (4, 4, 4),
       (5, 5, 1),
       (6, 5, 3);

INSERT INTO program_subject (`program_subject_id`, `program_id`, `subject_id`, `min_result`)
VALUES (1, 1, 1, 40),
       (2, 1, 2, 50),
       (3, 1, 4, 60),
       (4, 2, 1, 30),
       (5, 2, 2, 50),
       (6, 2, 4, 60),
       (7, 3, 1, 30),
       (8, 3, 2, 45),
       (9, 3, 3, 45),
       (10, 4, 1, 40),
       (11, 4, 2, 45),
       (12, 4, 3, 45);

INSERT INTO program_enrollee (`program_enrollee_id`, `program_id`, `enrollee_id`)
VALUES (1, 3, 1),
       (2, 4, 1),
       (3, 1, 1),
       (4, 2, 2),
       (5, 1, 2),
       (6, 1, 3),
       (7, 2, 3),
       (8, 4, 3),
       (9, 3, 4),
       (10, 3, 5),
       (11, 4, 5),
       (12, 2, 6),
       (13, 3, 6),
       (14, 4, 6);

INSERT INTO enrollee_subject (`enrollee_subject_id`, `enrollee_id`, `subject_id`, `result`)
VALUES (1, 1, 1, 68),
       (2, 1, 2, 70),
       (3, 1, 3, 41),
       (4, 1, 4, 75),
       (5, 2, 1, 75),
       (6, 2, 2, 70),
       (7, 2, 4, 81),
       (8, 3, 1, 85),
       (9, 3, 2, 67),
       (10, 3, 3, 90),
       (11, 3, 4, 78),
       (12, 4, 1, 82),
       (13, 4, 2, 86),
       (14, 4, 3, 70),
       (15, 5, 1, 65),
       (16, 5, 2, 67),
       (17, 5, 3, 60),
       (18, 6, 1, 90),
       (19, 6, 2, 92),
       (20, 6, 3, 88),
       (21, 6, 4, 94);