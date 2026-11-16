# language: es
# Historia: HU-09 · Emitir el certificado de trazabilidad del lote
# Épica: EP05 · Sprint 2 · 5 SP
# Tareas: T22 (Estructurar el contenido del certificado), T23 (Validar las capturas del lote antes de emitir), T24 (Cambiar el lote a Certificado) y T25 (Mostrar el error por lote no consolidado o con capturas inválidas)
# Responsable: Joao Rivero

@EP05 @HU-09
Característica: HU-09 Emitir el certificado de trazabilidad del lote
  Como Coordinador
  quiero generar un certificado de trazabilidad para un lote consolidado
  para respaldar con evidencia, ante la empresa exportadora, el origen del lote

  Antecedentes:
    Dado que el Coordinador Edgar Paredes ha iniciado sesión en la plataforma web de la "Cooperativa Mar Azul"
    Y el lote "LOTE-CF-0002" de "Perico" está en estado "Consolidado" con las siguientes capturas:
      | captura  | embarcacion | metodo   | fecha y hora     | ubicacion GPS       | cantidad | estado     |
      | CAP-0091 | IO-00002-EJ | Palangre | 01/10/2026 06:10 | 15°12' S · 75°20' O | 470 kg   | Verificada |
      | CAP-0094 | IO-00003-EJ | Palangre | 02/10/2026 05:50 | 15°33' S · 75°06' O | 390 kg   | Aprobada   |

  # Flujo normal

  Escenario: Emisión del certificado de un lote consolidado
    Dado que todas las capturas del lote "LOTE-CF-0002" están en estado "Verificada" o "Aprobada"
    Cuando el Coordinador hace click en el botón "Emitir certificado" del lote "LOTE-CF-0002"
    Entonces el sistema genera el certificado de trazabilidad con un código de verificación único
    Y el certificado incluye la cooperativa "Cooperativa Mar Azul" y la especie "Perico"
    Y el certificado incluye, por cada captura, los siguientes datos:
      | matricula   | metodo   | fecha y hora     | ubicacion GPS       | cantidad | estado     |
      | IO-00002-EJ | Palangre | 01/10/2026 06:10 | 15°12' S · 75°20' O | 470 kg   | Verificada |
      | IO-00003-EJ | Palangre | 02/10/2026 05:50 | 15°33' S · 75°06' O | 390 kg   | Aprobada   |
    Y el lote "LOTE-CF-0002" pasa del estado "Consolidado" al estado "Certificado"

  # Manejo de errores

  Esquema del escenario: Intento de emitir el certificado cuando una captura cambió de estado después de la consolidación
    Dado que la captura "CAP-0094" del lote "LOTE-CF-0002" cambió al estado "<estado>" después de la consolidación
    Cuando el Coordinador hace click en el botón "Emitir certificado" del lote "LOTE-CF-0002"
    Entonces el sistema no emite el certificado
    Y muestra el mensaje "No se puede emitir el certificado: la captura CAP-0094 quedó en estado <estado>."
    Y el lote "LOTE-CF-0002" permanece en estado "Consolidado"

    Ejemplos:
      | estado                    |
      | Pendiente de confirmación |
      | Rechazada                 |

  Escenario: Intento de emitir el certificado de un lote que ya está certificado
    Dado que el Coordinador ya emitió el certificado del lote "LOTE-CF-0002" y el lote pasó al estado "Certificado"
    Cuando el Coordinador solicita emitir nuevamente el certificado del lote "LOTE-CF-0002"
    Entonces el sistema no emite un nuevo certificado
    Y muestra el mensaje "El lote LOTE-CF-0002 ya está certificado. Solo se puede emitir el certificado de un lote consolidado."

  Escenario: Falla al generar el certificado
    Dado que todas las capturas del lote "LOTE-CF-0002" están en estado "Verificada" o "Aprobada"
    Cuando el Coordinador hace click en el botón "Emitir certificado" y la generación del certificado falla
    Entonces el sistema no emite el certificado
    Y el lote "LOTE-CF-0002" permanece en estado "Consolidado"
    Y muestra el mensaje "No se pudo emitir el certificado. Intenta nuevamente."
