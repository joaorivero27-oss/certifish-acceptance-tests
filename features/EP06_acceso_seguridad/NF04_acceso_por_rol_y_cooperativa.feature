# language: es
# Historia: NF04 · Restringir el acceso según rol y cooperativa (Seguridad, ISO/IEC 25010)
# Épica: EP06 · Sprint 4 · 3 SP
# Tareas: T70 (Controlar el acceso por rol en la interfaz), T71 (Validar los permisos en el servidor) y T72 (Mostrar el mensaje de error de autorización)
# Responsable: Lionel Fiestas

@EP06 @NF04
Característica: NF04 Restringir el acceso según rol y cooperativa (Seguridad)
  Como Coordinador
  quiero que cada usuario solo vea y ejecute lo que corresponde a su rol y a su cooperativa
  para proteger la información de mi cooperativa y la integridad del proceso

  Antecedentes:
    Dado que existen los siguientes usuarios:
      | usuario                     | correo                      | rol                   | cooperativa              | embarcacion |
      | Edgar Paredes               | edgar.paredes@marazul.test  | Coordinador           | Cooperativa Mar Azul     | —           |
      | Walter Mendoza              | walter.mendoza@marazul.test | Patrón de embarcación | Cooperativa Mar Azul     | IO-00002-EJ |
      | Patrón de prueba B          | patron.b@marazul.test       | Patrón de embarcación | Cooperativa Mar Azul     | IO-00003-EJ |
      | Coordinador de Puerto Nuevo | coord@puertonuevo.test      | Coordinador           | Cooperativa Puerto Nuevo | —           |
    Y existen los siguientes registros:
      | registro     | tipo    | cooperativa              | embarcacion | estado      |
      | CAP-0110     | captura | Cooperativa Mar Azul     | IO-00002-EJ | Verificada  |
      | CAP-0111     | captura | Cooperativa Mar Azul     | IO-00003-EJ | Aprobada    |
      | CAP-0201     | captura | Cooperativa Puerto Nuevo | IO-00009-EJ | Verificada  |
      | LOTE-CF-0002 | lote    | Cooperativa Mar Azul     | —           | Consolidado |
      | LOTE-PN-0001 | lote    | Cooperativa Puerto Nuevo | —           | Consolidado |

  # Flujo normal

  Esquema del escenario: Funcionalidades según el rol
    Dado que "<usuario>" inició sesión con el rol de "<rol>"
    Cuando accede al sistema
    Entonces el menú muestra únicamente las opciones "<opciones_visibles>"
    Y no muestra las opciones "<opciones_ocultas>"

    Ejemplos:
      | usuario        | rol                   | opciones_visibles                               | opciones_ocultas                         |
      | Edgar Paredes  | Coordinador           | Resumen, Revisión manual, Cierres, Lotes        | Registrar captura, Mis capturas          |
      | Walter Mendoza | Patrón de embarcación | Registrar captura, Mis capturas, Notificaciones | Resumen, Revisión manual, Cierres, Lotes |

  # Manejo de errores

  Esquema del escenario: Acción fuera del rol
    Dado que Walter Mendoza inició sesión con el rol de "Patrón de embarcación"
    Cuando intenta <accion>
    Entonces el sistema deniega la acción
    Y muestra: "No tienes autorización para acceder a esta sección."
    Y <comprobacion>

    Ejemplos:
      | accion                                                              | comprobacion                                             |
      | consolidar las capturas "CAP-0110" y "CAP-0111" en un lote          | no se crea ningún lote nuevo                             |
      | registrar un cierre de "Perico" con la "R.M. N° 09999-2026-PRODUCE" | no se registra ningún cierre                             |
      | emitir el certificado del lote "LOTE-CF-0002"                       | el lote "LOTE-CF-0002" permanece en estado "Consolidado" |

  Esquema del escenario: Solicitud directa al servidor
    Dado que "<usuario>" inició sesión con el rol de "<rol>"
    Cuando envía directamente al servidor, sin pasar por la interfaz, la operación "<operacion>"
    Entonces el servidor rechaza la operación
    Y muestra: "No tienes autorización para acceder a esta sección."
    Y <comprobacion>

    Ejemplos:
      | usuario        | rol                   | operacion                                     | comprobacion                                             |
      | Walter Mendoza | Patrón de embarcación | emitir el certificado del lote LOTE-CF-0002   | el lote "LOTE-CF-0002" permanece en estado "Consolidado" |
      | Walter Mendoza | Patrón de embarcación | aprobar la captura CAP-0110                   | la captura "CAP-0110" permanece en estado "Verificada"   |
      | Edgar Paredes  | Coordinador           | registrar una captura a nombre de IO-00002-EJ | no se registra ninguna captura nueva                     |

  # Casos borde

  Esquema del escenario: Datos de otra cooperativa
    Dado que Edgar Paredes inició sesión como Coordinador de la "Cooperativa Mar Azul"
    Cuando intenta consultar <recurso> "<identificador>" de la "Cooperativa Puerto Nuevo"
    Entonces el sistema deniega el acceso
    Y no muestra ningún dato de "<identificador>"

    Ejemplos:
      | recurso        | identificador |
      | la captura     | CAP-0201      |
      | la embarcación | IO-00009-EJ   |
      | el lote        | LOTE-PN-0001  |

  Escenario: Capturas de otro Patrón
    Dado que Walter Mendoza inició sesión con el rol de "Patrón de embarcación"
    Cuando intenta consultar la captura "CAP-0111", registrada por la embarcación "IO-00003-EJ"
    Entonces el sistema deniega el acceso
    Y no muestra los datos de la captura "CAP-0111"
    Y en "Mis capturas" solo aparecen capturas de la embarcación "IO-00002-EJ"
