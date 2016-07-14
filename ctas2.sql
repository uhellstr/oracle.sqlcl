conn hr@xe
set sqlformat ansiconsole
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform, 'STORAGE', false);
ctas employees t1;
