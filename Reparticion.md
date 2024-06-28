## Plazo de entrega: antes del **5 de junio 8PM**
- Se los espera que halla enviado su video y su documento antes del **5 de junio 8PM**
## Orden 
Realizar el video y la documentación para explicando sobre la administración de nuestra base de datos (procesos, archivos y memoria) y las 10 consultas avanzadas SQL.

## Repartición
Cada uno hace son 30 puntos por lo que a cada quien le corresponde trabajar 5 puntos
Esto es lo que le toca a cada quien hacer en el video de **MAXIMO  2 MINUTOS 30 SEGUNDOS CADA PERSONA**:

![[Pasted image 20240529170343.png]]
- Walter: me encargaré también de explica la tabla de las 10 consultas avanzadas, juntar los videos y documentos de todos y calificar el aporte de cada uno de los integrantes en el documento de calificación con honestidad.
## Entrega
## Material de entrega
Se debe entrar por el grupo de WhatsApp lo siguiente:
- **Archivo comprimido con el video de su explicación**
- Documento word con todas las **capturas + una breve explicación por cada captura**


## Materiales de ejemplo
### Video de ejemplo
[Ejemplo de la Explicacion Proyecto BDA - YouTube](https://www.youtube.com/watch?v=WDyDrYNWHaY) 
### Documentación de ejemplo
[CAPTURAS DE COMPILACION.docx](https://1drv.ms/w/s!Arv2uTNxQcCahA4iWzPhtPZHpUYo?e=lE3ZnP)

## Código de guía para ejecutar en sql Plus y/o Pl Sql Developer

### Instancia y memoria
```sql
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
```

### Procesos
```sql
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
```

### Archivos
```sql
-- 1. Configurar Flash Recovery Area
ALTER SYSTEM SET DB_RECOVERY_FILE_DEST = 'C:\copias_seguridad\' SCOPE = BOTH;

-- 2. Configurar Backups Automáticos del Control File y SPFILE
CONFIGURE CONTROLFILE AUTOBACKUP ON;

-- 3. Realizar una Copia de Seguridad del Tablespace y sus Datafiles con RMAN
RMAN> BACKUP AS COPY TABLESPACE tablespace_name;

-- 4. Eliminar Datafiles Físicamente en el Sistema Operativo
-- Realiza la eliminación física de los archivos de datos correspondientes a los datafiles que deseas eliminar.
-- Esto puede variar dependiendo del sistema operativo, pero típicamente sería algo como:
-- DEL C:\ruta\datafile1.dbf
-- DEL C:\ruta\datafile2.dbf

-- 5. Realizar Restore y Recovery con RMAN de la Copia de Seguridad
RMAN> RESTORE TABLESPACE tablespace_name;
RMAN> RECOVER TABLESPACE tablespace_name;

-- 6. Configurar el Tamaño de los Control Files
ALTER DATABASE
   DATAFILE 'controlfile_path/control01.ctl' RESIZE 3M;

-- 7. Configurar el Archivo SPFILE.ORA
-- Edita el archivo SPFILE.ORA según las configuraciones y las mejores prácticas que desees aplicar.

-- 8. Configurar una Ubicación para Archivos Redo Logs
ALTER SYSTEM SET LOG_FILE_NAME_CONVERT='C:\ruta\redo\', 'F:\ruta\redo\' SCOPE=SPFILE;
```

### Seguridad
```sql
-- 1. Crear Usuario Administrador/Propietario
CREATE USER administrador IDENTIFIED BY contraseña;
GRANT DBA TO administrador;

-- 2. Crear los Cuatro Roles Especificados

-- Rol Gerente:
CREATE ROLE gerente;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES TO gerente;
GRANT CREATE SESSION TO gerente;

-- Rol Jefe:
CREATE ROLE jefe;
GRANT SELECT, UPDATE ON ALL TABLES TO jefe;
GRANT CREATE SESSION TO jefe;

-- Rol Operador:
CREATE ROLE operador;
GRANT SELECT ON ALL TABLES TO operador;
GRANT CREATE SESSION TO operador;

-- Rol Desarrollador:
CREATE ROLE desarrollador;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES TO desarrollador;
GRANT CREATE TABLE, DROP TABLE, CREATE PROCEDURE, CREATE FUNCTION TO desarrollador;
GRANT CREATE SESSION TO desarrollador;

-- Crear 12 usuarios con los roles especificados

-- Usuarios con rol de Gerente
CREATE USER gerente1 IDENTIFIED BY contraseña1;
GRANT gerente TO gerente1;

CREATE USER gerente2 IDENTIFIED BY contraseña2;
GRANT gerente TO gerente2;

-- Usuarios con rol de Jefe
CREATE USER jefe1 IDENTIFIED BY contraseña1;
GRANT jefe TO jefe1;

CREATE USER jefe2 IDENTIFIED BY contraseña2;
GRANT jefe TO jefe2;

CREATE USER jefe3 IDENTIFIED BY contraseña3;
GRANT jefe TO jefe3;

CREATE USER jefe4 IDENTIFIED BY contraseña4;
GRANT jefe TO jefe4;

-- Usuarios con rol de Operador
CREATE USER operador1 IDENTIFIED BY contraseña1;
GRANT operador TO operador1;

CREATE USER operador2 IDENTIFIED BY contraseña2;
GRANT operador TO operador2;

CREATE USER operador3 IDENTIFIED BY contraseña3;
GRANT operador TO operador3;

CREATE USER operador4 IDENTIFIED BY contraseña4;
GRANT operador TO operador4;

CREATE USER operador5 IDENTIFIED BY contraseña5;
GRANT operador TO operador5;

-- Usuario con rol de Desarrollador
CREATE USER desarrollador1 IDENTIFIED BY contraseña1;
GRANT desarrollador TO desarrollador1;

-- Configurar autenticación del usuario Desarrollador a través del sistema operativo

-- Crear un usuario Desarrollador identificado externamente
CREATE USER desarrollador IDENTIFIED EXTERNALLY;

-- Asignar el rol Desarrollador al usuario Desarrollador
GRANT desarrollador TO desarrollador;

-- Configurar la autenticación del sistema operativo para el usuario Desarrollador
ALTER USER desarrollador IDENTIFIED EXTERNALLY;

-- Configurar autenticación a través de la base de datos para los usuarios restantes

-- Cambiar la autenticación de los usuarios a través de la base de datos
ALTER USER gerente1 IDENTIFIED BY contraseña1;
ALTER USER gerente2 IDENTIFIED BY contraseña2;
ALTER USER jefe1 IDENTIFIED BY contraseña1;
ALTER USER jefe2 IDENTIFIED BY contraseña2;
ALTER USER jefe3 IDENTIFIED BY contraseña3;
ALTER USER jefe4 IDENTIFIED BY contraseña4;
ALTER USER operador1 IDENTIFIED BY contraseña1;
ALTER USER operador2 IDENTIFIED BY contraseña2;
ALTER USER operador3 IDENTIFIED BY contraseña3;
ALTER USER operador4 IDENTIFIED BY contraseña4;
ALTER USER operador5 IDENTIFIED BY contraseña5;

-- Crear perfiles de recursos
CREATE PROFILE recurso_mayor LIMIT SESSIONS_PER_USER 5 CPU_PER_SESSION 10000 CPU_PER_CALL 20000;
CREATE PROFILE recurso_menor LIMIT SESSIONS_PER_USER 3 CPU_PER_SESSION 5000 CPU_PER_CALL 10000;

-- Asignar perfiles a los roles correspondientes
ALTER USER gerente1 PROFILE recurso_mayor;
ALTER USER gerente2 PROFILE recurso_mayor;
ALTER USER jefe1 PROFILE recurso_mayor;
ALTER USER jefe2 PROFILE recurso_mayor;
ALTER USER jefe3 PROFILE recurso_mayor;
ALTER USER jefe4 PROFILE recurso_mayor;
ALTER USER operador1 PROFILE recurso_menor;
ALTER USER operador2 PROFILE recurso_menor;
ALTER USER operador3 PROFILE recurso_menor;
ALTER USER operador4 PROFILE recurso_menor;
ALTER USER operador5 PROFILE recurso_menor;
ALTER USER desarrollador1 PROFILE recurso_menor;

-- Crear el perfil recurso_mayor
CREATE PROFILE recurso_mayor LIMIT
    SESSIONS_PER_USER UNLIMITED
    IDLE_TIME 1800
    PASSWORD_LIFE_TIME 120
    PASSWORD_REUSE_MAX 5
    PASSWORD_REUSE_TIME UNLIMITED
    PASSWORD_LOCK_TIME UNLIMITED
    PASSWORD_GRACE_TIME 20;

-- Crear el perfil recurso_menor
CREATE PROFILE recurso_menor LIMIT
    SESSIONS_PER_USER UNLIMITED
    IDLE_TIME 1200
    PASSWORD_LIFE_TIME 60
    PASSWORD_REUSE_MAX 3
    PASSWORD_REUSE_TIME UNLIMITED
    PASSWORD_LOCK_TIME UNLIMITED
    PASSWORD_GRACE_TIME 10;

-- 29. Crear una tabla de usuario que almacene las contraseñas encriptadas

-- Crear la tabla para almacenar las contraseñas encriptadas
CREATE TABLE tabla_contraseñas (
    usuario VARCHAR2(50),
    contraseña_encriptada VARCHAR2(100)
);

-- 30. Asignar permiso de ejecución sólo al usuario con Rol de Desarrollador
-- para que pueda ejecutar las funciones de encriptación y desencriptación

-- Crear las funciones de encriptación y desencriptación
CREATE OR REPLACE FUNCTION encriptar_contraseña(p_contraseña IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
    -- Lógica de encriptación (por ejemplo, hash SHA-256)
    RETURN DBMS_CRYPTO.HASH(p_contraseña, DBMS_CRYPTO.HASH_SH256);
END;

CREATE OR REPLACE FUNCTION desencriptar_contraseña(p_contraseña_encriptada IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
    -- En este caso, no es posible desencriptar una contraseña hash
    RETURN NULL;
END;

-- Asignar permisos de ejecución solo al rol Desarrollador
GRANT EXECUTE ON encriptar_contraseña TO desarrollador;
GRANT EXECUTE ON desencriptar_contraseña TO desarrollador;
```

## Esta es nuestra tabla de pedidos YA con sus datos y sus 10 consultas avanzadas
```sql
CREATE TABLE clientes (
  cliente_id INT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  direccion VARCHAR(255) NOT NULL,
  ciudad VARCHAR(50) NOT NULL,
  telefono VARCHAR(20) NOT NULL,
  correo_electronico VARCHAR(50)
);

CREATE TABLE direcciones (
  direccion_id INT PRIMARY KEY,
  calle VARCHAR(255) NOT NULL,
  numero_exterior INT NOT NULL,
  numero_interior INT,
  barrio VARCHAR(50) NOT NULL,
  ciudad VARCHAR(50) NOT NULL,
  codigo_postal VARCHAR(10) NOT NULL,
  cliente_id INT,
  FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

CREATE TABLE paquetes (
  paquete_id INT PRIMARY KEY,
  descripcion VARCHAR(255) NOT NULL,
  dimensiones DECIMAL(10,2) NOT NULL,
  peso DECIMAL(10,2) NOT NULL,
  valor_declarado DECIMAL(10,2) NOT NULL,
  cliente_id INT,
  direccion_origen_id INT,
  direccion_destino_id INT,
  FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
  FOREIGN KEY (direccion_origen_id) REFERENCES direcciones(direccion_id),
  FOREIGN KEY (direccion_destino_id) REFERENCES direcciones(direccion_id)
);

CREATE TABLE tarifas (
  tarifa_id INT PRIMARY KEY,
  tipo_servicio VARCHAR(50) NOT NULL,
  destino VARCHAR(50) NOT NULL,
  precio_base DECIMAL(10,2) NOT NULL,
  precio_kg_adicional DECIMAL(10,2) NOT NULL
);

CREATE TABLE rutas (
  ruta_id INT PRIMARY KEY,
  nombre_ruta VARCHAR(50) NOT NULL,
  descripcion VARCHAR(255) NOT NULL,
  puntos_intermedios VARCHAR(255)
);

CREATE TABLE asignaciones_rutas (
  asignacion_id INT PRIMARY KEY,
  ruta_id INT,
  paquete_id INT,
  FOREIGN KEY (ruta_id) REFERENCES rutas(ruta_id),
  FOREIGN KEY (paquete_id) REFERENCES paquetes(paquete_id)
);

CREATE TABLE estados_paquetes (
  estado_id INT PRIMARY KEY,
  descripcion VARCHAR(50) NOT NULL
);

CREATE TABLE historial_estados_paquetes (
  historial_id INT PRIMARY KEY,
  paquete_id INT,
  estado_id INT,
  fecha_hora DATE NOT NULL,
  FOREIGN KEY (paquete_id) REFERENCES paquetes(paquete_id),
  FOREIGN KEY (estado_id) REFERENCES estados_paquetes(estado_id)
);

CREATE TABLE pagos (
  pago_id INT PRIMARY KEY,
  paquete_id INT,
  metodo_pago VARCHAR(50) NOT NULL,
  fecha_pago DATE NOT NULL,
  monto_pagado DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (paquete_id) REFERENCES paquetes(paquete_id)
);

CREATE TABLE cobranzas (
  cobro_id INT PRIMARY KEY,
  paquete_id INT,
  fecha_vencimiento DATE NOT NULL,
  monto_cobrar DECIMAL(10,2) NOT NULL,
  estado_cobro VARCHAR(50) NOT NULL,
  FOREIGN KEY (paquete_id) REFERENCES paquetes(paquete_id)
);


INSERT INTO clientes (cliente_id, nombre, apellido, direccion, ciudad, telefono, correo_electronico)
VALUES (1, 'Juan', 'P rez', 'Av. 12 de Octubre 23', 'Quito', '0987654321', 'juan.perez@email.com');
INSERT INTO clientes (cliente_id, nombre, apellido, direccion, ciudad, telefono, correo_electronico)
VALUES (2, 'Mar a', 'Garc a', 'Calle Rocafuerte 15', 'Cuenca', '0965432109', 'maria.garcia@email.com');
INSERT INTO clientes (cliente_id, nombre, apellido, direccion, ciudad, telefono, correo_electronico)
VALUES (3, 'Pedro', 'L pez', 'Av. Amazonas 56', 'Guayaquil', '0954321098', 'pedro.lopez@email.com');

INSERT INTO direcciones (direccion_id, calle, numero_exterior, numero_interior, barrio, ciudad, codigo_postal, cliente_id)
VALUES (1, 'Av. 12 de Octubre', 23, NULL, 'La Mariscal', 'Quito', '170101', 1);
INSERT INTO direcciones (direccion_id, calle, numero_exterior, numero_interior, barrio, ciudad, codigo_postal, cliente_id)
VALUES (2, 'Calle Rocafuerte', 15, NULL, 'Centro Hist rico', 'Cuenca', '010101', 2);
INSERT INTO direcciones (direccion_id, calle, numero_exterior, numero_interior, barrio, ciudad, codigo_postal, cliente_id)
VALUES (3, 'Av. Amazonas', 56, NULL, 'Urdesa', 'Guayaquil', '090909', 3);
INSERT INTO direcciones (direccion_id, calle, numero_exterior, numero_interior, barrio, ciudad, codigo_postal, cliente_id)
VALUES (4, 'Calle Rocafuerte', 10, NULL, 'Centro Hist rico', 'Cuenca', '010101', 2);

INSERT INTO paquetes (paquete_id, descripcion, dimensiones, peso, valor_declarado, cliente_id, direccion_origen_id, direccion_destino_id)
VALUES (1, 'Laptop', 0.20, 2.5, 1200.00, 1, 1, 3);
INSERT INTO paquetes (paquete_id, descripcion, dimensiones, peso, valor_declarado, cliente_id, direccion_origen_id, direccion_destino_id)
VALUES (2, 'Celular', 0.10, 0.25, 500.00, 2, 2, 4);
INSERT INTO paquetes (paquete_id, descripcion, dimensiones, peso, valor_declarado, cliente_id, direccion_origen_id, direccion_destino_id)
VALUES (3, 'Libros', 0.30, 1.00, 150.00, 1, 1, 3);
INSERT INTO paquetes (paquete_id, descripcion, dimensiones, peso, valor_declarado, cliente_id, direccion_origen_id, direccion_destino_id)
VALUES (4, 'Ropa', 0.25, 0.75, 200.00, 3, 3, 1);

INSERT INTO tarifas (tarifa_id, tipo_servicio, destino, precio_base, precio_kg_adicional)
VALUES (1, 'Nacional', 'Quito', 10.00, 2.00);
INSERT INTO tarifas (tarifa_id, tipo_servicio, destino, precio_base, precio_kg_adicional)
VALUES (2, 'Nacional', 'Cuenca', 12.00, 2.50);
INSERT INTO tarifas (tarifa_id, tipo_servicio, destino, precio_base, precio_kg_adicional)
VALUES (3, 'Nacional', 'Guayaquil', 15.00, 3.00);
INSERT INTO tarifas (tarifa_id, tipo_servicio, destino, precio_base, precio_kg_adicional)
VALUES (4, 'Internacional', 'Estados Unidos', 50.00, 5.00);
INSERT INTO tarifas (tarifa_id, tipo_servicio, destino, precio_base, precio_kg_adicional)
VALUES (5, 'Internacional', 'Espa a', 45.00, 4.50);

INSERT INTO rutas (ruta_id, nombre_ruta, descripcion, puntos_intermedios)
VALUES (1, 'Ruta Norte', 'Ruta que conecta Quito con Cuenca', 'Quito - Latacunga - Ambato - Cuenca');
INSERT INTO rutas (ruta_id, nombre_ruta, descripcion, puntos_intermedios)
VALUES (2, 'Ruta Sur', 'Ruta que conecta Quito con Guayaquil', 'Quito - Riobamba - Guayaquil');
INSERT INTO rutas (ruta_id, nombre_ruta, descripcion, puntos_intermedios)
VALUES (3, 'Ruta Internacional', 'Ruta para env os internacionales', 'Quito - Aeropuerto Internacional Mariscal Sucre - Destino Internacional');

INSERT INTO asignaciones_rutas (asignacion_id, ruta_id, paquete_id)
VALUES (1, 1, 1);
INSERT INTO asignaciones_rutas (asignacion_id, ruta_id, paquete_id)
VALUES (2, 2, 2);
INSERT INTO asignaciones_rutas (asignacion_id, ruta_id, paquete_id)
VALUES (3, 1, 3);
INSERT INTO asignaciones_rutas (asignacion_id, ruta_id, paquete_id)
VALUES (4, 2, 4);

INSERT INTO estados_paquetes (estado_id, descripcion)
VALUES (1, 'Recogido');
INSERT INTO estados_paquetes (estado_id, descripcion)
VALUES (2, 'En tr nsito');
INSERT INTO estados_paquetes (estado_id, descripcion)
VALUES (3, 'Entregado');
INSERT INTO estados_paquetes (estado_id, descripcion)
VALUES (4, 'En espera de entrega');
INSERT INTO estados_paquetes (estado_id, descripcion)
VALUES (5, 'Cancelado');
INSERT INTO estados_paquetes (estado_id, descripcion)
VALUES (6, 'Devuelto');

INSERT INTO historial_estados_paquetes (historial_id, paquete_id, estado_id, fecha_hora)
VALUES (1, 1, 1, TO_TIMESTAMP('2024-05-20 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO historial_estados_paquetes (historial_id, paquete_id, estado_id, fecha_hora)
VALUES (2, 1, 2, TO_TIMESTAMP('2024-05-21 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO historial_estados_paquetes (historial_id, paquete_id, estado_id, fecha_hora)
VALUES (3, 2, 1, TO_TIMESTAMP('2024-05-22 09:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO historial_estados_paquetes (historial_id, paquete_id, estado_id, fecha_hora)
VALUES (4, 2, 2, TO_TIMESTAMP('2024-05-23 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO historial_estados_paquetes (historial_id, paquete_id, estado_id, fecha_hora)
VALUES (5, 3, 3, TO_TIMESTAMP('2024-05-24 11:15:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO historial_estados_paquetes (historial_id, paquete_id, estado_id, fecha_hora)
VALUES (6, 1, 4, TO_TIMESTAMP('2024-05-25 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO pagos (pago_id, paquete_id, metodo_pago, fecha_pago, monto_pagado)
VALUES (1, 1, 'Tarjeta de cr dito', TO_TIMESTAMP('2024-05-20 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1200.00);
INSERT INTO pagos (pago_id, paquete_id, metodo_pago, fecha_pago, monto_pagado)
VALUES (2, 2, 'Efectivo', TO_TIMESTAMP('2024-05-22 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 500.00);
INSERT INTO pagos (pago_id, paquete_id, metodo_pago, fecha_pago, monto_pagado)
VALUES (3, 3, 'Transferencia bancaria', TO_TIMESTAMP('2024-05-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 150.00);

INSERT INTO cobranzas (cobro_id, paquete_id, fecha_vencimiento, monto_cobrar, estado_cobro)
VALUES (1, 4, TO_DATE('2024-06-10', 'YYYY-MM-DD'), 200.00, 'PENDIENTE');
INSERT INTO cobranzas (cobro_id, paquete_id, fecha_vencimiento, monto_cobrar, estado_cobro)
VALUES (2, 2, TO_DATE('2024-05-25', 'YYYY-MM-DD'), 500.00, 'PAGADO');
INSERT INTO cobranzas (cobro_id, paquete_id, fecha_vencimiento, monto_cobrar, estado_cobro)
VALUES (3, 1, TO_DATE('2024-05-30', 'YYYY-MM-DD'), 1200.00, 'VENCIDO');

-- 10 Consultas Avanzadas SQL 
-- 1 Obtener la informaci n completa de los clientes que han enviado paquetes a la ciudad de Guayaquil.
SELECT c.*
FROM clientes c
JOIN direcciones d ON c.cliente_id = d.cliente_id
JOIN paquetes p ON d.direccion_id = p.direccion_origen_id
WHERE p.direccion_destino_id IN (
    SELECT direccion_id FROM direcciones WHERE ciudad = 'Guayaquil'
);

-- 2 Listar todos los paquetes junto con el nombre de la ruta asignada y el estado actual del paquete.
SELECT p.paquete_id, p.descripcion, r.nombre_ruta, e.descripcion AS estado_actual
FROM paquetes p
JOIN asignaciones_rutas ar ON p.paquete_id = ar.paquete_id
JOIN rutas r ON ar.ruta_id = r.ruta_id
JOIN historial_estados_paquetes he ON p.paquete_id = he.paquete_id
JOIN estados_paquetes e ON he.estado_id = e.estado_id
WHERE he.fecha_hora = (
    SELECT MAX(fecha_hora) FROM historial_estados_paquetes WHERE paquete_id = p.paquete_id
);

-- 3 Encontrar el total de pagos realizados por cada cliente.
SELECT c.cliente_id, c.nombre, c.apellido, SUM(pagos.monto_pagado) AS total_pagado
FROM clientes c
JOIN paquetes p ON c.cliente_id = p.cliente_id
JOIN pagos pagos ON p.paquete_id = pagos.paquete_id
GROUP BY c.cliente_id, c.nombre, c.apellido;

-- 4 Mostrar los paquetes que a n no han sido entregados.
SELECT p.*
FROM paquetes p
JOIN historial_estados_paquetes he ON p.paquete_id = he.paquete_id
WHERE he.fecha_hora = (
    SELECT MAX(fecha_hora) FROM historial_estados_paquetes WHERE paquete_id = p.paquete_id
)
AND he.estado_id != (SELECT estado_id FROM estados_paquetes WHERE descripcion = 'Entregado');

-- 5 Listar todos los clientes que han enviado m s de un paquete.
SELECT c.cliente_id, c.nombre, c.apellido, COUNT(p.paquete_id) AS total_paquetes
FROM clientes c
JOIN paquetes p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nombre, c.apellido
HAVING COUNT(p.paquete_id) > 1;

-- 6 Obtener la direcci n completa de origen y destino para cada paquete.
SELECT p.paquete_id, p.descripcion, 
       do.calle AS origen_calle, do.numero_exterior AS origen_numero_exterior, do.barrio AS origen_barrio, do.ciudad AS origen_ciudad, do.codigo_postal AS origen_codigo_postal,
       dd.calle AS destino_calle, dd.numero_exterior AS destino_numero_exterior, dd.barrio AS destino_barrio, dd.ciudad AS destino_ciudad, dd.codigo_postal AS destino_codigo_postal
FROM paquetes p
JOIN direcciones do ON p.direccion_origen_id = do.direccion_id
JOIN direcciones dd ON p.direccion_destino_id = dd.direccion_id;

-- 7 Mostrar la ruta y el total de paquetes asignados a cada ruta.
SELECT r.nombre_ruta, COUNT(ar.paquete_id) AS total_paquetes
FROM rutas r
JOIN asignaciones_rutas ar ON r.ruta_id = ar.ruta_id
GROUP BY r.nombre_ruta;

-- 8 Calcular el monto total a cobrar por los paquetes que a n est n pendientes de cobro.
SELECT SUM(c.monto_cobrar) AS total_pendiente
FROM cobranzas c
WHERE c.estado_cobro = 'PENDIENTE';

-- 9 Listar los paquetes y sus dimensiones que han sido enviados por clientes que viven en Quito.
SELECT p.paquete_id, p.descripcion, p.dimensiones
FROM paquetes p
JOIN clientes c ON p.cliente_id = c.cliente_id
WHERE c.ciudad = 'Quito';

-- 10 Obtener el listado de paquetes junto con la fecha y el estado m s reciente de cada paquete.
SELECT p.paquete_id, p.descripcion, he.fecha_hora, e.descripcion AS estado_actual
FROM paquetes p
JOIN historial_estados_paquetes he ON p.paquete_id = he.paquete_id
JOIN estados_paquetes e ON he.estado_id = e.estado_id
WHERE (p.paquete_id, he.fecha_hora) IN (
    SELECT paquete_id, MAX(fecha_hora)
    FROM historial_estados_paquetes
    GROUP BY paquete_id
);

```