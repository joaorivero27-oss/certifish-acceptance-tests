# language: es
# Historia: NF01 · Registrar capturas sin conexión (Fiabilidad, ISO/IEC 25010)
# Épica: EP01 · Sprint 1 · 2 SP
# Tareas: T04 (Implementar el registro sin conexión) y T05 (Sincronizar sin duplicados los envíos interrumpidos)
# Responsable: Lionel Fiestas
**
@EP01 @NF01
Característica: NF01 Registrar capturas sin conexión (Fiabilidad)
  Como Patrón de embarcación
  quiero registrar mis capturas aunque no tenga señal en altamar
  para no perder ningún registro y que se envíen solas cuando recupere la conexión

  Antecedentes:
    Dado que el Patrón Walter Mendoza de la embarcación "IO-00002-EJ" de la "Cooperativa Mar Azul" ha iniciado sesión en la aplicación móvil de CertiFish
    Y la velocidad mínima de conexión para enviar capturas es de 55 kbps

  # Flujo normal

  Escenario: Registro sin señal
    Dado que el celular del Patrón no tiene conexión a internet
    Cuando el Patrón registra la captura "CAP-0130" con los siguientes datos:
      | dato                          | valor               |
      | especie                       | Perico              |
      | cantidad                      | 420 kg              |
      | metodo                        | Palangre            |
      | foto                          | cap0130_01.jpg      |
      | fecha y hora del dispositivo  | 07/10/2026 05:40    |
      | ubicacion GPS del dispositivo | 15°20' S · 75°10' O |
    Entonces la app guarda la captura "CAP-0130" en el celular con el indicador "Pendiente de envío"
    Y conserva la fecha y hora "07/10/2026 05:40" y la ubicación "15°20' S · 75°10' O" del momento del registro
    Y muestra: "Captura guardada. Se enviará cuando tengas señal."

  Esquema del escenario: Envío automático al recuperar la conexión
    Dado que el celular guarda las siguientes capturas con el indicador "Pendiente de envío":
      | captura  | especie | cantidad | fecha y hora del registro |
      | CAP-0130 | Perico  | 420 kg   | 07/10/2026 05:40          |
      | CAP-0131 | Perico  | 380 kg   | 07/10/2026 08:15          |
      | CAP-0132 | Pota    | 250 kg   | 07/10/2026 11:30          |
    Cuando el celular recupera una conexión de <velocidad> kbps a las 14:00, sin que el Patrón haga ninguna acción
    Entonces la app envía las 3 capturas a más tardar a las 15:00
    Y las capturas "CAP-0130", "CAP-0131" y "CAP-0132" quedan en estado "Registrada"
    Y cada captura conserva la fecha y hora de su registro, no la del envío

    Ejemplos:
      | velocidad |
      | 55        |
      | 512       |

  # Manejo de errores

  Escenario: Envío interrumpido
    Dado que el celular guarda las capturas "CAP-0130", "CAP-0131" y "CAP-0132" con el indicador "Pendiente de envío"
    Y la app comenzó a enviarlas con una conexión de 128 kbps
    Cuando la conexión se corta después de enviar "CAP-0130" y mientras envía "CAP-0131"
    Y el celular recupera una conexión de 128 kbps y la app reintenta el envío
    Entonces el sistema tiene registradas las siguientes capturas:
      | captura  | veces registrada | estado     |
      | CAP-0130 | 1                | Registrada |
      | CAP-0131 | 1                | Registrada |
      | CAP-0132 | 1                | Registrada |
    Y en el celular no queda ninguna captura con el indicador "Pendiente de envío"

  # Casos borde

  Esquema del escenario: Conexión lenta
    Dado que la conexión del celular es de <velocidad> kbps
    Cuando el Patrón registra la captura "CAP-0133" de "Perico" con 300 kg
    Entonces la app guarda la captura "CAP-0133" con el indicador "Pendiente de envío"
    Y no la envía mientras la conexión siga por debajo de 55 kbps

    Ejemplos:
      | velocidad |
      | 54        |
      | 20        |

  Esquema del escenario: App cerrada o celular apagado
    Dado que el celular guarda las capturas "CAP-0130" y "CAP-0131" con el indicador "Pendiente de envío"
    Cuando <evento>
    Y el Patrón vuelve a abrir la app sin conexión
    Entonces la app muestra las capturas "CAP-0130" y "CAP-0131" con el indicador "Pendiente de envío"
    Y al recuperar una conexión de 55 kbps la app las envía y quedan en estado "Registrada"

    Ejemplos:
      | evento                                                 |
      | el Patrón cierra la app                                |
      | el celular se apaga por batería y se vuelve a encender |
