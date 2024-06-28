--Memoria 
-- Esto se ejecuta en desde la terminal SQL PLUS
sqlplus / as sysdba

SHOW PARAMETER sga_target;
SHOW PARAMETER large_pool_size;
SHOW PARAMETER shared_pool_size;
SHOW PARAMETER db_cache_size;
SHOW PARAMETER log_buffer;
SHOW PARAMETER pga_aggregate_target;
SHOW PARAMETER shared_servers;
SHOW PARAMETER dispatchers;
SHOW PARAMETER processes;
SHOW PARAMETER sessions;

ALTER SYSTEM SET sga_target = 500M SCOPE = SPFILE;
ALTER SYSTEM SET large_pool_size = 5M SCOPE = SPFILE;
ALTER SYSTEM SET shared_pool_size = 5M SCOPE = SPFILE;
ALTER SYSTEM SET db_cache_size = 3M SCOPE = SPFILE;
ALTER SYSTEM SET log_buffer = 2M SCOPE = SPFILE;
ALTER SYSTEM SET pga_aggregate_target = 200M SCOPE = SPFILE;
ALTER SYSTEM SET SHARED_SERVERS = 5 SCOPE = BOTH;
ALTER SYSTEM SET DISPATCHERS = '(PROTOCOL=TCP)(DISPATCHERS=3)' SCOPE = BOTH;
ALTER SYSTEM SET processes = 200 SCOPE = SPFILE;
ALTER SYSTEM SET sessions = 300 SCOPE = SPFILE;

-- Es necesario reiniciar para ver los cambios
SHUTDOWN IMMEDIATE;
STARTUP;

-- Verificar los cambios
SHOW PARAMETER sga_target;
SHOW PARAMETER large_pool_size;
SHOW PARAMETER shared_pool_size;
SHOW PARAMETER db_cache_size;
SHOW PARAMETER log_buffer;
SHOW PARAMETER pga_aggregate_target;
SHOW PARAMETER shared_servers;
SHOW PARAMETER dispatchers;
SHOW PARAMETER processes;
SHOW PARAMETER sessions;

