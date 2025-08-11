#Q1
select promo_type,
concat(round((sum(case
			WHEN promo_type = 'BOGOF' THEN base_price * 0.5 * (`quantity_sold(after_promo)` * 2)
            WHEN promo_type = '500 Cashback' THEN (base_price - 500) * `quantity_sold(after_promo)`
            WHEN promo_type = '50% OFF' THEN base_price * 0.5 * `quantity_sold(after_promo)`
            WHEN promo_type = '33% OFF' THEN base_price * 0.67 * `quantity_sold(after_promo)`
            WHEN promo_type = '25% OFF' THEN base_price * 0.75 * `quantity_sold(after_promo)`
            ELSE 0 end)- sum(base_price*`quantity_sold(before_promo)`))/1000000,2),"M") as IR
from retail_events_db.fact_events
group by promo_type
order by IR desc;
#Q2
SELECT promo_type,ROUND((
SUM(IF(f.promo_type = 'BOGOF', `quantity_sold(after_promo)` * 2, `quantity_sold(after_promo)`))
        - SUM(`quantity_sold(before_promo)`)) / 1000, 2)AS ISU
FROM retail_events_db.fact_events AS f 
GROUP BY promo_type
order by ISU;
#Q3
select promo_type,
concat(round(sum(base_price*`quantity_sold(before_promo)`)/1000000,2),"M") as revenue_before,
 concat(round(sum(ROUND(CASE
    WHEN promo_type = 'BOGOF' THEN base_price * 0.5 * (`quantity_sold(after_promo)` * 2)
    WHEN promo_type = '500 Cashback' THEN (base_price - 500) * `quantity_sold(after_promo)`
    WHEN promo_type = '50% OFF' THEN base_price * 0.5 * `quantity_sold(after_promo)`
    WHEN promo_type = '33% OFF' THEN base_price * 0.67 * `quantity_sold(after_promo)`
    WHEN promo_type = '25% OFF' THEN base_price * 0.75 * `quantity_sold(after_promo)`
    ELSE NULL
  END,2))/1000000,2),"M") as revenue_after
from retail_events_db.fact_events
group by promo_type ;