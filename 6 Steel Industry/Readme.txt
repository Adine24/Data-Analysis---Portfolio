-----Steel Industry Energy Consumption Data----

---About Dataset---
- This company produces several types of coils, steel plates, and iron plates. The information on electricity consumption is held in a cloud-based system. The information on energy consumption of the industry is stored on the website of the Korea Electric Power Corporation (pccs.kepco.go.kr), and the perspectives on daily, monthly, and annual data are calculated and shown.

---Aim of EDA---
-From the data we can tell:
  - Which times of the year is the most energy consumed?
  - What patterns can we identify in energy usage?
  - and more...

--Process--

- 1 I began with Data Cleaning:
  - Read dataset 
  - Viewed dataset information to check datatypes and number of null values for columns.
  - Checked shape, dataset initially has 35,040 rows and 11 columns.
  - Converting date column to datetime format.
  - Extract Year, Month, Day and Hour from Date Column.
  - Checked for duplicates - no duplicates.
  - Checked for inconsistencies in text columns.

- 2 Exploratory Analysis and Visualization:
  - I was able to answer these questions:
	- What are the Total, Max and Average Energy Consumption per Hour for the Year.
	- At What hours do the Total, Max and Average Energy Consumption in the Year occur.
      - On What days do we have higher level release of CO2 and which loads releases it more.
	- How is the energy consumptions on different days of the week.
	- How do different Load types consume energy by week status.
	- What is the Average energy consumption on days of the week.
	- How is the energy consumption by different Load Types over the Months.
	- What are the aggregate values for energy consumption for all the Load Types.
	- What is the Correlation between all the values.
	- What is the Energy Consumption on Month, Days of the Week.
	- What Load_Types release CO2 more during energy consumption.
	- What are the Load_Types energy consumption density.


As a Student of Mechanical Engineering, I was thrilled to work on this dataset, I was able to notice somethings which I stated in my observations. I am open to my fellow Engineers and the publics opinion on this Analysis.


