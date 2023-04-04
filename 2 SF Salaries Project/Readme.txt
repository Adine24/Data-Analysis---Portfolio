----San Francisco Salaries Dataset----

---About Dataset---
- This data contains the names, job title, and compensation for San Francisco city employees on an annual basis from 2011 to 2014. Dataset gotten from Kaggle.com

--Aim of EDA--
- To know how salaries have changed over the years for different jobs.
- To know the most common jobs in San Francisco with their salaries.
- Compare Jobs with normal pay and those with added benefits.
- Compare range of overtime paid jobs.
- To know the average salary paid for employees.
- and more...

--Process--

- 1 I began with Data Cleaning:
  - Read dataset 
  - Viewed dataset information to check datatypes and number of null values for columns.
  - Checked shape, dataset initially has 148,654  rows and 13 columns.
  - 'Notes' and 'Status' columns caught my attention, so I checked for rows that had values. And no row had values, so I decided to drop those columns as they weren't needed.
  - Checked duplicates - No duplicated data was in dataset.

  - Dealing with null values:
	- 'Overtimepay' and 'Otherpay' columns had null values on 4 rows, after viewing those rows I discovered that Employee Name and Job Title wasn't provided. So I decided to remove those rows from the dataset.
	- 'Basepay' column had null values which I replace with 0, because the column will be useful for my analysis.
	- To make sure that the values in 'Basepay' column was correct, I did calculations to get the correct amount.

  - Lastly I viewed the statistical summary of numerical columns in the dataset. 

- 2 After Data Cleaning, I began my Exploratory Analysis and Visualization:
  - I was able to answer these questions:
	- What is the Average BasePay for all Jobs ?
		- I got the mean of the Basepay column.

	- What is the highest amount of OvertimePay for all Jobs?
		- Used .max() function to get the highest value in overtimepay column.

	- What are the details of the employee with the most overtimepay?
		- Used loc to locate and get details of where overtimpay is max using .idxmax()

	- What is the job title of a guy named JOSEPH DRISCOLL ?
		- I got the row with that Employee name and using Job title as a factor. 
		- I used different methods to get this which you can observe when you view the file.

	- What is the name of highest paid person (including benefits)?
		- Used .idxmax() to get the details of the highest paid Employee with benefits.

-- You can view how I answered the following questions in the file --
 
	- What is the name of lowest paid person (including benefits)?
	- What was the average (mean) BasePay of all employees per year? (2011-2014)?
	- How many unique job titles are there?
	- What are the top 5 most common jobs?
	- What is the average basepay for the Top 5 most common jobs?
	- How many Job Titles were represented by only one person in 2013?
	- How many people have the word Chief in their job title?
	- Is there a correlation between length of the Job Title string and Salary?
	- What is the number of Jobs recorded per Year?
	- Compare Most BasePaying Jobs with TotalPay
	- Compare Least Paying Jobs with added benefits
	- What are the most OvertimePaying Jobs?
	- Compare Jobs with high Benefits

   - Finally I gave my conclusion regarding my analysis and gave advice with my decision from the Analysis.

-------------------------------------------------------------------------

There were some tricky parts, hence why I used different methods to do the same thing, some were easier to do than most. Also it took me sometime in writing some functions just to simplify my codes and prevent repetition. 

Visualizing the average basepay for Top 5 most common jobs in different subplots also took me sometime, but I figured it out with the help of the internet.

My Observations, Conclusions and Decisions are from a personal point of view. I am very
open to corrections. Thank you!






