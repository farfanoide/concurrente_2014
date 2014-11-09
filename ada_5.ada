TASK Consultorio IS
  ENTRY recibirNota (nota: IN string)
  ENTRY entregarNota (nota: OUT string)
end Consultorio

TASK Medico IS
  ENTRY peticionEnfermera (nota: INOUT string)
  ENTRY peticionEnfermo (nota: IN string)
end Medico

TASK TYPE BODY Enfermera IS

  While true LOOP
    SELECT
      Medico.peticionEnfermera ("ALGUNA PETICION");
    ELSE
      Consultorio.entregarNota ("ALGUNA NOTA");
    end SELECT

    -- TRABAJAR

  end LOOP
end Enfermera

TASK BODY Medico IS

  var nota

  SELECT
    WHEN(peticionEnfermo's count = 0) -> ACCEPT peticionEnfermera (something) do
      -- hago algo
        end peticionEnfermera;
    OR ACCEPT peticionEnfermo (something) do
      -- hago algo
        end peticionEnfermo;
    OR 
  end SELECT

end Medico

TASK TYPE BODY Enfermo IS
  pruebas = 0

  while pruebas < 4 LOOP
      SELECT
          Medico.peticionEnfermo("ENVIO ALGO");
      OR DELAY (5)
          delay(10)
          pruebas++
      end SELECT
  end LOOP

end Enfermero


TASK BODY Consultorio IS

  queue cola;

  SELECT
      ACCEPT recibirNota(nota) do
              cola.push(nota);
            end recibirNota
      OR WHEN(!empty(cola)) -> ACCEPT entregarNota(nota) do
              cola.pop(nota);
            end entregarNota
  end SELECT

end Consultorio


  task body medico is
    nota:string
    loop
      select
        accept atenderPaciente() do
          delay();
        end atenderPaciente;
        or
        when (atenderPaciente'COUNT = 0) -> accept atenderEnfermera() do
          delay();
        end atenderEnfermera;
      else
        select
          escritorio.tomarNota(nota);
          delay();
        else
          null; --No hace nada
        end select;
    end select;
end loop;
end medico;
