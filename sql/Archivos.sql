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
