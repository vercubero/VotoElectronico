--- BASE DE DATOS G2_LENGUAJES DE BD
CREATE TABLE FIDE_ESTADOS_TB(
    Estado_ID NUMBER PRIMARY KEY,
    Descripcion VARCHAR2(100),
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100)
);

CREATE TABLE FIDE_GENEROS_TB(
    Genero_ID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(20),
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100)
);

CREATE TABLE FIDE_PROVINCIAS_TB(
    Provincia_ID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(20) UNIQUE NOT NULL,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100)
);

CREATE TABLE FIDE_CANTONES_TB(
    Canton_ID NUMBER PRIMARY KEY,
    Provincia_ID NUMBER,
    Nombre VARCHAR2(20) UNIQUE NOT NULL,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Provincia_ID) REFERENCES FIDE_PROVINCIAS_TB(Provincia_ID)
);
CREATE TABLE FIDE_DISTRITOS_TB(
    Distrito_ID NUMBER PRIMARY KEY,
    Canton_ID NUMBER,
    Nombre VARCHAR2(20) UNIQUE NOT NULL,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Canton_ID) REFERENCES FIDE_CANTONES_TB(Canton_ID)
);
CREATE TABLE FIDE_DIRECCIONES_TB(
    Direccion_ID NUMBER PRIMARY KEY,
    Provincia_ID NUMBER,
    Canton_ID NUMBER,
    Distrito_ID NUMBER,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Provincia_ID) REFERENCES FIDE_PROVINCIAS_TB(Provincia_ID),
    FOREIGN KEY (Canton_ID) REFERENCES FIDE_CANTONES_TB(Canton_ID),
    FOREIGN KEY (Distrito_ID) REFERENCES FIDE_DISTRITOS_TB(Distrito_ID)
);

CREATE TABLE FIDE_VOTANTES_TB(
    Votante_ID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(50) NOT NULL,
    Apellido VARCHAR2(50) NOT NULL,
    Fecha_Nacimiento DATE NOT NULL,
    Email VARCHAR2(100) UNIQUE NOT NULL,
    Telefono VARCHAR2(8),
    Genero_ID NUMBER,
    Direccion_ID NUMBER,
    Estado_ID NUMBER,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Genero_ID) REFERENCES FIDE_GENEROS_TB(Genero_ID),
    FOREIGN KEY (Direccion_ID) REFERENCES FIDE_DIRECCIONES_TB(Direccion_ID),
    FOREIGN KEY (Estado_ID) REFERENCES FIDE_ESTADOS_TB(Estado_ID)
);

CREATE TABLE FIDE_ELECCIONES_TB(
    Eleccion_ID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(100) NOT NULL,
    Fecha_Inicio DATE NOT NULL,
    Fecha_Fin DATE NOT NULL,
    Descripcion VARCHAR2(255),
    Estado_ID NUMBER,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Estado_ID) REFERENCES FIDE_ESTADOS_TB(Estado_ID)
);

CREATE TABLE FIDE_PARTIDOS_TB(
    Partido_ID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(50) UNIQUE NOT NULL,
    Siglas_Partido VARCHAR2(10) UNIQUE NOT NULL,
    Fecha_Fundacion DATE,
    Estado_ID NUMBER,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Estado_ID) REFERENCES FIDE_ESTADOS_TB(Estado_ID)
);

CREATE TABLE FIDE_CANDIDATOS_TB(
    Candidato_ID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(50) NOT NULL,
    Apellido VARCHAR2(50) NOT NULL,
    Partido_ID NUMBER,
    Eleccion_ID NUMBER,
    Estado_ID NUMBER,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Partido_ID) REFERENCES FIDE_PARTIDOS_TB(Partido_ID),
    FOREIGN KEY (Eleccion_ID) REFERENCES FIDE_ELECCIONES_TB(Eleccion_ID),
    FOREIGN KEY (Estado_ID) REFERENCES FIDE_ESTADOS_TB(Estado_ID)
);

CREATE TABLE FIDE_ROLES_TB(
    Rol_ID NUMBER PRIMARY KEY,
    Nombre_Rol VARCHAR2(50) UNIQUE NOT NULL,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100)
);


CREATE TABLE FIDE_USUARIOS_TB(
    Usuario_ID NUMBER PRIMARY KEY,
    User_name VARCHAR2(50) UNIQUE NOT NULL,
    Password VARCHAR2(255) NOT NULL,
    Email VARCHAR2(100) UNIQUE NOT NULL,
    Rol_ID NUMBER,
    Estado_ID NUMBER,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Rol_ID) REFERENCES FIDE_ROLES_TB(Rol_ID),
    FOREIGN KEY (Estado_ID) REFERENCES FIDE_ESTADOS_TB(Estado_ID)
);

CREATE TABLE FIDE_AUDITORES_TB(
    Auditor_ID NUMBER PRIMARY KEY,
    Estado_ID NUMBER,
    Nombre VARCHAR2(50) NOT NULL,
    Apellido VARCHAR2(50) NOT NULL,
    Email VARCHAR2(100) UNIQUE NOT NULL,
    Telefono VARCHAR2(20),
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Estado_ID) REFERENCES FIDE_ESTADOS_TB(Estado_ID)
);

CREATE TABLE FIDE_AUDITORIAS_TB(
    Auditoria_ID NUMBER PRIMARY KEY,
    Eleccion_ID NUMBER,
    Auditor_ID NUMBER,
    Fecha_Auditoria DATE NOT NULL,
    Resultado VARCHAR2(255),
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Eleccion_ID) REFERENCES FIDE_ELECCIONES_TB(Eleccion_ID),
    FOREIGN KEY (Auditor_ID) REFERENCES FIDE_AUDITORES_TB(Auditor_ID)
);

CREATE TABLE FIDE_SEDES_TB(
    Sede_ID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(20) UNIQUE NOT NULL,
    Direccion_ID NUMBER,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Direccion_ID) REFERENCES FIDE_DIRECCIONES_TB(Direccion_ID)
);

CREATE TABLE FIDE_VOTOS_TB(
    Voto_ID NUMBER PRIMARY KEY,
    Votante_ID NUMBER,
    Eleccion_ID NUMBER,
    Candidato_ID NUMBER,
    Fecha_Voto DATE NOT NULL,
    Detalle_Voto VARCHAR2(200),
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Votante_ID) REFERENCES FIDE_VOTANTES_TB(Votante_ID),
    FOREIGN KEY (Eleccion_ID) REFERENCES FIDE_ELECCIONES_TB(Eleccion_ID),
    FOREIGN KEY (Candidato_ID) REFERENCES FIDE_CANDIDATOS_TB(Candidato_ID)
);

CREATE TABLE FIDE_MESAS_VOTO_TB(
    Mesa_Voto_ID NUMBER PRIMARY KEY,
    Eleccion_ID NUMBER,
    Votante_ID NUMBER,
    Estado_ID NUMBER,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Eleccion_ID) REFERENCES FIDE_ELECCIONES_TB(Eleccion_ID),
    FOREIGN KEY (Votante_ID) REFERENCES FIDE_VOTANTES_TB(Votante_ID),
    FOREIGN KEY (Estado_ID) REFERENCES FIDE_ESTADOS_TB(Estado_ID)
);

CREATE TABLE FIDE_CREDENCIALES_TB(
    Credencial_ID NUMBER PRIMARY KEY,
    Votante_ID NUMBER,
    Eleccion_ID NUMBER,
    Codigo VARCHAR2(50) UNIQUE NOT NULL,
    FechaEmision DATE NOT NULL,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Votante_ID) REFERENCES FIDE_VOTANTES_TB(Votante_ID),
    FOREIGN KEY (Eleccion_ID) REFERENCES FIDE_ELECCIONES_TB(Eleccion_ID)
);

CREATE TABLE FIDE_REPORTES_TB(
    Reporte_ID NUMBER PRIMARY KEY,
    Eleccion_ID NUMBER,
    Votante_ID NUMBER,
    FechaReporte DATE NOT NULL,
    Descripcion VARCHAR2(255),
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Eleccion_ID) REFERENCES FIDE_ELECCIONES_TB(Eleccion_ID),
    FOREIGN KEY (Votante_ID) REFERENCES FIDE_VOTANTES_TB(Votante_ID)
);

CREATE TABLE FIDE_BOLETAS_TB(
    Boleta_ID NUMBER PRIMARY KEY,
    Eleccion_ID NUMBER,
    Votante_ID NUMBER,
    Candidato_ID NUMBER,
    FechaBoleta DATE NOT NULL,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Eleccion_ID) REFERENCES FIDE_ELECCIONES_TB(Eleccion_ID),
    FOREIGN KEY (Votante_ID) REFERENCES FIDE_VOTANTES_TB(Votante_ID),
    FOREIGN KEY (Candidato_ID) REFERENCES FIDE_CANDIDATOS_TB(Candidato_ID)
);

CREATE TABLE FIDE_CLAVES_SEGURIDAD_TB(
    Clave_ID NUMBER PRIMARY KEY,
    Votante_ID NUMBER,
    Clave VARCHAR2(255) NOT NULL,
    FechaCreacion DATE NOT NULL,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Votante_ID) REFERENCES FIDE_VOTANTES_TB(Votante_ID)
);

CREATE TABLE FIDE_LOGSEGURIDAD_TB(
    Log_ID NUMBER PRIMARY KEY,
    Votante_ID NUMBER,
    Fecha DATE NOT NULL,
    Accion_log VARCHAR2(255) NOT NULL,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Votante_ID) REFERENCES FIDE_VOTANTES_TB(Votante_ID)
);

CREATE TABLE FIDE_NOTIFICACIONES_TB(
    Notificacion_ID NUMBER PRIMARY KEY,
    Votante_ID NUMBER,
    Mensaje VARCHAR2(255) NOT NULL,
    FechaNotificacion DATE NOT NULL,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Votante_ID) REFERENCES FIDE_VOTANTES_TB(Votante_ID)
);

CREATE TABLE FIDE_SESIONES_TB (
    Sesion_ID NUMBER PRIMARY KEY,
    Usuario_ID NUMBER,
    FechaInicio DATE NOT NULL,
    FechaFin DATE,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Usuario_ID) REFERENCES FIDE_USUARIOS_TB(Usuario_ID)
);

CREATE TABLE FIDE_HISTORIALVOTOS_TB(
    Historial_ID NUMBER PRIMARY KEY,
    Votante_ID NUMBER,
    FechaModificacion DATE NOT NULL,
    Accion_historial VARCHAR2(50) NOT NULL,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Votante_ID) REFERENCES FIDE_VOTANTES_TB(Votante_ID)
);

CREATE TABLE FIDE_VOTOS_HISTORIAL_TB(
    Votos_Historial_ID NUMBER PRIMARY KEY,
    Voto_ID NUMBER,
    Historial_ID NUMBER,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Voto_ID) REFERENCES FIDE_VOTOS_TB(Voto_ID),
    FOREIGN KEY (Historial_ID) REFERENCES FIDE_HISTORIALVOTOS_TB(Historial_ID)
);
CREATE TABLE FIDE_RESULTADOS_TB(
    Resultado_ID NUMBER PRIMARY KEY,
    Eleccion_ID NUMBER,
    Candidato_ID NUMBER,
    Estado_ID NUMBER,
    Votos_Obtenidos NUMBER,
    creado_por VARCHAR2(50),
    modificado_por VARCHAR2(50),
    fecha_creacion DATE,
    fecha_modificacion DATE,
    accion VARCHAR2(100),
    FOREIGN KEY (Eleccion_ID) REFERENCES FIDE_ELECCIONES_TB(Eleccion_ID),
    FOREIGN KEY (Candidato_ID) REFERENCES FIDE_CANDIDATOS_TB(Candidato_ID),
    FOREIGN KEY (Estado_ID) REFERENCES FIDE_ESTADOS_TB(Estado_ID)
);
