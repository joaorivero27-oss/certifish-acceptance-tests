# language: es
# Historia: HU-10 · Descargar el certificado y preparar los datos del lote en formato CATCH o SIMP
# Épica: EP05 · Sprint 3 · 3 SP
# Tareas: T32 (Generar el PDF del certificado), T33 (Preparar los datos en formato CATCH o SIMP), T34 (Validar los datos contra el esquema oficial), T35 (Registrar las descargas y preparaciones) y T36 (Impedir la descarga de un lote sin certificado)
# Responsable: Joao Rivero

@EP05 @HU-10
Característica: HU-10 Descargar el certificado y preparar los datos del lote en formato CATCH o SIMP
  Como Coordinador
  quiero descargar el certificado del lote en PDF y preparar los datos del lote en el formato que exige el mercado de destino (CATCH para la Unión Europea o SIMP para Estados Unidos), ambos con su código de verificación
  para entregarlos a la empresa exportadora

  Antecedentes:
    Dado que el Coordinador Edgar Paredes ha iniciado sesión en la plataforma web de la "Cooperativa Mar Azul"
    Y está en el detalle del lote "LOTE-CF-0002" de "Perico"

  # Flujo normal

  Escenario: Descarga del certificado en PDF
    Dado que el lote "LOTE-CF-0002" está en estado "Certificado" con el código de verificación "CF-7K2Q-9MXA"
    Cuando el Coordinador hace click en el botón "Descargar certificado (PDF)"
    Entonces el sistema entrega el archivo PDF del certificado con el código de verificación "CF-7K2Q-9MXA"
    Y registra la descarga en el "Historial de descargas" con la fecha, la hora y el Coordinador responsable

  Esquema del escenario: Preparación de los datos del lote para el mercado de destino
    Dado que el lote "LOTE-CF-0002" está en estado "Certificado" con el código de verificación "CF-7K2Q-9MXA"
    Cuando el Coordinador elige "<mercado>" como mercado de destino y hace click en el botón "<boton>"
    Entonces el sistema valida los datos del lote contra el esquema oficial vigente de <formato>
    Y entrega los datos del lote con la estructura de <formato> y el código de verificación "CF-7K2Q-9MXA"
    Y registra la preparación en el "Historial de descargas" con la fecha, la hora y el Coordinador responsable

    Ejemplos:
      | mercado        | boton                            | formato |
      | Unión Europea  | Generar documento CATCH (UE)     | CATCH   |
      | Estados Unidos | Generar documento SIMP (EE. UU.) | SIMP    |

  # Manejo de errores

  Esquema del escenario: Falla en la generación del archivo
    Dado que el lote "LOTE-CF-0002" está en estado "Certificado"
    Cuando el Coordinador hace click en el botón "<boton>" y ocurre un error al generar el archivo
    Entonces el sistema muestra el mensaje "No se pudo generar el archivo. Intenta nuevamente."
    Y no registra la solicitud en el "Historial de descargas"

    Ejemplos:
      | boton                            |
      | Descargar certificado (PDF)      |
      | Generar documento CATCH (UE)     |
      | Generar documento SIMP (EE. UU.) |

  Esquema del escenario: Datos del lote que no cumplen el esquema oficial
    Dado que el lote "LOTE-CF-0002" está en estado "Certificado"
    Y los datos del lote no cumplen el esquema oficial vigente de <formato>
    Cuando el Coordinador hace click en el botón "<boton>"
    Entonces el sistema muestra el mensaje "Los datos del lote no cumplen el formato oficial. Revisa la información del lote."
    Y no entrega el archivo

    Ejemplos:
      | formato | boton                            |
      | CATCH   | Generar documento CATCH (UE)     |
      | SIMP    | Generar documento SIMP (EE. UU.) |

  Esquema del escenario: Intento de descargar o preparar los datos de un lote sin certificado emitido
    Dado que el lote "LOTE-CF-0002" está en estado "Consolidado"
    Cuando el Coordinador solicita la acción "<accion>"
    Entonces el sistema muestra el mensaje "El lote debe estar certificado antes de descargar el PDF o preparar sus datos."
    Y no entrega ningún archivo

    Ejemplos:
      | accion                           |
      | Descargar certificado (PDF)      |
      | Generar documento CATCH (UE)     |
      | Generar documento SIMP (EE. UU.) |

  # Casos borde

  Escenario: Solicitudes repetidas del mismo lote certificado
    Dado que el lote "LOTE-CF-0002" está en estado "Certificado"
    Y el "Historial de descargas" del lote registra los siguientes eventos:
      | fecha      | hora  | documento            | responsable   |
      | 06/10/2026 | 10:20 | Certificado PDF      | Edgar Paredes |
      | 07/10/2026 | 09:05 | Documento CATCH (UE) | Edgar Paredes |
    Cuando el Coordinador vuelve a hacer click en el botón "Descargar certificado (PDF)" el 08/10/2026 a las 11:40
    Entonces el sistema entrega nuevamente el PDF del certificado
    Y el "Historial de descargas" registra un nuevo evento independiente:
      | fecha      | hora  | documento       | responsable   |
      | 08/10/2026 | 11:40 | Certificado PDF | Edgar Paredes |
    Y el historial conserva los 2 eventos anteriores
