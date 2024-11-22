class Persona {
  var edad
  var emociones = []
  var valorElevado
  
  method esAdolecente() = (edad >= 12) && (edad <= 19)
  
  method agregarEmocion(emocion) {
    emociones.add(emocion)
  }
  
  method estaPorExplotar(unEvento) = emociones.all(
    { unaEmocion => unaEmocion.puedeLiberarse(unEvento) }
  )
  
  method vivirEvento(unEvento) {
    emociones.forEach(
      { unaEmocion => unaEmocion.registrarEvento()
        if (unaEmocion.puedeLiberarse(unEvento)) unaEmocion.liberarse(unEvento)
      }
    )
  }
  
  method vivirEventoEnGrupo(grupo, unEvento) {
    grupo.forEach({ unaPersona => unaPersona.vivirEvento(unEvento) })
  }
  
  method modificarValorElevado(nuevoValor) {
    valorElevado = nuevoValor
  }
}

class Evento {
  var property impacto = 0
  var property descripcion = ""
}

class Emocion {
  var intensidad = 0
  var eventosVividos = 0
  
  method registrarEvento() {
    eventosVividos += 1
  }
  
  method puedeLiberarse() 
  
  method liberarse(unEvento) 
}

class Furia inherits Emocion {
  var palabrotas = []
  
  method establecerIntensidad(valor) {
    intensidad = valor // inicia con valor = 100
  }
  
  method agregarPalabrota(palabra) {
    palabrotas.add(palabra)
  }
  
  method esIntensidadElevada() = intensidad > Persona.valorElevado
  
  override method puedeLiberarse() = 
  self.esIntensidadElevada() && palabrotas.any({ palabra => palabra.size() > 7 })
  
  override method liberarse(unEvento) {
    if (self.puedeLiberarse()) {
      intensidad -= unEvento.impacto()
      if (palabrotas.size() > 0) { 
        palabrotas.removeAt(0) // Para olvidar la primera palabrota de la lista
      } 
    }
  }
}

class Alegria inherits Emocion {

  method establecerIntensidad(valor) {
    intensidad = valor
  }
  
  override method puedeLiberarse() = intensidad > Persona.valorElevado && (eventosVividos % 2) == 0
  
  override method liberarse(unEvento) {
    if (self.puedeLiberarse()) {
      intensidad -= unEvento.impacto() // Disminuimos la intensidad
      if (intensidad < 0) {
        intensidad = -intensidad  // Si es negativa la pasamos a positiva
      }
    }
  }
}

class Tristeza inherits Emocion {
  var causa = "melancolía" // Es la causa inicial de tristeza
  
  method establecerIntensidad(valor) {
    intensidad = valor
  }
  
  override method puedeLiberarse() = causa != "melancolía" && intensidad > Persona.valorElevado
  
  override method liberarse(unEvento) {
    if (self.puedeLiberarse()) {
      causa = unEvento.descripcion() // Actualizamos la causa con la descripcion del evento
      intensidad -= unEvento.impacto() // Disminuimos la intensidaf
    }
  }
}

class EmocionSimple inherits Emocion { // Abarca tanto al desagrado como al temor ya que comparten logica
  
  override method puedeLiberarse() = (intensidad > Persona.valorElevado) && (eventosVividos > intensidad)
  
  override method liberarse(unEvento) {
    if (self.puedeLiberarse()) {
      intensidad -= unEvento.impacto() // Disminuimos la intensidad
    }
  }
}

class Desagrado inherits EmocionSimple {}

class Temor inherits EmocionSimple {}

class Ansiedad inherits Emocion {
  var nivelPreocupacion = 0 // Implementacion diferente de los demas
  
  override method puedeLiberarse() = nivelPreocupacion > 5 && intensidad > Persona.valorElevado
  
  // Liberar la emocion ansiedad disminuye la intensidad y reduce la preocupación
  override method liberarse(unEvento) {
    if (self.puedeLiberarse()) {
      intensidad -= unEvento.impacto()
      nivelPreocupacion -= 5 // Reduce la preocupacion
      if (nivelPreocupacion < 0) {
        nivelPreocupacion = 0  // La preocupacion no puede ser negativa
      }
    }
  }
}

// En cuanto a herencia Ansiedad hereda atributos intensidad, eventosVividos y el metodo registrarEvento de Emocion.// En cuanto a herencia Ansiedad hereda atributos intensidad, eventosVividos y el metodo registrarEvento de Emocion.
// Sobrescribe metodos como puedeLiberarse y liberarse para implementar su propio comportamiento.

// Por parte del polimorfismo tenemos una clase base Emocion con metodos como puedeLiberarse y liberarse. 
// La clase Ansiedad tiene su propia forma de liberar la emocion, pero la tratamos de manera polimorfica igual que a todas 
// las emociones, todas entienden el mismo mensaje
