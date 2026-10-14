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



  method puedeInscribirseAMateria(materia){
    return self.esMateriaDeAlgunaCarrera(materia) and     // _m_ corresponde a una carrera de _e_
    not self.aproboLaMateria(materia)             and     // _e_ no puede haber aprobado _m_ previamente
    not self.inscriptoEnLaMateria(materia)        and     // _e_ no debe estar ya inscripta en _m_
    self.aproboTodosLosRequisitosDe(materia)              // _e_ tiene aprobadas las materias _requisitos_ de _m_
  }


  method inscriptoEnLaMateria(materia){
    return materia.estudiantesInscriptos().contains(self)
  }


  method aproboTodosLosRequisitosDe(materia) {
    return materia.cumpleRequisitos(self)
  }


  method inscribirAMateria(materia){
    if (self.puedeInscribirseAMateria(materia)) {
      historiaAcadémica.inscribirAlEstudianteEnLaMateria(materia)
      materia.inscribirAEstudiante(self)
    } else {
      self.error("el estudiante no puede inscribirse a esta materia")
    }
  }



  method materiasHabilitadasDeLaCarrera(carrera){
    self.validarQueEstaInscriptoEn(carrera)
    return carrera.materias().filter({materia => self.puedeInscribirseAMateria(materia)})
  }


  method creditosObtenidos(carrera){
    return historiaAcadémica.creditosDeLaCarrera(carrera)
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

    const property requisito

    const estudiantesInscriptos = #{}

    const property creditosQueOtorga 

    const property añoDeCarrera

    var carrera = null


    method carrera() {
      return carrera
    }


    method carrera(unaCarrera) {
     carrera = unaCarrera
    }


    method cumpleRequisitos(estudiante) {
      return requisito.cumplePara(estudiante, self)}
  
  

    method inscribirAEstudiante(estudiante){
      estudiantesInscriptos.add(estudiante)
    }


    method estudiantesInscriptos(){
      return estudiantesInscriptos
    }




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

  const property inscriptoEnMaterias = #{}

  // var creditosTotales = 0



  method esMateriaAprobada(materia){
    return materiasAprobadas.contains(materia)
  }


  method registrarCursada(cursada){
    if (cursada.estaAprobada()){
      materiasAprobadas.add(cursada.materia())
      // creditosTotales += cursada.materia().creditosQueOtorga()   
    }
    cursadas.add(cursada)
    inscriptoEnMaterias.remove(cursada.materia())
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


  method estaInscriptoEnMateria(materia){
    return inscriptoEnMaterias.contains(materia)
  }
  

  method inscribirAlEstudianteEnLaMateria(materia){
    inscriptoEnMaterias.add(materia)
  }


  method creditosDeLaCarrera(carrera){
    return self.materiasAprobadasDeLaCarrera(carrera).sum({materia => materia.creditosQueOtorga()})
  }


  //method creditosTotales(){
  //  return creditosTotales
  //}


 
}





class Correlativas{

  const materiasCorrelativas 


  method cumplePara(estudiante, materia) {
    return materiasCorrelativas.all({materia => estudiante.aproboLaMateria(materia)})
  }

}





class Creditos{

  const creditosNecesarios 


  method cumplePara(estudiante, materia) {
    return estudiante.creditosObtenidos(materia.carrera()) >= creditosNecesarios
  }

}







class PorAño{


  method cumplePara(estudiante, materia){
    return materia.carrera().materias().filter({otraMateria => otraMateria.añoDeCarrera() == materia.añoDeCarrera() - 1}).all({materiaAnterior => estudiante.aproboLaMateria(materiaAnterior)})
  }
  

}






object sinRequisitos{

  method cumplePara(estudiante, materia){
      return true
  }

}