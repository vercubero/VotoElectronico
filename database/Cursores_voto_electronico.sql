---primer cursor
SET SERVEROUTPUT ON;

DECLARE
    -- Declaración del cursor estático
    CURSOR c_candidatos IS
        SELECT Candidato_ID, Nombre, Apellido, Partido_ID, Eleccion_ID, Estado_ID, 
               creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion
        FROM FIDE_CANDIDATOS_TB
        WHERE Estado_ID = 1;  

BEGIN
   
    FOR v_candidato IN c_candidatos LOOP
        --- Mostrar los datos del candidato
        DBMS_OUTPUT.PUT_LINE('Candidato ID: ' || v_candidato.Candidato_ID || 
                             ' - Nombre: ' || v_candidato.Nombre || 
                             ' - Apellido: ' || v_candidato.Apellido || 
                             ' - Partido ID: ' || v_candidato.Partido_ID ||
                             ' - Elección ID: ' || v_candidato.Eleccion_ID);
    END LOOP;
END;
/
---segundo cursor
SET SERVEROUTPUT ON;

DECLARE
    -- Declaración del cursor estático
    CURSOR c_roles IS
        SELECT Rol_ID, Nombre_Rol, creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion
        FROM FIDE_ROLES_TB;

BEGIN
   
    FOR v_rol IN c_roles LOOP
        
        DBMS_OUTPUT.PUT_LINE('Rol ID: ' || v_rol.Rol_ID || 
                             ' - Nombre Rol: ' || v_rol.Nombre_Rol || 
                             ' - Creado Por: ' || v_rol.creado_por || 
                             ' - Modificado Por: ' || v_rol.modificado_por ||
                             ' - Fecha Creación: ' || TO_CHAR(v_rol.fecha_creacion, 'DD/MM/YYYY') ||
                             ' - Fecha Modificación: ' || TO_CHAR(v_rol.fecha_modificacion, 'DD/MM/YYYY') ||
                             ' - Acción: ' || v_rol.accion);
    END LOOP;
END;
/
---tercer cursor
SET SERVEROUTPUT ON;

DECLARE
    --- Declaración del cursor estático
    CURSOR c_usuarios IS
        SELECT Usuario_ID, User_name, Password, Email, Rol_ID, Estado_ID, creado_por, modificado_por, 
               fecha_creacion, fecha_modificacion, accion
        FROM FIDE_USUARIOS_TB;

BEGIN

    FOR v_usuario IN c_usuarios LOOP
        --- Mostrar los datos del usuario
        DBMS_OUTPUT.PUT_LINE('Usuario ID: ' || v_usuario.Usuario_ID || 
                             ' - Nombre de Usuario: ' || v_usuario.User_name || 
                             ' - Email: ' || v_usuario.Email || 
                             ' - Rol ID: ' || v_usuario.Rol_ID ||
                             ' - Estado ID: ' || v_usuario.Estado_ID ||
                             ' - Creado Por: ' || v_usuario.creado_por || 
                             ' - Modificado Por: ' || v_usuario.modificado_por ||
                             ' - Fecha Creación: ' || TO_CHAR(v_usuario.fecha_creacion, 'DD/MM/YYYY') ||
                             ' - Fecha Modificación: ' || TO_CHAR(v_usuario.fecha_modificacion, 'DD/MM/YYYY') ||
                             ' - Acción: ' || v_usuario.accion);
    END LOOP;
END;
/
---cuarto cursor
SET SERVEROUTPUT ON;

DECLARE
    -- Declaración del cursor estático
    CURSOR c_auditores IS
        SELECT Auditor_ID, Nombre, Apellido, Email, Telefono, creado_por, modificado_por, 
               fecha_creacion, fecha_modificacion, accion
        FROM FIDE_AUDITORES_TB;

BEGIN
   
    FOR v_auditor IN c_auditores LOOP
    
        DBMS_OUTPUT.PUT_LINE('Auditor ID: ' || v_auditor.Auditor_ID || 
                             ' - Nombre: ' || v_auditor.Nombre || 
                             ' - Apellido: ' || v_auditor.Apellido || 
                             ' - Email: ' || v_auditor.Email || 
                             ' - Teléfono: ' || v_auditor.Telefono ||
                             ' - Creado Por: ' || v_auditor.creado_por || 
                             ' - Modificado Por: ' || v_auditor.modificado_por ||
                             ' - Fecha Creación: ' || TO_CHAR(v_auditor.fecha_creacion, 'DD/MM/YYYY') ||
                             ' - Fecha Modificación: ' || TO_CHAR(v_auditor.fecha_modificacion, 'DD/MM/YYYY') ||
                             ' - Acción: ' || v_auditor.accion);
    END LOOP;
END;
/
---quinto cursor
SET SERVEROUTPUT ON;

DECLARE
    --- Declaración del cursor estático
    CURSOR c_resultados IS
        SELECT Resultado_ID, Eleccion_ID, Candidato_ID, Estado_ID, Votos_Obtenidos, 
               creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion
        FROM FIDE_RESULTADOS_TB;

BEGIN

    FOR v_resultado IN c_resultados LOOP

        DBMS_OUTPUT.PUT_LINE('Resultado ID: ' || v_resultado.Resultado_ID || 
                             ' - Elección ID: ' || v_resultado.Eleccion_ID || 
                             ' - Candidato ID: ' || v_resultado.Candidato_ID || 
                             ' - Estado ID: ' || v_resultado.Estado_ID || 
                             ' - Votos Obtenidos: ' || v_resultado.Votos_Obtenidos ||
                             ' - Creado Por: ' || v_resultado.creado_por || 
                             ' - Modificado Por: ' || v_resultado.modificado_por ||
                             ' - Fecha Creación: ' || TO_CHAR(v_resultado.fecha_creacion, 'DD/MM/YYYY') ||
                             ' - Fecha Modificación: ' || TO_CHAR(v_resultado.fecha_modificacion, 'DD/MM/YYYY') ||
                             ' - Acción: ' || v_resultado.accion);
    END LOOP;
END;
/
---sexto cursor
SET SERVEROUTPUT ON;

DECLARE
    --- Declaración del cursor estático
    CURSOR c_votantes IS
        SELECT Votante_ID, Nombre, Apellido, Fecha_Nacimiento, Email, Telefono, 
               Genero_ID, Direccion_ID, Estado_ID, creado_por, modificado_por, 
               fecha_creacion, fecha_modificacion, accion
        FROM FIDE_VOTANTES_TB;

BEGIN
   
    FOR v_votante IN c_votantes LOOP
       
        DBMS_OUTPUT.PUT_LINE('Votante ID: ' || v_votante.Votante_ID || 
                             ' - Nombre: ' || v_votante.Nombre || 
                             ' - Apellido: ' || v_votante.Apellido || 
                             ' - Fecha de Nacimiento: ' || TO_CHAR(v_votante.Fecha_Nacimiento, 'DD/MM/YYYY') ||
                             ' - Email: ' || v_votante.Email || 
                             ' - Teléfono: ' || v_votante.Telefono ||
                             ' - Género ID: ' || v_votante.Genero_ID ||
                             ' - Dirección ID: ' || v_votante.Direccion_ID ||
                             ' - Estado ID: ' || v_votante.Estado_ID ||
                             ' - Creado Por: ' || v_votante.creado_por || 
                             ' - Modificado Por: ' || v_votante.modificado_por ||
                             ' - Fecha Creación: ' || TO_CHAR(v_votante.fecha_creacion, 'DD/MM/YYYY') ||
                             ' - Fecha Modificación: ' || TO_CHAR(v_votante.fecha_modificacion, 'DD/MM/YYYY') ||
                             ' - Acción: ' || v_votante.accion);
    END LOOP;
END;
/
---septimo cursor
SET SERVEROUTPUT ON;

DECLARE
    --- Declaración del cursor estático
    CURSOR c_provincias IS
        SELECT Provincia_ID, Nombre, creado_por, modificado_por, 
               fecha_creacion, fecha_modificacion, accion
        FROM FIDE_PROVINCIAS_TB;

BEGIN
   
    FOR v_provincia IN c_provincias LOOP
      
        DBMS_OUTPUT.PUT_LINE('Provincia ID: ' || v_provincia.Provincia_ID || 
                             ' - Nombre: ' || v_provincia.Nombre || 
                             ' - Creado Por: ' || v_provincia.creado_por || 
                             ' - Modificado Por: ' || v_provincia.modificado_por ||
                             ' - Fecha Creación: ' || TO_CHAR(v_provincia.fecha_creacion, 'DD/MM/YYYY') ||
                             ' - Fecha Modificación: ' || TO_CHAR(v_provincia.fecha_modificacion, 'DD/MM/YYYY') ||
                             ' - Acción: ' || v_provincia.accion);
    END LOOP;
END;
/
---octavo cursor
SET SERVEROUTPUT ON;

DECLARE
    --- Declaración del cursor estático
    CURSOR c_generos IS
        SELECT Genero_ID, Nombre, creado_por, modificado_por, 
               fecha_creacion, fecha_modificacion, accion
        FROM FIDE_GENEROS_TB;

BEGIN
    
    FOR v_genero IN c_generos LOOP
       
        DBMS_OUTPUT.PUT_LINE('Género ID: ' || v_genero.Genero_ID || 
                             ' - Nombre: ' || v_genero.Nombre || 
                             ' - Creado Por: ' || v_genero.creado_por || 
                             ' - Modificado Por: ' || v_genero.modificado_por ||
                             ' - Fecha Creación: ' || TO_CHAR(v_genero.fecha_creacion, 'DD/MM/YYYY') ||
                             ' - Fecha Modificación: ' || TO_CHAR(v_genero.fecha_modificacion, 'DD/MM/YYYY') ||
                             ' - Acción: ' || v_genero.accion);
    END LOOP;
END;
/






