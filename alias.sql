set echo off
alias monitor=
with vs as (
  select
    rownum rnum,
    inst_id,
    sid,
    serial#,
    status,
    username,
    last_call_et,
    command,
    machine,
    osuser,
    module,
    action,
    resource_consumer_group,
    client_info,
    client_identifier,
    type,
    terminal,
    sql_id,
    sql_child_number
  from
    gv$session
)
select
  vs.inst_id,
  vs.sid,
  serial#                                                                      serial,
  vs.sql_id,
  vs.sql_child_number,
  vs.username                                                                  "Username",
  case
    when vs.status = 'ACTIVE' then
      last_call_et
    else
      null
  end "Seconds in Wait",
  (
    select
      command_name
    from
      v$sqlcommand
    where
      command_type = vs.command
  )     "Command",
  vs.machine                                                                   "Machine",
  vs.osuser                                                                    "OS User",
  lower(
    vs.status
  )                                                             "Status",
  vs.module                                                                    "Module",
  vs.action                                                                    "Action",
  vs.resource_consumer_group,
  vs.client_info,
  vs.client_identifier
from
  vs
where
  vs.username is not null
  and nvl(
    vs.osuser, 'x'
  ) <> 'SYSTEM'
  and vs.type <> 'BACKGROUND'
order by
  1,
  2,
  3;

alias explan=select * from table(DBMS_XPLAN.DISPLAY(FORMAT=>'ALL +OUTLINE'));

alias explain_sql = SELECT * FROM TABLE(DBMS_XPLAN.display_cursor(sql_id=>:sqlid,
                                      format=>'ALLSTATS LAST +cost +bytes  +outline'));
alias cls=clear screen

 alias top=
SELECT
    SQL, SQL_ID, CPU_SECONDS_FORM CPU, ELAPSED_SECONDS_FORM ELAPSED, DISK_READS, BUFFER_GETS, EXECUTIONS_FORM EXECS, MODULE, LAST_ACTIVE_TIME_FORM
FROM
    (
        SELECT
            D.*
            ,ROWNUM ROW#
        FROM
            (
                SELECT
                    D.*
                FROM
                    (
                        SELECT
                            substr(SQL_TEXT, 1, 25) AS SQL
                            ,S.CPU_TIME / 1000000 AS CPU_SECONDS
                                ,CASE WHEN
                                    S.CPU_TIME < 1000
                                THEN
                                    '< 1 ms'
                                WHEN
                                    S.CPU_TIME < 1000000
                                THEN
                                    TO_CHAR(ROUND(S.CPU_TIME / 1000,1) )
                                     ||  ' ms'
                                WHEN
                                    S.CPU_TIME < 60000000
                                THEN
                                    TO_CHAR(ROUND(S.CPU_TIME / 1000000,1) )
                                     ||  ' s'
                                ELSE
                                    TO_CHAR(ROUND(S.CPU_TIME / 60000000,1) )
                                     ||  ' m'
                                END
                            AS CPU_SECONDS_FORM
                            ,DECODE(L.MAX_CPU_TIME,0,0,S.CPU_TIME / L.MAX_CPU_TIME) AS CPU_SECONDS_PROP
                            ,S.ELAPSED_TIME / 1000000 AS ELAPSED_SECONDS
                                ,CASE WHEN
                                    S.ELAPSED_TIME < 1000
                                THEN
                                    '< 1 ms'
                                WHEN
                                    S.ELAPSED_TIME < 1000000
                                THEN
                                    TO_CHAR(ROUND(S.ELAPSED_TIME / 1000,1) )
                                     ||  ' ms'
                                WHEN
                                    S.ELAPSED_TIME < 60000000
                                THEN
                                    TO_CHAR(ROUND(S.ELAPSED_TIME / 1000000,1) )
                                     ||  ' s'
                                ELSE
                                    TO_CHAR(ROUND(S.ELAPSED_TIME / 60000000,1) )
                                     ||  ' m'
                                END
                            AS ELAPSED_SECONDS_FORM
                            ,DECODE(L.MAX_ELAPSED_TIME,0,0,S.ELAPSED_TIME / L.MAX_ELAPSED_TIME) AS ELAPSED_SECONDS_PROP
                            ,S.DISK_READS AS DISK_READS
                                ,CASE WHEN
                                    S.DISK_READS < 1000
                                THEN
                                    TO_CHAR(S.DISK_READS)
                                WHEN
                                    S.DISK_READS < 1000000
                                THEN
                                    TO_CHAR(ROUND(S.DISK_READS / 1000,1) )
                                     ||  'K'
                                WHEN
                                    S.DISK_READS < 1000000000
                                THEN
                                    TO_CHAR(ROUND(S.DISK_READS / 1000000,1) )
                                     ||  'M'
                                ELSE
                                    TO_CHAR(ROUND(S.DISK_READS / 1000000000,1) )
                                     ||  'G'
                                END
                            AS DISK_READS_FORM
                            ,DECODE(L.MAX_DISK_READS,0,0,S.DISK_READS / L.MAX_DISK_READS) AS DISK_READS_PROP
                            ,S.BUFFER_GETS AS BUFFER_GETS
                                ,CASE WHEN
                                    S.BUFFER_GETS < 1000
                                THEN
                                    TO_CHAR(S.BUFFER_GETS)
                                WHEN
                                    S.BUFFER_GETS < 1000000
                                THEN
                                    TO_CHAR(ROUND(S.BUFFER_GETS / 1000,1) )
                                     ||  'K'
                                WHEN
                                    S.BUFFER_GETS < 1000000000
                                THEN
                                    TO_CHAR(ROUND(S.BUFFER_GETS / 1000000,1) )
                                     ||  'M'
                                ELSE
                                    TO_CHAR(ROUND(S.BUFFER_GETS / 1000000000,1) )
                                     ||  'G'
                                END
                            AS BUFFER_GETS_FORM
                            ,DECODE(L.MAX_BUFFER_GETS,0,0,S.BUFFER_GETS / L.MAX_BUFFER_GETS) AS BUFFER_GETS_PROP
                            ,S.EXECUTIONS AS EXECUTIONS
                                ,CASE WHEN
                                    S.EXECUTIONS < 1000
                                THEN
                                    TO_CHAR(S.EXECUTIONS)
                                WHEN
                                    S.EXECUTIONS < 1000000
                                THEN
                                    TO_CHAR(ROUND(S.EXECUTIONS / 1000,1) )
                                     ||  'K'
                                WHEN
                                    S.EXECUTIONS < 1000000000
                                THEN
                                    TO_CHAR(ROUND(S.EXECUTIONS / 1000000,1) )
                                     ||  'M'
                                ELSE
                                    TO_CHAR(ROUND(S.EXECUTIONS / 1000000000,1) )
                                     ||  'G'
                                END
                            AS EXECUTIONS_FORM
                            ,DECODE(L.MAX_EXECUTIONS,0,0,S.EXECUTIONS / L.MAX_EXECUTIONS) AS EXECUTIONS_PROP
                            ,DECODE(S.MODULE,NULL,' ',S.MODULE) AS MODULE
                            ,S.LAST_ACTIVE_TIME AS LAST_ACTIVE_TIME
                            ,DECODE(S.LAST_ACTIVE_TIME,NULL,' ',TO_CHAR(S.LAST_ACTIVE_TIME,'DD-Mon-YYYY HH24:MI:SS') ) AS LAST_ACTIVE_TIME_FORM
                            ,S.SQL_ID AS SQL_ID
                            ,S.CHILD_NUMBER AS CHILD_NUMBER
                            ,S.INST_ID AS INST_ID
                        FROM
                            GV$SQL S
                            ,(
                                SELECT
                                    MAX(CPU_TIME) AS MAX_CPU_TIME
                                    ,MAX(ELAPSED_TIME) AS MAX_ELAPSED_TIME
                                    ,MAX(DISK_READS) AS MAX_DISK_READS
                                    ,MAX(BUFFER_GETS) AS MAX_BUFFER_GETS
                                    ,MAX(EXECUTIONS) AS MAX_EXECUTIONS
                                FROM
                                    GV$SQL
                            ) L
                    ) D
                ORDER BY
                    CPU_SECONDS_PROP DESC
                    ,SQL
                    ,DISK_READS_PROP
                    ,BUFFER_GETS_PROP
                    ,EXECUTIONS_PROP
                    ,ELAPSED_SECONDS_PROP
                    ,MODULE
                    ,LAST_ACTIVE_TIME
            ) D
    ) D
WHERE
    ROW# >= 1
AND
    ROW# <= :high;

alias wait =
SELECT  WAIT_CLASS,
        TOTAL_WAITS,
        ROUND(100 * (TOTAL_WAITS / SUM_WAITS),2) PCT_WAITS,
        ROUND((TIME_WAITED / 100),2) TIME_WAITED_SECS,
        ROUND(100 * (TIME_WAITED / SUM_TIME),2) PCT_TIME
FROM
(SELECT WAIT_CLASS,
        TOTAL_WAITS,
        TIME_WAITED
FROM    V$SYSTEM_WAIT_CLASS
WHERE   WAIT_CLASS != 'Idle'),
(SELECT  SUM(TOTAL_WAITS) SUM_WAITS,
        SUM(TIME_WAITED) SUM_TIME
FROM    V$SYSTEM_WAIT_CLASS
WHERE   WAIT_CLASS != 'Idle')
ORDER BY 5 desc;

alias sess_wait=SELECT  sess_id,
        username,
        PROGRAM,
        wait_event,
        sess_time,
        ROUND(100 * (sess_time / total_time),2) pct_time_waited
FROM
(SELECT A.session_id sess_id,
        DECODE(session_type,'background',session_type,c.username) username,
        A.PROGRAM PROGRAM,
        b.NAME wait_event,
        SUM(A.time_waited) sess_time
FROM    sys.v_$active_session_history A,
        sys.v_$event_name b,
        sys.dba_users c
WHERE   A.event# = b.event# AND
        A.user_id = c.user_id AND
        sample_time > TRUNC(SYSDATE) AND 
        sample_time < SYSDATE AND
        b.wait_class = 'User I/O'
GROUP BY A.session_id,
        DECODE(session_type,'background',session_type,c.username),
        A.PROGRAM,
        b.NAME),
(SELECT SUM(A.time_waited) total_time
FROM    sys.v_$active_session_history A,
        sys.v_$event_name b
WHERE   A.event# = b.event# AND
        sample_time > TRUNC(SYSDATE) AND 
        sample_time < SYSDATE AND
        b.wait_class = 'User I/O')
ORDER BY 6 desc;

alias plugdatabases = select con_id
       ,creation_time
       ,name
       ,open_mode
       ,restricted
       ,open_time
       ,total_size
       ,recovery_status
       ,application_root
       ,application_pdb
from v$pdbs
order by creation_time,name;

alias num_pdbs = select count(*)
from v$pdbs
where open_mode = 'READ WRITE';

