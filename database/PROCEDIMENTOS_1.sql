
CREATE OR REPLACE PROCEDURE FIDE_VOTOS_TB_VOTOSxCANDIDATO_SP (
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
SET SERVEROUTPUT ON;
BEGIN
FIDE_VOTOS_TB_VOTOSxCANDIDATO_SP(1);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_VOTOS_TB_PARTICIPACION_ELECTORAL_SP (
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
SET SERVEROUTPUT ON;
BEGIN
FIDE_VOTOS_TB_PARTICIPACION_ELECTORAL_SP(1);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_ELECCIONES_TB_ESTADO_ELECCIONES_SP
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
--LLAMAR AL PROCEDIMIENTO
SET SERVEROUTPUT ON;
BEGIN
FIDE_ELECCIONES_TB_ESTADO_ELECCIONES_SP();
END;
/
-----
CREATE OR REPLACE PROCEDURE FIDE_VOTOS_RANKING_PARTIDOS_SP (
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
--LLAMAR
SET SERVEROUTPUT ON;
BEGIN
FIDE_VOTOS_RANKING_PARTIDOS_SP(1);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_VOTOS_HISTORIAL_VOTANTE_SP (
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
SET SERVEROUTPUT ON;
BEGIN
FIDE_VOTOS_HISTORIAL_VOTANTE_SP(1);
END;
/
----
CREATE OR REPLACE PROCEDURE FIDE_AUDITORIAS_POR_ELECCION_SP
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
SET SERVEROUTPUT ON;
BEGIN
FIDE_AUDITORIAS_POR_ELECCION_SP();
END;
/
CREATE OR REPLACE PROCEDURE FIDE_CANDIDATOS_SIN_VOTOS_SP (
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
SET SERVEROUTPUT ON;
BEGIN
FIDE_CANDIDATOS_SIN_VOTOS_SP(1);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_VOTOS_PARTICIPACION_POR_GENERO_SP (
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
SET SERVEROUTPUT ON;
BEGIN
FIDE_VOTOS_PARTICIPACION_POR_GENERO_SP(1);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_VOTOS_POR_DISTRITO_SP (
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
SET SERVEROUTPUT ON;
BEGIN
FIDE_VOTOS_POR_DISTRITO_SP(1);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_AUDITORIAS_POR_AUDITOR_SP
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
SET SERVEROUTPUT ON;
BEGIN
FIDE_AUDITORIAS_POR_AUDITOR_SP();
END;
/
CREATE OR REPLACE PROCEDURE FIDE_AUDITORES_SIN_AUDITORIAS_SP
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
SET SERVEROUTPUT ON;
BEGIN
FIDE_AUDITORES_SIN_AUDITORIAS_SP();
END;
/
CREATE OR REPLACE PROCEDURE FIDE_VOTOS_PROMEDIO_POR_CANDIDATO (
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
SET SERVEROUTPUT ON;
BEGIN
FIDE_VOTOS_PROMEDIO_POR_CANDIDATO(1);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_VOTOS_CANDIDATO_TOP_POR_ELECCION_SP
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
SET SERVEROUTPUT ON;
BEGIN
FIDE_VOTOS_CANDIDATO_TOP_POR_ELECCION_SP();
END;
/
CREATE OR REPLACE PROCEDURE FIDE_VOTANTES_POR_PROVINCIAS_SP
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
SET SERVEROUTPUT ON;
BEGIN
FIDE_VOTANTES_POR_PROVINCIAS_SP();
END;
/
CREATE OR REPLACE PROCEDURE FIDE_VOTOS_POR_CANTON_SP
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
SET SERVEROUTPUT ON;
BEGIN
FIDE_VOTOS_POR_CANTON_SP();
END;
/


