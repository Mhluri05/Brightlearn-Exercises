----------------Data Cleaning-------------------------

-- running the data as it is to check if it runs

select *
from retail.sales.bright_coffee_shop_sales;

-- to confirm the data types of every column
describe retail.sales.bright_coffee_shop_sales;

-- checking the total number of rows

select count(*) as total_rows
from retail.sales.bright_coffee_shop_sales;

-- checking if there are any missing values

select * 
from retail.sales.bright_coffee_shop_sales
where transaction_id is null
   or transaction_date is null
   or transaction_time is null
   or transaction_qty is null
   or store_id is null
   or store_location is null
   or product_id is null
   or unit_price is null
   or product_category is null
   or product_type is null
   or product_detail is null;

-- checking if there are duplicates

select *,
      count(*)
from retail.sales.bright_coffee_shop_sales
group by all
having count(*) > 1; --- there are no duplicates


-----------------------------------------------------------------------------------

-- permanently adding new_columns to the dataset----

-- adding a total_amount column

alter table retail.sales.bright_coffee_shop_sales
add column total_amount decimal(10,2); -- adding column

update retail.sales.bright_coffee_shop_sales
set total_amount = unit_price * transaction_qty; --- updating column

-- adding transaction_time_bucket(3 hour intervals) 

alter table retail.sales.bright_coffee_shop_sales
add column transaction_time_bucket string; -- adding column

update retail.sales.bright_coffee_shop_sales
set transaction_time_bucket =
case
    when hour(transaction_time) between 0 and 2 then '00:00-02:59'
    when hour(transaction_time) between 3 and 5 then '03:00-05:59'
    when hour(transaction_time) between 6 and 8 then '06:00-08:59'
    when hour(transaction_time) between 9 and 11 then '09:00-11:59'
    when hour(transaction_time) between 12 and 14 then '12:00-14:59'
    when hour(transaction_time) between 15 and 17 then '15:00-17:59'
    when hour(transaction_time) between 18 and 20 then '18:00-20:59'
    when hour(transaction_time) between 21 and 23 then '21:00-23:59'
end; --- updating column

-- adding new columns(month_name,month_number,month_id,day_name,day_number & time_bucket)

alter table retail.sales.bright_coffee_shop_sales
add columns (
    month_name string,
    month_number int,
    month_id string,
    day_name string,
    day_number int,
    time_bucket string); -- adding column
    

update retail.sales.bright_coffee_shop_sales
set
    month_name = monthname(transaction_date),
    month_number = month(transaction_date),
    month_id = date_format(transaction_date, 'yyyy-MM'),
    day_name = dayname(transaction_date),
    day_number = dayofweek(transaction_date)
    
    time_bucket = 
    case
        when date_format(transaction_time, 'HH:mm:ss') between '06:00:00' and '11:59:59' then 'morning'
        when date_format(transaction_time, 'HH:mm:ss') between '12:00:00' and '16:59:59' then 'afternoon'
        when date_format(transaction_time, 'HH:mm:ss') between '17:00:00' and '19:59:59' then 'evening'
        else 'night'
    end,
total_amount = unit_price * transaction_qty; -- updating column

-- 
----these are my additional columns to help me analyse better

-- adding a quarter column

alter table retail.sales.bright_coffee_shop_sales
add column 
    quarter int; -- adding column

update retail.sales.bright_coffee_shop_sales
set 
    quarter = quarter(transaction_date); -- updating column

-- adding weeking of the year column

alter table retail.sales.bright_coffee_shop_sales
add column 
           week_of_year int; -- adding column

update retail.sales.bright_coffee_shop_sales
set 
    week_of_year = weekofyear(transaction_date); -- updating column

--adding weekend vs weekday column

alter table retail.sales.bright_coffee_shop_sales
add column 
         day_type string; -- adding column

update retail.sales.bright_coffee_shop_sales
set day_type =
case
    when dayofweek(transaction_date) in (1, 7) then 'weekend'
    else 'weekday'
end; -- updating column



--------------THE DATA HAS BEEN TRANSFORMED TO WHAT I WANTED IT TO BE-------------
--------it is now time for the sql analysis-------------




                                             ---SALES PERFORMANCE---

--what is the total revenue?
select 
      sum (total_amount) as total_revenue
from retail.sales.bright_coffee_shop_sales;

-- how many transactions are in the dataset?
select 
      count (distinct transaction_id) as total_tumber_of_transactions
from retail.sales.bright_coffee_shop_sales;

-- how many products were sold?
select 
      count (distinct product_id) as total_tumber_of_products_sold
from retail.sales.bright_coffee_shop_sales;

-- what is the average sale value?
select avg(total_amount) as average_sale_value
from retail.sales.bright_coffee_shop_sales;

--which products sell the most? -- by revenue
select 
      product_detail,
      sum(transaction_qty) as total_revenue
from retail.sales.bright_coffee_shop_sales
group by product_detail
order by total_revenue desc
limit 1;

                                        ---PRODUCT ANALYSIS---

-- best-selling products by quantity sold
select
    product_detail,
    sum(transaction_qty) as total_units_sold
from retail.sales.bright_coffee_shop_sales
group by product_detail
order by total_units_sold desc;

-- low-selling products by quantity sold
select
    product_detail,
    sum(transaction_qty) as total_units_sold
from retail.sales.bright_coffee_shop_sales
group by product_detail
order by total_units_sold asc;

--Which individual product sells the most?
select
    product_detail,
    sum(transaction_qty) as total_units_sold
from retail.sales.bright_coffee_shop_sales
group by product_detail
order by total_units_sold desc
limit 1;

                                          ---TIME ANALYSIS---

--- time intervals with the highest sales
select 
       time_bucket,
       sum(transaction_id) as total_revenue
from retail.sales.bright_coffee_shop_sales
group by time_bucket
order by total_revenue desc
limit 1;

--what are the peak sales hours?
select 
       time_bucket,
       count(transaction_id) as total_transactions
from retail.sales.bright_coffee_shop_sales
group by time_bucket
order by total_transactions desc;

--time intervals with the lowest sales
select 
       time_bucket,
       sum(transaction_id) as total_revenue
from retail.sales.bright_coffee_shop_sales
group by time_bucket
order by total_revenue asc
limit 1;

--which hour is the busiest?

select
    hour(transaction_time) as hour_of_day,
    count(*) as total_transactions
from retail.sales.bright_coffee_shop_sales
group by hour(transaction_time)
order by total_transactions desc
limit 1;

-- day with the highest sales?
select 
   dayname(transaction_date) as day_of_week,
    sum(total_amount) as total_sales
from retail.sales.bright_coffee_shop_sales
group by day_name(transaction_date)
order by total_sales desc
limit 1; --------------------------not running

-- month with the highest sales?
select 
   month(transaction_date) as month,
    sum(total_amount) as total_sales
from retail.sales.bright_coffee_shop_sales
group by day_name(transaction_date)
order by total_sales desc
limit 1; --------------------------not running

                                                  ---STORE ANALYSIS---

--which store location performs best? -- revenue

select 
      store_location,
      sum(transaction_qty) as total_revenue
from retail.sales.bright_coffee_shop_sales
group by store_location
order by total_revenue desc
limit 1;

--which store sells the most products?
select 
      store_location,
      sum(transaction_qty) as total_products_sold
from retail.sales.bright_coffee_shop_sales  
group by store_location
order by total_products_sold desc
limit 1;

--which store has the highest average transaction value?
select 
      store_location,
      avg(total_amount) as average_transiction_value
from retail.sales.bright_coffee_shop_sales  
group by store_location
order by average_transiction_value desc
limit 1;






