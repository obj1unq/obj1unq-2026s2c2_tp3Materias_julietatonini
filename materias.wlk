class Estudiante {

  const carreras = #{}

  const historiaAcadémica = new HistoriaAcadémica()


  method inscribirseACarrera(carrera){
    self.validarInscripcion(carrera)
    carreras.add(carrera)
  }


  method validarInscripcion(carrera){
    if (carreras.contains(carrera)){
      self.error("el estudiante ya se encuentra inscripto en esta carrera")
    }
  }


  method estaInscriptoEn(carrera){
    return carreras.contains(carrera)
  }


  method carreras(){
    return carreras
  }


  method esMateriaDeAlgunaCarrera(materia){
    return carreras.any({carrera => carrera.esMateriaDeLaCarrera(materia)})  
  }


  method finalizarLaCursada(materia, nota){
    self.validarMateriaDeCarreras(materia)
    self.validarNota(nota)
    self.validarMateriaAprobada(materia)
    const cursada = new Cursada(
    materia = materia,
    nota = nota
    )
    historiaAcadémica.registrarCursada(cursada)
  }


  method validarMateriaDeCarreras(materia){
    if (not self.esMateriaDeAlgunaCarrera(materia)){
      self.error("la materia no pertenece a ninguna carrera del estudiante")
    }
  }


  method validarNota(nota){
    if ((nota < 1) or (nota > 10)) {
      self.error("la nota no es válida")
    }
  }


  method validarMateriaAprobada(materia){
    if(historiaAcadémica.esMateriaAprobada(materia)){
      self.error("el estudiante ya aprobó esta materia antes")
    }
  }


  method aproboLaMateria(materia){
    return historiaAcadémica.esMateriaAprobada(materia)
  }


  method cantMateriasAprobadasDeCarrera(carrera){ 
    return historiaAcadémica.materiasAprobadasDeLaCarrera(carrera).size()
  }


  method promedioMateriasAprobadasDeCarrera(carrera) {
    self.validarQueEstaInscriptoEn(carrera)
    const notas = historiaAcadémica.notasDeMateriasAprobadasDe(carrera)
    if (notas.isEmpty()){
      self.error("no hay materias aprobadas en esta carrera")
    }
    return notas.sum() / notas.size()
  }


  method validarQueEstaInscriptoEn(carrera){
    if(not self.estaInscriptoEn(carrera)){
      self.error("el estudiante no se encuentra inscripto es esta carrera")
    }
  }



  method cantMateriasAprobadasEnTotal(){
    return historiaAcadémica.cantidadMateriasAprobadasEnTotal()
  }


  method promedioMateriasAprobadasEnTotal(){
    const notas = historiaAcadémica.notasDeMateriasAprobadasEnTotal()
    if (notas.isEmpty()){
      self.error("no hay materias aprobadas en ninguna carrera")
    }
    return notas.sum() / notas.size()
  }



  method todasLasCursadasDe(materia){
    return historiaAcadémica.todasLasCursadasDeLaMateria(materia)
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





class Cursada {

  const property materia 

  const property nota


  method estaAprobada(){
    return nota >= 6
  }

}






class HistoriaAcadémica {

  const property materiasAprobadas = #{}

  const property cursadas = [] 


  method esMateriaAprobada(materia){
    return materiasAprobadas.contains(materia)
  }


  method registrarCursada(cursada){
    cursadas.add(cursada)
    self.agregarMateriaSiEsAprobada(cursada)
  }


  method agregarMateriaSiEsAprobada(cursada){
    if(cursada.estaAprobada()){
      materiasAprobadas.add(cursada.materia())
    }
  }



  method cursadaAprobadaDe(materia) {
    return cursadas.find({cursada => cursada.materia() == materia and cursada.estaAprobada()})
  }


  method notasDeMateriasAprobadasDe(carrera){
    return self.materiasAprobadasDeLaCarrera(carrera).map({materia => self.cursadaAprobadaDe(materia).nota()})
  }


  method materiasAprobadasDeLaCarrera(carrera){        
    return self.materiasAprobadas().filter({materia => carrera.esMateriaDeLaCarrera(materia)})
  }


  method cantidadMateriasAprobadasEnTotal(){
    return materiasAprobadas.size()
  }

  method notasDeMateriasAprobadasEnTotal(){
    return materiasAprobadas.map({materia => self.cursadaAprobadaDe(materia).nota()})
  }


  method todasLasCursadasDeLaMateria(materia){
    return cursadas.filter({cursada => cursada.materia() == materia})
  }

   

 
}