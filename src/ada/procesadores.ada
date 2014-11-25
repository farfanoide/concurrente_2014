TASK TYPE Usuario IS
  ENTRY recibirRespuesta
TASK Administrador IS
  ENTRY entregarProcesador

TASK TYPE Procesador IS
  ENTRY tomaTrabajo

TASK BODY Usuario IS

  Administrador.entregarProcesador(nro_procesador)
  while(termino!=true){
    Procesadores[nro_procesador].tomaTrabajo(programa, error, nro_usuario)
      if(error){
        arregloPrograma(programa)
      } else {
        termino = true
      }
  }
end

TASK BODY Administrador IS
While true LOOP
  ACCEPT entregarProcesador(nro_procesador) DO
    calculaProcesador(nro_procesador)
  END entregarProcesador
END LOOP

END

TASK BODY Procesador IS
While true LOOP
  ACCEPT tomaTrabajo(programa, error, nro_usuario) DO
    while(estado==normal) { ejecutarLinea(estado) }
  if estado=error{ error = true }
  END tomaTrabajo
END LOOP



-- n usuarios
-- k procesadores
-- administrador
--
-- usuario
--   -> administrador dame procesador
--   espera nro_procesador
--   mientras no se ejecute bien
--     -> procesador ejecutate esto(mi programa)
--     espera respuesta
--     si error
--       arreglo programa
--
-- administrador
-- llega pedido
--   calcula procesador menos cargado
--   devuelve nro_procesador
--
-- procesador
--   while true
--     recibir pedido
--     for linea en pedido
--       ejecutar linea
--       si error
--         mandar error usuario
