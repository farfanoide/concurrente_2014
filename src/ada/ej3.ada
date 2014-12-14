
Ejercicio 3
-----------

M personas concurren a un gimnasio para hacer su rutina diaria. Cada persona
cuando llega al gimnasio da su nombre, su bolso con ropa para bañarse y su
portafolio o cartera personal (dependiendo de si es hombre o mujer) a la
secretaria. La secretaria debe verificar que la persona tenga la cuota paga, si
es así, la deja ingresar avisándole que puede guardar sus pertenencias en un
locker.

Una vez que la persona ingresó al gimnasio pide que alguno de los J profesores
la atienda (el profesor que se le debe asignar a la persona es aquel que menos
personas esté atendiendo en ese momento). El profesor que la atiende toma su
rutina y le indica cuál tipo de máquina debe utilizar. La persona busca una
máquina del tipo (la que hace más tiempo que no se utiliza) y si en ese momento
la máquina no está disponible, le pide a su profesor que le diga otro tipo de
máquina a utilizar. La persona se retira del gimnasio cuando termina su rutina
o cuando 5 máquinas no estuvieron disponibles, en cualquiera de los casos debe
retirar sus pertenencias personales.

TASK TYPE Persona
End Persona;

TASK Secretaria IS
  ENTRY recibirPersona(nombre: IN string, autorizado IN/OUT boolean,
  locker: int IN/OUT)
End Secretaria;

TASK TYPE Locker IS
  ENTRY identificador(id: integer IN)
  ENTRY guardarPertenencias(pilcha: string IN, pertenencias: string IN)
  ENTRY devolverPertenencias(pilcha: string OUT, pertenencias: string OUT)
End Loocker;

TASK AdminProfes IS
  ENTRY asignarProfesor(id_profe: IN/OUT integer)
  ENTRY liberarProfe(idprofe: IN integer)
End AdminProfes;

TASK TYPE Profesor
  ENTRY identificador(id_profe: integer IN)
  ENTRY asignarMaquina(id_maquina: integer IN/OUT)
End Profesor;

TASK AdminMaquina
  ENTRY asignarMaquina(id: IN integer, maquina_disponible: IN/OUT boolean)
End AdminMaquina;
TASK TYPE Maquina
  ENTRY identificador(id: IN integer)
  ENTRY liberarMaquina()
End AdminMaquina;

TASK BODY Maquina

End Maquina

TASK BODY Persona IS
  string nombre, pilcha, pertenencias;
  integer id_locker, id_profe, id_maquina, cantMaquinas=0;
  boolean maquina_disponible, termine_rutina=false, autorizado=false;
  Secretaria.recibirPersona(nombre, id_locker, autorizado)
  if(autorizado){
    locker[id_locker].guardarPertenencias(pilcha, pertenencias)
    AdminProfes.asignarProfesor(id_profe);
    while(!termine_rutina and cantMaquinas < 5 ){
      Profesor[id_profe].asignarMaquina(id_maquina, termine_rutina)
      AdminMaquina(id_maquina, maquina_disponible)
      if(!maquina_disponible){cantMaquinas ++;}
    }
    AdminProfes.liberarProfe(id_profe);
    Locker[id_locker].devolverPertenencias(pilcha, pertenencias)
  }
  //me voy
End Persona;

TASK BODY AdminProfes IS
profesores: Array [1..P] of integer
  SELECT
    ACCEPT asignarProfesor(id_profe);
      id_profe = profeMin()
      profesores[id_profe] = ++
    end asignarProfesor
  OR
    ACCEPT liberarProfesor(id_profe)
      profesores[id_profe] = --
    end liberarProfesor
  END SELECT
End AdminProfes

TASK BODY Profesor
  id_profe: integer
  ACCEPT identificador(id_profe);
    id = id_profe
  end identificador
  While(true){
    ACCEPT asignarMaquina(id_maquina, termine_rutina)
      if(!rutina){id_maquina = calcularProximaMaquina()}
      else {termine_rutina = true}
    end asignarMaquina
  }
End Profesor

TASK BODY AdminMaquina

End AdminMaquina
