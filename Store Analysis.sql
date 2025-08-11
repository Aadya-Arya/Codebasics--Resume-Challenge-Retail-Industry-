#Q1
select s.store_id, 
concat(round((sum(case
			WHEN promo_type = 'BOGOF' THEN base_price * 0.5 * (`quantity_sold(after_promo)` * 2)
            WHEN promo_type = '500 Cashback' THEN (base_price - 500) * `quantity_sold(after_promo)`
            WHEN promo_type = '50% OFF' THEN base_price * 0.5 * `quantity_sold(after_promo)`
            WHEN promo_type = '33% OFF' THEN base_price * 0.67 * `quantity_sold(after_promo)`
            WHEN promo_type = '25% OFF' THEN base_price * 0.75 * `quantity_sold(after_promo)`
            ELSE 0 end)- sum(base_price*`quantity_sold(before_promo)`))/1000000,2),"M") as IR
from retail_events_db.fact_events as f join retail_events_db.dim_stores as s
on s.store_id = f.store_id
group by s.store_id
order by IR desc limit 10;
#Q2
SELECT s.store_id,ROUND((
SUM(IF(f.promo_type = 'BOGOF', `quantity_sold(after_promo)` * 2, `quantity_sold(after_promo)`))
        - SUM(`quantity_sold(before_promo)`)) / 1000, 2)AS ISU
FROM retail_events_db.fact_events AS f 
JOIN retail_events_db.dim_stores AS s ON s.store_id = f.store_id
GROUP BY s.store_id
order by ISU limit 10;
#Q3
select s.store_id, s.city,f.promo_type,
round((sum(case
			WHEN promo_type = 'BOGOF' THEN base_price * 0.5 * (`quantity_sold(after_promo)` * 2)
            WHEN promo_type = '500 Cashback' THEN (base_price - 500) * `quantity_sold(after_promo)`
            WHEN promo_type = '50% OFF' THEN base_price * 0.5 * `quantity_sold(after_promo)`
            WHEN promo_type = '33% OFF' THEN base_price * 0.67 * `quantity_sold(after_promo)`
            WHEN promo_type = '25% OFF' THEN base_price * 0.75 * `quantity_sold(after_promo)`
            ELSE 0 end)- sum(base_price*`quantity_sold(before_promo)`))/1000000,2) as IR
from retail_events_db.fact_events as f join retail_events_db.dim_stores as s
on s.store_id = f.store_id
group by s.store_id, s.city,f.promo_type
order by IR desc limit 10;