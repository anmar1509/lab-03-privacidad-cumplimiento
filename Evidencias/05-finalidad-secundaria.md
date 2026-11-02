# Actividad 5 — Analizar una finalidad secundaria

## 1. Objetivo
Analizar la legitimidad, los riesgos de privacidad y los controles técnicos necesarios ante la propuesta de reutilizar los datos de los clientes para una finalidad secundaria de marketing y promociones personalizadas, garantizando el cumplimiento de los principios de limitación de finalidad, minimización y consentimiento.

## 2. Procedimiento
1. Se evaluó la propuesta del negocio: *"Enviar promociones personalizadas basadas en la edad, ciudad y comportamiento de compra"*.
2. Se analizaron los principios de privacidad aplicables según la Ley Federal de Protección de Datos Personales en Posesión de los Particulares (LFPDPPP) y estándares de gobierno de datos.
3. Se formularon las preguntas de control que la organización debe responder antes de autorizar el nuevo tratamiento.
4. Se diseñó el esquema de controles técnicos y de acceso necesarios para limitar la entrega de datos personales al área de marketing.

## 3. Resultado
Un documento de análisis de impacto en la privacidad que determina la improcedencia de otorgar acceso directo a la tabla principal de clientes y establece la arquitectura de controles por vista/agregación y gestión de consentimiento (*opt-in* / *opt-out*).

## 4. Análisis y Respuestas a las Preguntas

### 1. ¿El hecho de que la organización ya tenga los datos significa automáticamente que puede utilizarlos para cualquier finalidad?
**No.** Poseer los datos para una finalidad operativa (como brindar soporte o facturar) no otorga un derecho automático ni ilimitado para utilizarlos en finalidades distintas. De acuerdo con el **Principio de Limitación de Finalidad**, los datos personales solo deben ser tratados para los propósitos expresamente informados al titular en el Aviso de Privacidad original. Cualquier uso secundario (como mercadotecnia o prospección comercial) requiere una base jurídica válida, la actualización del aviso de privacidad y, por lo general, la obtención del consentimiento expreso o la opción de rechazo (*opt-out*) por parte del cliente.

### 2. ¿Qué preguntas debería realizar la organización antes de implementar este tratamiento?
* **¿Está contemplada esta finalidad en el Aviso de Privacidad actual?** Si no lo está, ¿se notificará y solicitará el consentimiento previo a los usuarios?
* **¿Existe un mecanismo para que los clientes puedan oponerse (derecho de Oposición / *opt-out*) a recibir publicidad sin perder el servicio principal?**
* **¿Qué datos son estrictamente necesarios para la campaña?** ¿Se requiere la identidad directa o solo un perfil anónimo/segmentado?
* **¿Qué canal se utilizará para el envío?** (Correo, SMS, WhatsApp) y si el titular autorizó específicamente ese canal.
* **¿Quiénes tendrán acceso a la información y durante cuánto tiempo?**

### 3. ¿Qué datos serían realmente necesarios?
Para fines de personalización y segmentación de promociones, únicamente se requieren:
* **Datos de segmentación:** Rango de edad (no la edad exacta) y Ciudad/Región.
* **Historial de preferencias/comportamiento:** Categorías de producto de interés (agregadas o seudonimizadas).
* **Dato de contacto:** Correo electrónico o teléfono *(únicamente si el titular otorgó su consentimiento para promociones)*.

**Datos innecesarios que deben excluirse:** Nombre completo, RFC, dirección exacta, código postal puntual, fecha exacta de alta o edad precisa.

### 4. ¿Necesitaría el área de marketing acceso directo a la tabla clientes?
**No.** El área de marketing **nunca debe tener acceso directo** a la tabla base `clientes` ni a la base de datos operativa por las siguientes razones:
* Violaría los principios de mínimo privilegio y minimización de datos.
* Expondría datos sensibles o fiscales (como el RFC) que marketing no necesita.
* Permitiría la extracción masiva no autorizada de la base de datos completa.

### 5. ¿Qué controles técnicos podrían limitar la información entregada?
* **Vistas Restringidas (`VIEWS`):** Crear vistas específicas para marketing que expongan únicamente los correos de usuarios que hayan aceptado recibir promociones, acompañados de sus datos de segmentación en rangos o categorías.
* **Tablas de Preferencias / Consentimiento (*Opt-In* / *Opt-Out*):** Implementar una tabla de control (ej. `clientes_preferencias`) con un campo booleano `acepta_publicidad DEFAULT FALSE` que filtre automáticamente las consultas del área de marketing.
* **Seudonimización / IDs de Campaña:** Entregar a las herramientas de automatización de marketing identificadores seudonimizados en lugar de la identidad real del cliente.
* **Roles y Permisos Granulares (DCL):** Crear un rol específico `ROL_MARKETING` limitado a consultar únicamente la vista de promociones filtrada, sin acceso de lectura a la tabla `clientes`.

## 5. Conclusión
La reutilización de datos para finalidades secundarias no es un problema puramente técnico, sino una decisión legal y de gobierno de datos. La implementación de vistas filtradas según el estado del consentimiento del titular (*opt-in*) permite que la empresa realice esfuerzos comerciales sin comprometer la privacidad ni exponer la estructura principal de la base de datos.