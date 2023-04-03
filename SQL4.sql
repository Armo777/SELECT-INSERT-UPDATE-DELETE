Создание БД:

CREATE TABLE departments (
  Id SERIAL PRIMARY KEY,
  Financing MONEY NOT NULL DEFAULT 0 CHECK (Financing >= CAST(0 AS MONEY)),
  Name NVARCHAR(100) NOT NULL UNIQUE CHECK (Name <> '')
);

CREATE TABLE faculties (
  Id SERIAL PRIMARY KEY,
  Dean TEXT NOT NULL CHECK (Dean <> ''),
  Name VARCHAR(100) NOT NULL UNIQUE CHECK (Name <> '')
);

CREATE TABLE groups (
  Id SERIAL PRIMARY KEY,
  Name VARCHAR(10) NOT NULL UNIQUE CHECK (Name <> ''),
  Rating INT NOT NULL CHECK (Rating >= 0 AND Rating <= 5),
  Year INT NOT NULL CHECK (Year >= 1 AND Year <= 5)
);

CREATE TABLE teachers (
    Id SERIAL PRIMARY KEY,
    EmploymentDate DATE NOT NULL CHECK (EmploymentDate >= '1990-01-01'),
    IsAssistant BOOLEAN NOT NULL DEFAULT false,
    IsProfessor BOOLEAN NOT NULL DEFAULT false,
    Name TEXT NULL CHECK (Name <> ''),
    Position TEXT NOT NULL,
    Premium MONEY NOT NULL DEFAULT 0 CHECK (Premium >= CAST(0 AS MONEY)),
    Salary MONEY NOT NULL CHECK (Salary > CAST(0 AS MONEY)),
    Surname TEXT NOT NULL
);

Заполнение таблиц:

INSERT INTO departments (id, financing, name) VALUES
  (1, '3000000', 'Факультет компьютерных наук'),
  (2, '1500000', 'Факультет математики'),
  (3, '2500000', 'Кафедра физики');

INSERT INTO faculties (id, dean, name)
VALUES
    (1, 'Иванов Иван Иванович', 'Факультет компьютерных наук'),
    (2, 'Петров Петр Петрович', 'Факультет математики'),
    (3, 'Сидоров Сидор Сидорович', 'Кафедра физики');

INSERT INTO groups (id, name, rating, year) VALUES
  (1, 'Группа 1', 5, 5),
  (2, 'Группа 2', 1, 2),
  (3, 'Группа 3', 3, 3);

INSERT INTO teachers (id, employmentdate, isassistant, isprofessor, name, position, premium, salary, surname) 
VALUES 
(1, '1995-03-15', false, true, 'Иван', 'Профессор', 15000, 50000, 'Иванович'),
(2, '2005-08-20', true, false, 'Петр', 'Лектор', 10000, 30000, 'Петрович'),
(3, '2010-02-10', true, false, 'Владимир', 'Ассистент профессора', 12000, 35000, 'Владимирович');

Запросы:

SELECT premium, surname, salary, position, name, isprofessor, isassistant, employmentdate, id
FROM teachers;

SELECT groups.name AS groupname, groups.rating
FROM groups;

SELECT surname, 
       ((premium/salary)*100) AS "Ставка к надбавке, %", 
       (((salary+premium)/salary)*100) AS "Ставка к зарплате, %"
FROM teachers;

SELECT 'Декан факультета ' || name || ' - ' || dean || '.' as info
FROM faculties;

SELECT surname
FROM teachers
WHERE isprofessor = true AND Salary + Premium > CAST(1050 AS MONEY);

SELECT name 
FROM departments
WHERE financing < CAST(11000 AS MONEY) OR financing > CAST(25000 AS MONEY);

SELECT name FROM faculties
WHERE name != 'Информатика';

SELECT surname, position 
FROM teachers
WHERE surname NOT IN (SELECT surname FROM groups WHERE isprofessor = true);

SELECT surname, position, salary, premium
FROM teachers
WHERE isassistant = true AND premium::numeric BETWEEN 1600 AND 55000

SELECT surname, salary
FROM teachers
WHERE isassistant = true;

SELECT surname, position
FROM teachers
WHERE employmentdate < '2000-01-01' AND isassistant = true AND isprofessor = false;

SELECT name AS "Название департамента" 
FROM departments
WHERE name < 'Разработка программного обеспечения'
ORDER BY name;

SELECT surname
FROM teachers
WHERE isassistant = true AND salary <= CAST(1200 AS MONEY)

SELECT name, rating
FROM groups
WHERE year = 5 AND rating BETWEEN 2 AND 4;

SELECT surname, position, premium 
FROM teachers
WHERE isassistant = true AND (position = 'помощник' AND 
							  premium < CAST(550 AS MONEY) OR 
							  premium < CAST(200 AS M