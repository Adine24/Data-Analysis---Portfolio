-----McDonald's Nutrition Facts Dataset----

---About Dataset---
- This dataset provides a nutrition analysis of every menu item on the US McDonald's menu, including breakfast, beef burgers etc.

---Aim of EDA---
- How many calories does the average McDonald's value meal contain?
- How much do beverages, like soda or coffee, contribute to the overall caloric intake?  
- What about ordering egg whites instead of whole eggs? 
- What is the least number of items could you order from the menu to meet one day's nutritional requirements?
- and more...

--Process--

- 1 I began with Data Cleaning:
  - Read dataset 
  - Viewed dataset information to check datatypes and number of null values for columns.
  - Checked shape, dataset initially has 260 rows and 24 columns.
  - Checked statistical summary of numerical columns.
  - Checked for duplicates - no duplicates.
  - Checked for inconsistencies in text columns.
  - Making the Serving size column normal - This column had values in grams, ml, oz etc.
    which I made standard by making everything to be measured in grams.

- 2 After Data Cleaning, I began my Exploratory Analysis and Visualization:
  - I was able to answer these questions:
	- How many Items are in each categories of food on the menu.
	- What are the average amount of all nutrients contained in the food.
	- What are the Food Items with Maximum Nutrient Values for Each Category?
	- What are the Food Items with Minimum Nutrient Values for Each Category?
	- What are the Food Items with Maximum %Daily Nutrient Values for Each Category?
	- Breaking Down Nutrient Categories With High average value (Top 3)
	- Which Item of Food product has the highest and lowest level of nutrient and how does the serving size relate to the amount of nutrient? (Top 3)
	- How much beverages, like soda or coffee, contribute to the overall caloric intake?
	- If ordering grilled chicken instead of crispy increases a sandwich's nutritional value?
	- If ordering egg whites instead of whole eggs increases nutritional value?
	- What is the Correlation between the Nutrients?

   - Finally, I created Interactive plots with Dashboards that can enable comparison of nutrients stats between two Food items on the menu


Had a nice time working on this project. The sodium amount on McDonald's is ridiculously high. I also observed other interesting things, like:
- Nutritional value increases when Breakfast is taken with Egg whites compared to just eggs.
- Crispy chicken sandwiches increases a sandwiches nutritional value more compared to grilled chicken sandwiches.
- and more..
- Pls do so to correct me if you realise any thing that grabs your attention. Thank you!


