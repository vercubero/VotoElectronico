CREATE OR REPLACE FUNCTION FIDE_CREDENCIALES_GENERAR_CODIGO RETURN VARCHAR2 IS
  codigo VARCHAR2(50);
BEGIN
  SELECT SUBSTR(DBMS_RANDOM.STRING('X', 6), 1, 6)
  INTO codigo
  FROM DUAL;

  RETURN codigo;
END;
/
CREATE OR REPLACE TRIGGER FIDE_CREDENCIALES_CODIGO
BEFORE INSERT ON FIDE_CREDENCIALES_TB
FOR EACH ROW
BEGIN
  :NEW.Codigo := FIDE_CREDENCIALES_GENERAR_CODIGO();
END;
/
ALTER TABLE FIDE_VOTANTES_TB
ADD (
    cedula NUMBER NOT NULL UNIQUE,
    fecha_vence DATE
);
ALTER TABLE FIDE_VOTANTES_TB
ADD (
    Segundo_Apellido VARCHAR2(50)
);
/
CREATE OR REPLACE FUNCTION FIDE_VOTANTES_OBTENER_ID(
    p_cedula NUMBER
) RETURN NUMBER IS
    v_votante_id NUMBER;
BEGIN
    SELECT VOTANTE_ID
    INTO v_votante_id
    FROM FIDE_VOTANTES_TB
    WHERE CEDULA = p_cedula;
    RETURN v_votante_id;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE;
END FIDE_VOTANTES_OBTENER_ID;
/

