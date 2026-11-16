# language: es
# Historia: HU-02 · Verificación automática de la captura registrada
# Épica: EP02 · Sprint 1 · 5 SP
# Tareas: T06 (Comparar la especie declarada con la observada), T07 (Validar la coherencia del peso o volumen), T08 (Contrastar la ubicación y asignar confianza y estado), T09 (Probar el rendimiento de la verificación), T10 (Reintentar la verificación y derivar a revisión manual) y T11 (Disparar la alerta al Coordinador desde la verificación)
# Responsable: Joao Rivero

@EP02 @HU-02
Característica: HU-02 Verificación automática de la captura registrada
  Como Patrón de embarcación
  quiero que el sistema verifique automáticamente mi captura contra la foto adjunta
  para saber si quedó "Verificada" o si requiere revisión manual del Coordinador

  Antecedentes:
    Dado que el Patrón de la embarcación "IO-00002-EJ", de la "Cooperativa Mar Azul", registró la captura "CAP-0110" con los siguientes datos:
      | dato                          | valor               |
      | especie                       | Perico              |
      | cantidad                      | 430 kg              |
      | metodo                        | Palangre            |
      | foto                          | cap0110_01.jpg      |
      | ubicacion GPS del dispositivo | 15°18' S · 75°12' O |
      | fecha y hora del dispositivo  | 07/10/2026 06:05    |
    Y la captura "CAP-0110" está en estado "Registrada"
    Y la Talla Mínima de Captura vigente para "Perico" es de 70 cm de longitud a la horquilla

  # Flujo normal

  Escenario: Captura verificada cuando todas las comprobaciones coinciden con la foto
    Dado que la foto "cap0110_01.jpg" muestra un objeto de referencia visible junto al ejemplar
    Y los metadatos EXIF de la foto registran la ubicación "15°18' S · 75°12' O" y la fecha y hora "07/10/2026 06:05"
    Cuando el sistema ejecuta la verificación automática de la captura "CAP-0110"
    Entonces el resultado de la verificación automática muestra:
      | comprobacion           | resultado                                 |
      | Especie en la foto     | Perico, coincide con la especie declarada |
      | Talla estimada         | 78 cm, cumple la Talla Mínima de Captura  |
      | Peso o volumen         | Coherente con lo estimado en la foto      |
      | Ubicación GPS vs. EXIF | Coinciden                                 |
      | Fecha y hora vs. EXIF  | Coinciden                                 |
    Y el nivel de confianza de la verificación es igual o mayor al 80 %
    Y la captura "CAP-0110" queda en estado "Verificada"
    Y el estado se asigna en un máximo de 8 segundos desde el envío de la foto

  # Manejo de errores

  Esquema del escenario: Captura enviada a revisión manual cuando una comprobación no coincide con la foto
    Dado que la foto "cap0110_01.jpg" muestra un objeto de referencia visible junto al ejemplar
    Y la verificación automática obtiene en la comprobación "<comprobacion>" el resultado "<resultado>"
    Y las demás comprobaciones coinciden con los datos declarados
    Cuando finaliza la verificación automática de la captura "CAP-0110"
    Entonces la captura "CAP-0110" queda en estado "Pendiente de revisión manual"
    Y la comprobación "<comprobacion>" se marca como inconsistencia con el motivo "<motivo>"
    Y la captura "CAP-0110" no queda en estado "Rechazada"

    Ejemplos:
      | comprobacion           | resultado           | motivo                                              |
      | Especie en la foto     | Bonito              | La especie de la foto no coincide con la declarada. |
      | Talla estimada         | 64 cm               | La talla es menor a la Talla Mínima de Captura.     |
      | Peso o volumen         | 150 kg estimados    | El peso o volumen no es coherente con la foto.      |
      | Ubicación GPS vs. EXIF | 16°40' S · 73°20' O | La ubicación GPS no coincide con el EXIF.           |
      | Fecha y hora vs. EXIF  | 05/10/2026 22:40    | La fecha y hora no coinciden con el EXIF.           |

  Escenario: Captura enviada a revisión manual por un nivel de confianza menor al 80 %
    Dado que la verificación automática no encuentra inconsistencias en las comprobaciones
    Y el nivel de confianza de la verificación es de 72 %
    Cuando finaliza la verificación automática de la captura "CAP-0110"
    Entonces la captura "CAP-0110" queda en estado "Pendiente de revisión manual" con el motivo "Nivel de confianza menor al 80 %."
    Y la captura "CAP-0110" no queda en estado "Rechazada"

  Escenario: La captura permanece "Registrada" mientras el sistema reintenta la verificación
    Dado que el servicio de verificación automática no responde dentro del tiempo esperado
    Cuando el sistema intenta verificar la captura "CAP-0110"
    Entonces la captura "CAP-0110" permanece en estado "Registrada"
    Y el sistema reintenta la verificación hasta 3 veces

  Esquema del escenario: Resultado de la verificación según los intentos fallidos del servicio
    Dado que la foto "cap0110_01.jpg" cumple todas las comprobaciones con un nivel de confianza de 91 %
    Y el servicio de verificación automática falla en <intentos_fallidos> intentos consecutivos
    Cuando el sistema termina de procesar la verificación de la captura "CAP-0110"
    Entonces el sistema realiza <reintentos> reintentos
    Y la captura "CAP-0110" queda en estado "<estado_final>"

    Ejemplos:
      | intentos_fallidos | reintentos | estado_final                 |
      | 1                 | 1          | Verificada                   |
      | 3                 | 3          | Verificada                   |
      | 4                 | 3          | Pendiente de revisión manual |

  Escenario: Captura enviada a revisión manual cuando fallan los 3 reintentos
    Dado que el servicio de verificación automática no responde en el intento inicial ni en ninguno de los 3 reintentos
    Cuando el sistema agota los reintentos de la verificación de la captura "CAP-0110"
    Entonces la captura "CAP-0110" queda en estado "Pendiente de revisión manual" con el motivo "El servicio de verificación no respondió tras 3 reintentos."
    Y el sistema notifica al Coordinador de la "Cooperativa Mar Azul"

  # Casos borde

  Escenario: Alerta al Coordinador cuando la captura pasa a revisión manual
    Dado que la captura "CAP-0110" pasó al estado "Pendiente de revisión manual" con el motivo "Nivel de confianza menor al 80 %."
    Cuando el sistema registra el cambio de estado
    Entonces el sistema genera una alerta de revisión manual para el Coordinador de la "Cooperativa Mar Azul"
    Y la alerta indica la captura "CAP-0110" y su motivo
