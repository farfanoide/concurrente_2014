Programación Concurrente – 2014
===============================
Práctica Nº4 – Plan 2003 y 2007

Pasaje de Mensajes Sincrónico – Asincrónico
-------------------------------------------

Nota: En todos los ejercicios el tiempo debe representarse con la función delay

CONSIDERACIONES PARA RESOLVER LOS EJERCICIOS:

1. Para el pasaje de mensajes asincrónico:

  * Sintaxis declaración:

    ```
    chan nombrecanal(tipoDato)
    chan nombrecanal[1..m](tipoDato) #=> arreglo de canales
    ```

  * Sintaxis uso de canales

    ```
    Proceso uno[i:1..n]{
      Send nombreCanal(datos a enviar)
      Receive nombreCanal(datos a recibir)
      Send nombreCanal[i](datos a enviar)
      Receive nombreCanal[i](datos a recibir)
      If (empty(nombreCanal)) then ...
    }
    ```

  * Los canales son globales.
  * Cada canal es una cola de mensajes, por lo tanto el primer mensaje encolado
  es el primero en ser atendido.
  * Por ser pasaje de mensajes asincrónico el send no bloquea al emisor.
  * No se puede preguntar por la cantidad de mensajes encolados.
  * Se puede utilizar el if/do no determinístico donde cada opción es una
  condición boolena donde se puede preguntar por el EMPTY de los canales.

    ```
    If (cond 1) -> Acciones 1
    [] (cond 2) -> Acciones 2
    ...
    [] (cond N) -> Acciones N
    End if
    ```

    De todas las opciones cuya condición sea Verdadera elige una en forma no
    determinística y ejecuta las acciones correspondientes. Si ninguna es verdadera
    sale del if/do.




2. Para el pasaje de mensajes sincrónico:

  * Sintaxis declaración: Los canales en PMS no se declaran porque di
    rectamente se nombra el proceso con el cual se quiere comunicar.
  * Sintaxis uso de canales

    ```
    Proceso uno[i:1..n] {
      nombreProcesoReceptor!port (datos a enviar)
      nombreProcesoEmisor?port (datos a recibir)
    }
    ```

    El port (o etiqueta) puede no ir. Se utiliza para diferenciar los tipos de
    mensajes que se podrían comunicarse entre dos procesos.


Ejemplo:

Si el Proceso1 se quiere comunicar con el Proceso2 entonces:

```
Proceso2!port(datos a enviar)
```

Si el Proceso1 se quiere comunicar con un proceso de tipo 2 (existe un arreglo
de procesos 2) entonces:

```
ProcesoTipo2[j]!port(datos a enviar)
```

[j] es la posición en el arreglo de procesos de tipo 2 con el que me quiero comunicar.

Se puede usar el if/do guardado

```
If (Guarda 1) -> Acciones 1
[] (Guarda 2) -> Acciones 2
...
[] (Guarda 3) -> Acciones 3
End if
```


Cada Guarda de un if/do se compone de las siguientes partes:
cond.booleana;
- sent. de comunicación de recep donde:

* Si no se especifica la cond. booleana se considera verdadera (la condición
  booleana sólo puede hacer referencia a variables locales al proceso).

* En la sentencia de comunicación de recepción se puede usar el comodín * si
  el origen es un proceso dentro de un arreglo de procesos. Ejemplo:
  Clientes[*]?port(datos).

Cada guarda tiene tres posibles estados:

- Elegible: la condición bool eana es verdadera y la sentencia de comunicación
  se puede resolver inmediatamente.
- No elegible: la condición bo oleana es falsa.
- Bloqueada: la condición bo oleana es verdadera y la sentencia de comunicación
  no se puede resolver inmediata mente.



El IF funciona de la siguiente manera:

  - De todas las guardas elegibles se selecciona una en forma no determinística,
  se realiza la sentencia de comunicación correspondiente, y luego las acciones
  asociadas a esa guarda.

  - Si todas las guar das tienen el estado de no elegibles, se sale del if sin
  hacer nada.

  - Si no hay ninguna guarda ele gible, pero algunas estas en estado
  bloqueado, se queda esperando en el if hasta que alguna de esas se vuelva
  elelgible.


El DO funciona de la siguiente manera: 

  - Sigue iterando de la misma manera que el if hasta que todas las guardas son
  FALSAS. En ese momento sale del DO.


Ejercicio 1
-----------

Supongamos que tenemos una abuela que tiene dos tipos de lápices para dibujar,
de colores y lápices negros.

Además tenemos tres clases de niños que quieren dibujar con los lápices: los
que quieren usar sólo los lápices de colores (tipo C), los que usan sólo los
lápices negros (tipo N), y los niños que usan cualquier tipo de lápiz (tipo A).

Implemente un código para cada clase de niño de manera que ejecute pedido de
lápiz, lo use por 10 minutos y luego lo devuelva y además el proceso abuela
encargada de asignar los lápices. Se deben modelar al menos los procesos niño,
el proceso abuela y los procesos lápices.

1. Implementar utilizando pasaje de mensajes asincrónico (PMA).
2. Implementar utilizando pasaje de mensajes sincrónico (PMS).
3. Modificar el ejercicio original de la siguiente manera y resolverlo con PMS.

A los niños de tipo A se les puede asignar un lápiz sólo cuando: hay lápiz
negro disponible y ningún pedido pendiente de tipo N, o si hay lápiz de color
disponible y ningún pedido pendiente de tipo C.

Ejercicio 2
-----------

Supongamos que existen N niños que corren una carrera, para esto todos los
niños deben ubicarse en el punto de partida antes de comenzar la carrera.
Modele el problema de dos formas: Utilizando pasaje de mensaje asincrónico y
procesos que representan a los niños y un proceso coordinador el cual es el
encargado de largar la carrera cuando los N niños están ubicados en la largada.

Utilizando PMA y procesos que representan a los niños, es decir, sin utilizar
ningún otroproceso auxiliar.

No se puede suponer ningún orden en la llegada de los niños al punto de
partida.

Ejercicio 3
-----------

En una sala de baile deben entrar como mínimo dos bailarines. Existen cuatro
tipos de bailarines los de danza (A), los de tango (B), los de salsa (C) y los
de rock (D).

En la sala siempre debe haber un bailarín A y uno D. Además la cantidad de
bailarines A debe ser mayor que la cantidad de bailarines B y que la cantidad
de bailarines C. Dentro de la sala los bailarines bailan 5 minutos y luego
deben intentar retirarse de la sala.

*Notas:*
  - Modelice el problema utilizando PMA.

Ejercicio 4
-----------

Se desea modelar el funcionamiento de un banco el cual se encarga de cobrar
únicamente el servicio de seguro de sus clientes, en el cual existen 5 cajas
donde se cobra.

Existen P personas que desean pagar su seguro en el banco. Para esto cada una
selecciona la caja donde hay menos personas esperando, una vez seleccionada
espera a ser atendido según el orden de llegada. Cuando lo atienden, si esperó
más de 15 minutos entonces el banco le regala el cobro del servicio, en caso
contrario, debe abonar una cierta cantidad dependiendo de la categoría de
cliente (en caso de no pagar justo el empleado debe darle el vuelto).

Si la persona esperó más de 15 minutos, puede optar por levantar una queja. En
ese caso, una vez que se retiro de la caja (sin pagar), se dirige al
departamento de quejas donde un supervisor toma los datos de la persona (DNI de
la persona, monto) y el número de caja que lo atendió. Luego se retira.

*Aclaraciones:*

  - Existe una función Costo que retorna la cantidad que debe pagar quien la
  invoca.
  - Existe una función que dado el dni de la persona devuelve si la misma quiere o
  no realizar una queja.
  - Modelice el problema utilizando PMA.

Ejercicio 5
-----------

Se debe modelar una casa de Comida Rápida, en el cual trabajan DOS cocineros y
TRES vendedores. Además hay C clientes que dejan un pedido y quedan esperando a
que se lo alcancen.

Los pedidos que dejan los clientes son tomados por cualquiera de los vendedores
y se lo pasan a los cocineros para que realicen el plato.

Cuando no hay pedidos para atender, los vendedores aprovechan para reponer un
pack de bebidas de la heladera (tardan entre 1 y 3 minutos para hacer esto).

Repetidamente cada cocinero toma un pedido pendiente dejado por los vendedores,
lo cocina y se lo entrega directamente al cliente correspondiente.

*Notas:*
  - Modelice utilizando PMA. Maximice la concurrencia.

Ejercicio 6
-----------

En una estación de comunicaciones se cuenta con 10 radares y una unidad de
procesamiento que se encarga de procesar la información enviada por los
radares. Cada radar repetidamente detecta señales de radio durante 15 segundos
y le envía esos datos a la unidad de procesamiento para que los analice. Los
radares no deben esperar a ser atendidos para continuar trabajando.

*Notas:*
  - Modelice utilizando PMS.





