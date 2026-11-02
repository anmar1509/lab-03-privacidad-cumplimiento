# Actividad 11 — Diseñar una matriz de gobierno de datos

## 1. Objetivo
Diseñar e implementar una matriz de gobierno de datos para clasificar los principales campos de la tabla `clientes`, asignando responsabilidades organizacionales, definiendo niveles de acceso por rol funcional y estableciendo controles de protección, retención y disposición final de la información.

## 2. Procedimiento
1. Se identificaron los atributos principales almacenados en la tabla `clientes` (`nombre`, `correo`, `telefono`, `rfc`, `edad`, `ciudad`, `codigo_postal`).
2. Se definieron las finalidades legítimas y los roles autorizados dentro de la organización (Atención al cliente, Facturación, Analítica, DBA, Dirección).
3. Se determinaron las medidas de protección técnica (vistas, mascaras, cifrado) requeridas para cada dato según su sensibilidad.
4. Se asignaron los periodos de retención y la acción técnica al finalizar el ciclo de vida (supresión segura o anonimización).

## 3. Resultado

### Matriz de Gobierno de Datos

| Dato | Finalidad | Responsable (*Data Owner*) | Usuarios autorizados | Protección | Retención | Acción al finalizar |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **nombre** | Identificación y atención al cliente | Gerente de Atención al Cliente | Atención al cliente, Facturación | Control de acceso por rol (RLS / Vistas) | Durante la relación comercial + 5 años | Supresión segura (*Purge*) |
| **correo** | Comunicación, notificaciones y autenticación | Gerente de Atención al Cliente | Atención al cliente | Control de acceso por rol, Enmascaramiento | Durante la relación comercial + periodo de baja (1 año) | Supresión / Eliminación |
| **telefono** | Contacto operativo y soporte | Gerente de Soporte Técnico | Atención al cliente | Restricción de acceso directo | Durante la relación comercial | Supresión |
| **rfc** | Identificación fiscal y facturación | Director de Finanzas | Facturación | Restricción estricta de esquema/rol, Cifrado | 5 años (Obligatorio por Ley Fiscal) | Supresión definitiva |
| **edad** | Análisis demográfico y segmentación | Gerente de Inteligencia de Negocios | Analítica *(Solo en rangos)* | Anonimización / Vista agregada (`CASE`) | Mientras dure el estudio analítico | Anonimización irreversible |
| **ciudad** | Logística y análisis regional | Gerente de Operaciones | Analítica, Soporte regional | Agregación de datos | Mientras la cuenta esté activa | Conservación agregada |
| **codigo_postal** | Validación de cobertura de servicio | Gerente de Operaciones | Analítica, Soporte regional | Agregación de datos | Mientras la cuenta esté activa | Conservación agregada |

## 4. Análisis y Respuestas a las Preguntas

### 1. Relación entre Roles y Accesos Funcionales
La asignación de permisos no se realizó de manera generalizada, sino respondiendo estrictamente a la necesidad del rol (*Need-to-Know*):
* **Facturación** únicamente requiere `nombre` y `rfc` para comprobantes fiscales.
* **Atención al Cliente** interactúa con `nombre`, `correo` y `telefono` para resolver tickets operativos.
* **Analítica** procesa únicamente `edad` (transformada en rangos), `ciudad` y `codigo_postal` de forma agregada, previniendo el acceso directo a datos identificables (PII).
* **DBA** es el *custodio técnico* del motor de base de datos; administra la infraestructura pero no debe consultar el contenido de negocio salvo por tareas explícitas de mantenimiento.

### 2. Disposición Final de los Datos
Al finalizar el periodo de retención se aplican dos estrategias diferenciadas:
1. **Supresión segura (*Purge / Delete*):** Eliminación física de datos personales directos (`nombre`, `correo`, `rfc`) de las tablas de producción y purga de respaldos según política.
2. **Anonimización irreversible:** Desasociar los datos demográficos (`edad`, `ciudad`) de la identidad del usuario, permitiendo conservar históricos estadísticos valiosos para el negocio sin violar la privacidad.

## 5. Conclusión
El establecimiento de una Matriz de Gobierno de Datos demuestra que la seguridad y la privacidad en bases de datos van más allá de la asignación de contraseñas. Vincular cada campo a un *Data Owner*, definir accesos por perfil operativo y documentar el destino final del dato permite institucionalizar los principios de minimización, responsabilidad proactiva (*Accountability*) y mínimo privilegio dentro de la organización.