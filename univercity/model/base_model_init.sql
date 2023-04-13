DROP DATABASE IF EXISTS university;
CREATE DATABASE university;

USE university;

DROP TABLE IF EXISTS enrollee_subject;
DROP TABLE IF EXISTS program_enrollee;
DROP TABLE IF EXISTS program_subject;
DROP TABLE IF EXISTS enrollee_achievement;
DROP TABLE IF EXISTS achievement;
DROP TABLE IF EXISTS enrollee;
DROP TABLE IF EXISTS program;
DROP TABLE IF EXISTS subject;
DROP TABLE IF EXISTS department;

CREATE TABLE department
(
    department_id   INT PRIMARY KEY AUTO_INCREMENT,
    name_department VARCHAR(30)
);

CREATE TABLE subject
(
    subject_id   INT PRIMARY KEY AUTO_INCREMENT,
    name_subject VARCHAR(30)
);

CREATE TABLE program
(
    program_id    INT PRIMARY KEY AUTO_INCREMENT,
    name_program  VARCHAR(50),
    department_id INT,
    plan          INT,
    FOREIGN KEY (department_id) REFERENCES department (department_id) ON DELETE CASCADE
);

CREATE TABLE enrollee
(
    enrollee_id   INT PRIMARY KEY AUTO_INCREMENT,
    name_enrollee VARCHAR(50)
);

CREATE TABLE achievement
(
    achievement_id   INT PRIMARY KEY AUTO_INCREMENT,
    name_achievement VARCHAR(30),
    bonus            INT
);

CREATE TABLE enrollee_achievement
(
    enrollee_achiev_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollee_id        INT,
    achievement_id     INT,
    FOREIGN KEY (enrollee_id) REFERENCES enrollee (enrollee_id) ON DELETE CASCADE,
    FOREIGN KEY (achievement_id) REFERENCES achievement (achievement_id) ON DELETE CASCADE
);

CREATE TABLE program_subject
(
    program_subject_id INT PRIMARY KEY AUTO_INCREMENT,
    program_id         INT,
    subject_id         INT,
    min_result         INT,
    FOREIGN KEY (program_id) REFERENCES program (program_id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subject (subject_id) ON DELETE CASCADE
);

CREATE TABLE program_enrollee
(
    program_enrollee_id INT PRIMARY KEY AUTO_INCREMENT,
    program_id          INT,
    enrollee_id         INT,
    FOREIGN KEY (program_id) REFERENCES program (program_id) ON DELETE CASCADE,
    FOREIGN KEY (enrollee_id) REFERENCES enrollee (enrollee_id) ON DELETE CASCADE
);

CREATE TABLE enrollee_subject
(
    enrollee_subject_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollee_id         INT,
    subject_id          INT,
    result              INT,
    FOREIGN KEY (enrollee_id) REFERENCES enrollee (enrollee_id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subject (subject_id) ON DELETE CASCADE
);
