# language: es
# Historia: HU-11 · Verificar públicamente un certificado de lote
# Épica: EP05 · Sprint 2 · 5 SP
# Tareas: T28 (Crear la página pública de consulta), T29 (Validar la autenticidad y la integridad), T30 (Mostrar el mensaje de código inválido) y T31 (Probar el acceso sin cuenta)
# Responsable: Joao Rivero

@EP05 @HU-11
Característica: HU-11 Verificar públicamente un certificado de lote
  Como tercero interesado en un lote
  quiero validar la autenticidad e integridad de un certificado mediante su código de verificación, sin necesitar una cuenta
  para contar con evidencia verificable del origen del lote antes de aceptarlo

  Antecedentes:
    Dado que el tercero interesado está en la página pública "Verifica un certificado" sin haber iniciado sesión
    Y el código de verificación tiene el formato "CF-XXXX-XXXX", con letras mayúsculas y dígitos
    Y existe un certificado emitido con el código de verificación "CF-7K2Q-9MXA" para el lote "LOTE-CF-0002"

  # Flujo normal

  Escenario: Verificación exitosa de un certificado auténtico
    Dado que el certificado "CF-7K2Q-9MXA" no fue modificado desde su emisión
    Cuando el tercero interesado ingresa el código "CF-7K2Q-9MXA" y hace click en el botón "Verificar"
    Entonces el sistema confirma que el certificado es auténtico y que no ha sido alterado desde su emisión
    Y muestra la cooperativa "Cooperativa Mar Azul" y la especie "Perico"
    Y muestra, por cada captura, los siguientes datos:
      | matricula   | metodo   | fecha y hora     | ubicacion GPS       | cantidad | estado     |
      | IO-00002-EJ | Palangre | 01/10/2026 06:10 | 15°12' S · 75°20' O | 470 kg   | Verificada |
      | IO-00003-EJ | Palangre | 02/10/2026 05:50 | 15°33' S · 75°06' O | 390 kg   | Aprobada   |
    Y no muestra nombres ni otros datos personales de los Patrones de embarcación
    Y no solicita iniciar sesión ni crear una cuenta

  # Manejo de errores

  Esquema del escenario: Código de verificación inexistente, vacío o con formato incorrecto
    Cuando el tercero interesado ingresa el código "<codigo>" y hace click en el botón "Verificar"
    Entonces el sistema <consulta>
    Y muestra el mensaje "<mensaje>"

    Ejemplos:
      | codigo       | consulta                    | mensaje                                   |
      | CF-0000-0000 | no encuentra el certificado | Código de verificación no válido.         |
      |              | no realiza la consulta      | Ingresa un código de verificación válido. |
      | 7K2Q9MXA     | no realiza la consulta      | Ingresa un código de verificación válido. |
      | CF-7K2Q      | no realiza la consulta      | Ingresa un código de verificación válido. |
      | CF-7K2Q-9MX! | no realiza la consulta      | Ingresa un código de verificación válido. |
