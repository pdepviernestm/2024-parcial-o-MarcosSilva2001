class Persona {
  var edad
  var emociones = []
  var valorElevado

  method esAdolecente() = edad >= 12 && edad <= 19

  method agregarEmocion(emocion) {
        emociones.add(emocion)
  }
  
  method estaPorExplotar(unEvento) = emociones.all({ unaEmocion => unaEmocion.puedeLiberarse(unEvento) })

  method vivirEvento(unEvento) {
    emociones.forEach({ unaEmocion => unaEmocion.registrarEvento()
    if (unaEmocion.puedeLiberarse(unEvento)) {
        unaEmocion.liberarse(unEvento)
      }
    })
  }

  method vivirEventoEnGrupo(grupo, unEvento) {
    grupo.forEach({ unaPersona => unaPersona.vivirEvento(unEvento) })
  }

  method modificarValorElevado(nuevoValor) {
    valorElevado = nuevoValor
  }
  
}

class Evento {
    var impacto = 0
    var descripcion = ""
}

class Emocion {
  var intensidad = 0
  var eventosVividos = 0

  method registrarEvento() {
    eventosVividos += 1
  }

  method puedeLiberarse(unEvento) {}

  method liberarse(unEvento) {} 

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

    override method puedeLiberarse(unEvento) = 
        self.esIntensidadElevada() && palabrotas.any({ palabra => palabra.size() > 7 })

    override method liberarse(unEvento) {
        if (self.puedeLiberarse(unEvento)) {
            intensidad -= unEvento.impacto
            if (palabrotas.size() > 0) {
                palabrotas.removeAt(0) // Para olvidar la primera palabrota de la lista
            }
        }
    }
}

