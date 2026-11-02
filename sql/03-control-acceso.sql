-- Crea un rol 
CREATE ROLE analista NOLOGIN;

-- Por ejemplo, crea una vista:
CREATE VIEW v_analitica_clientes AS SELECT ciudad, CASE
WHEN edad < 18 THEN 'Menor de 18'
WHEN edad BETWEEN 18 AND 29 THEN '18-29'
WHEN edad BETWEEN 30 AND 44 THEN '30-44'
WHEN edad BETWEEN 45 AND 59 THEN '45-59'
ELSE '60 o más' END AS rango_edad FROM clientes;
-- Otorga permisos:
GRANT USAGE ON SCHEMA public TO analista;

GRANT SELECT ON v_analitica_clientes TO analista;

-- Verificación
-- Comprueba los privilegios:
SELECT grantee, table_name, privilege_type 
FROM information_schema.role_table_grants
WHERE grantee = 'analista';

/*1. OBJETIVO
Implementar controles de acceso a nivel de base de datos en PostgreSQL 
para restringir la visibilidad del rol 'analista', garantizando que solo 
pueda acceder a datos anonimizados/agregados según la finalidad de sus 
funciones y respetando el principio de mínimo privilegio.

2. PROCEDIMIENTO
- Se creó el rol 'analista' sin permisos de autenticación (NOLOGIN).
- Se diseñó la vista 'v_analitica_clientes' para exponer únicamente los 
  campos 'ciudad' y 'rango_edad' calculados a partir de la tabla 'clientes'.
- Se asignó permiso SELECT sobre la vista y USAGE sobre el esquema public.
- Se omitió explícitamente cualquier permiso sobre la tabla base 'clientes'.
- Se consultó la tabla del sistema 'information_schema.role_table_grants' 
  para auditar y verificar los privilegios vigentes.

3. RESULTADO
El rol 'analista' cuenta únicamente con el privilegio SELECT sobre 
'v_analitica_clientes'. Al consultar la vista se obtienen datos demográficos 
desasociados de identidades individuales. Al intentar ejecutar un SELECT 
directo sobre la tabla 'clientes', el sistema PostgreSQL deniega el acceso.

4. ANÁLISIS Y RESPUESTAS A LAS PREGUNTAS DE LA PRÁCTICA

¿Qué información puede consultar el rol?
- Únicamente los datos expuestos a través de la vista 'v_analitica_clientes': 
  la ciudad y el rango de edad agrupado.

¿Puede consultar directamente la tabla clientes?
- No. Carece del permiso SELECT sobre la tabla 'clientes', por lo que PostgreSQL 
  bloqueará cualquier intento de consulta con un error de permisos denegados.

¿Puede obtener nombre, correo y RFC?
- No. Ninguno de estos campos de Identificación Personal (PII) o de carácter 
  fiscal forma parte de la vista 'v_analitica_clientes', ni existe acceso a la tabla base.

¿Qué principio de privacidad estás aplicando?
- Principio de Minimización de Datos y Limitación de Finalidad (Privacy by Default), 
  asegurando que el usuario solo reciba la información estrictamente necesaria 
  para cumplir el propósito de análisis estadístico.

¿Qué principio de seguridad estás aplicando?
- Principio de Mínimo Privilegio (Least Privilege) y Segregación de Funciones (SoD), 
  otorgando únicamente los permisos indispensables para la función operativa 
  del perfil sin comprometer la base de datos principal.

5. CONCLUSIÓN
La combinación de vistas estructuradas con la asignación granular de permisos 
demuestra que es posible desacoplar los datos operativos de los fines analíticos. 
Este control técnico evita la exposición innecesaria de PII y garantiza que la 
base de datos cumpla de origen con las restricciones de privacidad.
*/