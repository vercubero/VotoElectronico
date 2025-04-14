CREATE OR REPLACE PACKAGE Fide_Proyecto_Final_PKG AS

    -- Declaraci�n de la funci�n
    FUNCTION FIDE_ELECIONES_OBTENER_ESTADO_FN(p_eleccion_ID IN NUMBER) RETURN VARCHAR2;
    FUNCTION FIDE_PARTIDOS_CANDIDATOS_REGISTRADOS_FN(p_partido_ID IN NUMBER) RETURN VARCHAR2;
    FUNCTION FIDE_PARTIDOS_OBTENER_NOMBRE_FN(p_partido_ID IN NUMBER) RETURN VARCHAR2;
    FUNCTION FIDE_VOTANTES_CALCULAR_EDAD_FN(p_votante_ID IN NUMBER) RETURN NUMBER;
    FUNCTION FIDE_VOTANTES_NOMBRE_COMPLETO_FN(p_votante_ID IN NUMBER) RETURN VARCHAR2;
    FUNCTION FIDE_VOTANTES_POR_GENERO_FN(p_genero_ID IN NUMBER) RETURN NUMBER;
    FUNCTION FIDE_VOTOS_CONTAR_VOTOS_CANDIDATO_FN(p_candidato_ID IN NUMBER,p_eleccion_ID IN NUMBER) RETURN NUMBER;
    FUNCTION FIDE_VOTOS_VERIFICA_VOTANTE_FN(p_votante_ID IN NUMBER,p_eleccion_ID IN NUMBER) RETURN VARCHAR2;
    
    -- Declaraci�n del procedimiento
    PROCEDURE FIDE_AUDITORES_ACTUALIZAR_SP(
    p_Auditor_ID IN NUMBER,p_Nombre IN VARCHAR2,p_Apellido IN VARCHAR2,
    p_Email IN VARCHAR2,p_Telefono IN VARCHAR2,p_modificado_por IN VARCHAR2);
    PROCEDURE FIDE_AUDITORES_ELIMINAR_SP(p_Auditor_ID IN NUMBER);
    PROCEDURE FIDE_AUDITORES_INSERTAR_SP(
    p_Auditor_ID IN NUMBER,
    p_Nombre IN VARCHAR2,
    p_Apellido IN VARCHAR2,
    p_Email IN VARCHAR2,
    p_Telefono IN VARCHAR2,
    p_creado_por IN VARCHAR2);
    PROCEDURE FIDE_AUDITORES_SIN_AUDITORIAS_SP;
    PROCEDURE FIDE_AUDITORIAS_POR_AUDITOR_SP;
    PROCEDURE FIDE_AUDITORIAS_POR_ELECCION_SP;
    PROCEDURE FIDE_CANDIDATOS_ACTUALIZAR_SP(
    p_Candidato_ID IN NUMBER,
    p_Nombre IN VARCHAR2,
    p_Apellido IN VARCHAR2,
    p_Partido_ID IN NUMBER,
    p_Eleccion_ID IN NUMBER,
    p_Estado_ID IN NUMBER,
    p_modificado_por IN VARCHAR2);
    PROCEDURE FIDE_CANDIDATOS_ELIMINAR_SP(p_Candidato_ID IN NUMBER);
    PROCEDURE FIDE_CANDIDATOS_INSERTAR_SP(
    p_Candidato_ID IN NUMBER,
    p_Nombre IN VARCHAR2,
    p_Apellido IN VARCHAR2,
    p_Partido_ID IN NUMBER,
    p_Eleccion_ID IN NUMBER,
    p_Estado_ID IN NUMBER,
    p_creado_por IN VARCHAR2);
    PROCEDURE FIDE_CANDIDATOS_SIN_VOTOS_SP (
    p_eleccion_id IN NUMBER);
    PROCEDURE FIDE_CANTONES_Actualizar_SP (
    p_Canton_ID IN NUMBER,
    p_Nombre IN VARCHAR2);
    PROCEDURE FIDE_CANTONES_Eliminar_SP (
    p_Canton_ID IN NUMBER);
    PROCEDURE FIDE_CANTONES_Insertar_SP (
    p_Canton_ID IN NUMBER,
    p_Nombre IN VARCHAR2);
    PROCEDURE FIDE_CANTONES_ObtenerPorProvincia_SP(
    p_Provincia_ID IN NUMBER);
    PROCEDURE FIDE_DIRECCIONES_DELETE_SP(
    p_Direccion_ID IN NUMBER);
    PROCEDURE FIDE_DIRECCIONES_INSERT_SP(
    p_Direccion_ID IN NUMBER,
    p_Provincia_ID IN NUMBER,
    p_Canton_ID IN NUMBER,
    p_Distrito_ID IN NUMBER,
    p_creado_por IN VARCHAR2,
    p_modificado_por IN VARCHAR2,
    p_Fecha_Creacion IN DATE,
    p_Fecha_Modificacion IN DATE,
    p_accion IN VARCHAR2);
    PROCEDURE FIDE_DIRECCIONES_UPDATE_SP(
    p_Direccion_ID IN NUMBER,
    p_Provincia_ID IN NUMBER,
    p_Canton_ID IN NUMBER,
    p_Distrito_ID IN NUMBER,
    p_creado_por IN VARCHAR2,
    p_modificado_por IN VARCHAR2,
    p_Fecha_Creacion IN DATE,
    p_Fecha_Modificacion IN DATE,
    p_accion IN VARCHAR2);
    PROCEDURE FIDE_DISTRITOS_DELETE_SP(
    p_Distrito_ID IN NUMBER);
    PROCEDURE FIDE_DISTRITOS_INSERT_SP(
    p_Distrito_ID IN NUMBER,
    p_Nombre IN VARCHAR2,
    p_creado_por IN VARCHAR2,
    p_modificado_por IN VARCHAR2,
    p_Fecha_Creacion IN DATE,
    p_Fecha_Modificacion IN DATE,
    p_accion IN VARCHAR2);
    PROCEDURE FIDE_DISTRITOS_UPDATE_SP(
    p_Distrito_ID IN NUMBER,
    p_Nombre IN VARCHAR2,
    p_creado_por IN VARCHAR2,
    p_modificado_por IN VARCHAR2,
    p_Fecha_Creacion IN DATE,
    p_Fecha_Modificacion IN DATE,
    p_accion IN VARCHAR2);
    PROCEDURE FIDE_ELECCIONES_DELETE_SP(
    p_Eleccion_ID IN NUMBER);
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
    p_accion IN VARCHAR2);
    PROCEDURE FIDE_ELECCIONES_TB_ESTADO_ELECCIONES_SP;
    PROCEDURE FIDE_ELECCIONES_UPDATE_SP(
    p_Eleccion_ID IN NUMBER,
    p_Nombre IN VARCHAR2,
    p_Fecha_Inicio IN DATE,
    p_Fecha_Fin IN DATE,
    p_Descripcion IN VARCHAR2,
    p_Estado_ID IN NUMBER,
    p_modificado_por IN VARCHAR2,
    p_accion IN VARCHAR2);
    PROCEDURE FIDE_ESTADOS_Actualizar_SP (
    p_Estado_ID IN NUMBER,
    p_Descripcion IN VARCHAR2);
    PROCEDURE FIDE_ESTADOS_Eliminar_SP (
    p_Estado_ID IN NUMBER);
    PROCEDURE FIDE_ESTADOS_Insertar_SP (
    p_Estado_ID IN NUMBER,
    p_Descripcion IN VARCHAR2);
    PROCEDURE FIDE_ESTADOS_ObtenerActivos_SP;
    PROCEDURE FIDE_GENEROS_Actualizar_SP (
    p_Genero_ID IN NUMBER,
    p_Nombre IN VARCHAR2);
    PROCEDURE FIDE_GENEROS_Eliminar_SP (
    p_Genero_ID IN NUMBER);
    PROCEDURE FIDE_GENEROS_Insertar_SP (
    p_Genero_ID IN NUMBER,
    p_Nombre IN VARCHAR2);
    PROCEDURE FIDE_GENEROS_Obtener_SP;
    PROCEDURE FIDE_MESAS_VOTO_DELETE_SP(
    p_Mesa_Voto_ID IN NUMBER);
    PROCEDURE FIDE_MESAS_VOTO_INSERT_SP(
    p_Mesa_Voto_ID IN NUMBER,
    p_Eleccion_ID IN NUMBER,
    p_Votante_ID IN NUMBER,
    p_Estado_ID IN NUMBER,
    p_creado_por IN VARCHAR2,
    p_modificado_por IN VARCHAR2,
    p_fecha_creacion IN DATE,
    p_fecha_modificacion IN DATE,
    p_accion IN VARCHAR2);
    PROCEDURE FIDE_MESAS_VOTO_UPDATE_SP(
    p_Mesa_Voto_ID IN NUMBER,
    p_Eleccion_ID IN NUMBER,
    p_Votante_ID IN NUMBER,
    p_Estado_ID IN NUMBER,
    p_creado_por IN VARCHAR2,
    p_modificado_por IN VARCHAR2,
    p_fecha_creacion IN DATE,
    p_fecha_modificacion IN DATE,
    p_accion IN VARCHAR2);
    PROCEDURE FIDE_PARTIDOS_DELETE_SP(
    p_Partido_ID IN NUMBER);
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
    p_accion IN VARCHAR2);
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
    p_accion IN VARCHAR2);
    PROCEDURE FIDE_PROVINCIAS_Actualizar_SP (
    p_Provincia_ID IN NUMBER,
    p_Nombre IN VARCHAR2);
    PROCEDURE FIDE_PROVINCIAS_Eliminar_SP (
    p_Provincia_ID IN NUMBER);
    PROCEDURE FIDE_PROVINCIAS_Insertar_SP (
    p_Provincia_ID IN NUMBER,
    p_Nombre IN VARCHAR2);
    PROCEDURE FIDE_RESULTADOS_ACTUALIZAR_SP(
    p_Resultado_ID IN NUMBER,
    p_Eleccion_ID IN NUMBER,
    p_Candidato_ID IN NUMBER,
    p_Estado_ID IN NUMBER,
    p_Votos_Obtenidos IN NUMBER,
    p_modificado_por IN VARCHAR2);
    PROCEDURE FIDE_RESULTADOS_ELIMINAR_SP(p_Resultado_ID IN NUMBER);
    PROCEDURE FIDE_RESULTADOS_INSERTAR_SP(
    p_Resultado_ID IN NUMBER,
    p_Eleccion_ID IN NUMBER,
    p_Candidato_ID IN NUMBER,
    p_Estado_ID IN NUMBER,
    p_Votos_Obtenidos IN NUMBER,
    p_creado_por IN VARCHAR2);
    PROCEDURE FIDE_ROLES_ACTUALIZAR_SP(
    p_Rol_ID IN NUMBER,
    p_Nombre_Rol IN VARCHAR2,
    p_modificado_por IN VARCHAR2);
    PROCEDURE FIDE_ROLES_ELIMINAR_SP(p_Rol_ID IN NUMBER);
    PROCEDURE FIDE_ROLES_INSERTAR_SP(
    p_Rol_ID IN NUMBER,
    p_Nombre_Rol IN VARCHAR2,
    p_creado_por IN VARCHAR2);
    PROCEDURE FIDE_USUARIOS_ACTUALIZAR_SP(
    p_Usuario_ID IN NUMBER,
    p_User_name IN VARCHAR2,
    p_Password IN VARCHAR2,
    p_Email IN VARCHAR2,
    p_Rol_ID IN NUMBER,
    p_Estado_ID IN NUMBER,
    p_modificado_por IN VARCHAR2);
    PROCEDURE FIDE_USUARIOS_ELIMINAR_SP(p_Usuario_ID IN NUMBER);
    PROCEDURE FIDE_USUARIOS_INSERTAR_SP(
    p_Usuario_ID IN NUMBER,
    p_User_name IN VARCHAR2,
    p_Password IN VARCHAR2,
    p_Email IN VARCHAR2,
    p_Rol_ID IN NUMBER,
    p_Estado_ID IN NUMBER,
    p_creado_por IN VARCHAR2);
    PROCEDURE FIDE_USUARIOS_VALIDAR_USUARIO_SP(
    p_username IN VARCHAR2,
    p_password IN VARCHAR2,
    p_valido OUT NUMBER);
    PROCEDURE FIDE_VALIDAR_VOTANTE_SP(
    p_votante_id IN NUMBER,
    p_clave IN VARCHAR2,
    p_valido OUT NUMBER);
    PROCEDURE FIDE_VOTANTES_DELETE_SP(
    p_Votante_ID IN NUMBER);
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
    p_accion IN VARCHAR2);
    PROCEDURE FIDE_VOTANTES_POR_PROVINCIAS_SP;
    
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
    p_accion IN VARCHAR2);
    
    PROCEDURE FIDE_VOTOS_CANDIDATO_TOP_POR_ELECCION_SP;
    PROCEDURE FIDE_VOTOS_DELETE_SP(
    p_Voto_ID IN NUMBER);
    PROCEDURE FIDE_VOTOS_HISTORIAL_VOTANTE_SP (
    p_votante_id IN NUMBER);
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
    p_accion IN VARCHAR2);
    PROCEDURE FIDE_VOTOS_PARTICIPACION_POR_GENERO_SP (
    p_eleccion_id IN NUMBER);
    PROCEDURE FIDE_VOTOS_POR_CANTON_SP;
    PROCEDURE FIDE_VOTOS_POR_DISTRITO_SP (
    p_eleccion_id IN NUMBER);
    PROCEDURE FIDE_VOTOS_PROMEDIO_POR_CANDIDATO (
    p_eleccion_id IN NUMBER);
    PROCEDURE FIDE_VOTOS_RANKING_PARTIDOS_SP (
    p_eleccion_id IN NUMBER);
    PROCEDURE FIDE_VOTOS_TB_PARTICIPACION_ELECTORAL_SP (
    p_eleccion_id IN NUMBER);
    PROCEDURE FIDE_VOTOS_TB_VOTOSxCANDIDATO_SP (
    p_eleccion_id IN NUMBER);
    
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
    p_accion IN VARCHAR2);

END Fide_Proyecto_Final_PKG;

