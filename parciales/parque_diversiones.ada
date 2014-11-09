TASK type persona IS
  ENTRY recibirPases(pases: IN array[1..7]; juegos: OUT string);
  ENTRY identificador(id: IN integer);
End persona

TASK ventanilla IS
  ENTRY pedirPases(id: IN integer);
  ENTRY personaConMasPedidos(id: OUT integer);
End ventanilla;


TASK BODY persona IS
  -- Variables
  id: int := 0;
  pases: array[1..7] := 0;
  juegos: array[1..7] := '';
  -- End Variables

  ACCEPT identificador(pid) DO
    id := pid;
  End identificador;

  juegos := asignar_mis_juegos();
  tengo_pases := false;

  SELECT
    WHEN (not tengo_pases) -> ACCEPT recibirPases(pases_entrada, juegos_salida) DO
      juegos_salida := juegos;
      pases         := pases_entrada;
      tengo_pases   := true;
    End recibirPases;
  ELSE
    ventanilla.pedirPases(id);
  End SELECT
End persona

TASK BODY ventanilla IS
  -- Variables
  pedidos: array[1..cant_personas] := 0;
  -- End Variables

  SELECT
    ACCEPT personaConMasPedidos(id) DO
      id := maxPedidos();
    end personaConMasPedidos;
  OR
    ACCEPT pedirPases(id_persona) DO
      pedidos[id_persona]++
    end pedirPases;
  End SELECT
End ventanilla

TASK BODY jefe IS

End jefe
-- ppal

FOR i:=1 to cant_personas DO
  personas[i].identificador(i);
End FOR
