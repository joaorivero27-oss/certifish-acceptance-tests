# language: es
# Historia: HU-03 · Revisar manualmente una captura pendiente de revisión
# Épica: EP02 · Sprint 1 · 5 SP
# Tareas: T13 (Implementar la bandeja de revisión manual), T14 (Diseñar la vista de detalle de la captura), T15 (Implementar la aprobación o el rechazo con motivo) y T16 (Notificar el rechazo al Patrón)
# Responsable: Joao Rivero

@EP02 @HU-03
Característica: HU-03 Revisar manualmente una captura pendiente de revisión
  Como Coordinador
  quiero revisar manualmente las capturas en estado "Pendiente de revisión manual", visualizando la foto, los datos declarados por el Patrón y el resultado de la verificación automática
  para decidir si la captura queda "Aprobada" o "Rechazada", indicando el motivo en caso de rechazo

  Antecedentes:
    Dado que el Coordinador Edgar Paredes ha iniciado sesión en la plataforma web de la "Cooperativa Mar Azul"
    Y las siguientes capturas de su cooperativa están en estado "Pendiente de revisión manual":
      | captura  | embarcacion | especie | cantidad | fecha y hora     | resultado de la verificacion |
      | CAP-0120 | IO-00003-EJ | Pota    | 350 kg   | 06/10/2026 05:30 | GPS y EXIF no coinciden      |
      | CAP-0121 | IO-00002-EJ | Perico  | 410 kg   | 06/10/2026 06:10 | Confianza de 72 %            |
      | CAP-0122 | IO-00005-EJ | Bonito  | 280 kg   | 05/10/2026 07:45 | Especie no coincide          |
      | CAP-0123 | IO-00005-EJ | Perico  | 360 kg   | 05/10/2026 05:20 | Talla bajo la mínima         |

  # Flujo normal

  Escenario: Listado de las capturas pendientes de revisión manual
    Cuando el Coordinador accede a la sección "Revisión manual"
    Entonces el sistema muestra las 4 capturas pendientes de su cooperativa
    Y para cada captura muestra la foto, los datos declarados por el Patrón (especie, cantidad o peso y método), la fecha, la hora y la ubicación GPS tomadas por el dispositivo, la talla estimada y el resultado de la verificación automática con su motivo
    Y no muestra capturas pendientes de otras cooperativas

  Escenario: Aprobación de una captura pendiente de revisión manual
    Dado que el Coordinador revisa la captura "CAP-0120"
    Y ha comprobado que la especie y la cantidad declaradas coinciden con la foto, que la talla cumple la Talla Mínima de Captura y que los metadatos de la foto coinciden con los datos del dispositivo
    Cuando hace click en el botón "Aprobar"
    Entonces la captura "CAP-0120" queda en estado "Aprobada"
    Y la captura "CAP-0120" queda disponible para consolidarse en un lote
    Y el sistema registra la decisión con la fecha, la hora y el Coordinador responsable

  Esquema del escenario: Rechazo de una captura indicando el motivo
    Dado que el Coordinador revisa la captura "<captura>"
    Y ha comprobado que <hallazgo>
    Cuando escribe "<motivo_rechazo>" en el campo "Motivo del rechazo"
    Y hace click en el botón "Rechazar"
    Entonces la captura "<captura>" queda en estado "Rechazada"
    Y el Patrón que registró la captura recibe una notificación con el motivo "<motivo_rechazo>"
    Y el sistema registra la decisión con la fecha, la hora y el Coordinador responsable

    Ejemplos:
      | captura  | hallazgo                                      | motivo_rechazo                         |
      | CAP-0122 | la especie no coincide con la foto            | La foto muestra caballa, no bonito.    |
      | CAP-0123 | más del 10 % mide menos de la talla mínima    | Más del 10 % de ejemplares bajo 70 cm. |
      | CAP-0120 | los metadatos no coinciden con el dispositivo | La foto es de otra zona y otra fecha.  |

  # Manejo de errores

  Escenario: Intento de rechazar una captura sin indicar el motivo
    Dado que el Coordinador revisa la captura "CAP-0121"
    Y el campo "Motivo del rechazo" está vacío
    Cuando hace click en el botón "Rechazar"
    Entonces el sistema bloquea el rechazo y muestra el mensaje "Debes indicar el motivo del rechazo."
    Y la captura "CAP-0121" permanece en estado "Pendiente de revisión manual"

  # Casos borde

  Escenario: Captura pendiente de revisión afectada por un cierre normativo registrado
    Dado que el Coordinador ha registrado el cierre de emergencia "R.M. N° 09999-2026-PRODUCE" para "Perico", zona regulatoria "Sur" y capacidad de bodega "Menor de 20 m³", vigente del 05/10/2026 al 03/11/2026
    Y la captura "CAP-0123" coincide con la especie, el periodo, la zona regulatoria y la capacidad de bodega de ese cierre
    Cuando el Coordinador revisa la captura "CAP-0123"
    Entonces el detalle de la captura muestra el aviso "Esta captura coincide con el cierre R.M. N° 09999-2026-PRODUCE."
    Y los botones "Aprobar" y "Rechazar" siguen disponibles para que el Coordinador decida con esa información
