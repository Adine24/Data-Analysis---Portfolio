----FIFA 21 Messy Dataset----

---About Dataset---
- This dataset contains a lot of messy columns that require cleaning. I took this dataset as part of a data cleaning challenge on twitter, A big Thank You to the community that helped making the cleaning process faster. I also went further to make interactive visualizations with widgets on what I could. 

---Aim of EDA---
- To clean messy columns
- To analyze player stats and draw conclusions
- To compare player stats
- and more ...

---Process----
- 1 I began with Data Cleaning:
  - Read dataset 
  - Viewed dataset information to check datatypes and number of null values for columns.
  - Checked shape, dataset initially has 18,979 rows and 77 columns.
  - Checked for duplicates - no duplicates.
  - Checked for null values - 'Loan Date End' column and 'Hits' column had lots of null values.
  - Checked for inconsistencies in string datatype columns. 
  - Checked if a part of the name is contained in the long name : Those whose name wasn't found in their long name are those using an Alias for their name.
  - Checked the number of unique nationalities.
  - Cleaned the Club column by removing '\n' found in it.
  - Checked number of unique clubs.
  - Cleaned the height column, which had values in cm and 'feet & inches', so I decided to convert all values to cm using a function.
  - Cleaned the weight column, which had values in kg and lbs, so I decided to convert all values to kg using a function.
  - Checked the preferred foot column for inconsistencies.
  - Cleaned the value, wage and Release Clause columns: wrote a function to convert values in Millions, Thousands to their standard form for the three columns.
  - Renamed currency columns by adding the unit currency to column name.  
  - Cleaned the W/F, 'SM', 'IR' columns by removing '★' from the values.
  - Cleaned the Hits column : made values which were in thousands standard and filled nan values with 0 using a function.
  - Split the contract column which had differnt types of data in it to their appropriate place, using a function.
  - Got Playing years from Joined column after converting the column to datetime and subtracting the year joined from current year.
  - Finally, Dropped unneeded columns.
  - Saved the Cleaned data to a csv file, to be used for visualizations.
 
 
---Visualizations---
- The FIFA dataset is a huge one. So in order to carry out exploratory analysis effectively and see visualizations easily without having to write too many codes, I decided to create Dashboards with interactive dropdowns and plots.

1. The first visual is a countplot to view Different contract Types.
2. The Second visual shows The Number of players in each Age Range.
3. Dashboard 1 Enables -
   - Viewing of Clubs and Nationalities unique to that club.
   - Filtering by Nationality for a club.
   - Plot to show Players for clubs and compare their Age or Hits.
4. Dashboard 2 Enables -
   - Viewing of Clubs and Nationalities unique to that club.
   - Plot to show Players for clubs and compare their wage, release clause and value.
   - Filtering by Nationality for a club.
   - Filtering to show high earning players by club
   - Knowing a players worth, using a scatterplot between value and wage.
5. Dashboard 3 Enables -
   - Viewing of Clubs and Nationalities unique to that club.
   - Plot to show Players for clubs and compare their years played with contract start - end shown.
   - Filtering by Nationality for a club.
   - Filtering by number of years played for a club.
   - Filtering by year which player joined a club.
6. Dashboard 4 Enables -
   - Viewing of Clubs and Players unique to that club.
   - Filtering by positions played in that club.
   - Ability to view stats for 2 Players.
   - Plot to compare stats between the 2 selected players and draw a conclusion.


-------------------------------------------------------------------------------


Creating these dashboards came with challenges. I had to learn ipywidgets and modify a lot of things just to create different dashboards,  but it was worth it as I can use it well now, although I repeated a lot of codes for this dashboard visualizations , I will improve on it as I go on. I am open to opinions of others, pls do well to let me know your insights. Thank You!
 




