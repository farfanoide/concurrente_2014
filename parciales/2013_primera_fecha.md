Parcial 1 fecha 2013
====================

Ejercicio 1
-----------

Resolver con semaforos el siguiente problema: Un sistema de software esta
compuesto por un proceso CENTRAL y un conjunto de los procesos perifericos
donde cada uno de ellos realiza una determinada operacion especial (cuyo
resultado es  un valor entero). El proceso CENTRAL debe esperar a que todos
los procesos perifericos se hayan iniciado para poder comenzar. Una vez que el
proceso central comenzo a trabajar, cada vez que necesita realizar alguna de as
10 operaciones especiales avisa al correspondiente periferico para que realice
el trabajo y espera a que le devueelva el resultado.

> Nota: Suponga que existe una funcionn `int TrabajoProcesoCentral()` que simula
> el trabajo del proceso CENTRAL y devueelve un valor entero entre 1 y 10, que
> indica cual de las 10 operaciones debe realizar en ese momento.

```
sem s_iniciando = 1
sem central = 0
sem trabajo_listo = 0
sem perifericos[1..10] = 0
int iniciando = 0
int trabajo

process central{
  P(central)
  while (true) {
    id_periferico := trabajo_proceso_central()
    V(perifericos[id_periferico])
    P(trabajo_listo)
    // uso el trabajo para otras movidas
  }
}

process periferico[id:1..10] {
  P(s_iniciando)
  <
  iniciando++
  if (iniciando == 10) { V(central) }
  >
  V(s_iniciando)
  while (true) {
    P(perifericos[id])
    trabajo := hacer_mi_trabajo()
    V(trabajo_listo)
  }
}
```
