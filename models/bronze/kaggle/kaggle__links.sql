with ds as (
  select *
  from {{ source('bronze', 'links') }}
)
select *
from ds;
