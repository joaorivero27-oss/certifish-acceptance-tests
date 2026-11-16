# language: es
# Historia: NF03 · Detectar la alteración de un certificado emitido (Seguridad, ISO/IEC 25010)
# Épica: EP05 · Sprint 2 · 3 SP
# Tareas: T26 (Generar el código de verificación y la huella de integridad) y T27 (Probar la integridad del certificado)
# Responsable: Joao Rivero

@EP05 @NF03
Característica: NF03 Detectar la alteración de un certificado emitido (Seguridad)
  Como responsable de comercio exterior de la empresa exportadora
  quiero que cualquier alteración de un certificado emitido se detecte al verificarlo con su código
  para no presentar ante el comprador o la aduana un certificado adulterado

  Antecedentes:
    Dado que el certificado con código de verificación "CF-7K2Q-9MXA" del lote "LOTE-CF-0002" fue emitido el 06/10/2026 con el siguiente contenido:
      | embarcacion | especie | metodo   | fecha y hora     | ubicacion GPS       | cantidad | estado     |
      | IO-00002-EJ | Perico  | Palangre | 01/10/2026 06:10 | 15°12' S · 75°20' O | 470 kg   | Verificada |
      | IO-00003-EJ | Perico  | Palangre | 02/10/2026 05:50 | 15°33' S · 75°06' O | 390 kg   | Aprobada   |
    Y la responsable de comercio exterior Andrea Salhuana está en la página pública "Verifica un certificado"

  # Flujo normal

  Escenario: Verificación de un certificado íntegro
    Dado que el contenido del certificado "CF-7K2Q-9MXA" no fue modificado desde su emisión
    Cuando Andrea ingresa el código "CF-7K2Q-9MXA" y hace click en el botón "Verificar"
    Entonces el sistema muestra el mensaje "Certificado auténtico: no ha sido alterado desde su emisión"

  Escenario: Meta de detección del 100 % en el conjunto de prueba
    Dado que existe el siguiente conjunto de prueba de certificados emitidos:
      | tipo de certificado             | cantidad |
      | íntegro                         | 25       |
      | con la especie modificada       | 5        |
      | con la cantidad modificada      | 5        |
      | con la fecha y hora modificadas | 5        |
      | con la ubicación modificada     | 5        |
      | con la embarcación modificada   | 5        |
    Cuando se verifican los 50 certificados con su código en la consulta pública
    Entonces los 25 certificados modificados, es decir el 100 %, se reportan como alterados
    Y ninguno de los 25 certificados íntegros se reporta como alterado

  # Manejo de errores

  Esquema del escenario: Verificación de un certificado alterado después de su emisión
    Dado que en el certificado "CF-7K2Q-9MXA" el dato "<dato>" de la primera captura fue modificado de "<valor_emitido>" a "<valor_alterado>" después de la emisión
    Cuando Andrea ingresa el código "CF-7K2Q-9MXA" y hace click en el botón "Verificar"
    Entonces el sistema muestra el mensaje "Certificado alterado: su contenido no coincide con el emitido"
    Y no presenta el certificado como válido

    Ejemplos:
      | dato          | valor_emitido       | valor_alterado      |
      | especie       | Perico              | Bonito              |
      | cantidad      | 470 kg              | 520 kg              |
      | fecha y hora  | 01/10/2026 06:10    | 03/10/2026 06:10    |
      | ubicacion GPS | 15°12' S · 75°20' O | 14°05' S · 76°15' O |
      | embarcacion   | IO-00002-EJ         | IO-00007-EJ         |

  # Casos borde

  Escenario: PDF del certificado editado fuera del sistema
    Dado que el PDF descargado del certificado "CF-7K2Q-9MXA" fue editado después de la descarga para cambiar la cantidad de la primera captura de "470 kg" a "520 kg"
    Cuando Andrea ingresa el código "CF-7K2Q-9MXA" en la consulta pública
    Entonces el sistema muestra el contenido original del certificado tal como se emitió
    Y la cantidad que muestra para la captura de la embarcación "IO-00002-EJ" es "470 kg"
