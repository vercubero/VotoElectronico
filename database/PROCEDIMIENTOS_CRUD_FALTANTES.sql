create or replace PROCEDURE FIDE_AUDITORIAS_INSERTAR_SP(
    p_Eleccion_ID NUMBER,
    p_Auditor_ID NUMBER,
    p_Fecha_Auditoria DATE,
    p_Resultado VARCHAR2
) IS
BEGIN
    INSERT INTO FIDE_AUDITORIAS_TB (Eleccion_ID, Auditor_ID, Fecha_Auditoria, Resultado) 
    VALUES (p_Eleccion_ID, p_Auditor_ID, p_Fecha_Auditoria, p_Resultado);
    COMMIT;
END FIDE_AUDITORIAS_INSERTAR_SP;
/
create or replace PROCEDURE FIDE_AUDITORIAS_ACTUALIZAR_SP(
    p_Auditoria_ID NUMBER,
    p_Eleccion_ID NUMBER,
    p_Auditor_ID NUMBER,
    p_Fecha_Auditoria DATE,
    p_Resultado VARCHAR2
) IS
BEGIN
    UPDATE FIDE_AUDITORIAS_TB
    SET 
        Eleccion_ID = p_Eleccion_ID,
        Auditor_ID = p_Auditor_ID,
        Fecha_Auditoria = p_Fecha_Auditoria,
        Resultado = p_Resultado
    WHERE Auditoria_ID = p_Auditoria_ID;
    COMMIT;
END FIDE_AUDITORIAS_ACTUALIZAR_SP;
/
create or replace PROCEDURE FIDE_AUDITORIAS_ELIMINAR_SP(p_Auditoria_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_AUDITORIAS_TB WHERE Auditoria_ID = p_Auditoria_ID;
    COMMIT;
END FIDE_AUDITORIAS_ELIMINAR_SP;
/
------------------------------BOLETAS-----------------------------------------------------
create or replace PROCEDURE FIDE_BOLETAS_INSERTAR_SP(
    p_Eleccion_ID NUMBER,
    p_Votante_ID NUMBER,
    p_Candidato_ID NUMBER,
    p_FechaBoleta DATE
) IS
BEGIN
    INSERT INTO FIDE_BOLETAS_TB (Eleccion_ID, Votante_ID, Candidato_ID, FECHABOLETA) 
    VALUES (p_Eleccion_ID, p_Votante_ID, p_Candidato_ID, p_FechaBoleta);
    COMMIT;
END FIDE_BOLETAS_INSERTAR_SP;
/
create or replace PROCEDURE FIDE_BOLETAS_ACTUALIZAR_SP(
    p_Boleta_ID NUMBER,
    p_Eleccion_ID NUMBER,
    p_Votante_ID NUMBER,
    p_Candidato_ID NUMBER,
    p_FechaBoleta DATE
) IS
BEGIN
    UPDATE FIDE_BOLETAS_TB
    SET 
        Eleccion_ID = p_Eleccion_ID,
        Votante_ID = p_Votante_ID,
        Candidato_ID = p_Candidato_ID,
        FechaBoleta = p_FechaBoleta
    WHERE Boleta_ID = p_Boleta_ID;
    COMMIT;
END FIDE_BOLETAS_ACTUALIZAR_SP;
/
create or replace PROCEDURE FIDE_BOLETAS_ELIMINAR_SP(p_Boleta_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_Boletas_TB WHERE Boleta_ID = p_Boleta_ID;
    COMMIT;
END FIDE_BOLETAS_ELIMINAR_SP;
/
------------------------------Claves_seguridad-----------------------------------------------------
create or replace PROCEDURE FIDE_CLAVES_SEGURIDAD_INSERTAR_SP(
    p_Votante_ID NUMBER,
    p_Clave NUMBER

) IS
BEGIN
    INSERT INTO FIDE_CLAVES_SEGURIDAD_TB (Votante_ID, CLAVE) 
    VALUES (p_Votante_ID, p_Clave);
    COMMIT;
END FIDE_CLAVES_SEGURIDAD_INSERTAR_SP;
/
create or replace PROCEDURE FIDE_CLAVES_SEGURIDAD_ACTUALIZAR_SP(
    p_Calve_ID NUMBER,
    p_Votante_ID NUMBER,
    p_Clave NUMBER
) IS
BEGIN
    UPDATE FIDE_CLAVES_SEGURIDAD_TB
    SET 
        Votante_ID = p_Votante_ID,
        Clave = p_Clave
    WHERE Clave_ID = p_Calve_ID;
    COMMIT;
END FIDE_CLAVES_SEGURIDAD_ACTUALIZAR_SP;
/
create or replace PROCEDURE FIDE_CLAVES_SEGURIDAD_ELIMINAR_SP(p_Clave_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_CLAVES_SEGURIDAD_TB WHERE Clave_ID = p_Clave_ID;
    COMMIT;
END FIDE_CLAVES_SEGURIDAD_ELIMINAR_SP;
/
------------------------------CREDENCIALES-----------------------------------------------------
create or replace PROCEDURE FIDE_CREDENCIALES_INSERTAR_SP(
    p_Votante_ID NUMBER,
    p_Eleccion_id NUMBER,
    p_Codigo NUMBER,
    P_FechaEmision DATE

) IS
BEGIN
    INSERT INTO FIDE_CREDENCIALES_TB (Votante_ID, Eleccion_ID, Codigo, FechaEmision) 
    VALUES (p_Votante_ID,p_Eleccion_id, p_Codigo, p_FechaEmision);
    COMMIT;
END FIDE_CREDENCIALES_INSERTAR_SP;
/
create or replace PROCEDURE FIDE_CREDENCIALES_ACTUALIZAR_SP(
    p_Credencial_ID NUMBER,
    p_Votante_ID NUMBER,
    p_Eleccion_id NUMBER,
    p_Codigo NUMBER,
    P_FechaEmision DATE
) IS
BEGIN
    UPDATE FIDE_CREDENCIALES_TB
    SET 
        Votante_ID = p_Votante_ID,
        Eleccion_id = p_Eleccion_id,
        Codigo = p_Codigo,
        FechaEmision = P_FechaEmision
    WHERE Credencial_ID = p_Credencial_ID;
    COMMIT;
END FIDE_CREDENCIALES_ACTUALIZAR_SP;
/
create or replace PROCEDURE FIDE_CREDENCIALES_ELIMINAR_SP(p_Credencial_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_CREDENCIALES_TB WHERE Credencial_ID = p_Credencial_ID;
    COMMIT;
END FIDE_CREDENCIALES_ELIMINAR_SP;
/
------------------------------HISTORIALVOTOS-----------------------------------------------------
create or replace PROCEDURE FIDE_HISTORIALVOTOS_INSERTAR_SP(
    P_FechaModificacion DATE,
    p_Accion_Historial VARCHAR2

) IS
BEGIN
    INSERT INTO FIDE_HISTORIALVOTOS_TB (FechaModificacion, Accion_Historial) 
    VALUES (p_FechaModificacion,p_Accion_Historial);
    COMMIT;
END FIDE_HISTORIALVOTOS_INSERTAR_SP;
/
create or replace PROCEDURE FIDE_HISTORIALVOTOS_ACTUALIZAR_SP(
    p_Historial_ID NUMBER,
    P_FechaModificacion DATE,
    p_Accion_Historial VARCHAR2
) IS
BEGIN
    UPDATE FIDE_HISTORIALVOTOS_TB
    SET 
        FechaModificacion = P_FechaModificacion,
        Accion_Historial = p_Accion_Historial
    WHERE Historial_ID = p_Historial_ID;
    COMMIT;
END FIDE_HISTORIALVOTOS_ACTUALIZAR_SP;
/
create or replace PROCEDURE FIDE_HISTORIALVOTOS_ELIMINAR_SP(p_Historial_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_HISTORIALVOTOS_TB WHERE Historial_ID = p_Historial_ID;
    COMMIT;
END FIDE_HISTORIALVOTOS_ELIMINAR_SP;
/
------------------------------LOGSEGURIDAD-----------------------------------------------------
create or replace PROCEDURE FIDE_LOGSEGURIDAD_INSERTAR_SP(
    p_Votante_ID NUMBER,
    P_Fecha DATE,
    p_Accion_Log VARCHAR2

) IS
BEGIN
    INSERT INTO FIDE_LOGSEGURIDAD_TB (Votante_ID, Fecha, Accion_Log) 
    VALUES (p_Votante_ID,P_Fecha, p_Accion_Log);
    COMMIT;
END FIDE_LOGSEGURIDAD_INSERTAR_SP;
/
create or replace PROCEDURE FIDE_LOGSEGURIDAD_ACTUALIZAR_SP(
    p_LOG_ID NUMBER,
    p_Votante_ID NUMBER,
    P_Fecha DATE,
    p_Accion_Log VARCHAR2
) IS
BEGIN
    UPDATE FIDE_LOGSEGURIDAD_TB
    SET 
        Votante_ID = p_Votante_ID,
        Fecha = P_Fecha,
        Accion_Log = p_Accion_Log
    WHERE LOG_ID = p_LOG_ID;
    COMMIT;
END FIDE_LOGSEGURIDAD_ACTUALIZAR_SP;
/
create or replace PROCEDURE FIDE_LOGSEGURIDAD_ELIMINAR_SP(p_LOG_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_LOGSEGURIDAD_TB WHERE LOG_ID = p_LOG_ID;
    COMMIT;
END FIDE_LOGSEGURIDAD_ELIMINAR_SP;
/
------------------------------NOTIFICACIONES-----------------------------------------------------
create or replace PROCEDURE FIDE_NOTIFICACIONES_INSERTAR_SP(
    p_Votante_ID NUMBER,
    p_Mensaje VARCHAR2,
    P_FechaNotificacion DATE

) IS
BEGIN
    INSERT INTO FIDE_NOTIFICACIONES_TB (Votante_ID, Mensaje, FechaNotificacion) 
    VALUES (p_Votante_ID,p_Mensaje, P_FechaNotificacion);
    COMMIT;
END FIDE_NOTIFICACIONES_INSERTAR_SP;
/
create or replace PROCEDURE FIDE_NOTIFICACIONES_ACTUALIZAR_SP(
    p_Notificacion_ID NUMBER,
    p_Votante_ID NUMBER,
    p_Mensaje VARCHAR2,
    P_FechaNotificacion DATE
) IS
BEGIN
    UPDATE FIDE_NOTIFICACIONES_TB
    SET 
        Votante_ID = p_Votante_ID,
        Mensaje = p_Mensaje,
        FechaNotificacion = P_FechaNotificacion
    WHERE Notificacion_ID = p_Notificacion_ID;
    COMMIT;
END FIDE_NOTIFICACIONES_ACTUALIZAR_SP;
/
create or replace PROCEDURE FIDE_NOTIFICACIONES_ELIMINAR_SP(p_Notificacion_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_NOTIFICACIONES_TB WHERE Notificacion_ID = p_Notificacion_ID;
    COMMIT;
END FIDE_NOTIFICACIONES_ELIMINAR_SP;
/
------------------------------REPORTES-----------------------------------------------------
create or replace PROCEDURE FIDE_REPORTES_INSERTAR_SP(
    p_Eleccion_ID NUMBER,
    p_Votante_ID NUMBER,
    P_FechaReporte DATE,
    p_Descripcion VARCHAR2

) IS
BEGIN
    INSERT INTO FIDE_REPORTES_TB (Eleccion_ID, Votante_ID, FechaReporte, Descripcion) 
    VALUES (p_Eleccion_ID, p_Votante_ID,P_FechaReporte, p_Descripcion);
    COMMIT;
END FIDE_REPORTES_INSERTAR_SP;
/
create or replace PROCEDURE FIDE_REPORTES_ACTUALIZAR_SP(
    p_Reporte_ID NUMBER,
    p_Eleccion_ID NUMBER,
    p_Votante_ID NUMBER,
    P_FechaReporte DATE,
    p_Descripcion VARCHAR2
) IS
BEGIN
    UPDATE FIDE_REPORTES_TB
    SET 
        Eleccion_ID = p_Eleccion_ID,
        Votante_ID = p_Votante_ID,
        FechaReporte = P_FechaReporte,
        Descripcion = p_Descripcion
    WHERE Reporte_ID = p_Reporte_ID;
    COMMIT;
END FIDE_REPORTES_ACTUALIZAR_SP;
/
create or replace PROCEDURE FIDE_REPORTES_ELIMINAR_SP(p_Reporte_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_REPORTES_TB WHERE Reporte_ID = p_Reporte_ID;
    COMMIT;
END FIDE_REPORTES_ELIMINAR_SP;
/
------------------------------SEDES-----------------------------------------------------
create or replace PROCEDURE FIDE_SEDES_INSERTAR_SP(
    p_Nombre VARCHAR2,
    p_Direccion_ID NUMBER

) IS
BEGIN
    INSERT INTO FIDE_SEDES_TB (Nombre, Direccion_ID) 
    VALUES (p_Nombre, p_Direccion_ID);
    COMMIT;
END FIDE_SEDES_INSERTAR_SP;
/
create or replace PROCEDURE FIDE_SEDES_ACTUALIZAR_SP(
    p_Sede_ID NUMBER,
    p_Nombre VARCHAR2,
    p_Direccion_ID NUMBER
) IS
BEGIN
    UPDATE FIDE_SEDES_TB
    SET 
        Nombre = p_Nombre,
        Direccion_ID = p_Direccion_ID
    WHERE Sede_ID = p_Sede_ID;
    COMMIT;
END FIDE_SEDES_ACTUALIZAR_SP;
/
create or replace PROCEDURE FIDE_SEDES_ELIMINAR_SP(p_Sede_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_SEDES_TB WHERE Sede_ID = p_Sede_ID;
    COMMIT;
END FIDE_SEDES_ELIMINAR_SP;
/
------------------------------SESIONES-----------------------------------------------------
create or replace PROCEDURE FIDE_SESIONES_INSERTAR_SP(
    p_Usuario_ID NUMBER,
    p_FechaInicio TIMESTAMP,
    p_FechaFin TIMESTAMP

) IS
BEGIN
    INSERT INTO FIDE_SESIONES_TB (Usuario_ID, FechaInicio, FechaFin) 
    VALUES (p_Usuario_ID, p_FechaInicio, p_FechaFin);
    COMMIT;
END FIDE_SESIONES_INSERTAR_SP;
/
create or replace PROCEDURE FIDE_SESIONES_ACTUALIZAR_SP(
    p_Sesion_ID NUMBER,
    p_Usuario_ID NUMBER,
    p_FechaInicio TIMESTAMP,
    p_FechaFin TIMESTAMP
) IS
BEGIN
    UPDATE FIDE_SESIONES_TB
    SET 
        Usuario_ID = p_Usuario_ID,
        FechaInicio = p_FechaInicio,
        FechaFin = p_FechaFin
    WHERE Sesion_ID = p_Sesion_ID;
    COMMIT;
END FIDE_SESIONES_ACTUALIZAR_SP;
/
create or replace PROCEDURE FIDE_SESIONES_ELIMINAR_SP(p_Sesion_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_SESIONES_TB WHERE Sesion_ID = p_Sesion_ID;
    COMMIT;
END FIDE_SESIONES_ELIMINAR_SP;
/
------------------------------VOTOS_HISTORIAL-----------------------------------------------------
create or replace PROCEDURE FIDE_VOTOS_HISTORIAL_INSERTAR_SP(
    p_Voto_ID NUMBER,
    p_Historial_ID NUMBER

) IS
BEGIN
    INSERT INTO FIDE_VOTOS_HISTORIAL_TB (Voto_ID, Historial_ID) 
    VALUES (p_Voto_ID, p_Historial_ID);
    COMMIT;
END FIDE_VOTOS_HISTORIAL_INSERTAR_SP;
/
create or replace PROCEDURE FIDE_VOTOS_HISTORIAL_ACTUALIZAR_SP(
    p_Votos_Historial_ID NUMBER,
    p_Voto_ID NUMBER,
    p_Historial_ID NUMBER
) IS
BEGIN
    UPDATE FIDE_VOTOS_HISTORIAL_TB
    SET 
        Voto_ID = p_Voto_ID,
        Historial_ID = p_Historial_ID
    WHERE Votos_Historial_ID = p_Votos_Historial_ID;
    COMMIT;
END FIDE_VOTOS_HISTORIAL_ACTUALIZAR_SP;
/
create or replace PROCEDURE FIDE_VOTOS_HISTORIAL_ELIMINAR_SP(p_Votos_Historial_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_VOTOS_HISTORIAL_TB WHERE Votos_Historial_ID = p_Votos_Historial_ID;
    COMMIT;
END FIDE_VOTOS_HISTORIAL_ELIMINAR_SP;
/