select *,rank() over (order by ISU_total desc) as ISU_rank
from (select p.category,
round((sum(if(f.promo_type = 'BOGOF', `quantity_sold(after_promo)` * 2, `quantity_sold(after_promo)`))
        - sum(`quantity_sold(before_promo)`)) / nullif(sum(`quantity_sold(before_promo)`), 0) * 100, 2) as ISU_total
  from retail_events_db.fact_events as f
  join retail_events_db.dim_products as p on p.product_code = f.product_code
  join retail_events_db.dim_campaigns as c on f.campaign_id = c.campaign_id
  where c.campaign_name = 'Diwali'
  group by p.category) as sub;
