Programación Concurrente – 2014 - Práctica 5
============================================


Ejercicio 1 ADA
---

### CONSIDERACIONES PARA RESOLVER LOS EJERCICIOS:

1. *NO SE PUEDE USAR VARIABLES COMPARTIDAS*

2. Declaración de tareas

    1. Especificación de tareas sin ENTRY’s (nadie le puede hacer llamados).

    ```ada
    TASK Nombre;

    TASK TYPE Nombre;
    ```

    2. Especificación de tareas con ENTRY’s (le puede hacer llamados). Los
    entry’s funcionan de manera semejante los procedimientos: solo pueden
    recibir o enviar informarción por medio de los parámetros del entry. NO
    RETORNAN VALORES COMO LAS FUNCIONES

        ```ada
        TASK [TYPE] Nombre IS
          ENTRY e1;
          ENTRY e2 (p1: IN integer; p2: OUT char; p3: IN OUT float);
        END Nombre;
        ```

    3. Cuerpo de las tareas.

        ```ada
        TASK BODY Nombre IS
          -- Codigo que realiza la Tarea;
        END Nombre;
        ```

3. Sincronización y comunicación entre tareas

    1. Entry call para enviar información (o avisar algú n evento).

        ```ada
        NombreTarea.NombreEntry (parametros);
        ```

    2. Accept para atender un pedido de entry call sin cuerpo (sólo para
    recibir el aviso de un evento para sincronización).

        ```ada
        ACCEPT NombreEntry (p1: IN integer; p3: I N OUT float);
        ```

    3. Accept para atender un pedido de entry call con cuerpo.

        ```ada
        ACCEPT NombreEntry (p1: IN integer; p3: I N OUT float) do
          -- Cuerpo del accept donde se pued e acceder a los parámetros p1 y
          -- p3. Fuera del entry estos parámetros no se pueden usar.
        END NombreEntry;
        ```

    4. El accept se puede hacer en el cuerpo de la tare a que ha declarado el
    entry en su especificación. Los entry call se pueden hacer en cualquier
    tarea o en el programa principal.

    5. Tanto el entry call como el accept son bloquean tes, ambas tareas
    continuan trabajando cuando el cuerpo del accept ha terminado su ejecución.

4. Select para ENTRY CALL.

    1. `Select ...OR DELAY`: espera a lo sumo x tiempo a que l a tarea
    correspondiente haga el accept del entry call realizado. Si pasó el tiempo
    entonces realiza el código opcional.

        ```ada
        SELECT
          NombreTarea.NombreEntry(Parame tros);
          -- Sentencias;
        OR DELAY x
          -- Código opcional;
        END SELECT;
        ```

    2. `Select ...ELSE`: si la tarea correspondiente no puede realizar el accept
    *inmediatamente (en el momento que el procesador está ejecutando esa línea de
    código)* entonces se ejecuta el código opcional.

        ```ada
        SELECT
          NombreTarea.NombreEntry(Parametros);
          -- Sentencias;
        ELSE
          -- Código opcional;
        END SELECT;
        ```

    3. En los select para entry call sólo puede ponerse un entry call y una
    única opción (OR DELAY o ELSE);

5. Select para ACCEPT.

    1. En los select para los accept puede haber más de una alternativa de
    accept, pero no puede haber alternativas de entry call (no se puede mezclar
    accept con entries). Cada alternativas de ACCEPT puede ser o no condicional
    (WHEN).

        ```ada
        SELECT
          ACCEPT e1 (parametros);
          -- Sentencias1;
        OR
          ACCEPT e2 (parametros) IS
            -- cuerpo del accept;
          END e2;
        OR
          WHEN (condicion) => ACCEPT e3 (parametros) IS
            -- cuerpo del accept;
          END e3;
          -- Sentencias3
        END SELECT;
        ```

    Funcionamiento:

    i. Se evalúa la condición booleana del WHEN de cada alternativa (si no lo
    tiene se considera TRUE). Si todas son FALSAS se sale del select.

    ii. De las alternativas cuyo condición es ve rdadera se elige en forma no
    deterministica una que pueda ejecutarse inmediatamente (es decir que tiene
    un entry call pendiente). Si ninguna de ellas se puede ejecutar
    inmediatamente el select se bloquea hasta que haya un entry call para
    alguna alternatica cuya condición sea TRUE.



    2. Se puede poner una opción OR DELAY o ELSE.

    3. Dentro de la condición booleana de una altern ativa (en el WHEN) se
    puede preguntar por la cantidad de entry call pendientes de cualquier entry
    de la tarea.

    ```ada
      NombreEntry'count
    ```

    4. Después de escribir una condición por medio de un WHEN siempre se debe
    escribir un accept, es decir,

    ```ada
    SELECT
      ACCEPT e1 (parametros);
      -- Sentencias1;
    OR
      WHEN (condicion) => ACCEPT e2 (parametros)
    END SELECT;
    ```

-----------

Se debe controlar el acceso a una base de datos. Existen A procesos de Tipo 1,
B procesos de Tipo 2 y C procesos de Tipo 3 que trabajan indefinidamente de la
siguiente manera:

* Proceso Tipo 1: intenta escribir, si no lo logro en 2
  minutos, espera 5 minutos y vuelve a intentarlo.

* Proceso Tipo 2: intenta escribir, si no lo logra en 5 minutos, intenta leer, si
  no lo logra en 5 minutos vuelve a comenzar.

* Proceso Tipo 3: intenta leer, si no puede inmediatamente entonces espera
  hasta poder escribir.

Un proceso que quiera escribir podrá acceder si no hay ningún otro proceso en
la base de datos, al acceder escribe y avisa que termino de escribir. Un
proceso que quiera leer podrá acceder si no hay procesos que escriban, al
acceder lee y avisa que termino de leer. Siempre se le debe dar prioridad al
pedido de acceso para escribir sobre el pedido de acceso para leer.

Ejercicio 2
-----------

Existen 10 tareas Contadoras donde cada una posee un vector de 10000 números.
Se tiene una tarea Administradora que genera un número aleatorio y debe obtener
la cantidad de veces que dicho valor aparece en los vectores (la cantidad
total).

#### Nota:

    * En cada vector el número buscado puede aparecer 0, 1 o más veces.

    * MAXIMIZAR LA CONCURRENCIA.

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
o cuando 5 máquinas no estuvieron disponibles, en cualquiera de los casos debe retirar sus
pertenencias personales.

#### Notas:

    * La persona no conoce el número de su locker particular.

    * Existen N máquinas de cada tipo. La persona no elige con que profesor hace
      su rutina, una vez que consigue uno trabaja con ese hasta que se retira del
      gimnasio y tampoco elige cuál máquina de cada tipo utiliza.

    * Cada persona utiliza cada máquina durante 5 minutos.

    * Un profesor puede atender a 0, 1 ó más personas.

    * Suponga que cada máquina dispone de una función que le retorna cuanto
      tiempo hace que está disponible.

    * Maximice la concurrencia para TODAS las tareas.

Ejercicio 4
-----------

Suponga que existen N usuarios que deben ejecutar su programa, para esto
comparten K procesadores.

Los usuarios solicitan un procesador al administrador. Una vez que el
administrador les entregó el número de procesador, el usuario le da su programa
al procesador que le fue asignado. Luego el usuario espera a que:

  * El procesador le avise si hubo algún error en una línea de código con lo
  cual el usuario arregla el programa y se lo vuelve a entregar al procesador,
  es decir queda nuevamente en la cola de programas a ejecutar por su
  procesador. El usuario no termina hasta que el procesador haya ejecutado su
  programa correctamente(sin errores).

  * El procesador le avise que su programa termino, con lo cual termina su
    ejecución.

El administrador tomará los pedidos de procesador hechos por los usuarios y
balanceara la carga de programas que tiene cada procesador, de esta forma le
entregará al usuario un número de procesador.

El procesador ejecutará un Round-Robin de los programas listos a ejecutar. Cada
programa es ejecutado línea por línea por medio de la funcion EJECUCIÓN la cual
devuelve:

  * 1 error en la ejecución.
  * 2 normal.
  * 3 fin de programa.

#### Nota:

    * Suponga que existe también la función LineaSiguiente que dado un programa
    devuelve la línea a ser ejecutada.
    * Modelice con Ada.
    * Maximice la concurrencia en la solución.


Ejercicio 5
-----------

Se debe modelar el siguiente problema:

En una clínica existe un médico de guardia que recibe continuamente peticiones
de atención de las E enfermeras que trabajan en su piso y de las P personas que
llegan a la clínica para ser atendidos.

Cuando una persona necesita que la atiendan espera a lo sumo 5 minutos a que el
médico lo haga, si pasado ese tiempo no lo hace, espera 10 minutos y vuelve a
requerir la atención del médico. Si no es atendida tres veces, se enoja y se
retira de la clínica.

Cuando una enfermera requiere la atención del médico, si este no lo atiende
inmediatamente le hace una nota y se la deja en el consultorio para que esta
resuelva su pedido en el momento que pueda (el pedido puede ser que el médico
le firme algún papel). Cuando la petición ha sido recibida por el médico o la
nota ha sido dejada en el escritorio, continúa trabajando y haciendo más
peticiones.

El médico atiende los pedidos dándoles prioridad a los enfermos que
llegan para ser atendidos. Cuando atiende un pedido, recibe la solicitud y la
procesa durante un cierto tiempo. Cuando está libre aprovecha a procesar las
notas dejadas por las enfermeras.

#### Nota:

    * MAXIMICE LA CONCURRENCIA.
