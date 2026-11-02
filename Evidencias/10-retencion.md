# Actividad 10 — Política de retención

## 1. Objetivo
Analizar la propuesta de conservación indefinida de datos personales de clientes, evaluando su compatibilidad con los principios de privacidad, identificando los riesgos asociados y definiendo los criterios necesarios para establecer un periodo de retención justificado y conforme a la ley.

## 2. Procedimiento
1. Se evaluó la postura de la organización: *"Conservar todos los datos de clientes indefinidamente porque podrían ser útiles en el futuro"*.
2. Se confrontó dicha postura con el Principio de Minimización de Datos y Limitación de Almacenamiento.
3. Se identificaron los riesgos de seguridad, operativos y legales derivados de acumular información innecesaria o desactualizada.
4. Se definieron los criterios legales, regulatorios y funcionales para establecer un ciclo de vida con tiempos de conservación finitos y documentados.

## 3. Resultado
Un documento de análisis sobre políticas de conservación de datos que demuestra la inviabilidad legal y técnica de la retención indefinida, estableciendo las bases para definir periodos de depuración acordes a las obligaciones fiscales y operativas.

## 4. Análisis y Respuestas a las Preguntas

### Pregunta 1: ¿Es compatible con el principio de minimización?
**No.** Conservar información *"por si acaso puede ser útil en el futuro"* ignora directamente los principios de **Minimización de Datos** y **Limitación del Plazo de Conservación**. La minimización exige tratar únicamente los datos estrictamente necesarios y solo durante el tiempo indispensable para cumplir la finalidad informada en el Aviso de Privacidad. La retención sin un propósito presente o justificado constituye un tratamiento ilegítimo.

### Pregunta 2: ¿Qué riesgos genera conservar información innecesaria?
* **Aumento del impacto en incidentes de seguridad:** Ante una fuga de datos (*data breach*), la cantidad de información expuesta es drásticamente mayor, incrementando el daño reputacional y las multas regulatorias.
* **Inexactitud y obsolescencia de datos:** Con el tiempo, correos, teléfonos o domicilios quedan desactualizados, lo que reduce la calidad de la información e incrementa errores operativos.
* **Costos de almacenamiento e infraestructura:** Almacenar volúmenes masivos de datos inactivos incrementa los costos en bases de datos, copias de seguridad y procesamiento.
* **Complejidad en la gestión de derechos ARCO:** Atender solicitudes de acceso, rectificación o cancelación se vuelve exponencialmente más difícil y costoso en bases de datos sobrepobladas y sin purgar.
* **Sanciones por incumplimiento legal:** Marcos normativos (como la LFPDPPP o GDPR) sancionan expresamente la conservación de datos personales más allá de los plazos legales o de la finalidad autorizada.

### Pregunta 3: ¿Qué debería determinar la organización antes de establecer un periodo de retención?
1. **Obligaciones Legales y Fiscales:** Identificar los plazos mínimos exigidos por leyes tributarias, comerciales o laborales (por ejemplo, conservar comprobantes fiscales durante 5 años conforme al Código Fiscal de la Federación en México).
2. **Duración de la relación contractual:** Determinar el tiempo estimado en que el cliente se considera activo.
3. **Periodo de prescripción de responsabilidades:** Definir el tiempo legal en que podrían surgir reclamaciones, disputas o demandas tras la finalización del servicio.
4. **Necesidades operativas estrictas:** Evaluar el tiempo real en que los datos son útiles para atención de soporte o garantías.

### Pregunta 4: ¿Qué información debería documentarse para justificar el periodo seleccionado?
* **Finalidad específica del tratamiento:** El motivo preciso por el cual se conserva el dato.
* **Fundamento legal o regulatorio:** Las normas o leyes específicas que exigen la conservación y el plazo estipulado.
* **Fecha de inicio y fin del periodo de retención:** El evento detonante (ej. cancelación de la cuenta o emisión de la última factura) y la fecha exacta en que vence el plazo.
* **Procedimiento de destrucción o anonimización:** La descripción del método técnico que se utilizará al finalizar el plazo (ej. borrado seguro, sobreescritura de discos o anonimización irreversible para analítica).
* **Rol o responsable de la custodia:** El área o puesto interno encargado de supervisar la depuración periódica de los datos.

## 5. Conclusión
La conservación indefinida de información personal no es una estrategia prudente, sino una fuente de riesgo legal, operativo y de seguridad. Definir y documentar políticas de retención claras permite limitar la responsabilidad de la empresa, reducir la superficie de ataque y garantizar que la base de datos cumpla con el ciclo de vida de los datos personales.