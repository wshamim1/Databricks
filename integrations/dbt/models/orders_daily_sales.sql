select
    order_date,
    region,
    count(distinct order_id) as order_count,
    sum(amount) as gross_sales
from {{ source('silver', 'orders_silver') }}
where order_status = 'completed'
group by order_date, region