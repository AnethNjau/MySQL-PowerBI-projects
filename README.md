# MySQL-PowerBI-projects

HR Employee Distribution Analysis

![Capture 4](https://github.com/user-attachments/assets/70db2177-ce32-4cdb-8227-a80814899a6c)


This project focuses on analyzing employee distribution data using SQL for data cleaning and analysis, and Power BI for visualization. The dataset includes information on employee demographics, employment length, location, and more. Below is a detailed overview of the project, including the SQL queries used for data cleaning and analysis, and the visualizations created in Power BI.


Project Overview
The goal of this project is to analyze employee distribution within a company, focusing on various demographics such as gender, race, age, and location. The analysis helps in understanding the workforce composition and identifying trends or patterns.

Data Cleaning
Before performing any analysis, the data was cleaned to ensure accuracy and consistency. The following steps were taken:
Changing Column Names: Adjusted column names for better readability.
Updating Data Types: Modified data types for date columns to ensure proper date formatting.
Handling Missing Values: Ensured that missing or null values were appropriately handled.
Calculating Age: Added an age column to the dataset by calculating the difference between the current date and the birthdate.

SQL Queries for Data Cleaning
-- Changing column name
ALTER TABLE hr
CHANGE COLUMN id emp_id VARCHAR(20) NULL;

-- Updating birthdate format
SET sql_safe_updates = 0;
UPDATE hr
SET birthdate = CASE
    WHEN birthdate LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

-- Changing column data type
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

-- Updating hire_date format
UPDATE hr
SET hire_date = CASE
    WHEN hire_date LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

-- Adding age column
ALTER TABLE hr ADD COLUMN age INT;
UPDATE hr
SET age = TIMESTAMPDIFF(YEAR, birthdate, CURDATE());


Data Analysis
The cleaned data was then analyzed to answer several key questions about the employee distribution:
Gender Breakdown: What is the gender distribution of employees in the company?
Race/Ethnicity Breakdown: What is the race/ethnicity distribution of employees?
Age Distribution: What is the age distribution of employees?
Location Distribution: How many employees work at headquarters vs remote locations?
Average Length of Employment: What is the average length of employment for terminated employees?

SQL Queries for Data Analysis
-- Gender Breakdown
SELECT gender, COUNT(*) AS count
FROM hr
WHERE age > 18 AND termdate = '0000-00-00'
GROUP BY gender;

-- Race/Ethnicity Breakdown
SELECT race, COUNT(*) AS count
FROM hr
WHERE age > 18 AND termdate = '0000-00-00'
GROUP BY race
ORDER BY count(*) DESC;

-- Age Distribution
SELECT 
    CASE
        WHEN age >= 20 AND age <= 30 THEN '20-30'
        WHEN age >= 31 AND age <= 40 THEN '31-40'
        WHEN age >= 41 AND age <= 50 THEN '41-50'
        WHEN age >= 51 AND age <= 60 THEN '51-60'
        ELSE '60+'
    END AS age_group,
    gender,
    COUNT(*) AS count
FROM hr
WHERE age > 18 AND termdate = '0000-00-00'
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- Location Distribution
SELECT location, COUNT(*) AS count
FROM hr
WHERE age > 18 AND termdate = '0000-00-00'
GROUP BY location
ORDER BY count DESC;

-- Average Length of Employment
SELECT
    ROUND(AVG(DATEDIFF(termdate, hire_date)) / 365, 0) AS avg_employment_len
FROM hr
WHERE termdate <= CURDATE() AND termdate != '0000-00-00' AND age >= 18;


Visualizations
The analysis results were visualized using Power BI. The following visualizations were created:
Gender Distribution: A bar chart showing the distribution of employees by gender.
Race Distribution: A bar chart showing the distribution of employees by race.
Age Group Distribution: A bar chart showing the distribution of employees by age group.
Location Distribution: A pie chart showing the distribution of employees by location (Headquarters vs Remote).
Average Length of Employment: A card visualization showing the average length of employment for terminated employees.

Power BI Dashboard
The Power BI dashboard provides an interactive way to explore the employee distribution data. Users can filter the data by gender, race, age group, and location to gain deeper insights.


Key findings from the analysis:
Gender Balance: The workforce is evenly distributed across gender identities, with detailed breakdowns by department and age groups.
Location Trends: Headquarters hosts a significantly higher proportion of employees compared to remote locations.
Average Employment Duration: The average tenure for terminated employees was calculated at 8 years.
Age Segmentation: The most common age group was 31-40 years.

Future Improvements
To Collect additional data to better represent different employee demographics.
Implement scripts for automated formatting and validation to reduce manual efforts.
