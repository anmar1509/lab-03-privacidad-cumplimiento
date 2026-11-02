-- Diseña una consulta que proporcione información agregada:
SELECT ciudad, COUNT(*) AS cantidad_clientes FROM clientes GROUP BY ciudad
ORDER BY cantidad_clientes DESC;

-- Ahora crea rangos de edad:
SELECT CASE
WHEN edad < 18 THEN 'Menor de 18'
WHEN edad BETWEEN 18 AND 29 THEN '18-29'
WHEN edad BETWEEN 30 AND 44 THEN '30-44'
WHEN edad BETWEEN 45 AND 59 THEN '45-59' ELSE '60 o más'
END AS rango_edad, COUNT(*) AS cantidad FROM clientes
GROUP BY CASE
WHEN edad < 18 THEN 'Menor de 18'
WHEN edad BETWEEN 18 AND 29 THEN '18-29'
WHEN edad BETWEEN 30 AND 44 THEN '30-44'
WHEN edad BETWEEN 45 AND 59 THEN '45-59'
ELSE '60 o más' END ORDER BY rango_edad;

-- Respuesta a la pregunta de análisis:
-- ¿Por qué esta información es más apropiada para analítica que la tabla completa?
-- 1. Cumple con el principio de minimización y limitación de finalidad.
-- 2. Reduce el riesgo de reidentificación al no exponer nombres, correos, teléfonos o RFC.
-- 3. Aplica segregación de funciones, garantizando que el área analítica solo acceda a datos agregados.