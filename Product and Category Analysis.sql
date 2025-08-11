#Q1
SELECT c.campaign_name,p.category,
ROUND((
SUM(IF(f.promo_type = 'BOGOF', `quantity_sold(after_promo)` * 2, `quantity_sold(after_promo)`))
        - SUM(`quantity_sold(before_promo)`)) / 1000, 2)AS ISU
FROM retail_events_db.fact_events AS f join retail_events_db.dim_products as p
on p.product_code=f.product_code join retail_events_db.dim_campaigns as c on c.campaign_id =f.campaign_id
where c.campaign_name='Diwali'
GROUP BY c.campaign_name, p.category
order by ISU desc;

SELECT c.campaign_name,p.category,
ROUND((
SUM(IF(f.promo_type = 'BOGOF', `quantity_sold(after_promo)` * 2, `quantity_sold(after_promo)`))
        - SUM(`quantity_sold(before_promo)`)) / 1000, 2)AS ISU
FROM retail_events_db.fact_events AS f join retail_events_db.dim_products as p
on p.product_code=f.product_code join retail_events_db.dim_campaigns as c on c.campaign_id =f.campaign_id
where c.campaign_name!='Diwali'
GROUP BY c.campaign_name, p.category
order by ISU desc;
#Q2
SELECT p.product_name,category,ROUND((
SUM(IF(f.promo_type = 'BOGOF', `quantity_sold(after_promo)` * 2, `quantity_sold(after_promo)`))
        - SUM(`quantity_sold(before_promo)`)) / 1000, 2)AS ISU
FROM retail_events_db.fact_events AS f join retail_events_db.dim_products as p
on p.product_code=f.product_code
GROUP BY product_name,category
order by ISU desc limit 10;
SELECT p.category,p.product_name,ROUND((
SUM(IF(f.promo_type = 'BOGOF', `quantity_sold(after_promo)` * 2, `quantity_sold(after_promo)`))
        - SUM(`quantity_sold(before_promo)`)) / 1000, 2)AS ISU
FROM retail_events_db.fact_events AS f join retail_events_db.dim_products as p
on p.product_code=f.product_code
GROUP BY category,p.product_name
order by ISU limit 10;
#Q3
select p.category,f.promo_type,
round(sum(base_price*`quantity_sold(before_promo)`)/1000,2) as revenue_before,
 round(sum(ROUND(CASE
    WHEN promo_type = 'BOGOF' THEN base_price * 0.5 * (`quantity_sold(after_promo)` * 2)
    WHEN promo_type = '500 Cashback' THEN (base_price - 500) * `quantity_sold(after_promo)`
    WHEN promo_type = '50% OFF' THEN base_price * 0.5 * `quantity_sold(after_promo)`
    WHEN promo_type = '33% OFF' THEN base_price * 0.67 * `quantity_sold(after_promo)`
    WHEN promo_type = '25% OFF' THEN base_price * 0.75 * `quantity_sold(after_promo)`
    ELSE NULL
  END,2))/1000,2) as revenue_after
from retail_events_db.fact_events as f join retail_events_db.dim_products as p
on f.product_code=p.product_code
group by p.category,f.promo_Type ;

