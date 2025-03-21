------------------------------creacion de procediminetos ---------------------------------


--1. Procedimiento para insertar un Estado

CREATE OR REPLACE PROCEDURE FIDE_ESTADOS_Insertar_SP (
    p_Estado_ID IN NUMBER,
    p_Descripcion IN VARCHAR2
) AS
BEGIN
    INSERT INTO FIDE_ESTADOS_TB (Estado_ID, Descripcion, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion)
    VALUES (p_Estado_ID, p_Descripcion, NULL, NULL, NULL, NULL, NULL);
    COMMIT;
END FIDE_ESTADOS_Insertar_SP;


--2. Procedimiento para insertar un G�nero

CREATE OR REPLACE PROCEDURE FIDE_GENEROS_Insertar_SP (
    p_Genero_ID IN NUMBER,
    p_Nombre IN VARCHAR2
) AS
BEGIN
    INSERT INTO FIDE_GENEROS_TB (Genero_ID, Nombre, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion)
    VALUES (p_Genero_ID, p_Nombre, NULL, NULL, NULL, NULL, NULL);
    COMMIT;
END FIDE_GENEROS_Insertar_SP;


--3. Procedimiento para insertar una Provincia

CREATE OR REPLACE PROCEDURE FIDE_PROVINCIAS_Insertar_SP (
    p_Provincia_ID IN NUMBER,
    p_Nombre IN VARCHAR2
) AS
BEGIN
    INSERT INTO FIDE_PROVINCIAS_TB (Provincia_ID, Nombre, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion)
    VALUES (p_Provincia_ID, p_Nombre, NULL, NULL, NULL, NULL, NULL);
    COMMIT;
END FIDE_PROVINCIAS_Insertar_SP;


--4. Procedimiento para insertar un Cant�n

CREATE OR REPLACE PROCEDURE FIDE_CANTONES_Insertar_SP (
    p_Canton_ID IN NUMBER,
    p_Nombre IN VARCHAR2
) AS
BEGIN
    INSERT INTO FIDE_CANTONES_TB (Canton_ID, Nombre, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion)
    VALUES (p_Canton_ID, p_Nombre, NULL, NULL, NULL, NULL, NULL);
    COMMIT;
END FIDE_CANTONES_Insertar_SP;


--5. Procedimiento para actualizar la descripci�n de un Estado


CREATE OR REPLACE PROCEDURE FIDE_ESTADOS_Actualizar_SP (
    p_Estado_ID IN NUMBER,
    p_Descripcion IN VARCHAR2
) AS
BEGIN
    UPDATE FIDE_ESTADOS_TB
    SET Descripcion = p_Descripcion,
        fecha_modificacion = SYSDATE
    WHERE Estado_ID = p_Estado_ID;
    COMMIT;
END FIDE_ESTADOS_Actualizar_SP;


--6. Procedimiento para actualizar el nombre de un G�nero

CREATE OR REPLACE PROCEDURE FIDE_GENEROS_Actualizar_SP (
    p_Genero_ID IN NUMBER,
    p_Nombre IN VARCHAR2
) AS
BEGIN
    UPDATE FIDE_GENEROS_TB
    SET Nombre = p_Nombre,
        fecha_modificacion = SYSDATE
    WHERE Genero_ID = p_Genero_ID;
    COMMIT;
END FIDE_GENEROS_Actualizar_SP;


--7. Procedimiento para actualizar el nombre de una Provincia

CREATE OR REPLACE PROCEDURE FIDE_PROVINCIAS_Actualizar_SP (
    p_Provincia_ID IN NUMBER,
    p_Nombre IN VARCHAR2
) AS
BEGIN
    UPDATE FIDE_PROVINCIAS_TB
    SET Nombre = p_Nombre,
        fecha_modificacion = SYSDATE
    WHERE Provincia_ID = p_Provincia_ID;
    COMMIT;
END FIDE_PROVINCIAS_Actualizar_SP;


--8. Procedimiento para actualizar el nombre de un Cant�n

CREATE OR REPLACE PROCEDURE FIDE_CANTONES_Actualizar_SP (
    p_Canton_ID IN NUMBER,
    p_Nombre IN VARCHAR2
) AS
BEGIN
    UPDATE FIDE_CANTONES_TB
    SET Nombre = p_Nombre,
        fecha_modificacion = SYSDATE
    WHERE Canton_ID = p_Canton_ID;
    COMMIT;
END FIDE_CANTONES_Actualizar_SP;


--9. Procedimiento para eliminar un Estado

CREATE OR REPLACE PROCEDURE FIDE_ESTADOS_Eliminar_SP (
    p_Estado_ID IN NUMBER
) AS
BEGIN
    DELETE FROM FIDE_ESTADOS_TB
    WHERE Estado_ID = p_Estado_ID;
    COMMIT;
END FIDE_ESTADOS_Eliminar_SP;


--10. Procedimiento para eliminar un G�nero

CREATE OR REPLACE PROCEDURE FIDE_GENEROS_Eliminar_SP (
    p_Genero_ID IN NUMBER
) AS
BEGIN
    DELETE FROM FIDE_GENEROS_TB
    WHERE Genero_ID = p_Genero_ID;
    COMMIT;
END FIDE_GENEROS_Eliminar_SP;

--11. Procedimiento para eliminar una Provincia

CREATE OR REPLACE PROCEDURE FIDE_PROVINCIAS_Eliminar_SP (
    p_Provincia_ID IN NUMBER
) AS
BEGIN
    DELETE FROM FIDE_PROVINCIAS_TB
    WHERE Provincia_ID = p_Provincia_ID;
    COMMIT;
END FIDE_PROVINCIAS_Eliminar_SP;


--12. Procedimiento para eliminar un Cant�n

CREATE OR REPLACE PROCEDURE FIDE_CANTONES_Eliminar_SP (
    p_Canton_ID IN NUMBER
) AS
BEGIN
    DELETE FROM FIDE_CANTONES_TB
    WHERE Canton_ID = p_Canton_ID;
    COMMIT;
END FIDE_CANTONES_Eliminar_SP;


--13. Procedimiento para obtener los Estados activos

CREATE OR REPLACE PROCEDURE FIDE_ESTADOS_ObtenerActivos_SP
AS
BEGIN
    FOR rec IN (SELECT * FROM FIDE_ESTADOS_TB WHERE Descripcion = 'Activo') LOOP
        DBMS_OUTPUT.PUT_LINE('Estado_ID: ' || rec.Estado_ID || ' - Descripcion: ' || rec.Descripcion);
    END LOOP;
END FIDE_ESTADOS_ObtenerActivos_SP;



--14. Procedimiento para obtener los G�neros existentes

CREATE OR REPLACE PROCEDURE FIDE_GENEROS_Obtener_SP
AS
BEGIN
    FOR rec IN (SELECT * FROM FIDE_GENEROS_TB) LOOP
        DBMS_OUTPUT.PUT_LINE('Genero_ID: ' || rec.Genero_ID || ' - Nombre: ' || rec.Nombre);
    END LOOP;
END FIDE_GENEROS_Obtener_SP;


--15. Procedimiento para obtener los Cantones por Provincia

CREATE OR REPLACE PROCEDURE FIDE_CANTONES_ObtenerPorProvincia_SP (
    p_Provincia_ID IN NUMBER
) AS
BEGIN
    FOR rec IN (SELECT * FROM FIDE_CANTONES_TB WHERE Provincia_ID = p_Provincia_ID) LOOP
        DBMS_OUTPUT.PUT_LINE('Canton_ID: ' || rec.Canton_ID || ' - Nombre: ' || rec.Nombre);
    END LOOP;
END FIDE_CANTONES_ObtenerPorProvincia_SP;



---------------------------------------Cracion del paquete-------------------------
-- Crear el paquete 
CREATE OR REPLACE PACKAGE Fide_Proyecto_Final_PKG AS
    -- Declaraci�n de la funci�n
    FUNCTION obtener_nombre_votante (p_votante_id IN NUMBER) RETURN VARCHAR2;
    
    -- Declaraci�n del procedimiento
    PROCEDURE insertar_votante (
        p_nombre IN VARCHAR2,
        p_apellido IN VARCHAR2,
        p_fecha_nacimiento IN DATE,
        p_email IN VARCHAR2,
        p_telefono IN VARCHAR2,
        p_genero_id IN NUMBER,
        p_direccion_id IN NUMBER,
        p_estado_id IN NUMBER,
        p_creado_por IN VARCHAR2
    );
    
END Fide_Proyecto_Final_PKG;
/
CREATE OR REPLACE PACKAGE BODY Fide_Proyecto_Final_PKG AS

    -- Implementaci�n de la funci�n
    FUNCTION obtener_nombre_votante (p_votante_id IN NUMBER) RETURN VARCHAR2 IS
        v_nombre_completo VARCHAR2(101); -- para almacenar el nombre completo
    BEGIN
        -- Concatenamos el nombre y apellido del votante
        SELECT Nombre || ' ' || Apellido
        INTO v_nombre_completo
        FROM FIDE_VOTANTES_TB
        WHERE Votante_ID = p_votante_id;
        
        RETURN v_nombre_completo;
    END obtener_nombre_votante;
    
    -- Implementaci�n del procedimiento
    PROCEDURE insertar_votante (
        p_nombre IN VARCHAR2,
        p_apellido IN VARCHAR2,
        p_fecha_nacimiento IN DATE,
        p_email IN VARCHAR2,
        p_telefono IN VARCHAR2,
        p_genero_id IN NUMBER,
        p_direccion_id IN NUMBER,
        p_estado_id IN NUMBER,
        p_creado_por IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO FIDE_VOTANTES_TB (
            Nombre, Apellido, Fecha_Nacimiento, Email, Telefono, 
            Genero_ID, Direccion_ID, Estado_ID, creado_por, 
            fecha_creacion, accion
        ) VALUES (
            p_nombre, p_apellido, p_fecha_nacimiento, p_email, p_telefono, 
            p_genero_id, p_direccion_id, p_estado_id, p_creado_por, 
            SYSDATE, 'Insertado'
        );
    END insertar_votante;
    
END Fide_Proyecto_Final_PKG;
/

