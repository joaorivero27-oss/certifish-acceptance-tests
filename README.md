# CertiFish · Acceptance Tests (Gherkin)

Pruebas de aceptación de **CertiFish**, la plataforma de trazabilidad pesquera artesanal de **Deep Blue Solutions**.
Curso Ingeniería de Requisitos (1ASI0786), UPC, ciclo 2026-20.

Los archivos `.feature` traducen a Gherkin, en español, los criterios de aceptación de las historias de usuario de la sección 3.4 del informe. Cada escenario es un ejemplo concreto y verificable de un criterio, con datos de prueba en *data tables* y en tablas `Examplos`.

## Alcance

Según el enunciado, se cubren las historias de **dos épicas core business** y **cuatro historias no funcionales**:

| Épica | Historias cubiertas |
|---|---|
| EP02 · Verificación de la evidencia de cada captura | HU-02, NF02, HU-03, HU-12 |
| EP05 · Lotes, certificación y verificación pública | HU-08, HU-09, NF03, HU-10, HU-11 |
| EP01 · Registro y seguimiento de capturas del Patrón | NF01 |
| EP06 · Acceso y seguridad | NF04 |

NF02 y NF03 pertenecen a las épicas elegidas. Para completar las cuatro no funcionales se agregan NF01 y NF04, las únicas restantes del backlog.

## Estructura

```
features/
├── EP01_registro_capturas/
│   └── NF01_registro_sin_conexion.feature          (Lionel Fiestas)
├── EP02_verificacion_evidencia/
│   ├── HU02_verificacion_automatica.feature
│   ├── HU03_revision_manual.feature
│   ├── HU12_alerta_revision_manual.feature
│   └── NF02_precision_talla.feature
├── EP05_lotes_certificacion/
│   ├── HU08_consolidar_lote.feature
│   ├── HU09_emitir_certificado.feature
│   ├── HU10_descargar_certificado_catch_simp.feature
│   ├── HU11_verificacion_publica.feature
│   └── NF03_deteccion_alteracion.feature
└── EP06_acceso_seguridad/
    └── NF04_acceso_por_rol_y_cooperativa.feature   (Lionel Fiestas)
```

## Trazabilidad

| Archivo | Historia | Épica | Escenarios | Responsable |
|---|---|---|---|---|
| HU02_verificacion_automatica.feature | HU-02 | EP02 | 7 | Joao Rivero |
| NF02_precision_talla.feature | NF02 | EP02 | 4 | Joao Rivero |
| HU03_revision_manual.feature | HU-03 | EP02 | 5 | Joao Rivero |
| HU12_alerta_revision_manual.feature | HU-12 | EP02 | 3 | Joao Rivero |
| HU08_consolidar_lote.feature | HU-08 | EP05 | 4 | Joao Rivero |
| HU09_emitir_certificado.feature | HU-09 | EP05 | 4 | Joao Rivero |
| NF03_deteccion_alteracion.feature | NF03 | EP05 | 4 | Joao Rivero |
| HU10_descargar_certificado_catch_simp.feature | HU-10 | EP05 | 6 | Joao Rivero |
| HU11_verificacion_publica.feature | HU-11 | EP05 | 2 | Joao Rivero |
| NF01_registro_sin_conexion.feature | NF01 | EP01 | 5 | Lionel Fiestas |
| NF04_acceso_por_rol_y_cooperativa.feature | NF04 | EP06 | 5 | Lionel Fiestas |

**Total:** 11 archivos y 49 escenarios.

## Relación con el Impact Map

Cada prueba verifica una historia que contribuye a un Business Goal del Impact Map (sección 3.8 del informe):

| Business Goal | Meta | Historias con prueba |
|---|---|---|
| BG1 (BO1) | Reducir en 40 % los lotes observados o rechazados en aduana | NF01, HU-09, HU-10, HU-11 |
| BG2 (BO3) | Reducir en 50 % el tiempo para conformar un lote | HU-08 |
| BG4 (BO4) | Mantener por debajo del 5 % los certificados con observaciones | HU-02, NF02, HU-03, HU-12, NF03, NF04 |

BG3 (BO6, respuesta ante cierres de PRODUCE) no tiene pruebas en este repositorio, porque sus historias (HU-05, HU-06 y HU-07) pertenecen a EP03, que no es una de las épicas elegidas.

## Relación con el Roadmap

Las pruebas siguen la asignación de historias a sprints del Agile Product Roadmap (sección 3.7 del informe):

| Sprint | Historias con prueba en este repositorio |
|---|---|
| Sprint 1 (semanas 1 y 2) | HU-02, NF01, NF02, HU-03 |
| Sprint 2 (semanas 3 y 4) | HU-08, HU-09, NF03, HU-11 |
| Sprint 3 (semanas 5 y 6) | HU-10 |
| Sprint 4 (semanas 7 y 8) | HU-12, NF04 |

HU-02 deriva a HU-12 (Sprint 4) en su escenario 8; esa alerta se verifica al terminar HU-12.

## Convenciones

- **Idioma.** Gherkin en español. La primera línea de cada archivo es `# language: es`, así que las palabras clave son `Característica`, `Antecedentes`, `Escenario`, `Esquema del escenario`, `Ejemplos`, `Dado`, `Cuando`, `Entonces` e `Y`. No se mezclan palabras clave en inglés.
- **Cabecera.** Debajo de `# language: es` van cuatro comentarios: la historia (y su característica ISO/IEC 25010 si es no funcional), la épica con su sprint y story points, las tareas del Sprint Backlog (sección 3.6) y el responsable.
- **Título.** `Característica:` lleva el código de la historia (`HU-02`, `NF01`…) y, si es no funcional, su característica de calidad entre paréntesis. El enunciado de la historia va debajo, en tres líneas sin puntuación final.
- **Tags.** La épica y la historia (`@EP02 @HU-02`), justo antes de `Característica`.
- **Bloques.** Los escenarios se ordenan con los mismos bloques de los criterios de la sección 3.4: `# Flujo normal`, `# Manejo de errores` y `# Casos borde`.
- **Redacción.** Tercera persona. `Dado` describe un estado inicial; `Cuando` y `Entonces`, la acción y el resultado observable. Los mensajes van entre comillas, con el texto literal de los criterios.
- **Datos concretos.** Cada escenario usa datos de prueba concretos, en *data tables* o en tablas `Ejemplos`, incluidos valores límite (por ejemplo, 54 y 55 kbps en NF01).
- **Vocabulario.** Los estados de la captura (Registrada, Verificada, Pendiente de revisión manual, Aprobada, Pendiente de confirmación, Rechazada) y del lote (Consolidado, Certificado), y los nombres de pantallas y botones, son los del informe y de los wireframes.
- **Datos de prueba.** Todos son ficticios: la cooperativa, las matrículas, los códigos de verificación, los números de resolución y los correos (dominio `.test`). Edgar Paredes y Andrea Salhuana son las User Personas de la sección 2.6.2.
- **Formato.** Sangría de 2 espacios y tablas alineadas. En Visual Studio Code, con la extensión *Cucumber (Gherkin) Full Support*, se alinean con Shift + Alt + F.

## Flujo de trabajo

1. Cada integrante trabaja en su propia rama: `feature/nf01-registro-sin-conexion`.
2. Mensajes de commit con el formato `test(NF01): agrega escenarios de envío interrumpido`.
3. Los cambios llegan a `main` por pull request. Solo los commits que están en `main` aparecen en *Insights › Contributors*.
4. Antes del primer commit, cada integrante configura en Git el mismo correo de su cuenta de GitHub:
   `git config user.email "correo-de-tu-cuenta@ejemplo.com"`.
   Si el correo no coincide, sus commits no se vinculan a su cuenta y no aparece en el gráfico de colaboración.

## Equipo

| Integrante | Código |
|---|---|
| Joao Armando Rivero Medina | U20251K809 |
| Lionel Jesús Fiestas Galán | U20251J366 |
| Mathias Alejandro Lazo Yactayo | U20251K078 |
| Maricel Azul Modesto Alarcón | U20251J569 |
| Jheyson Smit Salcedo García | U20251O850 |
