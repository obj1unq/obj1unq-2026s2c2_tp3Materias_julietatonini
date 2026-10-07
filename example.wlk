class Estudiante {

  const carreras = #{}


  method inscribirseACarrera(carrera){
    self.validarInscripcion(carrera)
    carreras.add(carrera)
  }


  method validarInscripcion(carrera){
    if (carreras.contains(carrera)){
      self.error("el estudiante ya se encuentra inscripto en esta carrera")
    }
  }


  method carreras(){
    return carreras
  }


  method esMateriaDeAlgunaCarrera(materia){
    return carreras.any({carrera => carrera.esMateriaDeLaCarrera(materia)})  
  }

  
}




class Carrera {

  const materias = #{}


  method materias(){
    return materias 
  }

  method esMateriaDeLaCarrera(materia){
    return materias.contains(materia)
  }
}




class Materia {

}