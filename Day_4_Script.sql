select * from area ;-- hold: area_id,name
select * from customer_joining_info ;-- hold:customer_id,region_id,area_id,join_date
select * from customer_transactions ;-- hold:customer_id,txn_date,txn_type,txn_amount
select * from region ;-- hold:region_id,region_name


-- 1. How many unique customers are there?
select count(distinct(customer_id)) from
customer_joining_info ;


-- 2. How many unique customers are coming from each region?

select region_name,count(distinct(customer_id)) 
from customer_joining_info cji join region r 
on cji.region_id =r.region_id 
group by region_name;

-- 3. How many unique customers are coming from each area?
select name,count(distinct(customer_id)) 
from customer_joining_info cji join area a 
on cji.area_id =a.area_id 
group by name;

-- 4. What is the total amount for each transaction type?

select txn_type as Transaction_Type,
sum(txn_amount) as Total_Amount from customer_transactions ct 
group by Transaction_Type;

-- 5. For each month - how many customers make
--  more than 1 deposit and 1 withdrawal in a single month?
select month,count(customer_id) as total_customer_id   from
(select customer_id,month (txn_date) as month,
count(case when txn_type='deposit' then 1 end) as deposit_count,
count(case when txn_type='withdrawal' then 1 end ) as withdrawal_count
 from customer_transactions 
group by customer_id,month)t
where t.deposit_count>1 and t.withdrawal_count>1
group by month ;


-- 6. What is closing balance for each customer?

--  closing balance=deposit_amount-withdrawal_amount

-- select count(distinct customer_id) from customer_transactions ct ;-- 500 
select customer_id,(sum(t.deposit_amount)-sum(t.withdrawal_amount)) as closing_balance from
(select customer_id,txn_type,
case when txn_type ='deposit' then txn_amount
else 0 end as deposit_amount,
case when txn_type ='withdrawal' then txn_amount else 0 
end as withdrawal_amount
from customer_transactions )t
group by t.customer_id order by  t.customer_id desc;

-- 7. What is the closing balance -- 5963
-- for each customer at the end of the month?
-- select distinct LAST_DAY(txn_date) from customer_transactions 

select customer_id, LAST_DAY(txn_date) as last_day,(sum(t.deposit_amount)-sum(t.withdrawal_amount)) as closing_balence from 
(select customer_id,txn_date,txn_type,
case when txn_type = 'deposit' then txn_amount else 0 end as deposit_amount,
case when txn_type='withdrawal' then txn_amount else 0 end as withdrawal_amount
from customer_transactions)t
group by t.customer_id,LAST_DAY(t.txn_date)  order by t.customer_id desc

-- 8. Please show the latest 5 days total withdraw amount.
select sum(txn_amount) from
(select txn_amount from customer_transactions ct
where txn_type="withdrawal"
order by txn_date desc
limit 5)t;

/*9. Find out the total deposit amount for every five days consecutive series. 
 *    You can assume 1 week = 5 days. 
	Please show the result week wise total amount.
*/

select week,sum(t.txn_amount)as total_deposit_amount from 
(select ceiling(day(txn_date)/5)as week,(txn_amount) from customer_transactions 
where txn_type ='deposit'
order by txn_date asc)t
group by week


/*
  10. Please compare every week total deposit amount by the following previous week. 

	Example: Week 1 will be compared with Week 2 [Calculation Week2 - Week 1]-> Next week - previous week
		Week 2 will be compared with Week 3[Calculation Week3 - Week 2]
		[consider: 1 week = 5 day]
*/
select *,(amount-lag_value) as compare_value from
(
select wek,amount,
lag (amount,1,0) over(order by wek asc)as lag_value
from
(select wek,sum(txn_amount)as amount
from 
(select *,ceiling (day(txn_date)/5) as wek from  customer_transactions ct 
where txn_type ='deposit' 
)t
group by wek order by wek)t2)t3








