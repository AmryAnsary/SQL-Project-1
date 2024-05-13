-- BEGINNER LEVEL

SELECT first_name, 
last_name, 
age,
age+20-10
FROM parks_and_recreation.employee_demographics
;
-- Where Clause
SELECT *
FROM employee_salary
WHERE salary > 50000
;

-- AND OR NOT -- Logical Operators
SELECT *
FROM employee_demographics
WHERE birth_date > '1985-01--01'
AND gender = 'male'
;

SELECT *
FROM employee_demographics
WHERE (first_name = 'Leslie' AND age = 44) OR age > 55
;

-- LIKE Statement
-- % anything _ specific value
SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a%'
;

SELECT *
FROM employee_demographics
WHERE first_name LIKE 'A__'
;

-- GROUP BY 
SELECT gender, AVG(age), MAX(age) AS 'maximum age'
FROM employee_demographics
GROUP BY gender
;

-- ORDER BY
SELECT *
FROM employee_demographics
ORDER BY age, gender
;

-- HAVING CLAUSE
SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40
;

SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 75000
;

-- JOINS - INTERMEDIATE LEVEL
SELECT dem.employee_id, age, occupation
FROM employee_demographics dem
INNER JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;

SELECT *
FROM employee_demographics dem
RIGHT JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;

-- SELF JOIN
SELECT emp1.employee_id AS emp_santa,
emp1.first_name AS first_name_santa,
emp1.last_name AS last_name_santa,
emp2.employee_id AS emp_name,
emp2.first_name AS first_name_employee,
emp2.last_name AS last_name_employee
FROM employee_salary emp1
JOIN employee_salary emp2
	ON emp1.employee_id + 1 = emp2.employee_id
;

-- UNION
Select first_name, last_name,'Old Man' as Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
Select first_name, last_name,'Old Lady' as Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION
Select first_name, last_name, 'Highly Paid Salary' as Label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name,last_name
;

-- STRING
SELECT LENGTH('Skyfall')
;
SELECT first_name, LENGTH(first_name)
FROM employee_demographics
ORDER BY 2
;

SELECT first_name,
LEFT (first_name,4),
RIGHT (first_name,4),
birth_date,
SUBSTRING(birth_date,6,2) AS birth_month
FROM employee_demographics
;

SELECT first_name, REPLACE(first_name, 'Leslie', 'Lily') AS new_name
FROM employee_demographics
;

SELECT LOCATE('x','Alexander')
;

SELECT first_name, LOCATE('an',first_name)
FROM employee_demographics
;

SELECT first_name, last_name,
CONCAT(first_name,' ',last_name) AS full_name
FROM employee_demographics
;

-- Case Statements
SELECT first_name, last_name, age,
CASE
	WHEN age <= 30 THEN 'Young'
    When age BETWEEN 31 AND 50 THEN 'Old'
END
FROM employee_demographics
;

-- <50 000 = 5%
-- >50 000 = 7%
-- Finance Dept = 10$ bonus
SELECT first_name, last_name, salary,
CASE
	WHEN salary < 50000 THEN salary*1.05
    WHEN salary > 50000 THEN salary*1.07
END AS New_Salary,
CASE
	WHEN dept_id = 6 THEN salary * .10
END AS Bonus
FROM employee_salary
;

-- SUBQUERIES

SELECT *
FROM employee_demographics
WHERE employee_id IN
				(SELECT employee_id
					FROM employee_salary
                    WHERE dept_id = 1)
;

-- SUBQUERIES - how to calculate average for all
SELECT first_name, salary,
(SELECT AVG(salary)
FROM employee_salary)
FROM employee_salary
;

SELECT gender, AVG(age), MIN(age), MAX(age), COUNT(age)
FROM employee_demographics
GROUP BY gender
;

SELECT AVG(max_age)
FROM
(SELECT gender, 
AVG(age) AS avg_age, 
MIN(age) AS min_age, 
MAX(age) AS max_age, 
COUNT(age)
FROM employee_demographics
GROUP BY gender) AS Agg_Table
;

-- Window Function
SELECT gender, AVG(salary) AS avg_salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
;

SELECT dem.first_name,dem.last_name,gender, AVG(salary) OVER(PARTITION BY gender)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;

SELECT dem.employee_id,dem.first_name,dem.last_name,gender, salary,
SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_total
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;

SELECT dem.employee_id,dem.first_name,dem.last_name,gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;

-- ADVANCED MYSQL Tutorial
-- CTEs Common Table Expressions

WITH CTE_Example AS
(
SELECT gender, AVG(salary) as avg_salary, MAX(salary) AS max_salary, MIN(salary) AS min_salary, COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT AVG(avg_salary)
FROM CTE_Example
;

WITH CTE_Example AS
(
SELECT employee_id, gender, birth_date
FROM employee_demographics
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS
(
SELECT employee_id, salary
FROM employee_salary
WHERE salary > 50000
)
SELECT *
FROM CTE_Example
JOIN CTE_Example2
	ON CTE_Example.employee_id = CTE_Example2.employee_id
;

WITH CTE_Example (Gender, AVG_Sal, MAX_Sal, MIN_Sal, COUNT_Sal) AS
(
SELECT gender, AVG(salary) as avg_salary, MAX(salary) AS max_salary, MIN(salary) AS min_salary, COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM CTE_Example
;

-- TEMPORARY Tables

CREATE TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name varchar(50),
fav_movie varchar(100))
;

SELECT *
FROM temp_table
;

INSERT INTO temp_table
VALUES('Amry','Ansary','The Social Network')
;

CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM salary_over_50k;

-- STORED PROCEDURE

CREATE PROCEDURE large_salaries()
SELECT*
FROM employee_salary
WHERE salary >= 50000;

CALL large_salaries();

DELIMITER $$
CREATE PROCEDURE large_salaries2()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
	SELECT *
	FROM employee_salary
	WHERE salary >= 10000;
END $$
DELIMITER ;

CALL large_salaries2();

DELIMITER $$
CREATE PROCEDURE large_salaries3(id INT)
BEGIN
	SELECT salary
	FROM employee_salary
	WHERE employee_id = id;
END $$
DELIMITER ;

CALL large_salaries3(1)

-- TRIGGER and EVENTS
SELECT *
FROM employee_demographics

SELECT *
FROM employee_salary

DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics(employee_id,first_name,last_name)
    VALUES (NEW.employee_id,NEW.first_name,NEW.last_name);
END $$
DELIMITER ;

INSERT INTO employee_salary
VALUES(13, 'Jean-Ralphio','Saperstein','Entertainment 720 CEO', 1000000, NULL);

DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 second
DO
BEGIN
	DELETE
    FROM employee_demographics
    WHERE age >= 60;
END $$
DELIMITER ;

SHOW VARIABLES LIKE 'event%';