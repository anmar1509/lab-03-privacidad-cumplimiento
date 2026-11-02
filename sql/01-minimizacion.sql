-- Actividad 2: Principio de minimización
CREATE TABLE clientes_soporte ( id BIGSERIAL, nombre VARCHAR(120),
correo VARCHAR(150), telefono VARCHAR(20), rfc VARCHAR(13), edad INTEGER,
ciudad VARCHAR(80), codigo_postal VARCHAR(10), fecha_alta DATE );
-- 1. ¿Todos los campos son necesarios para atención al cliente? No, solo nombre, correo y teléfono.
-- 2. ¿Por qué soporte necesitaría conocer el RFC? No lo necesita, es un dato de trascendencia fiscal.
-- 3. ¿Necesita conocer la edad? No, la edad es para análisis demográfico.
-- 4. ¿Necesita conocer el código postal? No es estrictamente necesario para el soporte básico.
-- 5. ¿Qué principio de privacidad está relacionado? Principio de Minimización de Datos 

-- Crea una tabla que contenga únicamente los datos necesarios para la finalidad de soporte:
CREATE TABLE clientes_soporte ( id BIGINT PRIMARY KEY, nombre VARCHAR(120)
NOT NULL,
correo VARCHAR(150) NOT NULL, telefono VARCHAR(20) );

INSERT INTO clientes_soporte (id, nombre, correo, telefono)
SELECT id, nombre, correo, telefono FROM clientes;

SELECT * FROM clientes_soporte;

