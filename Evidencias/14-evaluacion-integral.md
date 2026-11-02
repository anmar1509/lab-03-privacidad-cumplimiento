# Actividad 14 — Escenario integral

## 1. Objetivo
Realizar una evaluación integral de riesgos de privacidad, seguridad y gobierno de datos en el escenario operacional de la empresa, identificando las vulnerabilidades derivadas del acceso no restringido, la falta de políticas de retención, la fuga de datos en entornos de desarrollo y el uso no autorizado para finalidades secundarias, para proponer controles correctivos inmediatos.

## 2. Procedimiento
1. Se analizó el escenario operativo de la empresa (50,000 clientes, consulta directa por analistas, retención de 12 años sin política, uso de datos reales en desarrollo, marketing no autorizado).
2. Se identificaron 10 fallas críticas en los procesos y arquitectura de la base de datos.
3. Se asoció cada problema con el principio de privacidad o seguridad afectado.
4. Se determinó el nivel de riesgo técnico, legal y operativo derivado de cada práctica.
5. Se formularon controles técnicos y administrativos específicos para mitigar cada vulnerabilidad.

## 3. Resultado

### Matriz de Evaluación Integral de Riesgos

| # | Problema identificado | Principio afectado | Riesgo | Control propuesto |
| :-: | :--- | :--- | :--- | :--- |
| **1** | Acceso directo y masivo de analistas a la tabla `clientes`. | Mínimo Privilegio / Minimización | Exposición innecesaria de PII y RFC; extracción masiva no autorizada. | Implementar vistas filtradas (`v_analitica_clientes`) y limitar permisos del rol `analista` a la vista. |
| **2** | Visualización de PII (nombre, correo, teléfono, RFC) por el área de analítica. | Minimización de Datos / Limitación de Finalidad | Reidentificación de clientes e incumplimiento de privacidad de origen. | Transformar la entrega de datos a formatos agregados/anonimizados (ej. rangos de edad, sin PII). |
| **3** | Conservación de datos de clientes por 12 años sin justificación. | Limitación del Almacenamiento / Retención | Inexactitud de datos, sobrecosto de infraestructura y mayor impacto ante brechas. | Definir una política de retención (ej. 5 años tras baja) y ejecutar procesos de depuración periódica. |
| **4** | Ausencia de una política documentada de retención de datos. | Responsabilidad Proactiva (*Accountability*) | Sanciones legales por incumplimiento regulatorio (LFPDPPP/GDPR) al no justificar la conservación. | Redactar, aproba y documentar la Política Institucional de Conservación y Purga de Datos. |
| **5** | Uso de copias completas con datos reales en entornos de desarrollo. | Privacidad por Defecto / Confidencialidad | Filtración o robo de base de datos desde equipos de desarrolladores o entornos no endurecidos. | Prohibir bases de producción en desarrollo; implementar bases de pruebas con datos sintéticos o seudonimizados. |
| **6** | Entrega de copias de la BD a desarrolladores sin controles de acceso/cifrado. | Seguridad de la Información / Control de Acceso | Copia y distribución no controlada de archivos `.dump` / `.sql` con información sensible. | Implementar un pipeline de sanitización (data masking) automatizado antes de entregar datos de prueba. |
| **7** | Uso de correos para campañas promocionales por marketing sin consentimiento. | Limitación de Finalidad / Consentimiento | Infracción a la ley de privacidad (envío de spam), daño reputacional y derecho de oposición (*opt-out*). | Implementar tabla/campos de preferencias (`acepta_marketing`) y restringir envíos solo a titular autorizados (*opt-in*). |
| **8** | Ausencia de documentación sobre la finalidad correspondiente a cada dato. | Transparencia / Gobierno de Datos | Incapacidad para auditorías, falta de trazabilidad y asignación ambigua de responsabilidades. | Crear y mantener actualizado el Catálogo y la Matriz de Gobierno de Datos. |
| **9** | Exposición de identificadores fiscales (RFC) fuera de facturación. | Proporcionalidad / Protección Reforzada | Exposición indebida de datos con trascendencia fiscal ante personal no autorizado. | Restringir el acceso al campo `rfc` únicamente al rol de Facturación mediante vistas y permisos DCL. |
| **10** | Inexistencia de mecanismos para registrar la trazabilidad de consultas masivas. | Trazabilidad / Auditoría | Imposibilidad de detectar quién descargó o filtró la base de datos completa ante un incidente. | Habilitar el módulo de auditoría (`pgaudit`) para monitorear consultas sobre la tabla `clientes`. |

## 4. Análisis y Respuestas a las Preguntas

### 1. Gravedad del Escenario Actual
El escenario actual representa un estado de alto riesgo operativo, legal y de seguridad. La combinación de **sobrerecolección, retención indefinida, desacoplamiento de finalidades y réplica indiscriminada de datos reales en ambientes de desarrollo** expone a la empresa a severas multas por parte de los organismos reguladores de privacidad, además del riesgo inminente de un incidente de filtración de datos (*data breach*).

### 2. Priorización de Implementación de Controles
1. **Prioridad Inmediata (Fase 1 - Seguridad Operativa):** Prohibir el uso de datos reales en desarrollo y revocar los permisos de acceso directo de los analistas a la tabla `clientes` sustituyéndolos por la vista de analítica.
2. **Prioridad Media (Fase 2 - Gobierno y Legal):** Actualizar el Aviso de Privacidad para la finalidad de marketing, implementar la gestión de *opt-in/opt-out* y crear la política formal de retención.
3. **Prioridad Continua (Fase 3 - Auditoría y Calidad):** Documentar la Matriz de Gobierno de Datos y activar la auditoría con `pgaudit`.

## 5. Conclusión
El análisis integral demuestra que los problemas de privacidad rara vez se deben a fallas aisladas, sino a la falta de una cultura institucional de gobierno de datos. La aplicación coordinada de controles técnicos (vistas, enmascaramiento, DCL) y administrativos (políticas de retención, avisos de privacidad) es indispensable para transformar una infraestructura vulnerable en un entorno seguro y en cumplimiento legal.