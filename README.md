# Informe Final — Práctica de Laboratorio: Privacidad, Seguridad y Gobierno de Datos en PostgreSQL

## Datos del Estudiante / Equipo
* **Materia:** Seguridad y Privacidad en Bases de Datos
* **Nombre:** Ana Maribel Felipe Rodriguez
* **Tecnología:** PostgreSQL

---

## 1. Introducción
El informe aborda el problema de la privacidad y la protección de datos personales dentro de sistemas de gestión de bases de datos relacionales (PostgreSQL). En las arquitecturas empresariales tradicionales, la recolección masiva e indiscriminada de información (conocida como *Data Hoarding*), la falta de segregación de roles y la conservación indefinida de datos generan graves vulnerabilidades de seguridad y el incumplimiento de marcos regulatorios como la LFPDPPP y el GDPR.

Este laboratorio analiza cómo resolver la brecha entre las operaciones técnicas del DBA y las exigencias legales de privacidad, implementando controles de acceso, técnicas de minimización, gobernanza de datos y mecanismos para atender los derechos de los titulares.

---

## 2. Inventario de Datos

A continuación se presenta la clasificación de los datos personales almacenados en la tabla `clientes`:

| Dato | Clasificación | Nivel de Sensibilidad |
| :--- | :--- | :--- |
| id | Identificador Técnico | Interno / Público |
| nombre | Dato Personal Identificable (PII) | Confidencial |
| correo | Dato Personal Identificable (PII) / Contacto | Confidencial |
| telefono | Dato Personal Identificable (PII) / Contacto | Confidencial |
| rfc | Dato Fiscal / Financiero | Sensible / Restringido |
| edad / fecha_nacimiento | Dato Demográfico | Interno / Confidencial |
| ciudad / codigo_postal | Dato Geográfico | Interno |
| salario / estado_civil | Dato Financiero / Sensible | Altamente Confidencial |

---

## 3. Finalidades

Los datos recolectados deben utilizarse exclusivamente para propósitos legítimos informados en el Aviso de Privacidad:

* **Finalidades Primarias (Indispensables):**
  * Autenticación y gestión de la cuenta del usuario.
  * Facturación y emisión de comprobantes fiscales obligatorios (`nombre`, `rfc`).
  * Atención a clientes, soporte técnico y notificaciones del servicio (`correo`, `telefono`).

* **Finalidades Secundarias (Opcionales / Requieren Consentimiento):**
  * Envío de boletines promocionales y campañas de mercadotecnia (`correo`).
  * Análisis estadístico y optimización de cobertura de servicios (`ciudad`, `codigo_postal`, `edad`).

---

## 4. Minimización

El principio de minimización exige tratar únicamente los datos estrictamente indispensables. 

* **Datos a eliminar inmediatamente:**
  * `salario`, `estado_civil` y `ocupacion`: No guardan relación con la prestación del servicio básico y exponen la privacidad del usuario ante una brecha.
  * `edad`: Se elimina por ser un dato redundante si se cuenta con la fecha de nacimiento (o viceversa).
* **Justificación:** Reducir la sobrecolecta disminuye el impacto financiero, legal y reputacional ante incidentes de seguridad, cumpliendo además con la norma de Privacidad por Diseño.

---

## 5. Control de Acceso

Los permisos se vincularon estrictamente con las funciones operativas de cada área utilizando el principio de Mínimo Privilegio (*Need-to-Know*):

* **Facturación:** Solo accede a `nombre`, `rfc` y datos de pago mediante la vista `v_facturacion`.
* **Soporte y Atención a Clientes:** Accede a `nombre`, `correo` y `telefono` para resolver tickets a través de `v_soporte`.
* **Analítica:** Consulta datos agregados o anonimizados (`rango_edad`, `ciudad`, `codigo_postal`) sin acceso a identificadores personales directos mediante `v_analitica`.
* **DBA:** Actúa como *custodio técnico* con acceso administrativo para mantenimiento, pero restringido de consultar libremente el contenido de negocio mediante auditoría activa.

---

## 6. Derechos ARCO

Atender los Derechos ARCO (Acceso, Rectificación, Cancelación y Oposición) implica consideraciones técnicas profundas:

* **Acceso:** Exige construir consultas integrales que no solo lean la tabla principal, sino que identifiquen registros en tablas secundarias, respaldos o sistemas derivados.
* **Cancelación y Oposición:** Demuestra que eliminar un registro (`DELETE`) en la base de producción no remueve el dato de las copias de seguridad (*backups*), bitácoras (*WAL / Logs*), réplicas de lectura ni de los almacenes de analítica (*Data Warehouse*). Se requiere implementar listas de exclusión (*Suppress Lists*) y bloqueos legales.

---

## 7. Retención

El periodo de conservación no debe ser indefinido, sino determinado por criterios legales y operativos:

1. **Plazos Legales/Fiscales:** Conservar registros financieros y fiscales durante el periodo mínimo exigido por la ley (ej. 5 años conforme al Código Fiscal).
2. **Ciclo de Vida de la Cuenta:** Mantener los datos durante la vigencia de la relación contractual más un periodo de gracia para atención de disputas.
3. **Disposición Final:** Cumplido el plazo, la información debe someterse a borrado seguro (*Purge*) o a un proceso de **anonimización irreversible** para conservación estadística.

---

## 8. Gobierno de Datos

### Matriz de Responsabilidades

| Campo | *Data Owner* (Responsable) | Custodio Técnico | Usuarios Autorizados | Acción al Finalizar Retención |
| :--- | :--- | :--- | :--- | :--- |
| `nombre` | Gerente de Atención al Cliente | DBA | Atención a Clientes, Facturación | Supresión Segura |
| `correo` | Gerente de Atención al Cliente | DBA | Atención a Clientes | Supresión Segura |
| `telefono` | Gerente de Soporte Técnico | DBA | Soporte Técnico | Supresión Segura |
| `rfc` | Director de Finanzas | DBA | Facturación | Supresión tras 5 años fiscales |
| `edad` | Gerente de Business Intelligence | DBA | Analítica *(Solo anonimizado)* | Anonimización Irreversible |
| `ciudad` | Gerente de Operaciones | DBA | Operaciones, Analítica | Conservación Agregada |

---

## 9. Evaluación Integral

Los principales riesgos identificados en la evaluación de la infraestructura fueron:

1. **Uso de datos reales en Desarrollo:** Réplica de bases de datos de producción con PII hacia entornos de prueba sin anonimizar o enmascarar (*Data Masking*).
2. **Acceso masivo directo:** Analistas consultando directamente la tabla `clientes` en lugar de utilizar vistas agregadas.
3. **Falta de gestión de consentimiento:** Envío de campañas de marketing sin verificar el *opt-in* del usuario o ignorando el derecho de oposición.
4. **Inexistencia de auditoría:** Ausencia de registros de logs (`pgaudit`) para detectar extracciones masivas no autorizadas.

---

## 10. Conclusiones

A lo largo de este laboratorio aprendí que la **privacidad, la seguridad y la administración de bases de datos son tres pilares interdependientes**:

* La **privacidad** establece las reglas del negocio y los límites legales sobre qué datos se pueden capturar y durante cuánto tiempo.
* La **seguridad** aporta los mecanismos de protección técnica (cifrado, vistas, RLS, auditoría) para evitar que los datos sean vulnerados.
* La **administración de bases de datos (DBA)** es la disciplina ejecutora que traduce las políticas de privacidad y los controles de seguridad en objetos y configuraciones reales dentro del motor de base de datos.

Diseñar bases de datos protegidas desde el origen (*Privacy by Design*) evita reestructuraciones costosas, reduce la superficie de ataque y garantiza que la tecnología opere en apego a los derechos fundamentales de los usuarios.

## 11. Preguntas de Reflexión

### 1. ¿Una base de datos técnicamente segura necesariamente cumple con todos los requisitos de privacidad?
**No.** La seguridad técnica (confidencialidad, integridad y disponibilidad) no garantiza el cumplimiento de la privacidad. Una base de datos puede estar protegida contra *hackers* con cifrado fuerte, *firewalls* y contraseñas robustas, pero si la organización recopila datos excesivos sin el consentimiento del usuario, los utiliza para finalidades no informadas o los conserva indefinidamente, la base de datos es **segura técnicamente pero viola gravemente la privacidad y la ley**.

---

### 2. ¿Por qué el principio de mínimo privilegio también contribuye a la privacidad?
Porque limita el acceso a la Información de Identificación Personal (PII) únicamente a los usuarios que estrictamente la necesitan para cumplir su función operativa (*Need-to-Know*). Al evitar que áreas secundarias (como analítica o mercadotecnia) tengan acceso a identificadores directos (nombres, correos o RFC), se reduce la exposición innecesaria, se previene el uso no autorizado y se minimiza el impacto en caso de que una cuenta de usuario sea comprometida.

---

### 3. ¿Por qué el DBA no debería decidir por sí solo la finalidad del tratamiento de los datos?
Porque la finalidad del tratamiento es una **decisión legal y estratégica de negocio**, no un parámetro técnico. El DBA es el *custodio técnico* del motor de base de datos; no tiene el contexto ni la atribución legal para interpretar el Aviso de Privacidad, los contratos comerciales ni el marco normativo aplicable. Permitir que el DBA decida qué datos usar o almacenar expone a la empresa a sanciones legales y violaciones de derechos de los titulares.

---

### 4. ¿Por qué los desarrolladores no deberían recibir automáticamente copias completas de bases de datos productivas?
Porque las bases de datos de producción contienen **información real y sensible de los clientes**. Los entornos de desarrollo suelen tener niveles de seguridad significativamente inferiores a producción (equipos portátiles de trabajo, contraseñas débiles, ausencia de auditoría y almacenamiento desprotegido en repositorios localizables), lo que convierte la entrega indiscriminada de *dumps* de producción en una brecha de seguridad e infracción directa a las leyes de privacidad.

---

### 5. ¿Por qué una copia utilizada para desarrollo también puede representar un riesgo de privacidad?
Porque una copia en desarrollo mantiene los mismos datos personales (nombres, RFC, correos) que la base productiva. Si un equipo de cómputo de un desarrollador es robado, si la base de prueba se sube por error a un repositorio público (ej. GitHub), o si el servidor de *testing* es vulnerado, **la filtración de datos reales ocurre con la misma gravedad que si se hubiera atacado el servidor de producción**.

---

### 6. ¿Por qué la retención debe formar parte del ciclo de vida de los datos?
Porque los datos personales solo deben conservarse durante el tiempo necesario para cumplir la finalidad autorizada o para responder a obligaciones legales/fiscales. Incluir la retención como etapa del ciclo de vida garantiza que la información inactiva sea purgada de forma segura (*Purge*) o anonimizada, evitando el almacenamiento indefinido (*Data Hoarding*), reduciendo costos de infraestructura y disminuyendo el volumen de datos expuestos ante un incidente.

---

### 7. ¿Qué relación existe entre privacidad por diseño y diseño de bases de datos?
La relación es directa e inseparable. Aplicar **Privacidad por Diseño** en el modelado de bases de datos significa estructurar las tablas, relaciones y esquemas priorizando la protección de los datos desde el origen. Esto se traduce en:
* No agregar campos sin justificación clara (*minimización*).
* Desacoplar atributos sensibles u opcionales en tablas independientes.
* Implementar banderas de consentimiento (`opt-in/opt-out`).
* Construir vistas filtradas y limitar permisos de acceso DCL desde la creación del esquema.

---

### 8. ¿Qué controles técnicos implementarías para reducir el riesgo de exposición de datos personales?
1. **Control de Acceso basado en Roles (RBAC / DCL):** Asignación estricta de permisos `GRANT/REVOKE`.
2. **Vistas Filtradas y Anonimizadas (`VIEWS`):** Entregar datos agregados (rangos de edad, sin PII) a analistas.
3. **Ofuscación y Enmascaramiento de Datos (*Data Masking*):** Ocultar parcial o totalmente atributos sensibles en la interfaz.
4. **Cifrado de Datos:** Cifrado en reposo (*Transparent Data Encryption* / columnas) y en tránsito (TLS/SSL).
5. **Auditoría de Consultas (`pgaudit`):** Monitoreo activo de consultas SQL masivas o sospechosas sobre tablas de PII.
6. **Entornos de Prueba Sanitizados:** Pipelines que generan datos sintéticos para el área de desarrollo.

---

### 9. ¿Qué información debería conocer un DBA para responder técnicamente a una solicitud ARCO?
* **Identificador del Titular:** Correo electrónico, ID o RFC exacto del cliente que realiza la solicitud.
* **Tipo de Solicitud (A, R, C u O):**
  * *Acceso:* Esquema completo de tablas, vistas y respaldos donde existe el dato.
  * *Rectificación:* Campos exactos a modificar y reglas de integridad.
  * *Cancelación / Oposición:* Dependencias relacionales (`FOREIGN KEYS`), tablas derivadas, políticas de retención activas y existencia del cliente en respaldos o réplicas.
* **Mecanismos de Exclusión:** Si se debe eliminar físicamente el dato o registrar al usuario en una *Lista de Exclusión (Suppress List)*.

---

### 10. ¿Qué responsabilidades deberían corresponder al DBA, al responsable de privacidad, al área jurídica y al propietario de los datos?

| Rol | Responsabilidad Principal |
| :--- | :--- |
| **Propietario de los Datos (*Data Owner*)** | Define la finalidad del negocio para recolectar el dato, autoriza quién puede acceder a la información y determina el tiempo de vida útil operativa. |
| **Área Jurídica** | Garantiza el cumplimiento normativo (LFPDPPP, GDPR), redacta los Avisos de Privacidad, atiende disputas legales y establece los plazos legales de conservación. |
| **Responsable de Privacidad (DPO / Oficial de Privacidad)** | Atiende y valida las solicitudes ARCO de los titulares, audita el cumplimiento de las políticas de privacidad y actúa como enlace con los organismos reguladores. |
| **Administrador de Base de Datos (DBA)** | Actúa como **custodio técnico**. Configura los permisos DCL, crea las vistas, implementa el cifrado, ejecuta las tareas de depuración/anonimización y habilita los módulos de auditoría requeridos por la política. |