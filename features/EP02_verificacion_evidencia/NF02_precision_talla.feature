# language: es
# Historia: NF02 · Estimar la talla con un error máximo de ±1 cm (Adecuación funcional, ISO/IEC 25010)
# Épica: EP02 · Sprint 1 · 3 SP
# Tareas: T12 (Estimar la talla por relación de píxeles)
# Responsable: Joao Rivero

@EP02 @NF02
Característica: NF02 Estimar la talla con un error máximo de ±1 cm (Adecuación funcional)
  Como Coordinador
  quiero que la talla que el sistema estima a partir de la foto tenga un error máximo de ±1 cm
  para confiar en la validación de la talla mínima sin medir cada captura en el desembarcadero

  Antecedentes:
    Dado que el servicio de verificación automática está disponible
    Y el margen de error máximo aceptado para la talla estimada es de 1 cm

  # Flujo normal

  Escenario: Precisión de la talla estimada en el conjunto de 30 fotos de prueba
    Dado que existe un conjunto de 30 fotos de prueba tomadas a la luz del día, con un objeto de referencia visible y con la talla de cada ejemplar medida a mano
    Cuando el sistema estima la talla del ejemplar en cada una de las 30 fotos
    Entonces la diferencia entre la talla estimada y la talla medida a mano es de 1 cm como máximo en cada foto
    Y la prueba de precisión se da por aprobada solo si las 30 fotos cumplen ese margen

  Esquema del escenario: Evaluación de cada foto del conjunto de prueba contra el margen de ±1 cm
    Dado que la foto "<foto>" del conjunto de prueba muestra un ejemplar de "<especie>" con una talla medida a mano de <talla_medida> cm
    Cuando el sistema estima una talla de <talla_estimada> cm para ese ejemplar
    Entonces la diferencia registrada es de <diferencia> cm
    Y la foto queda como "<resultado>" en la prueba de precisión

    Ejemplos:
      | foto       | especie          | talla_medida | talla_estimada | diferencia | resultado |
      | ref_01.jpg | Perico           | 78,0         | 78,4           | 0,4        | Cumple    |
      | ref_02.jpg | Perico           | 71,5         | 70,5           | 1,0        | Cumple    |
      | ref_03.jpg | Bonito           | 55,0         | 56,1           | 1,1        | No cumple |
      | ref_04.jpg | Tiburón martillo | 162,0        | 160,4          | 1,6        | No cumple |

  # Manejo de errores

  Escenario: Foto sin objeto de referencia
    Dado que el Patrón de la embarcación "IO-00005-EJ" registró la captura "CAP-0112" de "Perico"
    Y la foto de la captura no muestra un objeto de referencia visible
    Cuando el sistema intenta estimar la talla del ejemplar
    Entonces el sistema no informa una talla estimada
    Y la captura "CAP-0112" queda en estado "Pendiente de revisión manual" con el motivo "Sin objeto de referencia para medir la talla"

  # Casos borde

  Esquema del escenario: Foto movida o con poca luz
    Dado que el Patrón de la embarcación "IO-00005-EJ" registró la captura "CAP-0112" de "Perico"
    Y la foto de la captura <condicion_foto>
    Cuando el sistema intenta estimar la talla del ejemplar
    Entonces el sistema no informa una talla estimada
    Y la captura "CAP-0112" queda en estado "Pendiente de revisión manual" con el motivo "Foto no apta para medir la talla"

    Ejemplos:
      | condicion_foto         |
      | está movida            |
      | tiene poca iluminación |
