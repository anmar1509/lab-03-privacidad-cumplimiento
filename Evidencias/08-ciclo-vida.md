# Actividad 8 — Derecho de cancelación y ciclo de vida

## 1. Objetivo
Analizar las implicaciones técnicas y de infraestructura al atender una solicitud de cancelación de datos personales (Derecho C de ARCO), identificando el mapa del ciclo de vida de los datos para comprender por qué eliminar un registro en la tabla principal de la base de datos es insuficiente para erradicar la información de la organización.

## 2. Procedimiento
1. Se analizó el impacto de la solicitud de cancelación autorizada para un titular.
2. Se mapearon los diferentes entornos, réplicas, respaldos, sistemas derivados y archivos donde la información del titular puede residir activa o pasivamente.
3. Se construyó el mapa de dependencias y propagación de los datos personales a partir de la tabla principal `clientes`.
4. Se evaluaron las restricciones técnicas de eliminación (por ejemplo, en respaldos inmutables o logs de auditoría) frente a la obligación legal de supresión.

## 3. Resultado

### Mapa del ciclo de vida de los datos de `clientes`:

```text
clientes (Tabla Principal)
│
├── 1. Tablas relacionadas / secundarias
│   └── clientes_soporte (Tabla de minimización operativa)
│
├── 2. Vistas y capas de analítica
│   └── v_analitica_clientes (Datos derivados/agregados)
│
├── 3. Respaldos (Backups)
│   ├── Dump diario/semanal de PostgreSQL (archivos .sql / .dump)
│   └── Snapshots de almacenamiento / WAL (Write-Ahead Logging)
│
├── 4. Réplicas y alta disponibilidad
│   └── Nodos de lectura / Replicación física o lógica
│
├── 5. Registros de auditoría y logs
│   ├── pgaudit / pg_log (Logs del motor de base de datos)
│   └── Logs de aplicación (servidores web / API)
│
├── 6. Exportaciones y reportes
│   ├── Archivos CSV / Excel descargados por áreas operativas
│   └── Reportes estáticos PDF para dirección o finanzas
│
└── 7. Sistemas externos e integraciones
    ├── Plataforma de envío de correos / Marketing (ej. Mailchimp, SendGrid)
    └── Sistema de facturación / Proveedor Autorizado de Certificación (PAC)

   ```
### ¿Por qué eliminar un registro de una tabla no necesariamente significa que toda la información relacionada con esa persona haya desaparecido de la organización?

Ejecutar una consulta DELETE FROM clientes WHERE id = ... únicamente remueve la fila de la tabla principal en la base de datos transaccional de producción. Sin embargo, la información de la persona puede continuar existiendo en diversos puntos de la infraestructura de la empresa por las siguientes razones técnicas:

1. **Respaldos de base de datos (*Backups*):** La información permanece almacenada en copias de seguridad pasivas (archivos `.sql`, `.dump` o *snapshots* del sistema). Si la base de datos requiere ser restaurada ante un desastre, el registro eliminado volvería a introducirse al sistema.
2. **Réplicas y alta disponibilidad:** En entornos con replicación física o lógica, si existen retardos en la sincronización o nodos secundarios desvinculados, los datos pueden permanecer en las bases de datos de lectura.
3. **Tablas derivadas desvinculadas:** Tablas creadas previamente para operaciones específicas (como `clientes_soporte` de la Actividad 2) o copias manuales que no cuentan con restricciones de borrado en cascada (`ON DELETE CASCADE`) conservan los datos intactos.
4. **Registros de transacciones y auditoría (*WAL / Logs*):** El historial de transacciones previas se mantiene de forma inmutable en los archivos de auditoría (*pgaudit*, bitácoras del sistema y *Write-Ahead Logging*) para cumplir con fines de trazabilidad y seguridad.
5. **Capa de analítica y almacenes de datos (*Data Warehouses*):** Procesos de extracción previa (ETL) pueden haber transferido la información hacia bases de datos OLAP o vistas materializadas donde el dato persiste desacoplado.
6. **Exportaciones fuera del motor de BD:** Copias locales en hojas de cálculo (CSV, Excel), reportes en PDF o listas descargadas previamente por áreas operativas permanecen en equipos de trabajo o carpetas compartidas.
7. **Sistemas externos e integraciones:** Proveedores de servicios de mercadotecnia, herramientas de facturación o plataformas de correo sincronizadas mediante API no eliminan automáticamente sus registros a menos que se ejecute una instrucción explícita de supresión.
 