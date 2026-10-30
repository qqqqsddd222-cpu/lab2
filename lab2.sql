DROP TABLE IF EXISTS teachers_report CASCADE;
DROP TABLE IF EXISTS "group" CASCADE;
DROP TABLE IF EXISTS teachers CASCADE;

CREATE TABLE teachers (
    teacher_code INTEGER PRIMARY KEY,
    last_name VARCHAR(50),
    first_name VARCHAR(50),
    patronymic VARCHAR(50),
    education INTEGER,
    EX VARCHAR(50),
    department_nur INTEGER,
    contact_phone_ INTEGER,
    experience INTEGER DEFAULT 0 
);


CREATE TABLE "group" (
    group_id INTEGER PRIMARY KEY,
    max_number INTEGER NOT NULL,
    cod_F VARCHAR(100),
    curator INTEGER,
    CONSTRAINT fk_curator FOREIGN KEY (curator) 
        REFERENCES teachers (teacher_code) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);


INSERT INTO teachers (teacher_code, last_name, first_name, patronymic, education, "ex", department_nur, contact_phone_, experience) 
VALUES 
    (1, 'Иванов', 'Иван', 'Иванович', 1, 'высшее', 101, 9001112233, 12),
    (2, 'Петрова', 'Мария', 'Сергеевна', 2, 'высшее', 102, 9002223344, 5),
    (3, 'Сидоров', 'Алексей', 'Петрович', 1, 'среднее-специальное', 103, 9003334455, 8),
    (4, 'Кузнецова', 'Ольга', 'Дмитриевна', 2, 'высшее', 104, 9004445566, 15);

INSERT INTO "group" (group_id, max_number, cod_F, curator) 
VALUES 
    (1, 25, 'ИС-21', 1),
    (2, 30, 'ПИ-22', 2),
    (3, 20, 'М-23', NULL), 
    (4, 28, 'ИС-22', 4);


-- выполнение 11 варианта

-- 1. Выбрать все группы 1 курса математического факультета
SELECT * 
FROM "group" 
WHERE (cod_F LIKE 'М%' OR cod_F LIKE '1%') 
  AND curator IS NULL;

-- 2. Выбрать телефоны преподавателей, являющихся кураторами
SELECT t.last_name, t.first_name, t.contact_phone_
FROM teachers t
JOIN "group" g ON t.teacher_code = g.curator;

-- 3. Создать таблицу, содержащую 2 запроса с указанием номеров групп и стажа
CREATE TABLE teachers_report AS
SELECT 
    t.last_name, 
    t.first_name, 
    t.contact_phone_,
    g.group_id,
    t.experience
FROM teachers t
JOIN "group" g ON t.teacher_code = g.curator;

-- 4. Добавить в созданную таблицу преподавателей, в фамилиях которых встречается 3 и больше гласных букв
INSERT INTO teachers_report (last_name, first_name, contact_phone_, group_id, experience)
SELECT 
    last_name, 
    first_name, 
    contact_phone_, 
    NULL AS group_id, 
    experience
FROM teachers
WHERE last_name ~* '([аеёиоуыэюя].*){3,}';

-- 5. В созданной таблице у всех преподавателей увеличить стаж работы на год
UPDATE teachers_report 
SET experience = experience + 1;

-- 6. Удалить из созданной таблицы все записи для преподавателей, являющихся классными руководителями и имеющих стаж меньше 10 лет
DELETE FROM teachers_report 
WHERE group_id IS NOT NULL 
  AND experience < 10;

-- 7. Посчитать количество преподавателей, имеющих высшее образование, работающих на каждой кафедре
SELECT 
    department_nur AS "Кафедра", 
    COUNT(*) AS "Количество преподавателей с высшим образованием"
FROM teachers
WHERE ex = 'высшее'
GROUP BY department_nur;