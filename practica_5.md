Programaci�n Concurrente - 2014
Pr�ctica N�5 - Plan 2003 y 2007

ADA

CONSIDERACIONES PARA RESOLVER LOS EJERCICIOS:

1. NO SE PUEDE USAR VARIABLES COMPARTIDAS
2. Declaraci�n de tareas

    Especificaci�n de tareas sin ENTRY's (nadie le puede hacer llamados).

    ```ada
    TASK Nombre;

    TASK TYPE Nombre;
    ```

    Especificaci�n de tareas con ENTRY's (le puede hacer llamados). Los entry's
    funcionan de manera semejante los procedimientos: solo pueden recibir o enviar
    informarci�n por medio de los par�metros del entry. NO RETORNAN VALORES
    COMO LAS FUNCIONES

    ```ada
    TASK [TYPE] Nombre IS
    ENTRY e1;
    ENTRY e2 (p1: IN integer; p2: OUT char; p3: IN OUT float);

    END Nombre;
    ```

    Cuerpo de las tareas.

    ```ada
    TASK BODY Nombre IS
    Codigo que realiza la Tarea;

    END Nombre;
    ```

3. Sincronizaci�n y comunicaci�n entre tareas

Entry call para enviar informaci�n (o avisar alg�n evento).

NombreTarea.NombreEntry (parametros);

Accept para atender un pedido de entry call sin cuerpo (s�lo para recibir el aviso de un evento para
sincronizaci�n).

ACCEPT NombreEntry (p1: IN integer; p3: IN OUT float);

Accept para atender un pedido de entry call con cuerpo.

ACCEPT NombreEntry (p1: IN integer; p3: IN OUT float) do
Cuerpo del accept donde se puede acceder a los par�metros p1 y p3. Fuera del entry estos
par�metros no se pueden usar.

END NombreEntry;

El accept se puede hacer en el cuerpo de la tarea que ha declarado el entry en su especificaci�n. Los entry
call se pueden hacer en cualquier tarea o en el programa principal.

Tanto el entry call como el accept son bloqueantes, ambas tareas continuan trabajando cuando el cuerpo
del accept ha terminado su ejecuci�n.
4. Select para ENTRY CALL.

Select ...OR DELAY: espera a lo sumo x tiempo a que la tarea correspondiente haga el accept del entry call realizado.
Si pas� el tiempo entonces realiza el c�digo opcional.

SELECT
NombreTarea.NombreEntry(Parametros);
Sentencias;

OR DELAY x
C�digo opcional;

END SELECT;

Select ...ELSE: si la tarea correspondiente no puede realizar el accept inmediatamente (en el momento que el
procesador est� ejecutando esa l�nea de c�digo) entonces se ejecuta el c�digo opcional.

SELECT
NombreTarea.NombreEntry(Parametros);
Sentencias;

ELSE
C�digo opcional;

END SELECT;

En los select para entry call s�lo puede ponerse un entry call y una �nica opci�n (OR DELAY o ELSE);
5. Select para ACCEPT.

En los select para los accept puede haber m�s de una alternatica de accept, pero no se puede haber
alternativas de entry call (no se puede mezclar accept con entries). Cada alternativas de ACCEPT puede ser o
no condicional (WHEN).

SELECT
ACCEPT e1 (parametros);
Sentencias1;

OR
ACCEPT e2 (parametros) IS
cuerpo del accept;
END e2;

OR
WHEN (condicion) => ACCEPT e3 (parametros) IS

cuerpo del accept;

END e3;

Sentencias3
END SELECT;

Funcionamiento:
i. Se eval�a la condici�n booleana del WHEN de cada alternativa (si no lo tiene se considera TRUE). Si
todas son FALSAS se sale del select.

ii. De las alternativas cuyo condici�n es verdadera se elige en forma no deterministica una que pueda
ejecutarse inmediatamente (es decir que tiene un entry call pendiente). Si ninguna de ellas se puede
ejecutar inmediatamente el select se bloquea hasta que haya un entry call para alguna alternatica
cuya condici�n sea TRUE.

Se puede poner una opci�n OR DELAY o ELSE.

Dentro de la condici�n booleana de una alternativa (en el WHEN) se puede preguntar por la cantidad de entry
call pendientes de cualquier entry de la tarea.

NombreEntry'count

Despu�s de escribir una condici�n por medio de un WHEN siempre se debe escribir un accept, es decir,

SELECT
ACCEPT e1 (parametros);
Sentencias1;

OR
WHEN (condicion) => ACCEPT ...

END SELECT;
1. Se debe controlar el acceso a una base de datos. Existen A procesos de Tipo 1, B procesos de
Tipo 2 y C procesos de Tipo 3 que trabajan indefinidamente de la siguiente manera:
Proceso Tipo 1: intenta escribir, si no lo logro en 2 minutos, espera 5 minutos y vuelve a
intentarlo.
Proceso Tipo 2: intenta escribir, si no lo logra en 5 minutos, intenta leer, si no lo logra en 5
minutos vuelve a comenzar.
Proceso Tipo 3: intenta leer, si no puede inmediatamente entonces espera hasta poder
escribir.
Un proceso que quiera escribir podr� acceder si no hay ning�n otro proceso en la base de
datos, al acceder escribe y avisa que termino de escribir. Un proceso que quiera leer podr�
acceder si no hay procesos que escriban, al acceder lee y avisa que termino de leer. Siempre
se le debe dar prioridad al pedido de acceso para escribir sobre el pedido de acceso para leer.

2. Existen 10 tareas Contadoras donde cada una posee un vector de 10000 n�meros. Se tiene
una tarea Administradora que genera un n�mero aleatorio y debe obtener la cantidad de
veces que dicho valor aparece en los vectores (la cantidad total). Nota: en cada vector el
n�mero buscado puede aparecer 0, 1 o m�s veces. Maximizar la concurrencia.

3. M personas concurren a un gimnasio para hacer su rutina diaria. Cada persona cuando llega al
gimnasio da su nombre, su bolso con ropa para ba�arse y su portafolio o cartera personal
(dependiendo de si es hombre o mujer) a la secretaria. La secretaria debe verificar que la
persona tenga la cuota paga, si es as�, la deja ingresar avis�ndole que puede guardar sus
pertenencias en un locker.
Una vez que la persona ingres� al gimnasio pide que alguno de los J profesores la atienda (el
profesor que se le debe asignar a la persona es aquel que menos personas est� atendiendo en
ese momento). El profesor que la atiende toma su rutina y le indica cu�l tipo de m�quina debe
utilizar. La persona busca una m�quina del tipo (la que hace m�s tiempo que no se utiliza) y
si en ese momento la m�quina no est� disponible, le pide a su profesor que le diga otro tipo
de m�quina a utilizar. La persona se retira del gimnasio cuando termina su rutina o cuando 5
m�quinas no estuvieron disponibles, en cualquiera de los casos debe retirar sus pertenencias
personales.

Notas: La persona no conoce el n�mero de su locker particular.
Existen N m�quinas de cada tipo. La persona no elige con que profesor hace su rutina, una
vez que consigue uno trabaja con ese hasta que se retira del gimnasio y tampoco elige cu�l
m�quina de cada tipo utiliza.
Cada persona utiliza cada m�quina durante 5 minutos.
Un profesor puede atender a 0, 1 � m�s personas.
Suponga que cada m�quina dispone de una funci�n que le retorna cuanto tiempo hace que
est� disponible.
Maximice la concurrencia para TODAS las tareas.

4. Suponga que existen N usuarios que deben ejecutar su programa, para esto comparten K
procesadores.
Los usuarios solicitan un procesador al administrador. Una vez que el administrador les
entreg� el n�mero de procesador, el usuario le da su programa al procesador que le fue
asignado. Luego el usuario espera a que:

El procesador le avise si hubo alg�n error en una l�nea de c�digo con lo cual el usuario
arregla el programa y se lo vuelve a entregar al procesador, es decir queda
nuevamente en la cola de programas a ejecutar por su procesador. El usuario no
termina hasta que el procesador haya ejecutado su programa correctamente(sin
errores).
El procesador le avise que su programa termino, con lo cual termina su ejecuci�n.

El administrador tomar� los pedidos de procesador hechos por los usuarios y balanceara la
carga de programas que tiene cada procesador, de esta forma le entregar� al usuario un
n�mero de procesador.
El procesador ejecutar� un Round-Robin de los programas listos a ejecutar. Cada programa es
ejecutado l�nea por l�nea por medio de la funcion EJECUCI�N la cual devuelve:

1 error en la ejecuci�n.
2 normal.
3 fin de programa.

Nota: Suponga que existe tambi�n la funci�n LineaSiguiente que dado un programa devuelve
la l�nea a ser ejecutada. Modelice con Ada. Maximice la concurrencia en la soluci�n.

5. Se debe modelar el siguiente problema En una cl�nica existe un m�dico de guardia que recibe
continuamente peticiones de atenci�n de las E enfermeras que trabajan en su piso y de las P
personas que llegan a la cl�nica ser atendidos.
Cuando una persona necesita que la atiendan espera a lo sumo 5 minutos a que el m�dico lo
haga, si pasado ese tiempo no lo hace, espera 10 minutos y vuelve a requerir la atenci�n del
m�dico. Si no es atendida tres veces, se enoja y se retira de la cl�nica.
Cuando una enfermera requiere la atenci�n del m�dico, si este no lo atiende inmediatamente
le hace una nota y se la deja en el consultorio para que esta resuelva su pedido en el
momento que pueda (el pedido puede ser que el m�dico le firme alg�n papel). Cuando la
petici�n ha sido recibida por el m�dico o la nota ha sido dejada en el escritorio, contin�a
trabajando y haciendo m�s peticiones.
El m�dico atiende los pedidos teniendo d�ndoles prioridad a los enfermos que llegan para ser
atendidos. Cuando atiende un pedido, recibe la solicitud y la procesa durante un cierto
tiempo. Cuando est� libre aprovecha a procesar las notas dejadas por las enfermeras.
MAXIMICE LA CONCURRENCIA.
