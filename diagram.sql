conn sys@xe as sysdba
set sqlformat ansiconsole
with ts_details as
(
    select rpad(tablespace_name,30, ' ')||' '||lpad(floor(used_percent), 3, ' ') as ts_line,
        used_percent
    from dba_tablespace_usage_metrics
)
select
    case
        when used_percent > 70 then '@|bg_red '||ts_line||'|@'
        when used_percent < 1 then '@|bg_green '||ts_line||'|@'
        else '@|bg_yellow '||ts_line||'|@'
    end as ts_usage_percentage
from ts_details
/
