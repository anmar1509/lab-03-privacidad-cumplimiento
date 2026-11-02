# Actividad 1 — Inventario y Finalidad de los Datos

## 1. Objetivo
Identificar, clasificar y documentar los datos personales almacenados en la tabla `clientes`, determinando su necesidad, finalidad de uso, niveles de acceso autorizados y periodos de retención para establecer una base adecuada de gobierno de datos y privacidad.

## 2. Procedimiento
1. Se analizó la estructura actual de la tabla `clientes` de la empresa Comercializadora Norte S.A. de C.V. y sus campos (`id`, `nombre`, `correo`, `telefono`, `rfc`, `edad`, `ciudad`, `codigo_postal`, `fecha_alta`).
2. Se evaluaron los procesos operativos descritos (Atención al cliente, Facturación, Analítica y Administración de BD).
3. Se clasificó cada campo evaluando si constituye un dato personal directo, indirecto o sensible.
4. Se definieron las finalidades operativas estrictas, restringiendo los niveles de acceso según el principio de mínimo privilegio y estableciendo periodos de conservación apropiados.

## 3. Resultado

| Campo | ¿Es dato personal? | Finalidad | ¿Es necesario? | Nivel de acceso | Retención |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **id** | No | Identificador único interno del registro del cliente. | Sí | Sistema / Todos los roles operativos | Indefinida *(mientras exista la cuenta)* |
| **nombre** | Sí | Identificación y trato personalizado al cliente. | Sí | Atención al cliente, Facturación | Durante la relación comercial + periodo legal posterior |
| **correo** | Sí | Comunicación, notificación de servicios y autenticación. | Sí | Atención al cliente | Durante la relación comercial + periodo de baja activo |
| **telefono** | Sí | Contacto operativo para soporte o confirmación de servicios. | Sí | Atención al cliente | Durante la relación comercial |
| **rfc** | Sí *(Sensible en contexto fiscal)* | Identificación fiscal para emisión de comprobantes de pago. | Sí *(Solo para Facturación)* | Restringido a Facturación | Período legal obligatorio fiscal *(ej. 5 años)* |
| **edad** | Sí | Análisis demográfico y segmentación agregada. | No para operación diaria | Analítica *(Anonimizado/Agregado)* | Mientras dure el análisis o según política interna |
| **ciudad** | Sí *(En combinación)* | Ubicación geográfica para análisis comercial y logística. | Sí | Analítica, Soporte regional | Mientras la cuenta esté activa |
| **codigo_postal** | Sí *(En combinación)* | Validación de cobertura de servicio y análisis regional. | Sí | Analítica, Soporte regional | Mientras la cuenta esté activa |
| **fecha_alta** | No *(Directamente)* | Auditoría del ciclo de vida del cliente y antigüedad. | Sí | DBA, Analítica | Indefinida *(asociada al registro)* |

## 4. Análisis y Justificación

* **id / fecha_alta:** Son metadatos de control del sistema. Aunque por sí solos no identifican directamente a una persona, sirven para mantener la integridad técnica, el orden de los registros y la trazabilidad del ciclo de vida.
* **nombre, correo, telefono:** Son datos personales directos requeridos exclusivamente para la operación y la atención al cliente. No deben ser accesibles de manera directa ni masiva por el área de analítica.
* **rfc:** Es un dato personal con trascendencia fiscal. Su uso debe ser exclusivo del área de facturación y debe conservarse únicamente durante los plazos exigidos por la legislación tributaria aplicable.
* **edad, ciudad, codigo_postal:** Son datos demográficos y de ubicación que sirven para analítica comercial. Para reducir riesgos de reidentificación o exposición de privacidad, la edad no debe entregarse como dato puntual al perfil analítico, sino procesarse mediante rangos etarios o vistas agregadas.

## 5. Conclusión
El desarrollo del inventario demuestra que no todos los campos almacenados son necesarios para todos los roles de la organización. Limitar el acceso y definir la finalidad de cada dato personal permite sentar las bases para aplicar los principios de minimización, limitación de finalidad y control de acceso funcional dentro de la base de datos PostgreSQL.