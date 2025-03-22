---Insertar un candidato #1
CREATE OR REPLACE PROCEDURE insertar_candidato(
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
        p_creado_por, SYSDATE, 'INSERT'
    );
END insertar_candidato;
/
---Actualizar un candidato #2
CREATE OR REPLACE PROCEDURE actualizar_candidato(
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
        accion = 'UPDATE'
    WHERE Candidato_ID = p_Candidato_ID;
END actualizar_candidato;
/
---Eliminar un candidato #3
CREATE OR REPLACE PROCEDURE eliminar_candidato(p_Candidato_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_CANDIDATOS_TB WHERE Candidato_ID = p_Candidato_ID;
END eliminar_candidato;
/
---Insertar un rol #4
CREATE OR REPLACE PROCEDURE insertar_rol(
    p_Rol_ID IN NUMBER,
    p_Nombre_Rol IN VARCHAR2,
    p_creado_por IN VARCHAR2
) IS
BEGIN
    INSERT INTO FIDE_ROLES_TB (
        Rol_ID, Nombre_Rol, creado_por, fecha_creacion, accion
    ) VALUES (
        p_Rol_ID, p_Nombre_Rol, p_creado_por, SYSDATE, 'INSERT'
    );
END insertar_rol;
/
---Actualizar un rol #5
CREATE OR REPLACE PROCEDURE actualizar_rol(
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
        accion = 'UPDATE'
    WHERE Rol_ID = p_Rol_ID;
END actualizar_rol;
/
--- Eliminar un rol #6
CREATE OR REPLACE PROCEDURE eliminar_rol(p_Rol_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_ROLES_TB WHERE Rol_ID = p_Rol_ID;
END eliminar_rol;
/
--- Insertar un usuario #7
CREATE OR REPLACE PROCEDURE insertar_usuario(
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
        p_creado_por, SYSDATE, 'INSERT'
    );
END insertar_usuario;
/
---Actualizar un usuario #8
CREATE OR REPLACE PROCEDURE actualizar_usuario(
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
        accion = 'UPDATE'
    WHERE Usuario_ID = p_Usuario_ID;
END actualizar_usuario;
/
---Eliminar un usuario #9
CREATE OR REPLACE PROCEDURE eliminar_usuario(p_Usuario_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_USUARIOS_TB WHERE Usuario_ID = p_Usuario_ID;
END eliminar_usuario;
/
--- Insertar un auditor #10
CREATE OR REPLACE PROCEDURE insertar_auditor(
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
        SYSDATE, 'INSERT'
    );
END insertar_auditor;
/
--- Actualizar un auditor#11
CREATE OR REPLACE PROCEDURE actualizar_auditor(
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
        accion = 'UPDATE'
    WHERE Auditor_ID = p_Auditor_ID;
END actualizar_auditor;
/
---Eliminar un auditor #12
CREATE OR REPLACE PROCEDURE eliminar_auditor(p_Auditor_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_AUDITORES_TB WHERE Auditor_ID = p_Auditor_ID;
END eliminar_auditor;
/
---Insertar un resultado #13
CREATE OR REPLACE PROCEDURE insertar_resultado(
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
        p_creado_por, SYSDATE, 'INSERT'
    );
END insertar_resultado;
/
--- Actualizar un resultado #14
CREATE OR REPLACE PROCEDURE actualizar_resultado(
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
        accion = 'UPDATE'
    WHERE Resultado_ID = p_Resultado_ID;
END actualizar_resultado;
/
---Eliminar un resultado #15
CREATE OR REPLACE PROCEDURE eliminar_resultado(p_Resultado_ID IN NUMBER) IS
BEGIN
    DELETE FROM FIDE_RESULTADOS_TB WHERE Resultado_ID = p_Resultado_ID;
END eliminar_resultado;
/
