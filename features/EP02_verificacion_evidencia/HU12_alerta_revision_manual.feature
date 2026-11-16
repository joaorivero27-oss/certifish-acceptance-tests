# language: es
# Historia: HU-12 · Recibir alerta de captura pendiente de revisión manual
# Épica: EP02 · Sprint 4 · 2 SP
# Tareas: T53 (Notificar por push la revisión pendiente), T54 (Enviar el correo de respaldo) y T55 (Agrupar las alertas)
# Responsable: Joao Rivero

@EP02 @HU-12
Característica: HU-12 Recibir alerta de captura pendiente de revisión manual
  Como Coordinador
  quiero recibir una alerta cuando una verificación automática resulte con un nivel de confianza menor al 80 %
  para revisar manualmente esa captura antes de que afecte un lote

  Antecedentes:
    Dado que el Coordinador Edgar Paredes de la "Cooperativa Mar Azul" tiene activas las notificaciones push en su celular
    Y tiene registrado el correo electrónico "edgar.paredes@marazul.test"

  # Flujo normal

  Esquema del escenario: Alerta en un máximo de 1 minuto cuando una captura queda pendiente de revisión manual
    Dado que la captura "<captura>" pertenece a una embarcación de la cooperativa del Coordinador
    Cuando la captura "<captura>" pasa al estado "Pendiente de revisión manual" por <causa>
    Entonces el Coordinador recibe una notificación push y un correo electrónico en un máximo de 1 minuto
    Y la alerta indica la captura "<captura>" y el motivo "<motivo>"

    Ejemplos:
      | captura  | causa                  | motivo                                                      |
      | CAP-0121 | una confianza de 72 %  | Nivel de confianza menor al 80 %.                           |
      | CAP-0124 | una falla del servicio | El servicio de verificación no respondió tras 3 reintentos. |

  # Manejo de errores

  Escenario: Correo electrónico de respaldo cuando falla la notificación push
    Dado que la captura "CAP-0121" pasó al estado "Pendiente de revisión manual"
    Cuando el envío de la notificación push al Coordinador falla
    Entonces el sistema envía el correo electrónico de la alerta a "edgar.paredes@marazul.test"
    Y el correo indica la captura "CAP-0121" y el motivo de la alerta

  # Casos borde

  Esquema del escenario: Agrupación de alertas de capturas que quedan pendientes en un lapso de hasta 10 minutos
    Dado que la captura "CAP-0121" pasó al estado "Pendiente de revisión manual" a las 06:00
    Y el Coordinador recibió la alerta de esa captura
    Cuando la captura "CAP-0122" pasa al estado "Pendiente de revisión manual" a las <hora>
    Entonces el sistema <accion> en un máximo de 1 minuto
    Y el Coordinador tiene <alertas> alerta(s) de revisión manual
    Y la última alerta indica "<texto_alerta>"

    Ejemplos:
      | hora  | accion                       | alertas | texto_alerta                                     |
      | 06:04 | actualiza la alerta anterior | 1       | 2 capturas pendientes de revisión manual         |
      | 06:10 | actualiza la alerta anterior | 1       | 2 capturas pendientes de revisión manual         |
      | 06:11 | envía una nueva alerta       | 2       | 1 captura pendiente de revisión manual: CAP-0122 |
