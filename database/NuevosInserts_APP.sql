------------------------FIDE_ESTADOS_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_ESTADOS_TB (Descripcion) VALUES ('Activo');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_ESTADOS_TB (Descripcion) VALUES ('Inactivo');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_ESTADOS_TB (Descripcion) VALUES ('Suspendido');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_ESTADOS_TB (Descripcion) VALUES ('Eliminado');
COMMIT;
------------------------FIDE_GENEROS_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_GENEROS_TB (Nombre) VALUES ('Masculino');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_GENEROS_TB (Nombre) VALUES ('Femenino');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_GENEROS_TB (Nombre) VALUES ('Otro');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_GENEROS_TB (Nombre) VALUES ('No especificado');

------------------------FIDE_ROLES_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_ROLES_TB (Nombre_Rol) VALUES ('Administrador');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_ROLES_TB (Nombre_Rol) VALUES ('Auditor');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_ROLES_TB (Nombre_Rol) VALUES ('Votante');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_ROLES_TB (Nombre_Rol) VALUES ('Usuario');
------------------------FIDE_PROVINCIAS_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_PROVINCIAS_TB (Nombre) VALUES ('San Jose');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_PROVINCIAS_TB (Nombre) VALUES ('Alajuela');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_PROVINCIAS_TB (Nombre) VALUES ('Cartago');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_PROVINCIAS_TB (Nombre) VALUES ('Heredia');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_PROVINCIAS_TB (Nombre) VALUES ('Guanacaste');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_PROVINCIAS_TB (Nombre) VALUES ('Puntarenas');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_PROVINCIAS_TB (Nombre) VALUES ('Limon');
------------------------FIDE_CANTONES_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_CANTONES_TB (Nombre) VALUES ('SanJose');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_CANTONES_TB (Nombre) VALUES ('Alajuela');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_CANTONES_TB (Nombre) VALUES ('Cartago');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_CANTONES_TB (Nombre) VALUES ('Heredia'); 
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_CANTONES_TB (Nombre) VALUES ('Liberia');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_CANTONES_TB (Nombre) VALUES ('Puntarenas');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_CANTONES_TB (Nombre) VALUES ('Limon');

------------------------FIDE_DISTRITOS_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_DISTRITOS_TB (Nombre) VALUES ('Carmen');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_DISTRITOS_TB (Nombre) VALUES ('AlajuelaCentro');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_DISTRITOS_TB (Nombre) VALUES ('Oriental');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_DISTRITOS_TB (Nombre) VALUES ('HerediaCentro');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_DISTRITOS_TB (Nombre) VALUES ('LiberiaCentro');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_DISTRITOS_TB (Nombre) VALUES ('Barranca');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_DISTRITOS_TB (Nombre) VALUES ('LimonCentro'); 

------------------------FIDE_DIRECCIONES_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_DIRECCIONES_TB (Provincia_ID, Canton_ID, Distrito_ID) VALUES (1, 1, 1);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_DIRECCIONES_TB (Provincia_ID, Canton_ID, Distrito_ID) VALUES (2, 2, 2); 
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_DIRECCIONES_TB (Provincia_ID, Canton_ID, Distrito_ID) VALUES (3, 3, 3);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_DIRECCIONES_TB (Provincia_ID, Canton_ID, Distrito_ID) VALUES (4, 4, 4); 

------------------------FIDE_SEDES_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_SEDES_TB (Nombre, Direccion_ID) VALUES ('SedeSan Jose', 1);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_SEDES_TB (Nombre, Direccion_ID) VALUES ('SedeAlajuela', 2);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_SEDES_TB (Nombre, Direccion_ID) VALUES ('SedeCartago', 3);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_SEDES_TB (Nombre, Direccion_ID) VALUES ('SedeHeredia', 4);

------------------------FIDE_USUARIOS_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_USUARIOS_TB (User_name, Password, Email, Rol_ID, Estado_ID) VALUES ('admin', '123', 'admin@ufide.com', 1, 1);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_USUARIOS_TB (User_name, Password, Email, Rol_ID, Estado_ID) VALUES ('auditor1', '123', 'auditor1@ufide.com', 2, 1);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_USUARIOS_TB (User_name, Password, Email, Rol_ID, Estado_ID) VALUES ('visitante1', '123', 'visitante1@ufide.com', 3, 2);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_USUARIOS_TB (User_name, Password, Email, Rol_ID, Estado_ID) VALUES ('usuario1', '123', 'usuario1@ufide.com', 4, 1);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_USUARIOS_TB (User_name, Password, Email, Rol_ID, Estado_ID) VALUES ('yreyes', '123', 'yreyes@ufide.com', 1, 1);

------------------------FIDE_VOTANTES_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_VOTANTES_TB (Nombre, Apellido, Fecha_Nacimiento, Email, Telefono, Genero_ID, Direccion_ID, Estado_ID) VALUES ('Juan', 'Perez', TO_DATE('1990-01-01', 'YYYY-MM-DD'), 'juan@fide.com', '88888888', 1, 1, 1);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_VOTANTES_TB (Nombre, Apellido, Fecha_Nacimiento, Email, Telefono, Genero_ID, Direccion_ID, Estado_ID) VALUES ('Maria', 'Lopez', TO_DATE('1985-05-15', 'YYYY-MM-DD'), 'maria@fide.com', '89999999', 2, 2, 1);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_VOTANTES_TB (Nombre, Apellido, Fecha_Nacimiento, Email, Telefono, Genero_ID, Direccion_ID, Estado_ID) VALUES ('Carlos', 'Gomez', TO_DATE('1978-11-23', 'YYYY-MM-DD'), 'carlos@fide.com', '87777777', 1, 3, 1);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_VOTANTES_TB (Nombre, Apellido, Fecha_Nacimiento, Email, Telefono, Genero_ID, Direccion_ID, Estado_ID) VALUES ('Ana', 'Ramirez', TO_DATE('1995-02-14', 'YYYY-MM-DD'), 'ana@fide.com', '86666666', 2, 4, 1);

------------------------FIDE_ELECCIONES_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_ELECCIONES_TB (Nombre, Fecha_Inicio, Fecha_Fin, Descripcion, Estado_ID) VALUES ('Elecciones Presidenciales 2022', TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-01-15', 'YYYY-MM-DD'), 'Eleccion para presidente de la republica', 2);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_ELECCIONES_TB (Nombre, Fecha_Inicio, Fecha_Fin, Descripcion, Estado_ID) VALUES ('Elecciones Presidenciales 2018', TO_DATE('2018-02-01', 'YYYY-MM-DD'), TO_DATE('2018-02-15', 'YYYY-MM-DD'), 'Eleccion para presidente de la republica', 2);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_ELECCIONES_TB (Nombre, Fecha_Inicio, Fecha_Fin, Descripcion, Estado_ID) VALUES ('Elecciones Presidenciales 2014', TO_DATE('2014-03-01', 'YYYY-MM-DD'), TO_DATE('2014-03-15', 'YYYY-MM-DD'), 'Eleccion para presidente de la republica', 2);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_ELECCIONES_TB (Nombre, Fecha_Inicio, Fecha_Fin, Descripcion, Estado_ID) VALUES ('Elecciones Presidenciales 2010', TO_DATE('2010-04-01', 'YYYY-MM-DD'), TO_DATE('2010-04-15', 'YYYY-MM-DD'), 'Eleccion para presidente de la republica', 2);

------------------------FIDE_PARTIDOS_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_PARTIDOS_TB (Nombre, Siglas_Partido, Fecha_Fundacion, Estado_ID) VALUES ('Partido Innovador', 'PIN', TO_DATE('1990-06-15', 'YYYY-MM-DD'), 1);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_PARTIDOS_TB (Nombre, Siglas_Partido, Fecha_Fundacion, Estado_ID) VALUES ('Partido Democrata', 'PDEM', TO_DATE('1985-07-20', 'YYYY-MM-DD'), 1);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_PARTIDOS_TB (Nombre, Siglas_Partido, Fecha_Fundacion, Estado_ID) VALUES ('Partido Progresista', 'PPR', TO_DATE('2000-05-10', 'YYYY-MM-DD'), 1);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_PARTIDOS_TB (Nombre, Siglas_Partido, Fecha_Fundacion, Estado_ID) VALUES ('Partido Conservador', 'PCON', TO_DATE('1978-08-30', 'YYYY-MM-DD'), 2);

------------------------FIDE_CANDIDATOS_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_CANDIDATOS_TB (Nombre, Apellido, Partido_ID, Eleccion_ID, Estado_ID) VALUES ('Carlos', 'Martinez', 1, 1, 3);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_CANDIDATOS_TB (Nombre, Apellido, Partido_ID, Eleccion_ID, Estado_ID) VALUES ('Ana', 'Sanchez', 2, 1, 1);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_CANDIDATOS_TB (Nombre, Apellido, Partido_ID, Eleccion_ID, Estado_ID) VALUES ('Luis', 'Rodriguez', 3, 2, 1);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_CANDIDATOS_TB (Nombre, Apellido, Partido_ID, Eleccion_ID, Estado_ID) VALUES ('Maria', 'Gomez', 4, 2, 2);

------------------------FIDE_MESAS_VOTO_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_MESAS_VOTO_TB (Eleccion_ID, Votante_ID, Estado_ID) VALUES (1, 1, 1);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_MESAS_VOTO_TB (Eleccion_ID, Votante_ID, Estado_ID) VALUES (1, 2, 1);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_MESAS_VOTO_TB (Eleccion_ID, Votante_ID, Estado_ID) VALUES (2, 3, 1);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_MESAS_VOTO_TB (Eleccion_ID, Votante_ID, Estado_ID) VALUES (2, 4, 1);

------------------------FIDE_VOTOS_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_VOTOS_TB (Votante_ID, Eleccion_ID, Candidato_ID, Fecha_Voto, Detalle_Voto) VALUES (1, 1, 1, TO_DATE('2022-01-05', 'YYYY-MM-DD'), 'Voto emitido correctamente');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_VOTOS_TB (Votante_ID, Eleccion_ID, Candidato_ID, Fecha_Voto, Detalle_Voto) VALUES (2, 1, 2, TO_DATE('2022-01-06', 'YYYY-MM-DD'), 'Voto emitido correctamente');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_VOTOS_TB (Votante_ID, Eleccion_ID, Candidato_ID, Fecha_Voto, Detalle_Voto) VALUES (3, 2, 3, TO_DATE('2022-01-05', 'YYYY-MM-DD'), 'Voto emitido correctamente');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_VOTOS_TB (Votante_ID, Eleccion_ID, Candidato_ID, Fecha_Voto, Detalle_Voto) VALUES (4, 2, 4, TO_DATE('2022-01-06', 'YYYY-MM-DD'), 'Voto emitido correctamente');

------------------------FIDE_RESULTADOS_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_RESULTADOS_TB (Eleccion_ID, Candidato_ID, Estado_ID, Votos_Obtenidos) VALUES (1, 1, 1, 1500);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_RESULTADOS_TB (Eleccion_ID, Candidato_ID, Estado_ID, Votos_Obtenidos) VALUES (1, 2, 1, 1200);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_RESULTADOS_TB (Eleccion_ID, Candidato_ID, Estado_ID, Votos_Obtenidos) VALUES (2, 3, 1, 800);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_RESULTADOS_TB (Eleccion_ID, Candidato_ID, Estado_ID, Votos_Obtenidos) VALUES (2, 4, 2, 400);

------------------------FIDE_SESIONES_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_SESIONES_TB (Usuario_ID, FechaInicio, FechaFin) VALUES (1, TO_DATE('2025-01-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-01-01 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_SESIONES_TB (Usuario_ID, FechaInicio, FechaFin) VALUES (2, TO_DATE('2025-01-02 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-01-02 17:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_SESIONES_TB (Usuario_ID, FechaInicio, FechaFin) VALUES (3, TO_DATE('2025-01-03 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-01-03 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_SESIONES_TB (Usuario_ID, FechaInicio, FechaFin) VALUES (4, TO_DATE('2025-01-04 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-01-04 19:00:00', 'YYYY-MM-DD HH24:MI:SS'));
------------------------FIDE_AUDITORES_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_AUDITORES_TB (Nombre, Apellido, Email, Telefono) VALUES ('Laura', 'Hernandez', 'laura.hernandez@fide.com', '88112233');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_AUDITORES_TB (Nombre, Apellido, Email, Telefono) VALUES ('Pedro', 'Castro', 'pedro.castro@fide.com', '88223344');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_AUDITORES_TB (Nombre, Apellido, Email, Telefono) VALUES ('Claudia', 'Jimenez', 'claudia.jimenez@fide.com', '88334455');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_AUDITORES_TB (Nombre, Apellido, Email, Telefono) VALUES ('Jorge', 'Mora', 'jorge.mora@fide.com', '88445566');

------------------------FIDE_AUDITORIAS_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_AUDITORIAS_TB (Eleccion_ID, Auditor_ID, Fecha_Auditoria, Resultado) VALUES (1, 1, TO_DATE('2025-01-10', 'YYYY-MM-DD'), 'Auditoria completada sin inconvenientes');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_AUDITORIAS_TB (Eleccion_ID, Auditor_ID, Fecha_Auditoria, Resultado) VALUES (2, 2, TO_DATE('2025-02-10', 'YYYY-MM-DD'), 'Auditoria completada con observaciones');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_AUDITORIAS_TB (Eleccion_ID, Auditor_ID, Fecha_Auditoria, Resultado) VALUES (3, 3, TO_DATE('2025-03-10', 'YYYY-MM-DD'), 'Auditoria completada sin inconvenientes');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_AUDITORIAS_TB (Eleccion_ID, Auditor_ID, Fecha_Auditoria, Resultado) VALUES (4, 4, TO_DATE('2025-04-10', 'YYYY-MM-DD'), 'Auditoria pendiente de analisis');

------------------------FIDE_CREDENCIALES_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_CREDENCIALES_TB (Votante_ID, Eleccion_ID, Codigo, FechaEmision) VALUES (1, 1, 'ABC123', TO_DATE('2025-01-01', 'YYYY-MM-DD'));
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_CREDENCIALES_TB (Votante_ID, Eleccion_ID, Codigo, FechaEmision) VALUES (2, 1, 'DEF456', TO_DATE('2025-01-02', 'YYYY-MM-DD'));
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_CREDENCIALES_TB (Votante_ID, Eleccion_ID, Codigo, FechaEmision) VALUES (3, 2, 'GHI789', TO_DATE('2025-02-01', 'YYYY-MM-DD'));
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_CREDENCIALES_TB (Votante_ID, Eleccion_ID, Codigo, FechaEmision) VALUES (4, 2, 'JKL012', TO_DATE('2025-02-02', 'YYYY-MM-DD'));

------------------------FIDE_REPORTES_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_REPORTES_TB (Eleccion_ID, Votante_ID, FechaReporte, Descripcion) VALUES (1, 1, TO_DATE('2025-01-07', 'YYYY-MM-DD'), 'Reporte de irregularidades en mesa');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_REPORTES_TB (Eleccion_ID, Votante_ID, FechaReporte, Descripcion) VALUES (1, 2, TO_DATE('2025-01-08', 'YYYY-MM-DD'), 'Problemas con credencial de acceso');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_REPORTES_TB (Eleccion_ID, Votante_ID, FechaReporte, Descripcion) VALUES (2, 3, TO_DATE('2025-02-07', 'YYYY-MM-DD'), 'Reporte de ausencia de materiales');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_REPORTES_TB (Eleccion_ID, Votante_ID, FechaReporte, Descripcion) VALUES (2, 4, TO_DATE('2025-02-08', 'YYYY-MM-DD'), 'Inconsistencia en el padrón electoral');

------------------------FIDE_BOLETAS_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_BOLETAS_TB (Eleccion_ID, Votante_ID, Candidato_ID, FechaBoleta) VALUES (1, 1, 1, TO_DATE('2022-01-05', 'YYYY-MM-DD'));
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_BOLETAS_TB (Eleccion_ID, Votante_ID, Candidato_ID, FechaBoleta) VALUES (1, 2, 2, TO_DATE('2022-01-06', 'YYYY-MM-DD'));
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_BOLETAS_TB (Eleccion_ID, Votante_ID, Candidato_ID, FechaBoleta) VALUES (2, 3, 3, TO_DATE('2022-01-05', 'YYYY-MM-DD'));
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_BOLETAS_TB (Eleccion_ID, Votante_ID, Candidato_ID, FechaBoleta) VALUES (2, 4, 4, TO_DATE('2022-01-06', 'YYYY-MM-DD'));

------------------------FIDE_CLAVES_SEGURIDAD_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_CLAVES_SEGURIDAD_TB (Votante_ID, Clave, FechaCreacion) VALUES (1, 'Segura123', TO_DATE('2025-01-01', 'YYYY-MM-DD'));
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_CLAVES_SEGURIDAD_TB (Votante_ID, Clave, FechaCreacion) VALUES (2, 'Protegida456', TO_DATE('2025-01-02', 'YYYY-MM-DD'));
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_CLAVES_SEGURIDAD_TB (Votante_ID, Clave, FechaCreacion) VALUES (3, 'Confiable789', TO_DATE('2025-02-01', 'YYYY-MM-DD'));
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_CLAVES_SEGURIDAD_TB (Votante_ID, Clave, FechaCreacion) VALUES (4, 'Fuerte012', TO_DATE('2025-02-02', 'YYYY-MM-DD'));

------------------------FIDE_LOGSEGURIDAD_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_LOGSEGURIDAD_TB (Votante_ID, Fecha, Accion_log) VALUES (1, TO_DATE('2025-01-05', 'YYYY-MM-DD'), 'Intento de acceso exitoso');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_LOGSEGURIDAD_TB (Votante_ID, Fecha, Accion_log) VALUES (2, TO_DATE('2025-01-06', 'YYYY-MM-DD'), 'Intento de acceso fallido');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_LOGSEGURIDAD_TB (Votante_ID, Fecha, Accion_log) VALUES (3, TO_DATE('2025-02-05', 'YYYY-MM-DD'), 'Clave cambiada');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_LOGSEGURIDAD_TB (Votante_ID, Fecha, Accion_log) VALUES (4, TO_DATE('2025-02-06', 'YYYY-MM-DD'), 'Solicitud de recuperacion de clave');

------------------------FIDE_NOTIFICACIONES_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_NOTIFICACIONES_TB (Votante_ID, Mensaje, FechaNotificacion) VALUES (1, 'Su registro fue exitoso.', TO_DATE('2025-01-01', 'YYYY-MM-DD'));
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_NOTIFICACIONES_TB (Votante_ID, Mensaje, FechaNotificacion) VALUES (2, 'Su voto ha sido confirmado.', TO_DATE('2025-01-06', 'YYYY-MM-DD'));
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_NOTIFICACIONES_TB (Votante_ID, Mensaje, FechaNotificacion) VALUES (3, 'Su credencial esta lista.', TO_DATE('2025-02-01', 'YYYY-MM-DD'));
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_NOTIFICACIONES_TB (Votante_ID, Mensaje, FechaNotificacion) VALUES (4, 'Puede emitir su voto.', TO_DATE('2025-02-06', 'YYYY-MM-DD'));
/*
------------------------FIDE_HISTORIALVOTOS_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_HISTORIALVOTOS_TB (Votante_ID, FechaModificacion, Accion_historial) VALUES (1, TO_DATE('2025-01-07', 'YYYY-MM-DD'), 'Voto confirmado');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_HISTORIALVOTOS_TB (Votante_ID, FechaModificacion, Accion_historial) VALUES (2, TO_DATE('2025-01-08', 'YYYY-MM-DD'), 'Voto anulado');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_HISTORIALVOTOS_TB (Votante_ID, FechaModificacion, Accion_historial) VALUES (3, TO_DATE('2025-02-07', 'YYYY-MM-DD'), 'Boleta reemitida');
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_HISTORIALVOTOS_TB (Votante_ID, FechaModificacion, Accion_historial) VALUES (4, TO_DATE('2025-02-08', 'YYYY-MM-DD'), 'Credencial actualizada');

------------------------FIDE_VOTOS_HISTORIAL_TB-----------------------------------------
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_VOTOS_HISTORIAL_TB (Voto_ID, Historial_ID) VALUES (1, 1);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_VOTOS_HISTORIAL_TB (Voto_ID, Historial_ID) VALUES (2, 2);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_VOTOS_HISTORIAL_TB (Voto_ID, Historial_ID) VALUES (3, 3);
INSERT INTO FIDE_VOTO_ELECTRONICO.FIDE_VOTOS_HISTORIAL_TB (Voto_ID, Historial_ID) VALUES (4, 4);
*/
COMMIT;
