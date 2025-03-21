--verifica si un votante esta registrado en una eleccion especifica
CREATE OR REPLACE FUNCTION FIDE_VOTOS_VERIFICA_VOTANTE_FN(
    p_votante_ID IN NUMBER,
    p_eleccion_ID IN NUMBER
) RETURN VARCHAR2 IS
    v_Resultado VARCHAR2(10);
BEGIN
    SELECT CASE 
           WHEN COUNT(*) > 0 THEN 'SI'
           ELSE 'NO'
           END
    INTO v_Resultado
    FROM FIDE_VOTOS_TB
    WHERE Votante_ID = p_votante_ID AND Eleccion_ID = p_eleccion_ID;
    RETURN v_resultado;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'NO HAY DATOS INGRESADOS';
    WHEN OTHERS THEN
        RETURN 'ERROR';
END;
/*
--- aqui se llama la funcion
SET SERVEROUTPUT ON;
DECLARE
    v_resultado VARCHAR2(10);
BEGIN
    v_resultado := FIDE_VOTOS_VERIFICA_VOTANTE_FN(1,1);
    DBMS_OUTPUT.PUT_LINE('El usuario ingresado '||v_Resultado||' está registrado');
END;*/
/
CREATE OR REPLACE FUNCTION FIDE_VOTOS_CONTAR_VOTOS_CANDIDATO_FN(
    p_candidato_ID IN NUMBER,
    p_eleccion_ID IN NUMBER
) RETURN NUMBER IS
    v_numVotos NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_numVotos
    FROM FIDE_VOTOS_TB
    WHERE candidato_ID = p_candidato_ID AND eleccion_ID = p_eleccion_ID;
    RETURN v_numVotos;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
    WHEN OTHERS THEN
        RETURN -1;
END;
/
CREATE OR REPLACE FUNCTION FIDE_PARTIDOS_OBTENER_NOMBRE_FN(
    p_partido_ID IN NUMBER
) RETURN VARCHAR2 IS
    v_nombrePartido VARCHAR2(50);
BEGIN
    SELECT nombre
    INTO v_nombrePartido
    FROM FIDE_PARTIDOS_TB
    WHERE partido_ID = p_partido_ID;
    RETURN v_nombrePartido;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Partido no encontrado';
    WHEN OTHERS THEN
        RETURN 'Error al consultar el partido';
END;
/
CREATE OR REPLACE FUNCTION FIDE_ELECIONES_OBTENER_ESTADO_FN(
    p_eleccion_ID IN NUMBER
) RETURN VARCHAR2 IS
    v_nombreEstado VARCHAR2(50);
BEGIN
    SELECT E.Descripcion
    INTO v_nombreEstado
    FROM FIDE_ELECCIONES_TB ET
    JOIN FIDE_ESTADOS_TB E ON ET.Estado_ID = E.Estado_ID
    WHERE ET.Eleccion_ID = p_eleccion_ID;
    RETURN v_nombreEstado;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Elección no encontrada';
    WHEN OTHERS THEN
        RETURN 'Error al consultar el estado de la elección';
END;
/*
--- aqui se llama la funcion
SET SERVEROUTPUT ON;
DECLARE
    v_nombreEstado VARCHAR2(50);
BEGIN
    v_nombreEstado := FIDE_ELECIONES_OBTENER_ESTADO_FN(1);
    DBMS_OUTPUT.PUT_LINE('El Estado de las elecciones solicitadas es: '||v_nombreEstado);
END;*/
/
CREATE OR REPLACE FUNCTION FIDE_VOTANTES_NOMBRE_COMPLETO_FN(
    p_votante_ID IN NUMBER
) RETURN VARCHAR2 IS
    v_nombreCompleto VARCHAR2(100);
BEGIN
    SELECT Nombre || ' ' || Apellido
    INTO v_nombreCompleto
    FROM FIDE_VOTANTES_TB
    WHERE Votante_ID = p_votante_ID;
    RETURN v_nombreCompleto;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Votante no encontrado';
    WHEN OTHERS THEN
        RETURN 'Error al consultar el nombre';
END;
/*
--- aqui se llama la funcion
SET SERVEROUTPUT ON;
DECLARE
    v_nombreCompleto VARCHAR2(100);
BEGIN
    v_nombreCompleto := FIDE_VOTANTES_NOMBRE_COMPLETO_FN(1);
    DBMS_OUTPUT.PUT_LINE('El Nombre buscado es: '||v_nombreCompleto);
END;*/
/
CREATE OR REPLACE FUNCTION FIDE_PARTIDOS_CANDIDATOS_REGISTRADOS_FN(
    p_partido_ID IN NUMBER
) RETURN VARCHAR2 IS
    v_resultado VARCHAR2(10);
BEGIN
    SELECT CASE
           WHEN COUNT(*) > 0 THEN 'SI'
           ELSE 'NO'
           END
    INTO v_resultado
    FROM FIDE_CANDIDATOS_TB
    WHERE Partido_ID = p_partido_ID;
    RETURN v_resultado;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'NO';
    WHEN OTHERS THEN
        RETURN 'ERROR';
END;
/*
--- aqui se llama la funcion
SET SERVEROUTPUT ON;
DECLARE
    v_resultado VARCHAR2(100);
BEGIN
    v_resultado := FIDE_PARTIDOS_CANDIDATOS_REGISTRADOS_FN(1);
    DBMS_OUTPUT.PUT_LINE('El partido '||v_resultado||' tiene candidatos');
END;*/
/
CREATE OR REPLACE FUNCTION FIDE_VOTANTES_CALCULAR_EDAD_FN(
    p_votante_ID IN NUMBER
) RETURN NUMBER IS
    v_edad NUMBER;
BEGIN
    SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, Fecha_Nacimiento) / 12)
    INTO v_edad
    FROM FIDE_VOTANTES_TB
    WHERE votante_ID = p_votante_ID;
    RETURN v_edad;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1;
    WHEN OTHERS THEN
        RETURN -2;
END;
/*
-- aqui se llama la funsion
BEGIN
    DBMS_OUTPUT.PUT_LINE('Edad del votante solicitado es: ' || FIDE_VOTANTES_CALCULAR_EDAD_FN(1)||' años');
END;*/
/
CREATE OR REPLACE FUNCTION FIDE_VOTANTES_POR_GENERO_FN(
    p_genero_ID IN NUMBER
) RETURN NUMBER IS
    v_numVotantes NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_numVotantes
    FROM FIDE_VOTANTES_TB
    WHERE Genero_ID = p_genero_ID;
    RETURN v_numVotantes;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
    WHEN OTHERS THEN
        RETURN -1;-- esto indica cualquier otro error
END;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Cantidad de votates del genero seleccionado es: ' || FIDE_VOTANTES_POR_GENERO_FN(1));
END;
/



