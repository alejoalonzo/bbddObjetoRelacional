/*PREGUNTA 1---------------------------------------------------------------------------------------------------------------------------
En una Universidad se desea almacenar la información del personal docente y el personal auxiliar. 
Para ello se desea utilizar un modelo “objeto-relacional” con el siguiente esquema:

Cree un objeto padre “Persona” con atributos DNI y Nombre.*/

/*  Objeto padre */
create or replace TYPE persona AS OBJECT(
dni VARCHAR2(9),
nombre VARCHAR2(30)
)
/* para que pueda heredar */
NOT FINAL ;

/*PREGUNTA 2---------------------------------------------------------------------------------------------------------------------------
En la misma bbdd de la Universidad (vea pregunta 1), cree un objeto hijo “Auxiliar” con atributos: Teléfono, Sección, Turno y Sueldo.*/
/* Objeto hijo heredado */
create or replace TYPE auxiliar UNDER persona(
    telefono VARCHAR2(9),
    seccion VARCHAR2(30),
    turno VARCHAR2(10),
    sueldo NUMBER(5,0)
);



/*PREGUNTA 3---------------------------------------------------------------------------------------------------------------------------
En la misma bbdd de la Universidad (vea pregunta 1), cree 2 instancias de “Auxiliar” y asignele valores.*/
/* Creaci�n de instancia. Bloque PL-SQL */
DECLARE

    /* Declaracion de variable locales */
    auxiliar_A auxiliar;
    auxiliar_B auxiliar;

BEGIN

    /*  M�todo constructor  */
    /*  los parametros primero los del padre (personas) y luego los del hijo (revistas)*/
    auxiliar_A := NEW auxiliar('12345678Z', 'Juan', '123456789', 'Biblioteca', 'manana', '1120' ); /* NEW es opcional */

    auxiliar_B := auxiliar('12345678Y', 'Pedro', '123456788', 'Ciencias', 'tarde', '1120' );

END;

/*PREGUNTA 4-----------------------------------------------------------------------------------------------------------------------------
Siguiendo con la bbdd de Universidad, cree un objeto hijo “Docente” con los siguientes atributos:

“Titulación”, que puede ser “Licenciado” o “Doctor”
“Antigüedad”, expresada en años
“Categoría”, que puede ser A, B o C*/


create or replace TYPE docente UNDER persona(
    titulacion VARCHAR2(20),
    antiguedad NUMBER(2,0),
    categoria VARCHAR2(1)
   
);


/*PREGUNTA 5-------------------------------------------------------------------------------------------------------------------------------
Siguiendo con la bbdd de Universidad, en el objeto “Docente” cree un método constructor que asigne la categoria A a las instancias que tienen 
titulación “Doctor” y la categoria B al resto.*/

/*******  Objetos con m�todos    ******/

/* Objeto hijo heredado con m�todo Constructor sin precio */
CREATE OR REPLACE TYPE docente UNDER persona (
    titulacion VARCHAR2(12),
    antiguedad NUMBER(2,0),
    categoria VARCHAR2(1),
    CONSTRUCTOR FUNCTION docente (
        dni VARCHAR2,
        nombre VARCHAR2,
        titulacion VARCHAR2,
        antiguedad NUMBER
    ) RETURN SELF AS RESULT   /* Devuelve el mismo objeto como resultado */
);

/* Cuerpo con m�todos  */
CREATE OR REPLACE TYPE BODY docente AS  
        CONSTRUCTOR FUNCTION docente (
        dni VARCHAR2,
        nombre VARCHAR2,
        titulacion VARCHAR2,
        antiguedad NUMBER
    ) RETURN SELF AS RESULT
    IS
    BEGIN
        SELF.dni  := dni ;
        SELF.nombre := nombre ;
        SELF.titulacion := titulacion ;
        SELF.antiguedad := antiguedad ;
        
        IF (titulacion = 'doctor') THEN
            SELF.categoria := 'A';
        ELSE
            SELF.categoria := 'B';
        END IF;
        
        RETURN;
    END;
END;



/*PREGUNTA 6---------------------------------------------------------------------------------------------------------------------------------
Siguiendo con la bbdd de Universidad, en el objeto “Docente” cree un método que calcule una bonificación de 20€ por año para los docentes 
de categoria A y de 15€ por año para los de otras categorias*/

CREATE OR REPLACE TYPE docente UNDER persona (
    titulacion VARCHAR2(12),
    antiguedad NUMBER(2,0),
    categoria VARCHAR2(1),
    CONSTRUCTOR FUNCTION docente (
        dni VARCHAR2,
        nombre VARCHAR2,
        titulacion VARCHAR2,
        antiguedad NUMBER
    ) RETURN SELF AS RESULT, /* Devuelve el mismo objeto como resultado */
    MEMBER FUNCTION bonificacion RETURN NUMBER
);


CREATE OR REPLACE TYPE BODY docente AS  
        CONSTRUCTOR FUNCTION docente (
        dni VARCHAR2,
        nombre VARCHAR2,
        titulacion VARCHAR2,
        antiguedad NUMBER
    ) RETURN SELF AS RESULT
    IS
    BEGIN
        SELF.dni  := dni ;
        SELF.nombre := nombre ;
        SELF.titulacion := titulacion ;
        SELF.antiguedad := antiguedad ;
        
        IF (titulacion = 'doctor') THEN
            SELF.categoria := 'A';
        ELSE
            SELF.categoria := 'B';
        END IF;
        
        RETURN;
    END;


    MEMBER FUNCTION bonificacion RETURN NUMBER
    IS
        bonificacion NUMBER(4); 
    BEGIN
        IF (categoria = 'A') THEN
            bonificacion := (SELF.antiguedad)*'20' ;
        ELSE
            bonificacion := ((SELF.antiguedad)*'15' ;
        END IF;
        
        RETURN bonificacion;
    END;
END;


/**/
CREATE OR REPLACE TYPE docente UNDER persona (

    titulacion VARCHAR2(12),

    antiguedad NUMBER(2,0),

    categoria VARCHAR2(1),

    CONSTRUCTOR FUNCTION docente (

        dni VARCHAR2,

        nombre VARCHAR2,

        titulacion VARCHAR2,

        antiguedad NUMBER

    ) RETURN SELF AS RESULT, /* Devuelve el mismo objeto como resultado */

    MEMBER FUNCTION bonificacion RETURN NUMBER

);

 

CREATE OR REPLACE TYPE BODY docente AS  

        CONSTRUCTOR FUNCTION docente (

        dni VARCHAR2,

        nombre VARCHAR2,

        titulacion VARCHAR2,

        antiguedad NUMBER

    ) RETURN SELF AS RESULT

    IS

    BEGIN

        SELF.dni  := dni ;

        SELF.nombre := nombre ;

        SELF.titulacion := titulacion ;

        SELF.antiguedad := antiguedad ;

       

        IF (titulacion = 'doctor') THEN

            SELF.categoria := 'A';

        ELSE

            SELF.categoria := 'B';

        END IF;

       

        RETURN;

    END;



 

    MEMBER FUNCTION bonificacion RETURN NUMBER

    IS

        bonificacion NUMBER(4);

    BEGIN

        IF (categoria = 'A') THEN

            bonificacion := (SELF.antiguedad)*'20' ;

        ELSE

            bonificacion := (SELF.antiguedad)*'15' ;

        END IF;

       

        RETURN bonificacion;

    END;

END;



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