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
VALUES (1, 'Juan', 'Pérez', 'Av. 12 de Octubre 23', 'Quito', '0987654321', 'juan.perez@email.com');
INSERT INTO clientes (cliente_id, nombre, apellido, direccion, ciudad, telefono, correo_electronico)
VALUES (2, 'María', 'García', 'Calle Rocafuerte 15', 'Cuenca', '0965432109', 'maria.garcia@email.com');
INSERT INTO clientes (cliente_id, nombre, apellido, direccion, ciudad, telefono, correo_electronico)
VALUES (3, 'Pedro', 'López', 'Av. Amazonas 56', 'Guayaquil', '0954321098', 'pedro.lopez@email.com');

INSERT INTO direcciones (direccion_id, calle, numero_exterior, numero_interior, barrio, ciudad, codigo_postal, cliente_id)
VALUES (1, 'Av. 12 de Octubre', 23, NULL, 'La Mariscal', 'Quito', '170101', 1);
INSERT INTO direcciones (direccion_id, calle, numero_exterior, numero_interior, barrio, ciudad, codigo_postal, cliente_id)
VALUES (2, 'Calle Rocafuerte', 15, NULL, 'Centro Histórico', 'Cuenca', '010101', 2);
INSERT INTO direcciones (direccion_id, calle, numero_exterior, numero_interior, barrio, ciudad, codigo_postal, cliente_id)
VALUES (3, 'Av. Amazonas', 56, NULL, 'Urdesa', 'Guayaquil', '090909', 3);
INSERT INTO direcciones (direccion_id, calle, numero_exterior, numero_interior, barrio, ciudad, codigo_postal, cliente_id)
VALUES (4, 'Calle Rocafuerte', 10, NULL, 'Centro Histórico', 'Cuenca', '010101', 2);

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
VALUES (5, 'Internacional', 'España', 45.00, 4.50);

INSERT INTO rutas (ruta_id, nombre_ruta, descripcion, puntos_intermedios)
VALUES (1, 'Ruta Norte', 'Ruta que conecta Quito con Cuenca', 'Quito - Latacunga - Ambato - Cuenca');
INSERT INTO rutas (ruta_id, nombre_ruta, descripcion, puntos_intermedios)
VALUES (2, 'Ruta Sur', 'Ruta que conecta Quito con Guayaquil', 'Quito - Riobamba - Guayaquil');
INSERT INTO rutas (ruta_id, nombre_ruta, descripcion, puntos_intermedios)
VALUES (3, 'Ruta Internacional', 'Ruta para envíos internacionales', 'Quito - Aeropuerto Internacional Mariscal Sucre - Destino Internacional');

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
VALUES (2, 'En tránsito');
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
VALUES (1, 1, 'Tarjeta de crédito', TO_TIMESTAMP('2024-05-20 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1200.00);
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
-- 1 Obtener la información completa de los clientes que han enviado paquetes a la ciudad de Guayaquil.
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

-- 4 Mostrar los paquetes que aún no han sido entregados.
SELECT p.*
FROM paquetes p
JOIN historial_estados_paquetes he ON p.paquete_id = he.paquete_id
WHERE he.fecha_hora = (
    SELECT MAX(fecha_hora) FROM historial_estados_paquetes WHERE paquete_id = p.paquete_id
)
AND he.estado_id != (SELECT estado_id FROM estados_paquetes WHERE descripcion = 'Entregado');

-- 5 Listar todos los clientes que han enviado más de un paquete.
SELECT c.cliente_id, c.nombre, c.apellido, COUNT(p.paquete_id) AS total_paquetes
FROM clientes c
JOIN paquetes p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nombre, c.apellido
HAVING COUNT(p.paquete_id) > 1;

-- 6 Obtener la dirección completa de origen y destino para cada paquete.
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

-- 8 Calcular el monto total a cobrar por los paquetes que aún están pendientes de cobro.
SELECT SUM(c.monto_cobrar) AS total_pendiente
FROM cobranzas c
WHERE c.estado_cobro = 'PENDIENTE';

-- 9 Listar los paquetes y sus dimensiones que han sido enviados por clientes que viven en Quito.
SELECT p.paquete_id, p.descripcion, p.dimensiones
FROM paquetes p
JOIN clientes c ON p.cliente_id = c.cliente_id
WHERE c.ciudad = 'Quito';

-- 10 Obtener el listado de paquetes junto con la fecha y el estado más reciente de cada paquete.
SELECT p.paquete_id, p.descripcion, he.fecha_hora, e.descripcion AS estado_actual
FROM paquetes p
JOIN historial_estados_paquetes he ON p.paquete_id = he.paquete_id
JOIN estados_paquetes e ON he.estado_id = e.estado_id
WHERE (p.paquete_id, he.fecha_hora) IN (
    SELECT paquete_id, MAX(fecha_hora)
    FROM historial_estados_paquetes
    GROUP BY paquete_id
);
