-- 1. Выбрать все группы 1 курса математического факультета, у которых нет куратора
SELECT * 
FROM "group" 
WHERE (cod_f LIKE 'М%' OR cod_f LIKE '1%') 
  AND curator IS NULL;

-- 2. Выбрать телефоны преподавателей, являющихся кураторами групп
SELECT t.contact_phone_
FROM teachers t
JOIN "group" g ON t.teacher_code = g.curator;

-- 3. Создать таблицу, содержащую данные 2 запроса с указанием номеров групп и стажа
DROP TABLE IF EXISTS teachers_report CASCADE;
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
    department_nur AS Кафедра, 
    COUNT(*) AS Количество_преподавателей_с_высшим_образованием
FROM teachers
WHERE ex = 'высшее'
GROUP BY department_nur;
