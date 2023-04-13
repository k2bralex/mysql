DROP SCHEMA IF EXISTS online_testing;
CREATE SCHEMA online_testing;

DROP TABLE IF EXISTS testing;
DROP TABLE IF EXISTS attempt;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS answer;
DROP TABLE IF EXISTS question;
DROP TABLE IF EXISTS subject;

CREATE TABLE subject
(
    subject_id   INT PRIMARY KEY AUTO_INCREMENT,
    name_subject VARCHAR(30)
);

CREATE TABLE student
(
    student_id   INT PRIMARY KEY AUTO_INCREMENT,
    name_student VARCHAR(50)
);

CREATE TABLE attempt
(
    attempt_id   INT PRIMARY KEY AUTO_INCREMENT,
    student_id   INT,
    subject_id   INT,
    date_attempt DATE,
    result       INT,
    FOREIGN KEY (student_id) REFERENCES student (student_id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subject (subject_id) ON DELETE CASCADE
);

CREATE TABLE question
(
    question_id   INT PRIMARY KEY AUTO_INCREMENT,
    name_question VARCHAR(100),
    subject_id    INT,
    FOREIGN KEY (subject_id) REFERENCES subject (subject_id) ON DELETE CASCADE
);

CREATE TABLE answer
(
    answer_id   INT PRIMARY KEY AUTO_INCREMENT,
    name_answer VARCHAR(100),
    question_id INT,
    is_correct  BOOLEAN,
    FOREIGN KEY (question_id) REFERENCES question (question_id) ON DELETE CASCADE
);

CREATE TABLE testing
(
    testing_id  INT PRIMARY KEY AUTO_INCREMENT,
    attempt_id  INT,
    question_id INT,
    answer_id   INT,
    FOREIGN KEY (attempt_id) REFERENCES attempt (attempt_id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES question (question_id) ON DELETE CASCADE,
    FOREIGN KEY (answer_id) REFERENCES answer (answer_id) ON DELETE CASCADE
);