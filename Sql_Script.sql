CREATE DATABASE projects;
USE projects;
SELECT * FROM hr;

ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

DESCRIBE HR;
SET sql_safe_updates=0;

SELECT birthdate FROM hr;
UPDATE hr
SET birthdate = CASE 
   WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
   WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
   ELSE NULL
END;   

SELECT birthdate from hr;

ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

UPDATE hr
SET hire_date = CASE 
   WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
   WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
   ELSE NULL
END; 

SELECT termdate from hr;

UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SELECT termdate from hr;

SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE; 

ALTER TABLE hr
ADD COLUMN age INT;

SELECT * FROM hr;

UPDATE hr
SET AGE= timestampdiff(YEAR,birthdate,CURDATE());

SELECT
MIN(age) as youngest, 
MAX(age) as oldest
FROM hr;

-- 1. Gender breakdown of employees
SELECT gender,COUNT(*) as count
FROM hr
WHERE age>=18 AND termdate='0000-00-00'  -- Because there should be no termdate
GROUP BY gender;

-- 2. Race/ethnicity breakdown of employees
SELECT race,COUNT(*) as count
FROM hr
WHERE age>=18 AND termdate='0000-00-00'
GROUP BY race
ORDER BY count DESC;

-- 3. Age distribution of employees
SELECT 
	CASE 
		WHEN age>=18 AND age<=24 THEN '18-24'
		WHEN age>=25 AND age<=34 THEN '25-34'
		WHEN age>=35 AND age<=44 THEN '35-44'
		WHEN age>=45 AND age<=54 THEN '45-54'
        WHEN age>=55 AND age<=64 THEN '55-64'
        ELSE '65+'
    END AS age_group,
    count(*) AS count
 FROM hr
 WHERE age>=18 AND termdate='0000-00-00'
 GROUP BY age_group
 ORDER BY age_group;
 
 -- 4. Age distribution of employees by gender
SELECT 
	CASE 
		WHEN age>=18 AND age<=24 THEN '18-24'
		WHEN age>=25 AND age<=34 THEN '25-34'
		WHEN age>=35 AND age<=44 THEN '35-44'
		WHEN age>=45 AND age<=54 THEN '45-54'
        WHEN age>=55 AND age<=64 THEN '55-64'
        ELSE '65+'
    END AS age_group,gender,
    count(*) AS count
 FROM hr
 WHERE age>=18 AND termdate='0000-00-00'
 GROUP BY age_group,gender
 ORDER BY age_group,gender;   

-- 5. Location wise breakdown (Headquarter v/s Remote )
SELECT location,COUNT(*) as count
FROM hr
WHERE age>=18 AND termdate='0000-00-00'
GROUP BY location;

-- 6. Average length of employement in years
SELECT 
round(avg(datediff(termdate,hire_date))/365,0) AS avg_length_employment
FROM hr
WHERE termdate <= curdate() AND termdate <> '0000-00-00' AND age>=18;

-- 7. Gender distribution across departments
SELECT department,gender,COUNT(*) AS count
FROM hr
WHERE age>=18 AND termdate='0000-00-00'
GROUP BY department,gender
ORDER BY department;

-- 8. Distribution across job titles
SELECT jobtitle,COUNT(*) as count
FROM hr
WHERE age>=18 AND termdate='0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 9. Distribution of employees across locations by state 
SELECT location_state,COUNT(*) as count
FROM hr
WHERE age>=18 AND termdate='0000-00-00'
GROUP BY location_state
ORDER BY count DESC;

-- 10. Average tenure duration by department 
SELECT department,round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure
FROM hr
WHERE termdate<= curdate() and termdate<> '0000-00-00' and age>=18
GROUP BY department;
