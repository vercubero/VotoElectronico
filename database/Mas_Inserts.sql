-- Partido 6: Frente Amplio (FA)
INSERT INTO FIDE_PARTIDOS_TB (Partido_ID, Nombre, Siglas_Partido, Fecha_Fundacion, Estado_ID, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion)
VALUES (6, 'Frente Amplio', 'FA', TO_DATE('2004-07-12', 'YYYY-MM-DD'), 1, NULL, NULL, NULL, NULL, NULL);

-- Partido 7: Movimiento Libertario (ML)
INSERT INTO FIDE_PARTIDOS_TB (Partido_ID, Nombre, Siglas_Partido, Fecha_Fundacion, Estado_ID, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion)
VALUES (7, 'Movimiento Libertario', 'ML', TO_DATE('1994-05-13', 'YYYY-MM-DD'), 1, NULL, NULL, NULL, NULL, NULL);

-- Partido 8: Integración Nacional (PIN)
INSERT INTO FIDE_PARTIDOS_TB (Partido_ID, Nombre, Siglas_Partido, Fecha_Fundacion, Estado_ID, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion)
VALUES (8, 'Partido Integración Nacional', 'PIN', TO_DATE('1996-08-15', 'YYYY-MM-DD'), 1, NULL, NULL, NULL, NULL, NULL);
/


-- Inserción de elecciones
INSERT INTO FIDE_ELECCIONES_TB (Eleccion_ID, Nombre, Fecha_Inicio, Fecha_Fin, Descripcion, Estado_ID, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion) 
VALUES 
(3, 'Elecciones Presidenciales Costa Rica 2014', TO_DATE('2014-02-02', 'YYYY-MM-DD'), TO_DATE('2014-04-06', 'YYYY-MM-DD'), 'Elecciones presidenciales y legislativas en Costa Rica', 1, 'admin', NULL, SYSDATE, NULL, 'INSERT');

INSERT INTO FIDE_ELECCIONES_TB (Eleccion_ID, Nombre, Fecha_Inicio, Fecha_Fin, Descripcion, Estado_ID, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion) 
VALUES 
(2, 'Elecciones Presidenciales Costa Rica 2018', TO_DATE('2018-02-04', 'YYYY-MM-DD'), TO_DATE('2018-04-01', 'YYYY-MM-DD'), 'Elecciones presidenciales y legislativas en Costa Rica', 1, 'admin', NULL, SYSDATE, NULL, 'INSERT');
/


INSERT ALL  
INTO FIDE_CANDIDATOS_TB (Candidato_ID, Nombre, Apellido, Partido_ID, 
Eleccion_ID, Estado_ID, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion) 
VALUES (6, 'Carlos', 'Alvarado', 3, 2, 1, NULL, NULL, NULL, NULL, NULL)  -- PAC

INTO FIDE_CANDIDATOS_TB (Candidato_ID, Nombre, Apellido, Partido_ID, 
Eleccion_ID, Estado_ID, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion) 
VALUES (7, 'Fabricio', 'Alvarado', 4, 2, 1, NULL, NULL, NULL, NULL, NULL)  -- PRN

INTO FIDE_CANDIDATOS_TB (Candidato_ID, Nombre, Apellido, Partido_ID, 
Eleccion_ID, Estado_ID, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion) 
VALUES (8, 'Antonio', 'Álvarez', 1, 2, 1, NULL, NULL, NULL, NULL, NULL)  -- PLN

INTO FIDE_CANDIDATOS_TB (Candidato_ID, Nombre, Apellido, Partido_ID, 
Eleccion_ID, Estado_ID, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion) 
VALUES (9, 'Juan Diego', 'Castro', 8, 2, 1, NULL, NULL, NULL, NULL, NULL)  -- PIN

INTO FIDE_CANDIDATOS_TB (Candidato_ID, Nombre, Apellido, Partido_ID, 
Eleccion_ID, Estado_ID, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion) 
VALUES (10, 'Rodolfo', 'Piza', 2, 2, 1, NULL, NULL, NULL, NULL, NULL)  -- PUSC

INTO FIDE_CANDIDATOS_TB (Candidato_ID, Nombre, Apellido, Partido_ID, 
Eleccion_ID, Estado_ID, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion) 
VALUES (11, 'José María', 'Villalta', 6, 3, 1, NULL, NULL, NULL, NULL, NULL)  -- FA

INTO FIDE_CANDIDATOS_TB (Candidato_ID, Nombre, Apellido, Partido_ID, 
Eleccion_ID, Estado_ID, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion) 
VALUES (12, 'Otto', 'Guevara', 7, 3, 1, NULL, NULL, NULL, NULL, NULL)  -- ML

SELECT 1 FROM DUAL;

commit;