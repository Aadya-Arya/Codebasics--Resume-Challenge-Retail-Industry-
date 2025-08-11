select *,rank() over (order by INR desc) as INR_rank
from (select p.product_name,p.category,
 ROUND((SUM(CASE
            WHEN promo_type = 'BOGOF' THEN base_price * 0.5 * (`quantity_sold(after_promo)` * 2)
            WHEN promo_type = '500 Cashback' THEN (base_price - 500) * `quantity_sold(after_promo)`
            WHEN promo_type = '50% OFF' THEN base_price * 0.5 * `quantity_sold(after_promo)`
            WHEN promo_type = '33% OFF' THEN base_price * 0.67 * `quantity_sold(after_promo)`
            WHEN promo_type = '25% OFF' THEN base_price * 0.75 * `quantity_sold(after_promo)`
            ELSE 0
          END) - SUM(base_price * `quantity_sold(before_promo)`))/
          NULLIF(SUM(base_price * `quantity_sold(before_promo)`), 0),3)*100 AS INR
    from retail_events_db.fact_events as f
  join retail_events_db.dim_products as p on p.product_code = f.product_code
  group by p.product_name,p.category) as sub limit 5;
  