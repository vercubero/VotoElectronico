create or replace PROCEDURE FIDE_CREDENCIALES_SELEC_CODIGO_SP(
    p_cursor OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_cursor FOR
        SELECT Codigo, FechaEmision
        FROM FIDE_CREDENCIALES_TB;
END FIDE_CREDENCIALES_SELEC_CODIGO_SP;

/
CREATE OR REPLACE FUNCTION FIDE_VOTANTES_VALIDA_CEDULA_FN(p_cedula NUMBER)
RETURN NUMBER IS
    v_votante_id NUMBER;
BEGIN
    SELECT Votante_ID
    INTO v_votante_id
    FROM FIDE_VOTANTES_TB
    WHERE Cedula = p_cedula;

    RETURN v_votante_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL; -- No se encontró la cédula
END;
/
CREATE OR REPLACE TRIGGER FIDE_CREDENCIALES_INSERTAR_TRG
AFTER INSERT OR UPDATE ON FIDE_VOTANTES_TB
FOR EACH ROW
DECLARE
    v_eleccion_id NUMBER;
BEGIN
    -- Buscar Eleccion_ID basado en la fecha seleccionada
    SELECT Eleccion_ID
    INTO v_eleccion_id
    FROM FIDE_ELECCIONES_TB
    WHERE Fecha_Inicio = :NEW.p_Fecha;

    -- Llamar al procedimiento para insertar credencial
    FIDE_CREDENCIALES_INSERTAR_SP(:NEW.Votante_ID, v_eleccion_id, SYSDATE);
END;
