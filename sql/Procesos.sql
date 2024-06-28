-- Ejecutar en SqlPlus
-- Configurar el número máximo de procesos DBWR a 10
ALTER SYSTEM SET db_writer_processes = 10 SCOPE = SPFILE;

-- Controlar el número máximo de procesos ARCn a 10
ALTER SYSTEM SET log_archive_max_processes = 10 SCOPE = SPFILE;

-- SQL*Plus o PL/SQL Developer
-- Comprobar el tiempo de vida o actividad (uptime) de una base de datos con el PMON
SELECT to_char(startup_time, 'YYYY-MM-DD HH24:MI:SS') AS startup_time 
FROM v$instance;

-- Ejecutar en SqlPlus
-- Configurar que los checkpoints se realicen cada 4 segundos
ALTER SYSTEM SET log_checkpoint_timeout = 4 SCOPE = BOTH;

-- Ejecutar en SQL*Plus o PL/SQL Developer
-- Comprobar si el SMON está ejecutándose en mi B/D (Query)
SELECT p.spid, p.username, p.program 
FROM v$process p, v$bgprocess b 
WHERE p.addr = b.paddr AND b.name = 'SMON';

-- Conéctate como SYSDBA
sqlplus / as sysdba

-- Crear usuarios
CREATE USER user1 IDENTIFIED BY password1;
CREATE USER user2 IDENTIFIED BY password2;
CREATE USER user3 IDENTIFIED BY password3;
CREATE USER user4 IDENTIFIED BY password4;
CREATE USER user5 IDENTIFIED BY password5;

-- Asignar privilegios a los usuarios
GRANT CONNECT, RESOURCE TO user1;
GRANT CONNECT, RESOURCE TO user2;
GRANT CONNECT, RESOURCE TO user3;
GRANT CONNECT, RESOURCE TO user4;
GRANT CONNECT, RESOURCE TO user5;

-- Simulación de conexiones y ejecución de queries
-- Conéctate como user1 y ejecutar una consulta larga
sqlplus user1/password1@your_database
SELECT * FROM large_table WHERE ROWNUM <= 10000 ORDER BY some_column;

-- Conéctate como user2 y ejecutar otra consulta larga
sqlplus user2/password2@your_database
SELECT COUNT(*) FROM large_table GROUP BY another_column;

-- Conéctate como user3 y ejecutar una consulta que cause alta carga
sqlplus user3/password3@your_database
SELECT /*+ FULL(large_table) */ * FROM large_table WHERE some_column LIKE '%value%';

-- Conéctate como user4 y ejecutar una consulta con join
sqlplus user4/password4@your_database
SELECT a.*, b.* FROM large_table a JOIN another_table b ON a.id = b.id WHERE ROWNUM <= 10000;

-- Conéctate como user5 y ejecutar una consulta con agregaciones
sqlplus user5/password5@your_database
SELECT some_column, AVG(another_column) FROM large_table GROUP BY some_column;

-- Identificar el query que más recursos consume
sqlplus / as sysdba
SELECT s.sid, s.serial#, s.username, s.program, t.sql_id, t.sql_fulltext
FROM v$session s
JOIN v$sqlarea t ON s.sql_id = t.sql_id
ORDER BY s.last_call_et DESC;

-- Eliminar (Kill) la sesión que más recursos consume
-- ejemplo la sesión con SID 123 y SERIAL# 456 es la que consume más recursos
ALTER SYSTEM KILL SESSION '123,456'; -- OJO: cambiar el SID y el Serial a la consulta que mas consume recursos

-- Cree un escenario en el que un QUERY(Consulta) está causando un BLOQUEO sobre un objeto de B/D (tabla) y  realice el DESBLOQUEO del proceso 
-- Crear una tabla de prueba
CREATE TABLE test_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100)
);

-- Insertar datos en la tabla
INSERT INTO test_table VALUES (1, 'First Row');
INSERT INTO test_table VALUES (2, 'Second Row');

-- Sesión 1: Iniciar transacción y bloquear la tabla
-- Conéctate como user1
sqlplus user1/password1@your_database

-- Iniciar transacción y bloquear la tabla
BEGIN
    UPDATE test_table SET name = 'Updated Name' WHERE id = 1;
    COMMIT;
END;

-- Sesión 2: Intentar actualizar la misma fila, resultando en bloqueo
-- Conéctate como user2
sqlplus user2/password2@your_database

-- Intentar actualizar la misma fila, lo que resultará en un bloqueo
BEGIN
    UPDATE test_table SET name = 'New Name' WHERE id = 1;
    -- La transacción se quedará en espera debido al bloqueo
END;

-- Identificar la sesión que está bloqueando
-- Conéctate como SYSDBA
sqlplus / as sysdba

-- Identificar la sesión que está bloqueando
SELECT l.session_id AS blocker_sid, l.locked_mode, s.sid, s.serial#, s.username, s.status
FROM v$lock l
JOIN v$session s ON l.session_id = s.sid
WHERE l.block = 1;

-- Desbloquear el proceso (asumiendo SID 123 y SERIAL# 456)
ALTER SYSTEM KILL SESSION '123,456';



