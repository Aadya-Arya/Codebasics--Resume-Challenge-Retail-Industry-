select c.campaign_name,  
concat(round(sum(base_price*`quantity_sold(before_promo)`)/1000000,2),"M") as revenue_before,
 concat(round(sum(ROUND(CASE
    WHEN promo_type = 'BOGOF' THEN base_price * 0.5 * (`quantity_sold(after_promo)` * 2)
    WHEN promo_type = '500 Cashback' THEN (base_price - 500) * `quantity_sold(after_promo)`
    WHEN promo_type = '50% OFF' THEN base_price * 0.5 * `quantity_sold(after_promo)`
    WHEN promo_type = '33% OFF' THEN base_price * 0.67 * `quantity_sold(after_promo)`
    WHEN promo_type = '25% OFF' THEN base_price * 0.75 * `quantity_sold(after_promo)`
    ELSE NULL
  END,2))/1000000,2),"M") as revenue_after
from retail_events_db.dim_campaigns as c join retail_events_db.fact_events as f
on c.campaign_id=f.campaign_id
group by campaign_name;