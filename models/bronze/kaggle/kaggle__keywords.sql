select *
from {{ source('bronze', 'keywords') }}
