select distinct(product_name), base_price 
from retail_events_db.dim_products as p join retail_events_db.fact_events as f
on p.product_code=f.product_code 
where base_price>500 and promo_type='BOGOF'
 