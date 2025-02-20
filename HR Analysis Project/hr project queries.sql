Create Database PortfolioProject;

use portfolioProject;
select * from hr;

#### data cleaning######
####changing column name##
alter table hr
change column ï»¿id emp_id varchar (20) NULL;
select * from hr;

####check the data types of all our columns###
describe hr;
select birthdate from hr;

####before updating a table we have to turn off safe mode that prevents updates and later swith back to safe mode###
set sql_safe_updates = 0;

Update hr
set birthdate = case
 when birthdate like '%/%' then date_format(str_to_date(birthdate,'%m/%d/%Y'), '%Y-%m-%d')
 when birthdate like '%-%' then date_format(str_to_date(birthdate,'%m-%d-%Y'), '%Y-%m-%d')
 else null
end;
#### use capital Y instead of y for a four digit year but the latter for a 2 digit year###
####channging column data type
alter table hr
modify column birthdate date;
Update hr
set hire_date = case
 when hire_date like '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'), '%Y-%m-%d')
 when hire_date like '%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'), '%Y-%m-%d')
 else null
end;
alter table hr
modify column hire_date date;

set sql_mode= '';
Update hr
set termdate=date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
Where termdate is not null and termdate !=' ';
alter table hr
modify column termdate date;

select termdate from hr;
####creating an age column
alter table hr add column age int;

update hr
set age= timestampdiff(year, birthdate, curdate());

select birthdate, age from hr;

select min(age) as youngest, max(age) as oldest
from hr;

select count(*) from hr where age < 18;

select * from hr;
#####Analysis#####
####QUESTIONSSSSS#####
-- 1. what is the gender breakdown of employees in a company?
select gender, count(*) as count
from hr
where age > 18 and termdate = 0000-00-00
group by gender;

-- 2. what is the race/ethnicity breakdown of employees in the company?
select race, count(*) as count
from hr
where age > 18 and termdate = 0000-00-00
group by race
order by count(*)desc;

-- 3. What is the age distribution of employees in the company?
###first we are going to find the min and max age so that we can know where to start grouping the age groups##
select min(age) as youngest, max(age) as oldest
from hr
where age > 18 and termdate = 0000-00-00;

select case
 when age >=20 and age <=30 then '20-30'
 when age >=31 and age <=40 then '31-40'
 when age >=41 and age <=50 then '41-50'
 when age >=51 and age <=60 then '51-60'
else '60+'
end as age_group, gender,
count(*) as count
from hr
where age > 18 and termdate = 0000-00-00
group by age_group, gender
order by age_group,gender;

-- 4. How many employees work at headquarters vs remote locations###
SELECT location, COUNT(*) AS count
FROM hr
WHERE age > 18 AND termdate = '0000-00-00' 
GROUP BY location
ORDER BY count DESC; 

-- 5. what is the average length of employment for employees who have been terminated?
select
round(avg(datediff(termdate,hire_date))/365,0) as avg_employment_len
from hr
where termdate<=curdate() and termdate != '0000-00-00' and age >= 18;
