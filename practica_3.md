Programación Concurrente – 2014
===============================
Práctica Nº3 – Plan 2003 y 2007

Monitores
---------

CONSIDERACIONES PARA RESOLVER LOS EJERCICIOS:

1. Los monitores utilizan la técnica signal and continue.

2. A una variable condition SOLO pueden aplicársele las operaciones SIGNAL,
SIGNALALL y WAIT.

3. No puede utilizarse el wait con prioridades.

4. No se puede utilizar ninguna operación que determine la cantidad de procesos
encolados en una variable condition.

5. La única forma de comunicar datos entre monitores o entre un proceso y un
monitor es por medio de invocaciones al procedimiento del monitor del cual se
quieren obtener (o enviar) los datos.

6. No existen variables globales.

7. En todos los ejercicios debe maximizarse la concurrencia (sin contradecir el
enunciado).

8. En todos los ejercicios debe aprovecharse al máximo la característica de
exclusión mutua que brindan los monitores.


Ejercicio 1
-----------

Dado el siguiente enunciado y código:

  ```
  Monitor Puente
   Var cola: cond;
   cant:integer:= 0;

   Procedure entrarPuente (au: integer)
     do ( cant > 0) wait (cola)
     cant:= cant + 1;
   end;

   Procedure salirPuente (au: integer)
     cant:= cant – 1;
     Signal(cola);
   End;

  Auto [I:1..M]
   Puente. entrarPuente (i);
   “el auto cruza el puente”
   Puente. salirPuente(i);
  ```

Enunciado: suponga que se dispone de un puente por el cual puede pasar un solo
auto a la vez. Un auto pide permiso para pasar por el puente, cruza por el
mismo y luego sigue su camino.

  1. ¿El código funciona correctamente? Justifique su respuesta.

  2. ¿Se podría realizar el mismo programa reduciendo la cantidad de variables?
  En caso afirmativo, rescriba el código utilizando la menor cantidad posible
  de variables.

  3. ¿La solución original respeta el orden de llegada de los vehículos? Si
  rescribió el código en el punto b), ¿esa solución respeta el orden de
  llegada?

Ejercicio 2
-----------

En un laboratorio de genética se debe administrar el uso de una máquina
secuenciadora de ADN. Esta máquina se puede utilizar por una única persona a la
vez. Existen 100 personas en el laboratorio que utilizan repetidamente esta
máquina para sus estudios, para esto cada persona pide permiso para usarla, y
cuando termina el análisis avisa que termino. Cuando la máquina está libre se
le debe adjudicar a aquella persona cuyo pedido tiene mayor prioridad (valor
numérico entre 0 y 100).

Ejercicio 3
-----------

Suponga que N personas llegan a la cola de un banco. Una vez que la persona se
agrega en la cola no espera más de 15 minutos para su atención, si pasado ese
tiempo no fue atendida se retira. Para atender a las personas existen 2
empleados que van atendiendo de a una y por orden de llegada a las personas.

Ejercicio 4
-----------

Suponga que en una fábrica de camisas deben realizarse 5000 camisas, en la
misma trabajan X operarios. Los operarios entran a la fábrica, una vez que
todos han llegado a la fábrica el encargado los agrupa de a cuatro. Cuando
todos los operarios conocen el grupo al que pertenecen y se han encontrado con
sus compañeros de grupo comienza la fabricación de camisas. Dentro de un grupo
se necesitan 8 materiales diferentes para realizar la camisa, los cuales deben
conseguir entre los empleados del grupo (existe un encargado para cada tipo de
elemento). Una vez que un grupo consiguió los 8 elementos fabrican entre todos
la camisa. Cada vez que un grupo realiza una camisa debe conseguir los 8
elementos. Luego de que todas las camisas han sido fabricadas los grupos deben
retirarse.

Nota: No se deben fabricar camisas de más. No se puede suponer nada sobre los
tiempos, es decir, el tiempo en que un operario tarda en buscar los elementos,
ni el tiempo en que tarda un grupo en fabricar una camisa. Suponga X múltiplo
de 4.

Ejercicio 5
-----------

En una casa viven una abuela y sus N nietos. Además la abuela compró caramelos
que quiere convidar entre sus nietos. Inicialmente la abuela deposita en una
fuente X caramelos, luego cada nieto intenta comer caramelos de la siguiente
manera: si la fuente tiene caramelos el nieto agarra uno de ellos, en el caso
de que la fuente esté vacía entonces se le avisa a la abuela quien repone
nuevamente X caramelos. Luego se debe permitir que el nieto que no pudo comer
sea el primero en hacerlo, es decir, el primer nieto que puede comer nuevamente
es el primero que encontró la fuente vacía.

NOTA: siempre existen caramelos para reponer. Cada nieto tarda t minutos en
comer un caramelo ( t no es igual para cada nieto). Puede haber varios nietos
comiendo al mismo tiempo.

Ejercicio 6
-----------

Resolver la siguiente situación. Suponga una comisión con 50 alumnos. Cuando
los alumnos llegan forman una fila, una vez que están los 50 en la fila el jefe
de trabajos prácticos les entrega el número de grupo (número aleatorio del 1 al
25) de tal manera que dos alumnos tendrán el mismo número de grupo (suponga que
el jefe posee una función DarNumero() que devuelve en forma aleatoria un número
del 1 al 25, el jefe de trabajos prácticos no guarda el número que le asigna a
cada alumno).

Cuando un alumno ha recibido su número de grupo, busca al compañero que tenga
el mismo número de grupo para comenzar a realizar la práctica. Cuando ambos
alumnos se encuentran permanecen en una sala realizando la práctica. Al
terminar de trabajar, el alumno le avisa al jefe de trabajos prácticos y espera
a que su compañero también avise que finalizó.

El jefe de trabajos prácticos, cuando han llegado los dos alumnos de un grupo
les devuelve a ambos el orden en que termino el GRUPO (el primer grupo en
terminar tendrá como resultado 1, y el último 25).





