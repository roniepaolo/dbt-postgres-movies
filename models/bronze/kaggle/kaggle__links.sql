select *
from {{ source('bronze', 'links') }}
