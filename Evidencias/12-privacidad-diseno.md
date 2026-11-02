# Actividad 12 — Privacidad por diseño

## 1. Objetivo
Analizar la propuesta de diseño de un nuevo esquema de base de datos para la registración de clientes, identificando sobrerecolección de datos y aplicando los principios de Privacidad por Diseño (*Privacy by Design*) y Privacidad por Defecto (*Privacy by Default*) para definir un modelo relacional adecuado y necesario.

## 2. Procedimiento
1. Se revisó el script de creación propuesto por el desarrollador:
   `CREATE TABLE clientes ( id BIGSERIAL, nombre TEXT, correo TEXT, telefono TEXT, rfc TEXT, edad INTEGER, direccion TEXT, ciudad TEXT, codigo_postal TEXT, fecha_nacimiento DATE, ocupacion TEXT, salario NUMERIC, estado_civil TEXT, ...);`
2. Se evaluó la justificación dada: *"Es mejor guardar todos los datos por si posteriormente necesitamos alguno"*.
3. Se analizaron los vacíos de minimización y los riesgos derivados de solicitar atributos sin una finalidad operativa o legal definida.
4. Se formularon las preguntas de control de arquitectura y se depuró la estructura de la tabla excluyendo campos innecesarios o requiriendo justificaciones reforzadas.

## 3. Resultado
Un análisis técnico y de privacidad que rechaza la justificación de recolección masiva preventiva, sustituyendo la propuesta original por una estructura de datos minimizada y alineada con la operación de la empresa.

## 4. Análisis y Respuestas a las Preguntas

### 1. ¿Qué problemas identificas?
* **Sobrerecolección de datos (Data Hoarding):** Se están capturando datos innecesarios para la gestión básica de clientes sin un propósito presente ni justificado.
* **Redundancia técnica:** Solicitar simultáneamente `edad` y `fecha_nacimiento` genera inconsistencia de datos y redundancia.
* **Ingreso de datos financieros y personales sensibles:** Campos como `salario`, `ocupacion` y `estado_civil` exponen la privacidad del cliente y aumentan innecesariamente el nivel de riesgo de la base de datos ante una brecha de seguridad.
* **Justificación inadecuada:** Guardar datos *"por si acaso los necesitamos después"* viola explícitamente los marcos normativos de protección de datos (LFPDPPP, GDPR).

### 2. ¿Qué principio de privacidad se está ignorando?
Se ignoran los principios fundamentales de:
* **Minimización de Datos:** No limitar la recolección a lo estrictamente indispensable.
* **Limitación de Finalidad:** Recopilar datos sin informarlos expresamente en el Aviso de Privacidad.
* **Privacidad por Diseño y por Defecto:** Se diseñó el esquema priorizando la acumulación antes que la protección de la privacidad de origen.

### 3. ¿Qué preguntas realizarías antes de aprobar el diseño?
1. ¿Cuál es la finalidad específica de cada campo dentro de la aplicación actual?
2. ¿Qué campos son indispensables para la prestación del servicio y cuáles son opcionales?
3. ¿Está contemplado el almacenamiento de datos financieros (`salario`) y demográficos sensibles (`estado_civil`) en el Aviso de Privacidad vigente?
4. ¿Existen obligaciones legales o normativas que exijan la captura de estos atributos?

### 4. ¿Qué datos eliminarías?
* salario, estado_civil, ocupacion, edad

### 5. ¿Qué datos requerirían una justificación adicional?
* `fecha_nacimiento` vs. `edad`: Se debe justificar si la fecha exacta es indispensable (ej. validación legal de mayoría de edad) o si basta con registrar el año/rango de edad.
* `direccion` puntual: Justificar si el servicio requiere entrega a domicilio o si únicamente se necesita `ciudad` y `codigo_postal` para validar la cobertura del servicio.
* `rfc`: Requiere justificación fiscal (solo si el cliente solicita comprobantes tributarios/facturación).

### 6. ¿Cómo aplicarías privacidad por defecto?
* **Creación de un esquema mínimo obligatorio:** Diseñar la tabla base únicamente con identificador, datos de contacto operativos y credenciales de autenticación.
* **Campos opcionales desacoplados:** Mover los atributos adicionales a tablas complementarias (ej. `clientes_perfil_marketing`) cuyos registros solo se creen si el usuario autoriza expresamente esa finalidad.
* **Restricción de permisos en la BD (DCL):** Limitar los permisos de acceso de los componentes de la aplicación únicamente a las vistas o campos estrictamente necesarios para su función.

## 5. Conclusión
La práctica demuestra que almacenar más información de la requerida no genera valor por sí solo, por el contrario, incrementa la superficie de ataque y los costos de cumplimiento. Aplicar la Privacidad por Diseño desde la etapa de modelado de datos previene reestructuraciones costosas en producción y garantiza que la base de datos sea segura por defecto desde su creación.