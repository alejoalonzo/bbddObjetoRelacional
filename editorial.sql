/*  Objeto padre */
CREATE OR REPLACE TYPE publicacion AS OBJECT (
    isbn VARCHAR2(8),
    titulo VARCHAR2(30)
)
/* para que pueda heredar */
NOT FINAL  ;


/* Objeto con tipo anidado */
CREATE OR REPLACE TYPE libro  AS OBJECT (
    autor VARCHAR2(30),
    pub publicacion,
    paginas number(3),
    pasta VARCHAR2(8)
);

/* Tabla con tipos */
CREATE TABLE tabla_libros (
    anio number(2),
    lib libro,
    tirada number(4)    
);

INSERT INTO tabla_libros VALUES(
    '20', 
    libro(
        'Perez Reverte', 
        publicacion(
            '11111111',
            'Un día de colera'
        ),
        '401',
        'Dura'
        ), 
    '350'
);

INSERT INTO tabla_libros VALUES(
    '16', 
    libro(
        'Vicente Sevilla', 
        publicacion(
            '22222222',
            'De setas por Madrid'
        ),
        '207',
        'Blanda'
        ), 
    '400'
);

INSERT INTO tabla_libros VALUES(
    '14', 
    libro(
        'Juan Peréz', 
        publicacion(
            '33333333',
            'El jardin japones'
        ),
        '239',
        'Dura'
        ), 
    '3500'
);

/* Querys DML. Identificación por punto */
SELECT * FROM tabla_libros;

SELECT anio, t.lib.autor, t.lib.paginas, t.lib.pasta, tirada FROM tabla_libros t ;

SELECT anio, t.lib.autor,t.lib.pub.titulo, t.lib.paginas, t.lib.pasta, tirada, t.lib.pub.isbn FROM tabla_libros t ;

SELECT anio, t.lib.autor,t.lib.pub.titulo, t.lib.paginas, t.lib.pasta, tirada, t.lib.pub.isbn 
FROM tabla_libros t 
WHERE t.lib.paginas >= 230;

UPDATE tabla_libros t
SET t.lib.autor = 'Günter Nitschke'
WHERE t.lib.pub.isbn = '33333333';


/*****  REVISTAS *****/

/* Objeto hijo heredado */
CREATE OR REPLACE TYPE revista UNDER publicacion (
    periodo VARCHAR2(10),
    precio NUMBER(4,2)
);

/* Tablas de Instancias */
CREATE TABLE tabla_revistas OF revista;


/* Inserción de instancias */
INSERT INTO tabla_revistas VALUES (
    revista('44444444', 'Casa viva', 'Mensual', '4,50' )   /* Los decimales con coma y con comillas */
);

INSERT INTO tabla_revistas VALUES (
    revista('55555555', 'Entreculturas', 'Trimestral', '12,90' )   
);

INSERT INTO tabla_revistas VALUES (
    revista('66666666', 'Lecturas', 'semanal', '1,85' )   
);

/* Querys DML. Identificación directa */
SELECT * FROM tabla_revistas;

SELECT titulo, precio FROM tabla_revistas;

SELECT titulo, periodo, precio 
FROM tabla_revistas
WHERE PRECIO >= 2.50 ;


/****  Instancias   *****/

/*  activar salida de mensajes  */
 SET SERVEROUTPUT ON;

/* Creación de instancia. Bloque PL-SQL */
 DECLARE
    /* Declaracion de variable locales */
     revi_A revista;  
     revi_B revista; 
 BEGIN 
    /*  Método constructor  */
    revi_A := NEW revista('77777777', 'Autofacil', 'semanal', '1,60' ); /* NEW es opcional */
    revi_B := revista('88888888', 'Gamer', 'mensual', '1,85' ); 
    
    /* Consultar instancia */
    dbms_output.put_line('La revista ' || revi_A.titulo  || ' cuesta ' || revi_A.precio );
    dbms_output.put_line('La revista ' || revi_B.titulo  || ' cuesta ' || revi_B.precio );
    
    /* Insertar en tabla */
    INSERT INTO tabla_revistas VALUES revi_A;
    INSERT INTO tabla_revistas VALUES revi_B;
 END;


/*******  Objetos con métodos    ******/

/* Objeto hijo heredado con método Constructor sin precio */
CREATE OR REPLACE TYPE revista UNDER publicacion (
    periodo VARCHAR2(10),
    precio NUMBER(4,2),
    CONSTRUCTOR FUNCTION revista (
        isbn VARCHAR2,
        titulo VARCHAR2,
        periodo VARCHAR2
    ) RETURN SELF AS RESULT   /* Devuelve el mismo objeto como resultado */
);

/* Cuerpo con métodos  */
CREATE OR REPLACE TYPE BODY revista AS  
        CONSTRUCTOR FUNCTION revista ( /* Se repite completo */
        isbn VARCHAR2,
        titulo VARCHAR2,
        periodo VARCHAR2
    ) RETURN SELF AS RESULT 
    IS
    BEGIN
        SELF.isbn  := isbn ;
        SELF.titulo := titulo ;
        SELF.periodo := periodo ;
        
        IF (periodo = 'semanal') THEN
            SELF.precio := '1,75';
        ELSE
            SELF.precio := '4,25';
        END IF;
        
        RETURN;
    END;
END;

INSERT INTO tabla_revistas VALUES (
    revista('99999999', 'Fuera borda', 'semanal' )   
);

INSERT INTO tabla_revistas VALUES (
    revista('00000000', 'Muy interesante', 'mensual' )   
);

INSERT INTO tabla_revistas VALUES (
    revista('10000000', 'Visión', 'semestral', '12,50' )   
);



/* Objeto con tipo anidado y método peso*/
CREATE OR REPLACE TYPE libro  AS OBJECT (
    autor VARCHAR2(30),
    pub publicacion,
    paginas number(3),
    pasta VARCHAR2(8),
    MEMBER FUNCTION peso RETURN NUMBER
);

/* Cuerpo con método peso  */
CREATE OR REPLACE TYPE BODY libro AS
    MEMBER FUNCTION peso RETURN NUMBER
    IS
        cantidad NUMBER(4); 
    BEGIN
        IF (pasta = 'blanda') THEN
            cantidad := (SELF.paginas)*'0,8' ;
        ELSE
            cantidad := ((SELF.paginas)*'0,7')+'70' ;
        END IF;
        
        RETURN cantidad;
    END;
END;

/*  Uso del método */
SELECT anio, t.lib.autor,t.lib.pub.titulo, t.lib.paginas, t.lib.pasta, tirada, t.lib.pub.isbn, t.lib.peso() FROM tabla_libros t ;





/******     ARRAYS   ******/

/*  Crear ARRAY  */
CREATE OR REPLACE TYPE listaReparto IS VARRAY(20) OF revista;
 
/*  Instancias de ARRAYS */
 DECLARE
    /* Declaracion de variable locales */
    revi_A revista;  
    revi_B revista;
    /* Declaracion de arrays locales*/
    repa_14 listaReparto;
    repa_28 listaReparto;
 BEGIN 
    /*  Método constructor  */
    revi_A := NEW revista('77777777', 'Autofacil', 'semanal', '1,60' ); /* NEW es opcional */
    revi_B := revista('88888888', 'Gamer', 'mensual', '1,85' );       
 
    /* Inserción de Instancias en array */
    repa_14 := listaReparto(revi_A, revi_B);
    
    /* Ver contenido vArray  */
    dbms_output.put_line(
        'La lista de reparto del dia 14 es : ' 
        || repa_14(1).titulo || ', '
        || repa_14(2).titulo
    );
    
    /* Inserción de Instancias en array */
    repa_28 := listaReparto(
        revista('00000000', 'Muy interesante', 'mensual' ),
        revista('99999999', 'Fuera borda', 'semanal' ),
        revi_B        
    );
    
    /* Ver contenido vArray  */
    dbms_output.put_line(
        'La lista de reparto del dia 28 es : ' 
        || repa_28(1).titulo || ', '
        || repa_28(2).titulo || ', '
        || repa_28(3).titulo
    );
END;



