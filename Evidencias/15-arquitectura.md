# Actividad 15 — Propuesta de arquitectura de datos protegidos

## 1. Objetivo
Diseñar una propuesta integral de arquitectura de datos protegidos para la organización, integrando mecanismos técnicos y administrativos de Privacidad por Diseño, control de acceso basado en roles (RBAC), segregación de entornos, anonimización y gobernanza del ciclo de vida de los datos personales.

## 2. Procedimiento
1. Se consolidaron los hallazgos y vulnerabilidades identificadas en las actividades previas (acceso directo a PII, falta de retención, uso de datos reales en desarrollo, ausencia de consentimiento para marketing).
2. Se definieron las capas técnicas de la nueva arquitectura dentro del motor PostgreSQL (Base de datos OLTP, Vistas anonimizadas/filtradas, Control de Accesos DCL y Auditoría).
3. Se diseñó el flujo de datos seguro para entornos de desarrollo y analítica mediante procesos de sanitización y enmascaramiento (*Data Masking*).
4. Se formalizaron las políticas administrativas complementarias (Retención, Políticas de Privacidad, Gobierno de Datos) para garantizar un modelo sostenible.

## 3. Resultado

### Esquema de la Arquitectura de Datos Protegidos

```text
[ FUENTES DE ENTRADA / APLICACIÓN ]
              │
              ▼
┌────────────────────────────────────────────────────────────────────────┐
│                   BASE DE DATOS PRODUCTIVA (OLTP)                      │
│                                                                        │
│  Tabla Principal: `clientes` (Acceso exclusivo: DBA / Sistema Base)    │
│  - Cifrado en reposo y en tránsito (TLS/SSL)                           │
│  - Banderas de consentimiento (`acepta_marketing`)                      │
│  - Módulo de auditoría activo (`pgaudit`)                              │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
       ┌───────────────────────────┼───────────────────────────┐
       ▼                           ▼                           ▼
┌──────────────┐            ┌──────────────┐            ┌──────────────┐
│ VISTA 1:     │            │ VISTA 2:     │            │ VISTA 3:     │
│  Facturación │            │  Soporte     │            │  Analítica   │
├──────────────┤            ├──────────────┤            ├──────────────┤
│ - nombre     │            │ - nombre     │            │ - rango_edad │
│ - rfc        │            │ - correo     │            │ - ciudad     │
│ - datos_pago │            │ - telefono   │            │ - cp         │
└──────┬───────┘            └──────┬───────┘            └──────┬───────┘
       │                           │                           │
       ▼                           ▼                           ▼
[ Rol: Facturación ]       [ Rol: Soporte ]           [ Rol: Analista ]

                                   │
                                   ▼ (Pipeline ETL / Sanitización)
┌────────────────────────────────────────────────────────────────────────┐
│                      ENTORNOS SECUNDARIOS                              │
├──────────────────────────────────────┬─────────────────────────────────┤
│    Entorno de Analítica / OLAP       │     Entorno de Desarrollo       │
│  - Datos agregados / Anonimizados    │  - Datos 100% Sintéticos /      │
│  - Sin PII directa                   │    Enmascarados (Dump fogueado) │
└──────────────────────────────────────┴─────────────────────────────────┘