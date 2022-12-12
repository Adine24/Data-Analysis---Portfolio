-- Selects Database to use, Shows Tables and Describes the selected table
USE MyProjects;
SHOW TABLES;
SELECT  * FROM myprojects.bakerysales;
DESCRIBE myprojects.bakerysales;

-- Counts the Number of Rows in the table
SELECT COUNT(*) 
FROM myprojects.bakerysales;

-- Check for duplicates
select myunknowncolumn, date, time, ticket_number, article, quantity, unit_price,count(*)
from myprojects.bakerysales
group by myunknowncolumn
having count(*) > 1;

-- adds a new column called count to increment each row
alter table myprojects.bakerysales
add count int auto_increment primary key;

-- changes the date(datetime) column to date_ordered(date) column 
alter table myprojects.bakerysales
change date date_ordered date;

-- changes the time(text) column to time_ordered(time) column 
alter table myprojects.bakerysales
change time time_ordered time;

-- changes the article column name to product_ordered
alter table myprojects.bakerysales
change article product_ordered text;

-- checks if replace is possible for the unit price
select count,  
replace (unit_price,'€','')
from myprojects.bakerysales;

-- removes the '€' sign from the column 
update myprojects.bakerysales
set unit_price = replace (unit_price,'€','');

-- checks if replace is possible for the unit price
select count,  
replace (unit_price,',','.')
from myprojects.bakerysales;

-- changes the ',' sign to '.' in the column 
update myprojects.bakerysales
set unit_price = replace (unit_price,',','.');

-- changes the unit_price name to unit_price_Euro 
alter table myprojects.bakerysales
change unit_price unit_price_Euro text;

-- checks for null or blank cells
select myunknowncolumn, date_ordered, time_ordered, ticket_number, product_ordered, quantity, unit_price_euro,count(*)
from myprojects.bakerysales
group by myunknowncolumn
having count(*) = '' or count(*) is null;

-- orders the table by product_ordered column
select * from myprojects.bakerysales
order by product_ordered;

-- removes rows where the product_ordered is entered as '.'
delete from myprojects.bakerysales
where product_ordered = '.';

-- groups and orders table by quanitity
select product_ordered, quantity, unit_price_euro
from myprojects.bakerysales
group by Quantity
order by Quantity;

-- selects and groups from table where quantity is negative 
select product_ordered, quantity, unit_price_euro
from myprojects.bakerysales
where Quantity like '%-%'
group by Quantity;

-- removes rows where the quantity is negative
delete from myprojects.bakerysales
where Quantity like '%-%';

-- selects and groups from table where unit_price_euro = 0 
select product_ordered, quantity, unit_price_euro
from myprojects.bakerysales
where unit_price_Euro = 0
group by product_ordered;

-- removes rows where the unit_price_euro = 0
delete from myprojects.bakerysales
where unit_price_Euro = 0;

-- drops column named MyUnknownColumn
alter table myprojects.bakerysales
drop MyUnknownColumn;


select * 
from myprojects.bakerysales
order by unit_price_Euro;






