CREATE OR REPLACE PACKAGE BODY Fide_Proyecto_Final_PKG AS

    ----------------- Implementaci�n de la funci�n-----------------------
FUNCTION FIDE_ELECIONES_OBTENER_ESTADO_FN(p_eleccion_ID IN NUMBER) RETURN VARCHAR2 IS
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
------
FUNCTION FIDE_PARTIDOS_CANDIDATOS_REGISTRADOS_FN(
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
----
FUNCTION FIDE_PARTIDOS_OBTENER_NOMBRE_FN(
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
----
FUNCTION FIDE_VOTANTES_CALCULAR_EDAD_FN(
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
----
FUNCTION FIDE_VOTANTES_NOMBRE_COMPLETO_FN(
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
----
FUNCTION FIDE_VOTANTES_POR_GENERO_FN(
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
----
FUNCTION FIDE_VOTOS_CONTAR_VOTOS_CANDIDATO_FN(
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
----
FUNCTION FIDE_VOTOS_VERIFICA_VOTANTE_FN(
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
----
    
    ------------------- Implementaci�n del procedimiento--------------------------------------------
PROCEDURE FIDE_AUDITORES_ACTUALIZAR_SP(
    p_Auditor_ID IN NUMBER,
    p_Nombre IN VARCHAR2,
    p_Apellido IN VARCHAR2,
    p_Email IN VARCHAR2,
    p_Telefono IN VARCHAR2,
    p_modificado_por IN VARCHAR2
) IS
BEGIN
    UPDATE FIDE_AUDITORES_TB
    SET 
        Nombre = p_Nombre,
        Apellido = p_Apellido,
        Email = p_Email,
        Telefono = p_Telefono,
        modificado_por = p_modificado_por,
        fecha_modificacion = SYSDATE,
        accion = 'ACTUALIZAR'
    WHERE Auditor_ID = p_Auditor_ID;
END FIDE_AUDITORES_ACTUALIZAR_SP;
-----------------
PROCEDURE FIDE_AUDITORES_ELIMINAR_SP(p_Auditor_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_AUDITORES_TB WHERE Auditor_ID = p_Auditor_ID;
END FIDE_AUDITORES_ELIMINAR_SP;
--------------
PROCEDURE FIDE_AUDITORES_INSERTAR_SP(
    p_Auditor_ID IN NUMBER,
    p_Nombre IN VARCHAR2,
    p_Apellido IN VARCHAR2,
    p_Email IN VARCHAR2,
    p_Telefono IN VARCHAR2,
    p_creado_por IN VARCHAR2
) IS
BEGIN
    INSERT INTO FIDE_AUDITORES_TB (
        Auditor_ID, Nombre, Apellido, Email, Telefono, creado_por, 
        fecha_creacion, accion
    ) VALUES (
        p_Auditor_ID, p_Nombre, p_Apellido, p_Email, p_Telefono, p_creado_por, 
        SYSDATE, 'INSERTAR'
    );
END FIDE_AUDITORES_INSERTAR_SP;
--------------
PROCEDURE FIDE_AUDITORES_SIN_AUDITORIAS_SP
AS
BEGIN
    FOR registro IN (
        SELECT a.Auditor_ID, a.Nombre || ' ' || a.Apellido AS Nombre_Auditor
        FROM FIDE_AUDITORES_TB a
        WHERE a.Auditor_ID NOT IN (
            SELECT DISTINCT Auditor_ID FROM FIDE_AUDITORIAS_TB
        )
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Auditor: ' || registro.Nombre_Auditor || 
                             ' (ID: ' || registro.Auditor_ID || ')');
    END LOOP;
END;
---------------
PROCEDURE FIDE_AUDITORIAS_POR_AUDITOR_SP
AS
BEGIN
    FOR registro IN (
        SELECT a.Nombre || ' ' || a.Apellido AS Nombre_Auditor, 
               aud.Fecha_Auditoria, aud.Resultado
        FROM FIDE_AUDITORES_TB a
        JOIN FIDE_AUDITORIAS_TB aud ON a.Auditor_ID = aud.Auditor_ID
        ORDER BY aud.Fecha_Auditoria DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Auditor: ' || registro.Nombre_Auditor || 
                             ', Fecha: ' || TO_CHAR(registro.Fecha_Auditoria, 'YYYY-MM-DD') || 
                             ', Resultado: ' || registro.Resultado);
    END LOOP;
END;
-------------------
PROCEDURE FIDE_AUDITORIAS_POR_ELECCION_SP
AS
BEGIN
    FOR registro IN (
        SELECT e.Nombre AS Eleccion, COUNT(aud.Auditoria_ID) AS Total_Auditorias
        FROM FIDE_AUDITORIAS_TB aud
        JOIN FIDE_ELECCIONES_TB e ON aud.Eleccion_ID = e.Eleccion_ID
        GROUP BY e.Nombre
        ORDER BY Total_Auditorias DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Elección: ' || registro.Eleccion || 
                             ', Total Auditorías: ' || registro.Total_Auditorias);
    END LOOP;
END;
-----------------
PROCEDURE FIDE_CANDIDATOS_ACTUALIZAR_SP(
    p_Candidato_ID IN NUMBER,
    p_Nombre IN VARCHAR2,
    p_Apellido IN VARCHAR2,
    p_Partido_ID IN NUMBER,
    p_Eleccion_ID IN NUMBER,
    p_Estado_ID IN NUMBER,
    p_modificado_por IN VARCHAR2
) IS
BEGIN
    UPDATE FIDE_CANDIDATOS_TB
    SET 
        Nombre = p_Nombre,
        Apellido = p_Apellido,
        Partido_ID = p_Partido_ID,
        Eleccion_ID = p_Eleccion_ID,
        Estado_ID = p_Estado_ID,
        modificado_por = p_modificado_por,
        fecha_modificacion = SYSDATE,
        accion = 'ACTUALIZAR'
    WHERE Candidato_ID = p_Candidato_ID;
END FIDE_CANDIDATOS_ACTUALIZAR_SP;
-------------------------
PROCEDURE FIDE_CANDIDATOS_ELIMINAR_SP(p_Candidato_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_CANDIDATOS_TB WHERE Candidato_ID = p_Candidato_ID;
END FIDE_CANDIDATOS_ELIMINAR_SP;
------------------------
PROCEDURE FIDE_CANDIDATOS_INSERTAR_SP(
    p_Candidato_ID IN NUMBER,
    p_Nombre IN VARCHAR2,
    p_Apellido IN VARCHAR2,
    p_Partido_ID IN NUMBER,
    p_Eleccion_ID IN NUMBER,
    p_Estado_ID IN NUMBER,
    p_creado_por IN VARCHAR2
) IS
BEGIN
    INSERT INTO FIDE_CANDIDATOS_TB (
        Candidato_ID, Nombre, Apellido, Partido_ID, Eleccion_ID, Estado_ID, 
        creado_por, fecha_creacion, accion
    ) VALUES (
        p_Candidato_ID, p_Nombre, p_Apellido, p_Partido_ID, p_Eleccion_ID, p_Estado_ID, 
        p_creado_por, SYSDATE, 'INSERTAR'
    );
END FIDE_CANDIDATOS_INSERTAR_SP;
---------------------
PROCEDURE FIDE_CANDIDATOS_SIN_VOTOS_SP (
    p_eleccion_id IN NUMBER
)
AS
BEGIN
    FOR registro IN (
        SELECT c.Candidato_ID, c.Nombre || ' ' || c.Apellido AS Nombre_Candidato, 
               p.Nombre AS Partido
        FROM FIDE_CANDIDATOS_TB c
        JOIN FIDE_PARTIDOS_TB p ON c.Partido_ID = p.Partido_ID
        WHERE c.Eleccion_ID = p_eleccion_id AND 
              c.Candidato_ID NOT IN (
                  SELECT DISTINCT Candidato_ID FROM FIDE_VOTOS_TB WHERE Eleccion_ID = p_eleccion_id
              )
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Candidato: ' || registro.Nombre_Candidato || 
                             ', Partido: ' || registro.Partido);
    END LOOP;
END;
-----------------------
PROCEDURE FIDE_CANTONES_Actualizar_SP (
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
---------------
PROCEDURE FIDE_CANTONES_Eliminar_SP (
    p_Canton_ID IN NUMBER
) AS
BEGIN
    DELETE FROM FIDE_CANTONES_TB
    WHERE Canton_ID = p_Canton_ID;
    COMMIT;
END FIDE_CANTONES_Eliminar_SP;
----------------------
PROCEDURE FIDE_CANTONES_Insertar_SP (
    p_Canton_ID IN NUMBER,
    p_Nombre IN VARCHAR2
) AS
BEGIN
    INSERT INTO FIDE_CANTONES_TB (Canton_ID, Nombre, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion)
    VALUES (p_Canton_ID, p_Nombre, NULL, NULL, NULL, NULL, NULL);
    COMMIT;
END FIDE_CANTONES_Insertar_SP;
-------------------------
PROCEDURE FIDE_CANTONES_ObtenerPorProvincia_SP(
    p_Provincia_ID IN NUMBER
) AS
BEGIN
    FOR rec IN (SELECT Canton_ID, Nombre 
                FROM FIDE_CANTONES_TB 
                WHERE Canton_ID IN (
                    SELECT Canton_ID 
                    FROM FIDE_DIRECCIONES_TB 
                    WHERE Provincia_ID = p_Provincia_ID)) LOOP
        DBMS_OUTPUT.PUT_LINE('Canton_ID: ' || rec.Canton_ID || ' - Nombre: ' || rec.Nombre);
    END LOOP;
   /* IF NOT EXISTS (SELECT 1 
                   FROM FIDE_DIRECCIONES_TB 
                   WHERE Provincia_ID = p_Provincia_ID) THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron cantones para la Provincia con ID ' || p_Provincia_ID);
    END IF;*/

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM);
END FIDE_CANTONES_ObtenerPorProvincia_SP;
------------
PROCEDURE FIDE_DIRECCIONES_DELETE_SP(
    p_Direccion_ID IN NUMBER
)
AS
BEGIN
    DELETE FROM FIDE_DIRECCIONES_TB
    WHERE Direccion_ID = p_Direccion_ID;
END;
------------------------------
PROCEDURE FIDE_DIRECCIONES_INSERT_SP(
    p_Direccion_ID IN NUMBER,
    p_Provincia_ID IN NUMBER,
    p_Canton_ID IN NUMBER,
    p_Distrito_ID IN NUMBER,
    p_creado_por IN VARCHAR2,
    p_modificado_por IN VARCHAR2,
    p_Fecha_Creacion IN DATE,
    p_Fecha_Modificacion IN DATE,
    p_accion IN VARCHAR2
)
AS
BEGIN
    INSERT INTO FIDE_DIRECCIONES_TB (
        Direccion_ID, Provincia_ID, Canton_ID, Distrito_ID, 
        creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion
    )
    VALUES (
        p_Direccion_ID, p_Provincia_ID, p_Canton_ID, p_Distrito_ID, 
        p_creado_por, p_modificado_por, SYSDATE, SYSDATE, p_accion
    );
END;
---------------------------------------
PROCEDURE FIDE_DIRECCIONES_UPDATE_SP(
    p_Direccion_ID IN NUMBER,
    p_Provincia_ID IN NUMBER,
    p_Canton_ID IN NUMBER,
    p_Distrito_ID IN NUMBER,
    p_creado_por IN VARCHAR2,
    p_modificado_por IN VARCHAR2,
    p_Fecha_Creacion IN DATE,
    p_Fecha_Modificacion IN DATE,
    p_accion IN VARCHAR2
)
AS
BEGIN
    UPDATE FIDE_DIRECCIONES_TB
    SET Provincia_ID = p_Provincia_ID,
        Canton_ID = p_Canton_ID,
        Distrito_ID = p_Distrito_ID,
        creado_por = p_creado_por,
        modificado_por = p_modificado_por,
        fecha_creacion = SYSDATE,
        fecha_modificacion = SYSDATE,
        accion = p_accion
    WHERE Direccion_ID = p_Direccion_ID;
END;
--------------------------------
PROCEDURE FIDE_DISTRITOS_DELETE_SP(
    p_Distrito_ID IN NUMBER
)
AS
BEGIN
    DELETE FROM FIDE_DISTRITOS_TB
    WHERE Distrito_ID = p_Distrito_ID;
END;
---------------------------------
PROCEDURE FIDE_DISTRITOS_INSERT_SP(
    p_Distrito_ID IN NUMBER,
    p_Nombre IN VARCHAR2,
    p_creado_por IN VARCHAR2,
    p_modificado_por IN VARCHAR2,
    p_Fecha_Creacion IN DATE,
    p_Fecha_Modificacion IN DATE,
    p_accion IN VARCHAR2
)
AS
BEGIN
    INSERT INTO FIDE_DISTRITOS_TB (
        Distrito_ID, Nombre, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion
    )
    VALUES (
        p_Distrito_ID, p_Nombre, p_creado_por, p_modificado_por, SYSDATE, SYSDATE, p_accion
    );
END;
------------------------------------
PROCEDURE FIDE_DISTRITOS_UPDATE_SP(
    p_Distrito_ID IN NUMBER,
    p_Nombre IN VARCHAR2,
    p_creado_por IN VARCHAR2,
    p_modificado_por IN VARCHAR2,
    p_Fecha_Creacion IN DATE,
    p_Fecha_Modificacion IN DATE,
    p_accion IN VARCHAR2
)
AS
BEGIN
    UPDATE FIDE_DISTRITOS_TB
    SET Nombre = p_Nombre,
        creado_por = p_creado_por,
        modificado_por = p_modificado_por,
        fecha_creacion = SYSDATE,
        fecha_modificacion = SYSDATE,
        accion = p_accion
    WHERE Distrito_ID = p_Distrito_ID;
END;
----------------------------------
PROCEDURE FIDE_ELECCIONES_DELETE_SP(
    p_Eleccion_ID IN NUMBER
)
AS
BEGIN
    DELETE FROM FIDE_ELECCIONES_TB
    WHERE Eleccion_ID = p_Eleccion_ID;
END;
----------------------------
PROCEDURE FIDE_ELECCIONES_INSERT_SP(
    p_Eleccion_ID IN NUMBER,
    p_Nombre IN VARCHAR2,
    p_Fecha_Inicio IN DATE,
    p_Fecha_Fin IN DATE,
    p_Descripcion IN VARCHAR2,
    p_Estado_ID IN NUMBER,
    p_creado_por IN VARCHAR2,
    p_modificado_por IN VARCHAR2,
    p_Fecha_Creacion IN DATE,
    p_Fecha_Modificacion IN DATE,
    p_accion IN VARCHAR2
)
AS
BEGIN
    INSERT INTO FIDE_ELECCIONES_TB (
        Eleccion_ID, Nombre, Fecha_Inicio, Fecha_Fin, Descripcion, 
        Estado_ID, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion
    )
    VALUES (
        p_Eleccion_ID, p_Nombre, p_Fecha_Inicio, p_Fecha_Fin, p_Descripcion, 
        p_Estado_ID, p_creado_por, p_modificado_por, SYSDATE, SYSDATE, p_accion
    );
END;
---------------------------
PROCEDURE FIDE_ELECCIONES_TB_ESTADO_ELECCIONES_SP
AS
BEGIN
    FOR registro IN (
        SELECT e.Eleccion_ID, e.Nombre, 
               e.Fecha_Inicio, e.Fecha_Fin, es.Descripcion AS Estado
        FROM FIDE_ELECCIONES_TB e
        JOIN FIDE_ESTADOS_TB es ON e.Estado_ID = es.Estado_ID
        ORDER BY e.Fecha_Inicio DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Elección: ' || registro.Nombre || 
                             ', Inicio: ' || TO_CHAR(registro.Fecha_Inicio, 'YYYY-MM-DD') || 
                             ', Fin: ' || TO_CHAR(registro.Fecha_Fin, 'YYYY-MM-DD') || 
                             ', Estado: ' || registro.Estado);
    END LOOP;
END;
----------------------------------
PROCEDURE FIDE_ELECCIONES_UPDATE_SP(
    p_Eleccion_ID IN NUMBER,
    p_Nombre IN VARCHAR2,
    p_Fecha_Inicio IN DATE,
    p_Fecha_Fin IN DATE,
    p_Descripcion IN VARCHAR2,
    p_Estado_ID IN NUMBER,
    p_modificado_por IN VARCHAR2,
    p_accion IN VARCHAR2
)
AS
BEGIN
    UPDATE FIDE_ELECCIONES_TB
    SET Nombre = p_Nombre,
        Fecha_Inicio = p_Fecha_Inicio,
        Fecha_Fin = p_Fecha_Fin,
        Descripcion = p_Descripcion,
        Estado_ID = p_Estado_ID,
        modificado_por = p_modificado_por,
        fecha_modificacion = SYSDATE,
        accion = p_accion
    WHERE Eleccion_ID = p_Eleccion_ID;
END;
-----------------------------------
PROCEDURE FIDE_ESTADOS_Actualizar_SP (
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
---------------------------------
PROCEDURE FIDE_ESTADOS_Eliminar_SP (
    p_Estado_ID IN NUMBER
) AS
BEGIN
    DELETE FROM FIDE_ESTADOS_TB
    WHERE Estado_ID = p_Estado_ID;
    COMMIT;
END FIDE_ESTADOS_Eliminar_SP;
---------------------------------
PROCEDURE FIDE_ESTADOS_Insertar_SP (
    p_Estado_ID IN NUMBER,
    p_Descripcion IN VARCHAR2
) AS
BEGIN
    INSERT INTO FIDE_ESTADOS_TB (Estado_ID, Descripcion, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion)
    VALUES (p_Estado_ID, p_Descripcion, NULL, NULL, NULL, NULL, NULL);
    COMMIT;
END FIDE_ESTADOS_Insertar_SP;
---------------------------------
PROCEDURE FIDE_ESTADOS_ObtenerActivos_SP
AS
BEGIN
    FOR rec IN (SELECT * FROM FIDE_ESTADOS_TB WHERE Descripcion = 'Activo') LOOP
        DBMS_OUTPUT.PUT_LINE('Estado_ID: ' || rec.Estado_ID || ' - Descripcion: ' || rec.Descripcion);
    END LOOP;
END FIDE_ESTADOS_ObtenerActivos_SP;
---------------------------
PROCEDURE FIDE_GENEROS_Actualizar_SP (
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
----------------------------------
PROCEDURE FIDE_GENEROS_Eliminar_SP (
    p_Genero_ID IN NUMBER
) AS
BEGIN
    DELETE FROM FIDE_GENEROS_TB
    WHERE Genero_ID = p_Genero_ID;
    COMMIT;
END FIDE_GENEROS_Eliminar_SP;
---------------------------
PROCEDURE FIDE_GENEROS_Insertar_SP (
    p_Genero_ID IN NUMBER,
    p_Nombre IN VARCHAR2
) AS
BEGIN
    INSERT INTO FIDE_GENEROS_TB (Genero_ID, Nombre, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion)
    VALUES (p_Genero_ID, p_Nombre, NULL, NULL, NULL, NULL, NULL);
    COMMIT;
END FIDE_GENEROS_Insertar_SP;
----------------------------------
PROCEDURE FIDE_GENEROS_Obtener_SP
AS
BEGIN
    FOR rec IN (SELECT * FROM FIDE_GENEROS_TB) LOOP
        DBMS_OUTPUT.PUT_LINE('Genero_ID: ' || rec.Genero_ID || ' - Nombre: ' || rec.Nombre);
    END LOOP;
END FIDE_GENEROS_Obtener_SP;
---------------------------------
PROCEDURE FIDE_MESAS_VOTO_DELETE_SP(
    p_Mesa_Voto_ID IN NUMBER
)
AS
BEGIN
    DELETE FROM FIDE_MESAS_VOTO_TB
    WHERE Mesa_Voto_ID = p_Mesa_Voto_ID;
END;
---------------------------------
PROCEDURE FIDE_MESAS_VOTO_INSERT_SP(
    p_Mesa_Voto_ID IN NUMBER,
    p_Eleccion_ID IN NUMBER,
    p_Votante_ID IN NUMBER,
    p_Estado_ID IN NUMBER,
    p_creado_por IN VARCHAR2,
    p_modificado_por IN VARCHAR2,
    p_fecha_creacion IN DATE,
    p_fecha_modificacion IN DATE,
    p_accion IN VARCHAR2
)
AS
BEGIN
    INSERT INTO FIDE_MESAS_VOTO_TB (
        Mesa_Voto_ID, Eleccion_ID, Votante_ID, Estado_ID,
        creado_por, modificado_por, fecha_creacion,
        fecha_modificacion, accion
    )
    VALUES (
        p_Mesa_Voto_ID, p_Eleccion_ID, p_Votante_ID, p_Estado_ID,
        p_creado_por, p_modificado_por, p_fecha_creacion,
        p_fecha_modificacion, p_accion
    );
END;
----------------------------------------------
PROCEDURE FIDE_MESAS_VOTO_UPDATE_SP(
    p_Mesa_Voto_ID IN NUMBER,
    p_Eleccion_ID IN NUMBER,
    p_Votante_ID IN NUMBER,
    p_Estado_ID IN NUMBER,
    p_creado_por IN VARCHAR2,
    p_modificado_por IN VARCHAR2,
    p_fecha_creacion IN DATE,
    p_fecha_modificacion IN DATE,
    p_accion IN VARCHAR2
)
AS
BEGIN
    UPDATE FIDE_MESAS_VOTO_TB
    SET Eleccion_ID = p_Eleccion_ID,
        Votante_ID = p_Votante_ID,
        Estado_ID = p_Estado_ID,
        creado_por = p_creado_por,
        modificado_por = p_modificado_por,
        fecha_creacion = p_fecha_creacion,
        fecha_modificacion = p_fecha_modificacion,
        accion = p_accion
    WHERE Mesa_Voto_ID = p_Mesa_Voto_ID;
END;
-----------------------------------
PROCEDURE FIDE_PARTIDOS_DELETE_SP(
    p_Partido_ID IN NUMBER
)
AS
BEGIN
    DELETE FROM FIDE_PARTIDOS_TB
    WHERE Partido_ID = p_Partido_ID;
END;
-------------------------------------
PROCEDURE FIDE_PARTIDOS_INSERT_SP(
    p_Partido_ID IN NUMBER,
    p_Nombre IN VARCHAR2,
    p_Siglas_Partido IN VARCHAR2,
    p_Fecha_Fundacion IN DATE,
    p_Estado_ID IN NUMBER,
    p_creado_por IN VARCHAR2,
    p_modificado_por IN VARCHAR2,
    p_Fecha_Creacion IN DATE,
    p_Fecha_Modificacion IN DATE,
    p_accion IN VARCHAR2
)
AS
BEGIN
    INSERT INTO FIDE_PARTIDOS_TB (
        Partido_ID, Nombre, Siglas_Partido, Fecha_Fundacion, Estado_ID, 
        creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion
    )
    VALUES (
        p_Partido_ID, p_Nombre, p_Siglas_Partido, p_Fecha_Fundacion, p_Estado_ID, 
        p_creado_por, p_modificado_por, SYSDATE, SYSDATE, p_accion
    );
END;
----------------------------------
PROCEDURE FIDE_PARTIDOS_UPDATE_SP(
    p_Partido_ID IN NUMBER,
    p_Nombre IN VARCHAR2,
    p_Siglas_Partido IN VARCHAR2,
    p_Fecha_Fundacion IN DATE,
    p_Estado_ID IN NUMBER,
    p_creado_por IN VARCHAR2,
    p_modificado_por IN VARCHAR2,
    p_Fecha_Creacion IN DATE,
    p_Fecha_Modificacion IN DATE,
    p_accion IN VARCHAR2
)
AS
BEGIN
    UPDATE FIDE_PARTIDOS_TB
    SET Nombre = p_Nombre,
        Siglas_Partido = p_Siglas_Partido,
        Fecha_Fundacion = p_Fecha_Fundacion,
        Estado_ID = p_Estado_ID,
        creado_por = p_creado_por,
        modificado_por = p_modificado_por,
        fecha_creacion = SYSDATE,
        fecha_modificacion = SYSDATE,
        accion = p_accion
    WHERE Partido_ID = p_Partido_ID;
END;
-----------------------------------
PROCEDURE FIDE_PROVINCIAS_Actualizar_SP (
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
-------------------------
PROCEDURE FIDE_PROVINCIAS_Eliminar_SP (
    p_Provincia_ID IN NUMBER
) AS
BEGIN
    DELETE FROM FIDE_PROVINCIAS_TB
    WHERE Provincia_ID = p_Provincia_ID;
    COMMIT;
END FIDE_PROVINCIAS_Eliminar_SP;
--------------------------------------
PROCEDURE FIDE_PROVINCIAS_Insertar_SP (
    p_Provincia_ID IN NUMBER,
    p_Nombre IN VARCHAR2
) AS
BEGIN
    INSERT INTO FIDE_PROVINCIAS_TB (Provincia_ID, Nombre, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion)
    VALUES (p_Provincia_ID, p_Nombre, NULL, NULL, NULL, NULL, NULL);
    COMMIT;
END FIDE_PROVINCIAS_Insertar_SP;
----------------------------------------
PROCEDURE FIDE_RESULTADOS_ACTUALIZAR_SP(
    p_Resultado_ID IN NUMBER,
    p_Eleccion_ID IN NUMBER,
    p_Candidato_ID IN NUMBER,
    p_Estado_ID IN NUMBER,
    p_Votos_Obtenidos IN NUMBER,
    p_modificado_por IN VARCHAR2
) IS
BEGIN
    UPDATE FIDE_RESULTADOS_TB
    SET 
        Eleccion_ID = p_Eleccion_ID,
        Candidato_ID = p_Candidato_ID,
        Estado_ID = p_Estado_ID,
        Votos_Obtenidos = p_Votos_Obtenidos,
        modificado_por = p_modificado_por,
        fecha_modificacion = SYSDATE,
        accion = 'ACTUALIZAR'
    WHERE Resultado_ID = p_Resultado_ID;
END FIDE_RESULTADOS_ACTUALIZAR_SP;
----------------------------------------
PROCEDURE FIDE_RESULTADOS_ELIMINAR_SP(p_Resultado_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_RESULTADOS_TB WHERE Resultado_ID = p_Resultado_ID;
END FIDE_RESULTADOS_ELIMINAR_SP;
----------------------------------------------
PROCEDURE FIDE_RESULTADOS_INSERTAR_SP(
    p_Resultado_ID IN NUMBER,
    p_Eleccion_ID IN NUMBER,
    p_Candidato_ID IN NUMBER,
    p_Estado_ID IN NUMBER,
    p_Votos_Obtenidos IN NUMBER,
    p_creado_por IN VARCHAR2
) IS
BEGIN
    INSERT INTO FIDE_RESULTADOS_TB (
        Resultado_ID, Eleccion_ID, Candidato_ID, Estado_ID, Votos_Obtenidos, 
        creado_por, fecha_creacion, accion
    ) VALUES (
        p_Resultado_ID, p_Eleccion_ID, p_Candidato_ID, p_Estado_ID, p_Votos_Obtenidos, 
        p_creado_por, SYSDATE, 'INSERTAR'
    );
END FIDE_RESULTADOS_INSERTAR_SP;
--------------------------------------
PROCEDURE FIDE_ROLES_ACTUALIZAR_SP(
    p_Rol_ID IN NUMBER,
    p_Nombre_Rol IN VARCHAR2,
    p_modificado_por IN VARCHAR2
) IS
BEGIN
    UPDATE FIDE_ROLES_TB
    SET 
        Nombre_Rol = p_Nombre_Rol,
        modificado_por = p_modificado_por,
        fecha_modificacion = SYSDATE,
        accion = 'ACTUALIZAR'
    WHERE Rol_ID = p_Rol_ID;
END FIDE_ROLES_ACTUALIZAR_SP;
-------------------------------------
PROCEDURE FIDE_ROLES_ELIMINAR_SP(p_Rol_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_ROLES_TB WHERE Rol_ID = p_Rol_ID;
END FIDE_ROLES_ELIMINAR_SP;
-----------------------------------
PROCEDURE FIDE_ROLES_INSERTAR_SP(
    p_Rol_ID IN NUMBER,
    p_Nombre_Rol IN VARCHAR2,
    p_creado_por IN VARCHAR2
) IS
BEGIN
    INSERT INTO FIDE_ROLES_TB (
        Rol_ID, Nombre_Rol, creado_por, fecha_creacion, accion
    ) VALUES (
        p_Rol_ID, p_Nombre_Rol, p_creado_por, SYSDATE, 'INSERTAR'
    );
END FIDE_ROLES_INSERTAR_SP;
------------------------------------
PROCEDURE FIDE_USUARIOS_ACTUALIZAR_SP(
    p_Usuario_ID IN NUMBER,
    p_User_name IN VARCHAR2,
    p_Password IN VARCHAR2,
    p_Email IN VARCHAR2,
    p_Rol_ID IN NUMBER,
    p_Estado_ID IN NUMBER,
    p_modificado_por IN VARCHAR2
) IS
BEGIN
    UPDATE FIDE_USUARIOS_TB
    SET 
        User_name = p_User_name,
        Password = p_Password,
        Email = p_Email,
        Rol_ID = p_Rol_ID,
        Estado_ID = p_Estado_ID,
        modificado_por = p_modificado_por,
        fecha_modificacion = SYSDATE,
        accion = 'ACTUALIZAR'
    WHERE Usuario_ID = p_Usuario_ID;
END FIDE_USUARIOS_ACTUALIZAR_SP;
---------------------------------
PROCEDURE FIDE_USUARIOS_ELIMINAR_SP(p_Usuario_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_USUARIOS_TB WHERE Usuario_ID = p_Usuario_ID;
END FIDE_USUARIOS_ELIMINAR_SP;
------------------------------
PROCEDURE FIDE_USUARIOS_INSERTAR_SP(
    p_Usuario_ID IN NUMBER,
    p_User_name IN VARCHAR2,
    p_Password IN VARCHAR2,
    p_Email IN VARCHAR2,
    p_Rol_ID IN NUMBER,
    p_Estado_ID IN NUMBER,
    p_creado_por IN VARCHAR2
) IS
BEGIN
    INSERT INTO FIDE_USUARIOS_TB (
        Usuario_ID, User_name, Password, Email, Rol_ID, Estado_ID, 
        creado_por, fecha_creacion, accion
    ) VALUES (
        p_Usuario_ID, p_User_name, p_Password, p_Email, p_Rol_ID, p_Estado_ID, 
        p_creado_por, SYSDATE, 'INSERTAR'
    );
END FIDE_USUARIOS_INSERTAR_SP;
-----------------------------------
PROCEDURE FIDE_USUARIOS_VALIDAR_USUARIO_SP(
    p_username IN VARCHAR2,
    p_password IN VARCHAR2,
    p_valido OUT NUMBER
)
IS
BEGIN
    SELECT COUNT(*)
    INTO p_valido
    FROM FIDE_USUARIOS_TB
    WHERE User_name = p_username AND Password = p_password;
END;
-------------------------------------------
PROCEDURE FIDE_VALIDAR_VOTANTE_SP(
    p_votante_id IN NUMBER,
    p_clave IN VARCHAR2,
    p_valido OUT NUMBER
)
IS
BEGIN
    SELECT COUNT(*)
    INTO p_valido
    FROM FIDE_CLAVES_SEGURIDAD_TB
    WHERE Votante_ID = p_votante_id AND Clave = p_clave;
END;
------------------------------------
PROCEDURE FIDE_VOTANTES_DELETE_SP(
    p_Votante_ID IN NUMBER
)
AS
BEGIN
    DELETE FROM FIDE_VOTANTES_TB
    WHERE Votante_ID = p_Votante_ID;
END;
------------------------------------
PROCEDURE FIDE_VOTANTES_INSERT_SP(
    p_Votante_ID IN NUMBER,
    p_Nombre IN VARCHAR2,
    p_Apellido IN VARCHAR2,
    p_Fecha_Nacimiento IN DATE,
    p_Email IN VARCHAR2,
    p_Telefono IN VARCHAR2,
    p_Genero_ID IN NUMBER,
    p_Direccion_ID IN NUMBER,
    p_Estado_ID IN NUMBER,
    p_creado_por IN VARCHAR2,
    p_modificado_por IN VARCHAR2,
    p_Fecha_Creacion IN DATE,
    p_Fecha_Modificacion IN DATE,
    p_accion IN VARCHAR2
)
AS
BEGIN
    INSERT INTO FIDE_VOTANTES_TB (
        Votante_ID, Nombre, Apellido, Fecha_Nacimiento, Email, Telefono, 
        Genero_ID, Direccion_ID, Estado_ID, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion
    )
    VALUES (
        p_Votante_ID, p_Nombre, p_Apellido, p_Fecha_Nacimiento, p_Email, 
        p_Telefono, p_Genero_ID, p_Direccion_ID, p_Estado_ID, p_creado_por, p_modificado_por, SYSDATE, SYSDATE, p_accion
    );
END;
----------------------------------------------------------
PROCEDURE FIDE_VOTANTES_POR_PROVINCIAS_SP
AS
BEGIN
    FOR registro IN (
        SELECT p.Nombre AS Provincia, COUNT(v.Votante_ID) AS Total_Votantes
        FROM FIDE_VOTANTES_TB v
        JOIN FIDE_DIRECCIONES_TB d ON v.Direccion_ID = d.Direccion_ID
        JOIN FIDE_PROVINCIAS_TB p ON d.Provincia_ID = p.Provincia_ID
        GROUP BY p.Nombre
        ORDER BY Total_Votantes DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Provincia: ' || registro.Provincia || 
                             ', Total Votantes: ' || registro.Total_Votantes);
    END LOOP;
END;
---------------------------------------------------------
PROCEDURE FIDE_VOTANTES_UPDATE_SP(
    p_Votante_ID IN NUMBER,
    p_Nombre IN VARCHAR2,
    p_Apellido IN VARCHAR2,
    p_Fecha_Nacimiento IN DATE,
    p_Email IN VARCHAR2,
    p_Telefono IN VARCHAR2,
    p_Genero_ID IN NUMBER,
    p_Direccion_ID IN NUMBER,
    p_Estado_ID IN NUMBER,
    p_creado_por IN VARCHAR2,
    p_modificado_por IN VARCHAR2,
    p_Fecha_Creacion IN DATE,
    p_Fecha_Modificacion IN DATE,
    p_accion IN VARCHAR2
)
AS
BEGIN
    UPDATE FIDE_VOTANTES_TB
    SET Nombre = p_Nombre,
        Apellido = p_Apellido,
        Fecha_Nacimiento = p_Fecha_Nacimiento,
        Email = p_Email,
        Telefono = p_Telefono,
        Genero_ID = p_Genero_ID,
        Direccion_ID = p_Direccion_ID,
        Estado_ID = p_Estado_ID,
        creado_por = p_creado_por,
        modificado_por = p_modificado_por,
        fecha_creacion = SYSDATE,
        fecha_modificacion = SYSDATE,
        accion = p_accion
    WHERE Votante_ID = p_Votante_ID;
END;
------------------------------------
PROCEDURE FIDE_VOTOS_CANDIDATO_TOP_POR_ELECCION_SP
AS
BEGIN
    FOR registro IN (
        SELECT e.Eleccion_ID, e.Nombre AS Eleccion, 
               c.Nombre || ' ' || c.Apellido AS Candidato, 
               COUNT(v.Voto_ID) AS Total_Votos
        FROM FIDE_VOTOS_TB v
        JOIN FIDE_CANDIDATOS_TB c ON v.Candidato_ID = c.Candidato_ID
        JOIN FIDE_ELECCIONES_TB e ON v.Eleccion_ID = e.Eleccion_ID
        GROUP BY e.Eleccion_ID, e.Nombre, c.Candidato_ID, c.Nombre, c.Apellido
        HAVING COUNT(v.Voto_ID) = (
            SELECT MAX(COUNT(Voto_ID))
            FROM FIDE_VOTOS_TB vt
            WHERE vt.Eleccion_ID = e.Eleccion_ID
            GROUP BY vt.Candidato_ID
        )
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Elección: ' || registro.Eleccion || 
                             ', Candidato: ' || registro.Candidato || 
                             ', Total Votos: ' || registro.Total_Votos);
    END LOOP;
END;
---------------------------------------------------
PROCEDURE FIDE_VOTOS_DELETE_SP(
    p_Voto_ID IN NUMBER
)
AS
BEGIN
    DELETE FROM FIDE_VOTOS_TB
    WHERE Voto_ID = p_Voto_ID;
END;
------------------------------------------------------
PROCEDURE FIDE_VOTOS_HISTORIAL_VOTANTE_SP (
    p_votante_id IN NUMBER
)
AS
BEGIN
    FOR registro IN (
        SELECT v.Votante_ID, e.Nombre AS Eleccion, 
               c.Nombre || ' ' || c.Apellido AS Candidato, 
               v.Fecha_Voto, v.Detalle_Voto
        FROM FIDE_VOTOS_TB v
        JOIN FIDE_ELECCIONES_TB e ON v.Eleccion_ID = e.Eleccion_ID
        JOIN FIDE_CANDIDATOS_TB c ON v.Candidato_ID = c.Candidato_ID
        WHERE v.Votante_ID = p_votante_id
        ORDER BY v.Fecha_Voto DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Elección: ' || registro.Eleccion || 
                             ', Candidato: ' || registro.Candidato || 
                             ', Fecha: ' || TO_CHAR(registro.Fecha_Voto, 'YYYY-MM-DD') || 
                             ', Detalle: ' || registro.Detalle_Voto);
    END LOOP;
END;
-------------------------------------------------
PROCEDURE FIDE_VOTOS_INSERT_SP(
    p_Voto_ID IN NUMBER,
    p_Votante_ID IN NUMBER,
    p_Eleccion_ID IN NUMBER,
    p_Candidato_ID IN NUMBER,
    p_Fecha_Voto IN DATE,
    p_Detalle_Voto IN VARCHAR2,
    p_creado_por IN VARCHAR2,
    p_modificado_por IN VARCHAR2,
    p_fecha_creacion IN DATE,
    p_fecha_modificacion IN DATE,
    p_accion IN VARCHAR2
)
AS
BEGIN
    INSERT INTO FIDE_VOTOS_TB (
        Voto_ID, Votante_ID, Eleccion_ID, Candidato_ID, Fecha_Voto,
        Detalle_Voto, creado_por, modificado_por, fecha_creacion,
        fecha_modificacion, accion
    )
    VALUES (
        p_Voto_ID, p_Votante_ID, p_Eleccion_ID, p_Candidato_ID, p_Fecha_Voto,
        p_Detalle_Voto, p_creado_por, p_modificado_por, p_fecha_creacion,
        p_fecha_modificacion, p_accion
    );
END;
----------------------------------------------
PROCEDURE FIDE_VOTOS_PARTICIPACION_POR_GENERO_SP (
    p_eleccion_id IN NUMBER
)
AS
BEGIN
    FOR registro IN (
        SELECT g.Nombre AS Genero, COUNT(v.Voto_ID) AS Total_Votos
        FROM FIDE_VOTOS_TB v
        JOIN FIDE_VOTANTES_TB vt ON v.Votante_ID = vt.Votante_ID
        JOIN FIDE_GENEROS_TB g ON vt.Genero_ID = g.Genero_ID
        WHERE v.Eleccion_ID = p_eleccion_id
        GROUP BY g.Nombre
        ORDER BY Total_Votos DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Género: ' || registro.Genero || 
                             ', Total Votos: ' || registro.Total_Votos);
    END LOOP;
END;
---------------------------------------------
PROCEDURE FIDE_VOTOS_POR_CANTON_SP
AS
BEGIN
    FOR registro IN (
        SELECT c.Nombre AS Canton, COUNT(v.Voto_ID) AS Total_Votos
        FROM FIDE_VOTOS_TB v
        JOIN FIDE_VOTANTES_TB vt ON v.Votante_ID = vt.Votante_ID
        JOIN FIDE_DIRECCIONES_TB d ON vt.Direccion_ID = d.Direccion_ID
        JOIN FIDE_CANTONES_TB c ON d.Canton_ID = c.Canton_ID
        GROUP BY c.Nombre
        ORDER BY Total_Votos DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Cantón: ' || registro.Canton || 
                             ', Total Votos: ' || registro.Total_Votos);
    END LOOP;
END;
---------------------------------------
PROCEDURE FIDE_VOTOS_POR_DISTRITO_SP (
    p_eleccion_id IN NUMBER
)
AS
BEGIN
    FOR registro IN (
        SELECT d.Nombre AS Distrito, COUNT(v.Voto_ID) AS Total_Votos
        FROM FIDE_VOTOS_TB v
        JOIN FIDE_VOTANTES_TB vt ON v.Votante_ID = vt.Votante_ID
        JOIN FIDE_DIRECCIONES_TB dir ON vt.Direccion_ID = dir.Direccion_ID
        JOIN FIDE_DISTRITOS_TB d ON dir.Distrito_ID = d.Distrito_ID
        WHERE v.Eleccion_ID = p_eleccion_id
        GROUP BY d.Nombre
        ORDER BY Total_Votos DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Distrito: ' || registro.Distrito || 
                             ', Total Votos: ' || registro.Total_Votos);
    END LOOP;
END;
-----------------------------------------------
PROCEDURE FIDE_VOTOS_PROMEDIO_POR_CANDIDATO (
    p_eleccion_id IN NUMBER
)
AS
BEGIN
    FOR registro IN (
        SELECT AVG(Total_Votos) AS Promedio_Votos
        FROM (
            SELECT COUNT(v.Voto_ID) AS Total_Votos
            FROM FIDE_VOTOS_TB v
            WHERE v.Eleccion_ID = p_eleccion_id
            GROUP BY v.Candidato_ID
        )
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Promedio de Votos por Candidato: ' || registro.Promedio_Votos);
    END LOOP;
END;
------------------------------------------------
PROCEDURE FIDE_VOTOS_RANKING_PARTIDOS_SP (
    p_eleccion_id IN NUMBER
)
AS
BEGIN
    FOR registro IN (
        SELECT p.Partido_ID, p.Nombre AS Partido, 
               COUNT(v.Voto_ID) AS Total_Votos
        FROM FIDE_VOTOS_TB v
        JOIN FIDE_CANDIDATOS_TB c ON v.Candidato_ID = c.Candidato_ID
        JOIN FIDE_PARTIDOS_TB p ON c.Partido_ID = p.Partido_ID
        WHERE v.Eleccion_ID = p_eleccion_id
        GROUP BY p.Partido_ID, p.Nombre
        ORDER BY Total_Votos DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Partido: ' || registro.Partido || 
                             ', Total Votos: ' || registro.Total_Votos);
    END LOOP;
END;
-------------------------------------
PROCEDURE FIDE_VOTOS_TB_PARTICIPACION_ELECTORAL_SP (
    p_eleccion_id IN NUMBER
)
AS
BEGIN
    FOR registro IN (
        SELECT e.Nombre AS Eleccion, 
               (COUNT(DISTINCT v.Votante_ID) * 100) / (SELECT COUNT(*) FROM FIDE_VOTANTES_TB) AS Porcentaje_Participacion
        FROM FIDE_VOTOS_TB v
        JOIN FIDE_ELECCIONES_TB e ON v.Eleccion_ID = e.Eleccion_ID
        WHERE v.Eleccion_ID = p_eleccion_id
        GROUP BY e.Nombre
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Elección: ' || registro.Eleccion || 
                             ', Participación: ' || registro.Porcentaje_Participacion || '%');
    END LOOP;
END;
-------------------------------------------------
PROCEDURE FIDE_VOTOS_TB_VOTOSxCANDIDATO_SP (
    p_eleccion_id IN NUMBER
)
AS
BEGIN
    FOR registro IN (
        SELECT c.Candidato_ID, c.Nombre || ' ' || c.Apellido AS Nombre_Candidato, 
               COUNT(v.Voto_ID) AS Total_Votos
        FROM FIDE_VOTOS_TB v
        JOIN FIDE_CANDIDATOS_TB c ON v.Candidato_ID = c.Candidato_ID
        WHERE v.Eleccion_ID = p_eleccion_id
        GROUP BY c.Candidato_ID, c.Nombre, c.Apellido
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Candidato: ' || registro.Nombre_Candidato || 
                             ', Total Votos: ' || registro.Total_Votos);
    END LOOP;
END;
------------------------------------------------------
PROCEDURE FIDE_VOTOS_UPDATE_SP(
    p_Voto_ID IN NUMBER,
    p_Votante_ID IN NUMBER,
    p_Eleccion_ID IN NUMBER,
    p_Candidato_ID IN NUMBER,
    p_Fecha_Voto IN DATE,
    p_Detalle_Voto IN VARCHAR2,
    p_creado_por IN VARCHAR2,
    p_modificado_por IN VARCHAR2,
    p_fecha_creacion IN DATE,
    p_fecha_modificacion IN DATE,
    p_accion IN VARCHAR2
)
AS
BEGIN
    UPDATE FIDE_VOTOS_TB
    SET Votante_ID = p_Votante_ID,
        Eleccion_ID = p_Eleccion_ID,
        Candidato_ID = p_Candidato_ID,
        Fecha_Voto = p_Fecha_Voto,
        Detalle_Voto = p_Detalle_Voto,
        creado_por = p_creado_por,
        modificado_por = p_modificado_por,
        fecha_creacion = p_fecha_creacion,
        fecha_modificacion = p_fecha_modificacion,
        accion = p_accion
    WHERE Voto_ID = p_Voto_ID;
END;

END Fide_Proyecto_Final_PKG;