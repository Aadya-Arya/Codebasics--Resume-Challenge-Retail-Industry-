select city, count(*) as store_count 
from retail_events_db.dim_stores as s
group by city order by store_count desc;