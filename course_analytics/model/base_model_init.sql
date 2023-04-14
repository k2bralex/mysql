DROP DATABASE IF EXISTS course_analytics;
CREATE DATABASE course_analytics;

USE course_analytics;

CREATE TABLE module
(
    module_id   INT PRIMARY KEY AUTO_INCREMENT,
    module_name VARCHAR(64)
);

CREATE TABLE lesson
(
    lesson_id       INT PRIMARY KEY AUTO_INCREMENT,
    lesson_name     VARCHAR(50),
    module_id       INT,
    lesson_position INT,
    FOREIGN KEY (module_id) REFERENCES module (module_id) ON DELETE CASCADE
);

CREATE TABLE step
(
    step_id       INT PRIMARY KEY AUTO_INCREMENT,
    step_name     VARCHAR(256),
    step_type     VARCHAR(16),
    lesson_id     INT,
    step_position INT,
    FOREIGN KEY (lesson_id) REFERENCES lesson (lesson_id) ON DELETE CASCADE
);

CREATE TABLE keyword
(
    keyword_id   INT PRIMARY KEY AUTO_INCREMENT,
    keyword_name VARCHAR(16)
);

CREATE TABLE step_keyword
(
    step_id    INT,
    keyword_id INT,
    PRIMARY KEY (step_id, keyword_id),
    FOREIGN KEY (step_id) REFERENCES step (step_id) ON DELETE CASCADE,
    FOREIGN KEY (keyword_id) REFERENCES keyword (keyword_id) ON DELETE CASCADE
);

CREATE TABLE student
(
    student_id   INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(64)
);

CREATE TABLE step_student
(
    step_student_id INT PRIMARY KEY AUTO_INCREMENT,
    step_id         INT,
    student_id      INT,
    attempt_time    INT,
    submission_time INT,
    result          VARCHAR(16),
    FOREIGN KEY (student_id) REFERENCES student (student_id) ON DELETE CASCADE,
    FOREIGN KEY (step_id) REFERENCES step (step_id) ON DELETE CASCADE
);