# language: es
# Historia: HU-08 · Consolidar capturas en un lote
# Épica: EP05 · Sprint 2 · 5 SP
# Tareas: T18 (Implementar la selección múltiple de capturas), T19 (Validar el estado y la especie única), T20 (Cambiar el lote a Consolidado) y T21 (Mostrar los mensajes de error de la consolidación)
# Responsable: Joao Rivero

@EP05 @HU-08
Característica: HU-08 Consolidar capturas en un lote
  Como Coordinador
  quiero consolidar en un lote varias capturas de mi cooperativa que pertenezcan a una sola especie
  para preparar la emisión del certificado que entregaré a la empresa exportadora

  Antecedentes:
    Dado que el Coordinador Edgar Paredes ha iniciado sesión en la plataforma web de la "Cooperativa Mar Azul"
    Y su cooperativa tiene las siguientes capturas:
      | captura  | embarcacion | especie | cantidad | estado                       | lote         |
      | CAP-0110 | IO-00002-EJ | Perico  | 430 kg   | Verificada                   | ninguno      |
      | CAP-0111 | IO-00003-EJ | Perico  | 390 kg   | Aprobada                     | ninguno      |
      | CAP-0112 | IO-00005-EJ | Perico  | 410 kg   | Verificada                   | ninguno      |
      | CAP-0113 | IO-00003-EJ | Bonito  | 260 kg   | Verificada                   | ninguno      |
      | CAP-0114 | IO-00002-EJ | Perico  | 300 kg   | Registrada                   | ninguno      |
      | CAP-0109 | IO-00002-EJ | Perico  | 360 kg   | Pendiente de revisión manual | ninguno      |
      | CAP-0105 | IO-00005-EJ | Perico  | 280 kg   | Pendiente de confirmación    | ninguno      |
      | CAP-0115 | IO-00003-EJ | Perico  | 200 kg   | Rechazada                    | ninguno      |
      | CAP-0101 | IO-00002-EJ | Perico  | 420 kg   | Verificada                   | LOTE-CF-0001 |
    Y el Coordinador está en la pestaña "Por consolidar" de la sección "Lotes", con la especie "Perico" elegida en el campo "Especie del lote"

  # Flujo normal

  Escenario: Consolidación de capturas verificadas y aprobadas de una misma especie
    Cuando el Coordinador selecciona las capturas "CAP-0110" y "CAP-0111"
    Y hace click en el botón "Consolidar lote"
    Entonces el sistema crea un lote de "Perico" con 2 capturas y un total de 820 kg
    Y le asigna al lote el estado "Consolidado"

  # Manejo de errores

  Esquema del escenario: Intento de consolidar una captura que no está verificada ni aprobada
    Cuando el Coordinador solicita consolidar en un lote las capturas "CAP-0110" y "<captura>", que está en estado "<estado>"
    Entonces el sistema no consolida el lote
    Y muestra el mensaje "Solo se pueden consolidar capturas verificadas o aprobadas."

    Ejemplos:
      | captura  | estado                       |
      | CAP-0114 | Registrada                   |
      | CAP-0109 | Pendiente de revisión manual |
      | CAP-0105 | Pendiente de confirmación    |
      | CAP-0115 | Rechazada                    |

  Escenario: Intento de consolidar capturas de distintas especies
    Cuando el Coordinador solicita consolidar en un lote la captura "CAP-0110" de "Perico" y la captura "CAP-0113" de "Bonito"
    Entonces el sistema no consolida el lote
    Y muestra el mensaje "Un lote solo puede contener capturas de una misma especie."

  # Casos borde

  Escenario: Captura que ya pertenece a otro lote
    Cuando el Coordinador inicia el armado de un nuevo lote de "Perico"
    Entonces la captura "CAP-0101" no aparece entre las capturas disponibles para consolidar
    Y las capturas "CAP-0110", "CAP-0111" y "CAP-0112" aparecen como disponibles para consolidar
