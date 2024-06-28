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

