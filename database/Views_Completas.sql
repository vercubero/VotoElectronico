CREATE OR REPLACE VIEW VOTANTES_DIRECCIONES_V AS
SELECT V.Votante_ID, V.Nombre, V.Apellido, P.Nombre AS Provincia, 
C.Nombre AS Canton, D.Nombre AS Distrito
FROM FIDE_VOTANTES_TB V
JOIN FIDE_DIRECCIONES_TB DIR ON V.Votante_ID = DIR.Direccion_ID
JOIN FIDE_PROVINCIAS_TB P ON DIR.Provincia_ID = P.Provincia_ID
JOIN FIDE_CANTONES_TB C ON DIR.Canton_ID = C.Canton_ID
JOIN FIDE_DISTRITOS_TB D ON DIR.Distrito_ID = D.Distrito_ID;
/

CREATE OR REPLACE VIEW CANTIDAD_VOTANTES_PROVINCIA_V AS
SELECT P.Nombre AS Provincia, COUNT(V.Votante_ID) AS Total_Votantes
FROM FIDE_VOTANTES_TB V
JOIN FIDE_DIRECCIONES_TB DIR ON V.Votante_ID = DIR.Direccion_ID
JOIN FIDE_PROVINCIAS_TB P ON DIR.Provincia_ID = P.Provincia_ID
GROUP BY P.Nombre;
/

CREATE OR REPLACE VIEW HISTORIAL_VOTANTES_V AS
SELECT V.Votante_ID, V.Nombre, V.Apellido, V.creado_por, V.fecha_creacion, 
V.modificado_por, V.fecha_modificacion
FROM FIDE_VOTANTES_TB V;
/

CREATE OR REPLACE VIEW ESTADOS_V AS
SELECT Estado_ID, Descripcion, creado_por, fecha_creacion, modificado_por, 
fecha_modificacion
FROM FIDE_ESTADOS_TB;
/

CREATE OR REPLACE VIEW VOTANTES_EDAD_V AS
SELECT V.Votante_ID, V.Nombre, V.Apellido, TRUNC(MONTHS_BETWEEN(SYSDATE, 
V.Fecha_Nacimiento) / 12) AS Edad
FROM FIDE_VOTANTES_TB V;
/

CREATE OR REPLACE VIEW CANTIDAD_VOTANTES_GENERO_V AS
SELECT G.Nombre AS Genero, COUNT(V.Votante_ID) AS Total_Votantes
FROM FIDE_VOTANTES_TB V
JOIN FIDE_GENEROS_TB G ON V.Votante_ID = G.Genero_ID
GROUP BY G.Nombre;
/

CREATE OR REPLACE VIEW HISTORIAL_DIRECCIONES_V AS
SELECT D.Direccion_ID, D.Provincia_ID, D.Canton_ID, D.Distrito_ID, 
D.creado_por, D.fecha_creacion, D.modificado_por, D.fecha_modificacion
FROM FIDE_DIRECCIONES_TB D;
/

CREATE OR REPLACE VIEW DISTRITOS_CANTONES_PROVINCIAS_V AS
SELECT D.Nombre AS Distrito, C.Nombre AS Canton, P.Nombre AS Provincia
FROM FIDE_DISTRITOS_TB D
LEFT JOIN FIDE_CANTONES_TB C ON D.Nombre = C.Nombre
LEFT JOIN FIDE_PROVINCIAS_TB P ON C.Nombre = P.Nombre;
/

CREATE OR REPLACE VIEW PROVINCIAS_CANTONES_DISTRITOS_V AS
SELECT P.Nombre AS Provincia, COUNT(C.Nombre) AS Total_Cantones, COUNT(D.Nombre) AS Total_Distritos
FROM FIDE_PROVINCIAS_TB P
LEFT JOIN FIDE_CANTONES_TB C ON P.Nombre = C.Nombre
LEFT JOIN FIDE_DISTRITOS_TB D ON C.Nombre = D.Nombre
GROUP BY P.Nombre;
/

CREATE OR REPLACE VIEW CANTONES_DISTRITOS_V AS
SELECT C.Nombre AS Canton, COUNT(D.Nombre) AS Total_Distritos
FROM FIDE_CANTONES_TB C
LEFT JOIN FIDE_DISTRITOS_TB D ON C.Nombre = D.Nombre
GROUP BY C.Nombre;
/