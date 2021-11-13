/*PREGUNTA 1---------------------------------------------------------------------------------------------------------------------------
En una Universidad se desea almacenar la información del personal docente y el personal auxiliar. 
Para ello se desea utilizar un modelo “objeto-relacional” con el siguiente esquema:

Cree un objeto padre “Persona” con atributos DNI y Nombre.*/

/*  Objeto padre */
CREATE OR REPLACE TYPE persona AS OBJECT (
    dni CHAR(9),
    nombre VARCHAR2(30)
)
/* para que pueda heredar */
NOT FINAL  ;

/*PREGUNTA 2---------------------------------------------------------------------------------------------------------------------------
En la misma bbdd de la Universidad (vea pregunta 1), cree un objeto hijo “Auxiliar” con atributos: Teléfono, Sección, Turno y Sueldo.*/
/* Objeto hijo heredado */
CREATE OR REPLACE TYPE auxiliar UNDER persona (
    telefono CHAR(9),
    seccion VARCHAR2(30),
    turno VARCHAR2(6),
    sueldo NUMBER(5,2)
);


/*PREGUNTA 3---------------------------------------------------------------------------------------------------------------------------
En la misma bbdd de la Universidad (vea pregunta 1), cree 2 instancias de “Auxiliar” y asignele valores.*/
/* Creaci�n de instancia. Bloque PL-SQL */
DECLARE
    /* Declaracion de variable locales */
    auxiliar_A persona;  
    auxiliar_B persona; 
BEGIN 
    /*  M�todo constructor  */
    auxiliar_A := NEW persona('666666666', 'Biblioteca', 'mañana', '1120,60' ); /* NEW es opcional */
    auxiliar_B := persona('777777777', 'Ciencias', 'tarde', '1120,85' ); 
END;


/*PREGUNTA 4-----------------------------------------------------------------------------------------------------------------------------
Siguiendo con la bbdd de Universidad, cree un objeto hijo “Docente” con los siguientes atributos:

“Titulación”, que puede ser “Licenciado” o “Doctor”
“Antigüedad”, expresada en años
“Categoría”, que puede ser A, B o C*/


/*PREGUNTA 5-------------------------------------------------------------------------------------------------------------------------------
Siguiendo con la bbdd de Universidad, en el objeto “Docente” cree un método constructor que asigne la categoria A a las instancias que tienen 
titulación “Doctor” y la categoria B al resto.*/

/*PREGUNTA 6---------------------------------------------------------------------------------------------------------------------------------
Siguiendo con la bbdd de Universidad, en el objeto “Docente” cree un método que calcule una bonificación de 20€ por año para los docentes 
de categoria A y de 15€ por año para los de otras categorias*/

/*PREGUNTA 7-----------------------------------------------------------------------------------------------------
Siguiendo con la bbdd de Universidad, cree una tabla “profesores” para almacenar instancias de “Docente”.*/


/*PREGUNTA 8---------------------------------------------------------------------------------------------------------
Siguiendo con la bbdd de Universidad, en la tabla "profesores":
- Inserte 2 profesores utilizando el constructor por defecto.
- Inserte 2 profesores utilizando el 2º constructor.
*/


/*PREGUNTA 9--------------------------------------------------------------------------------------------------------------------
Siguiendo con la bbdd de Universidad, haga una consulta que muestre los profesores ordenados por categorias.*/


/*PREGUNTA 10-------------------------------------------------------------------------------------------------------------------
Siguiendo con la bbdd de Universidad, haga una consulta que muestre los profesores con sus bonificaciones*/