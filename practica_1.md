Programación Concurrente – 2014
===============================
Práctica Nº1 – Plan 2003 y 2007

Conceptos Básicos
-----------------


1. Para el siguiente programa concurrente suponga que las instrucciones del
siguiente código no son atómicas (la ejecución puede ser interrumpida). Indique
cual/es de las siguientes opciones son verdaderas:

  1. En algún caso el valor de x al terminar el programa es 95.
  2. En algún caso el valor de x al terminar el programa es 188.
  3. En algún caso el valor de x al terminar el programa es 942.
  4. x puede obtener un valor incorrecto (no consistente).


  ```
  int x = 0, y = 0;

  Process P1 {
    If(x==0)→ {
      y= 4*23;
      x= y + 2;
    }
  }

  Process P2 {
    If(x>0)→ {
      x= x + 1;
    }￼
  }

  Process P3 {
    x= (x*8) + x*2;
  }

  ```


2. Suponga ahora, el mismo ejercicio anterior pero las instrucciones son
atómicas. Indique cual/es de las siguientes opciones son verdaderas

  1. El valor de x al terminar el programa es 20.
  2. El valor de x al terminar el programa es 94.
  3. X obtiene un valor incorrecto (no consistente).
  4. Es posible calcular la cantidad de resultados posibles para las variables x e y.

3. Dado un numero N verifique cuantas veces existe ese número en un arreglo de
longitud M. Realice el algoritmo en forma concurrente. Escriba las condiciones
que considere necesarias.

4. En el siguiente código se da “inconsistencia de resultados”. Justifique
claramente.

  ```
  int x = 5, y = 10, z = 0;

  Process A {
  if(y>0)→
    z = x/y;
  }

  Process B {
  if(y<0)→
    z= -x/y;
  }

  Process C {
    y = 0;
  }
  ```
