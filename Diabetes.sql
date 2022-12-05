-- Selects Database to use, Shows Tables and Describes the selected table
USE MyProjects;
SHOW TABLES;
DESCRIBE diabetes;

-- Counts the Number of Rows in the table
SELECT COUNT(*) 
FROM myprojects.diabetes;

-- Orders The table by Age and level of glucose in body
SELECT * 
FROM myprojects.diabetes
ORDER BY Age,Glucose;

-- Adds a new table called Diabetes_Outcome
ALTER TABLE myprojects.diabetes 
ADD Diabetes_Outcome VARCHAR(30) NULL;

-- Assigns the Outcome column to the Diabetes_Outcome
UPDATE myprojects.diabetes 
SET Diabetes_Outcome = Outcome;

-- Selects Outcome and Diabetes_Outcome
SELECT Outcome, Diabetes_outcome
FROM myprojects.diabetes;

-- Sets Diabetes_Outcome from 1 to Yes
UPDATE myprojects.diabetes 
SET Diabetes_Outcome = 'Yes' 
WHERE Diabetes_Outcome = 1;

-- Sets Diabetes_Outcome from 0 to Yes
UPDATE myprojects.diabetes 
SET Diabetes_Outcome = 'No' 
WHERE Diabetes_Outcome = '0';

SELECT * 
FROM myprojects.diabetes
ORDER BY Age,Glucose,BloodPressure,DiabetesPedigreeFunction;










