const express = require('express');
const session = require('express-session');
const oracledb = require('oracledb');
const cors = require('cors');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');

const app = express();

// Configurar sesiones en Express
app.use(session({
    secret: 'clave-secreta',  // Clave secreta para firmar la sesión
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false } // Si usas HTTPS, pon `secure: true`
  }));



// Lista de orígenes permitidos
const allowedOrigins = ['http://192.168.100.23:5501', 'http://localhost:5500', 'http://localhost', 
    'http://127.0.0.1:5501', 'http://localhost:3000', 'http://192.168.100.10:5501'];

const corsOptions = {
  origin: function (origin, callback) {
    // Permitir peticiones sin origen (por ejemplo, llamadas de herramientas o desde el mismo servidor)
    if (!origin) return callback(null, true);
    if (allowedOrigins.indexOf(origin) !== -1) {
        callback(null, true);
    } else {
        callback(new Error('Not allowed by CORS'));
    }
  }
};

// Aplicar CORS una sola vez con la configuración adecuada
app.use(cors(corsOptions));
app.use(bodyParser.json());
// Otras configuraciones
app.use(express.json());
app.use(express.static('public'));
app.use(cookieParser());


oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;

// Configuración de conexión
const dbConfig = {
    user: "FIDE_VOTO_ELECTRONICO",
    password: "123",
    connectionString: "localhost:1521/XE"
    
};

// Endpoint para validar usuario
app.post('/validar-usuario', async (req, res) => {
    console.log("Datos recibidos:", req.body);
    const { username, password } = req.body;
    let connection;
  
    try {
      connection = await oracledb.getConnection(dbConfig);
  
      // Validación del usuario con nombre de usuario y contraseña
      const usuarioResult = await connection.execute(
        `BEGIN FIDE_PROYECTO_FINAL_PKG.FIDE_USUARIOS_VALIDAR_USUARIO_SP(:p_username, :p_password, :p_valido); END;`,
        {
          p_username: username,
          p_password: password,
          p_valido: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER }
        }
      );
      
      const usuarioValido = usuarioResult.outBinds.p_valido;
      console.log(`🔹 Usuario válido: ${usuarioValido}`);
  
      if (usuarioValido > 0) {
        // Obtener Usuario_ID usando un bloque anónimo PL/SQL
        const usuarioIDResult = await connection.execute(
          `DECLARE 
             v_usuarioID NUMBER;
           BEGIN 
             v_usuarioID := FIDE_USUARIOS_OBTENERID_FN(:p_username);
             :p_usuarioID := v_usuarioID;
           END;`,
          {
            p_username: username,
            p_usuarioID: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER }
          }
        );
  
        const usuarioID = usuarioIDResult.outBinds.p_usuarioID;
        console.log(`✅ Usuario ID obtenido: ${usuarioID}`);

         // Guardar el usuarioID en la sesión
         req.session.usuarioID = usuarioID;
         console.log(`📝 Usuario ID guardado en sesión: ${req.session.usuarioID}`);

        if (usuarioID) {
          // Insertar sesión con el Usuario_ID obtenido
          await connection.execute(
            `BEGIN FIDE_PROYECTO_FINAL_PKG.FIDE_SESIONES_INSERTAR_SP(:p_Usuario_ID); END;`,
            { p_Usuario_ID: usuarioID }
          );
          await connection.commit();
        }
  
        res.json({
          mensaje: "Usuario válido. Redirigiendo a admin.html.",
          redireccion: "http://192.168.100.23:5501/panel_admin.html"
        });
  
      } else {
        // Validación de credenciales
        const cedulaNumero = Number(username);
  
        const credencialResult = await connection.execute(
          `BEGIN FIDE_CREDENCIALES_VALIDAR_CREDENCIAL_SP(:p_cedula, :p_codigo, :p_resultado); END;`,
          {
            p_cedula: cedulaNumero,
            p_codigo: password,
            p_resultado: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER }
          }
        );
  
        const credencialValida = credencialResult.outBinds.p_resultado;
  
        if (credencialValida === 1) {
          res.json({
            mensaje: "Credencial válida. Redirigiendo a proceso_voto.html.",
            redireccion: "http://192.168.100.23:5501/panel_v.html"
          });
        } else {
          res.status(401).json({ mensaje: "Cédula o código incorrectos." });
        }
      }
    } catch (err) {
      console.error("Error en la validación:", err);
      res.status(500).json({ mensaje: "Error interno del servidor." });
    } finally {
      if (connection) {
        try {
          await connection.close();
        } catch (closeErr) {
          console.error("Error al cerrar la conexión:", closeErr);
        }
      }
    }
  });  

// Endpoint para obtener el Usuario_ID desde la sesión
app.get('/obtener-usuario-id', (req, res) => {
    if (req.session.usuarioID) {
      res.json({ usuarioID: req.session.usuarioID });
    } else {
      res.status(401).json({ mensaje: "No hay sesión activa." });
    }
  });

// Endpoint para insertar usuario en server.js
app.post('/insertar-usuario', async (req, res) => {
    console.log("Llega a insertar datos");
    console.log("Datos recibidos:", req.body);
    const { userName, password, email, rolId, estadoId } = req.body;
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);
        console.log("Llega al try del PS");
        console.log("Parámetros enviados al procedimiento:", {
            
            p_User_name: userName,
            p_password: password,
            p_Email: email,
            p_Rol_ID: rolId,
            p_Estado_ID: estadoId
        });
        
        // Llamada al procedimiento almacenado
        const result = await connection.execute(
            `BEGIN FIDE_PROYECTO_FINAL_PKG.FIDE_USUARIOS_INSERTAR_SP(:p_User_name, :p_password, 
            :p_Email, :p_Rol_ID, :p_Estado_ID); END;`,
            {
                
                p_User_name: userName,
                p_password: password,
                p_Email: email,
                p_Rol_ID: rolId,
                p_Estado_ID: estadoId
                
            }
        );
        
    } catch (err) {
        console.error("Error al Insertar usuario:", err);
        res.status(500).json({ message: "Error interno del servidor." });
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (closeErr) {
                console.error("Error al cerrar la conexión:", closeErr);
            }
        }
    }
    res.status(200).json({ message: 'Usuario insertado correctamente.' });
});

// Endpoint para eliminar usuarios utilizando el procedimiento almacenado
app.delete('/eliminar-usuario/:id', async (req, res) => {
    console.log("Datos recibidos:");
    const usuarioId = req.params.id; // Recuperar el ID del usuario desde los parámetros de la URL
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        // Llamamos al procedimiento almacenado para eliminar el usuario
        await connection.execute(
            `BEGIN FIDE_PROYECTO_FINAL_PKG.FIDE_USUARIOS_ELIMINAR_SP(:p_Usuario_ID); END;`,
            { p_Usuario_ID: Number(usuarioId) } // Enviamos el ID como parámetro
        );

       // await connection.commit(); // Aseguramos la transacción
        res.json({ message: 'Usuario eliminado exitosamente.' });
    } catch (err) {
        console.error('Error al eliminar usuario:', err);
        res.status(500).send({ message: 'Error al eliminar usuario.' });
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (err) {
                console.error('Error al cerrar conexión:', err);
            }
        }
    }
});

// Endpoint para actualizar usuario utilizando el procedimiento almacenado
app.put('/actualizar-usuario', async (req, res) => {
    console.log("Datos recibidos para actualización:", req.body);
    const { usuarioId, userName, password, email, rolId, estadoId } = req.body;
    let connection;
  
    try {
      connection = await oracledb.getConnection(dbConfig);
  
      console.log("Ejecutando procedimiento para actualizar usuario...");
      await connection.execute(
        `BEGIN FIDE_PROYECTO_FINAL_PKG.FIDE_USUARIOS_ACTUALIZAR_SP(:p_Usuario_ID, :p_User_name, :p_Password, 
        :p_Email, :p_Rol_ID, :p_Estado_ID); END;`,
        {
          p_Usuario_ID: usuarioId,
          p_User_name: userName,
          p_Password: password,
          p_Email: email,
          p_Rol_ID: rolId,
          p_Estado_ID: estadoId,
        }
      );
  
      res.json({ message: "Usuario actualizado correctamente." });
    } catch (err) {
      console.error("Error al actualizar usuario:", err);
      res.status(500).json({ message: "Error interno del servidor." });
    } finally {
      if (connection) {
        try {
          await connection.close();
        } catch (closeErr) {
          console.error("Error al cerrar conexión:", closeErr);
        }
      }
    }
  });

// Endpoint para obtener todos los usuarios
app.get('/usuarios', async (req, res) => {
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        const result = await connection.execute(
            `BEGIN FIDE_PROYECTO_FINAL_PKG.FIDE_USUARIOS_SELECT_SP(:p_cursor); END;`,
            { p_cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT } }
        );
        
        // Procesar los resultados del cursor
        const rows = [];
        const cursor = result.outBinds.p_cursor;
        
        let row;
        while ((row = await cursor.getRow())) {
            rows.push(row);
        }
        
        await cursor.close();
        
        res.json(rows); // Devuelve los datos al frontend
        
    } catch (err) {
        console.error('Error al obtener usuarios:', err);
        res.status(500).send('Error al obtener usuarios.');
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (err) {
                console.error('Error al cerrar conexión:', err);
            }
        }
    }
});

// Endpoint para insertar auditor en server.js
app.post('/insertar-auditor', async (req, res) => {
    console.log("Llega a insertar datos");
    console.log("Datos recibidos:", req.body);
    const { nombre, apellido, email, telefono } = req.body;
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);
        console.log("Llega al try del PS");
        console.log("Parámetros enviados al procedimiento:", {
            
            p_Nombre: nombre,
            p_Apellido: apellido,
            p_Email: email,
            p_Telefono: telefono
        });
        
        // Llamada al procedimiento almacenado
        const result = await connection.execute(
            `BEGIN FIDE_PROYECTO_FINAL_PKG.FIDE_AUDITORES_INSERTAR_SP(:p_Nombre, :p_Apellido, 
            :p_Email, :p_Telefono); END;`,
            {
                
                p_Nombre: nombre,
                p_Apellido: apellido,
                p_Email: email,
                p_Telefono: telefono
                
            }
        );
        
    } catch (err) {
        console.error("Error al Insertar Auditor:", err);
        res.status(500).json({ message: "Error interno del servidor." });
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (closeErr) {
                console.error("Error al cerrar la conexión:", closeErr);
            }
        }
    }
    res.status(200).json({ message: 'Auditor insertado correctamente.' });
});

// Endpoint para eliminar auditores utilizando el procedimiento almacenado
app.delete('/eliminar-auditor/:id', async (req, res) => {
    console.log("Datos recibidos:");
    const auditorID = req.params.id; // Recuperar el ID del auditor desde los parámetros de la URL
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        // Llamamos al procedimiento almacenado para eliminar el usuario
        await connection.execute(
            `BEGIN FIDE_PROYECTO_FINAL_PKG.FIDE_AUDITORES_ELIMINAR_SP(:p_Auditor_ID); END;`,
            { p_Auditor_ID: Number(auditorID) } // Enviamos el ID como parámetro
        );

        res.json({ message: 'Auditor eliminado exitosamente.' });
    } catch (err) {
        console.error('Error al eliminar Auditor:', err);
        res.status(500).send({ message: 'Error al eliminar Auditor.' });
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (err) {
                console.error('Error al cerrar conexión:', err);
            }
        }
    }
});

// Endpoint para actualizar auditor utilizando el procedimiento almacenado
app.put('/actualizar-auditor', async (req, res) => {
    console.log("Datos recibidos para actualización:", req.body);
    const { auditorID, nombre, apellido, email, telefono  } = req.body;
    let connection;
  
    try {
      connection = await oracledb.getConnection(dbConfig);
  
      console.log("Ejecutando procedimiento para actualizar auditores...");
      await connection.execute(
        `BEGIN FIDE_PROYECTO_FINAL_PKG.FIDE_AUDITORES_ACTUALIZAR_SP(:p_Auditor_ID, :p_Nombre, :p_Apellido, 
            :p_Email, :p_Telefono); END;`,

            {
                p_Auditor_ID: auditorID,
                p_Nombre: nombre,
                p_Apellido: apellido,
                p_Email: email,
                p_Telefono: telefono
                
            }
      );
  
      res.json({ message: "auditor actualizado correctamente." });
    } catch (err) {
      console.error("Error al actualizar auditor:", err);
      res.status(500).json({ message: "Error interno del servidor." });
    } finally {
      if (connection) {
        try {
          await connection.close();
        } catch (closeErr) {
          console.error("Error al cerrar conexión:", closeErr);
        }
      }
    }
  });
  

// Endpoint para obtener todos los usuarios
app.get('/auditores', async (req, res) => {
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        const result = await connection.execute(
            `BEGIN FIDE_PROYECTO_FINAL_PKG.FIDE_AUDITORES_SELECT_SP(:p_cursor); END;`,
            { p_cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT } }
        );
        
        // Procesar los resultados del cursor
        const rows = [];
        const cursor = result.outBinds.p_cursor;
        
        let row;
        while ((row = await cursor.getRow())) {
            rows.push(row);
        }
        
        await cursor.close();
        
        res.json(rows); // Devuelve los datos al frontend
        
    } catch (err) {
        console.error('Error al obtener usuarios:', err);
        res.status(500).send('Error al obtener usuarios.');
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (err) {
                console.error('Error al cerrar conexión:', err);
            }
        }
    }
});

// Endpoint para insertar candidato en server.js
app.post('/insertar-candidato', async (req, res) => {
    console.log("Llega a insertar datos");
    console.log("Datos recibidos:", req.body);
    const { nombre, apellido, PartidoID, EleccionID, EstadoID} = req.body;
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);
        console.log("Llega al try del PS");
        console.log("Parámetros enviados al procedimiento:", {
            
            p_Nombre: nombre,
            p_Apellido: apellido,
            p_Partido_ID: PartidoID,
            p_Eleccion_ID: EleccionID,
            p_Estado_ID: EstadoID
        });
        
        // Llamada al procedimiento almacenado
        const result = await connection.execute(
            `BEGIN FIDE_PROYECTO_FINAL_PKG.FIDE_CANDIDATOS_INSERTAR_SP(:p_Nombre, :p_Apellido, 
            :p_Partido_ID, :p_Eleccion_ID, :p_Estado_ID); END;`,
            {
                
                p_Nombre: nombre,
                p_Apellido: apellido,
                p_Partido_ID: PartidoID,
                p_Eleccion_ID: EleccionID,
                p_Estado_ID: EstadoID
            }
        );
        
    } catch (err) {
        console.error("Error al Insertar candidato:", err);
        res.status(500).json({ message: "Error interno del servidor." });
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (closeErr) {
                console.error("Error al cerrar la conexión:", closeErr);
            }
        }
    }
    res.status(200).json({ message: 'candidato insertado correctamente.' });
});

// Endpoint para eliminar candidatos utilizando el procedimiento almacenado
app.delete('/eliminar-candidato/:id', async (req, res) => {
    const candidatoID = req.params.id; // Recuperar el ID del candidato desde los parámetros de la URL
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        // Llamamos al procedimiento almacenado para eliminar el usuario
        await connection.execute(
            `BEGIN FIDE_PROYECTO_FINAL_PKG.FIDE_CANDIDATOS_ELIMINAR_SP(:p_candidato_ID); END;`,
            { p_candidato_ID: Number(candidatoID) } // Enviamos el ID como parámetro
        );

        res.json({ message: 'Candidato eliminado exitosamente.' });
    } catch (err) {
        console.error('Error al eliminar candidato:', err);
        res.status(500).send({ message: 'Error al eliminar candidato.' });
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (err) {
                console.error('Error al cerrar conexión:', err);
            }
        }
    }
});

// Endpoint para actualizar candidato utilizando el procedimiento almacenado
app.put('/actualizar-candidato', async (req, res) => {
    console.log("Datos recibidos para actualización:", req.body);
    const { CandidatoID, nombre, apellido, PartidoID, EleccionID, EstadoID } = req.body;
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        console.log("Ejecutando procedimiento para actualizar candidatos...");
        await connection.execute(
            `BEGIN FIDE_PROYECTO_FINAL_PKG.FIDE_CANDIDATOS_ACTUALIZAR_SP(:p_candidato_ID, :p_Nombre, :p_Apellido, 
                :p_Partido_ID, :p_Eleccion_ID, :p_Estado_ID); END;`,
            {
                p_candidato_ID: CandidatoID,
                p_Nombre: nombre,
                p_Apellido: apellido,
                p_Partido_ID: PartidoID,
                p_Eleccion_ID: EleccionID,
                p_Estado_ID: EstadoID
            }
        );

        res.json({ message: "Candidato actualizado correctamente." });
    } catch (err) {
        console.error("Error al actualizar candidato:", err);
        res.status(500).json({ message: "Error interno del servidor." });
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (closeErr) {
                console.error("Error al cerrar conexión:", closeErr);
            }
        }
    }
});


// Endpoint para obtener todos los candidatos
app.get('/candidatos', async (req, res) => {
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        const result = await connection.execute(
            `BEGIN FIDE_PROYECTO_FINAL_PKG.FIDE_CANDIDATOS_SELECT_SP(:p_cursor); END;`,
            { p_cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT } }
        );
        
        // Procesar los resultados del cursor
        const rows = [];
        const cursor = result.outBinds.p_cursor;
        
        let row;
        while ((row = await cursor.getRow())) {
            rows.push(row);
        }
        
        await cursor.close();
        
        res.json(rows); // Devuelve los datos al frontend
    } catch (err) {
        console.error('Error al obtener candidatos:', err);
        res.status(500).send('Error al obtener candidatos.');
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (err) {
                console.error('Error al cerrar conexión:', err);
            }
        }
    }
});

app.post('/generar-y-obtener-credenciales', async (req, res) => {
    const { cedula, fecha } = req.body; // Recibe cédula y fecha como parámetros
    console.log("Datos recibidos:", { cedula, fecha });
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        // Validar la cédula con el procedimiento almacenado para obtener el VOTANTE_ID
        const votanteResult = await connection.execute(
            `BEGIN FIDE_VOTANTES_VALIDA_CEDULA_SP(:p_cedula, :v_votante_id); END;`,
            {
                p_cedula: cedula,
                v_votante_id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER }
            }
        );

        const votanteId = votanteResult.outBinds.v_votante_id;

        if (!votanteId) {
            return res.status(404).json({ mensaje: "Cédula no encontrada." });
        }

        // Consultar el Eleccion_ID basándose en la fecha proporcionada
        const eleccionResult = await connection.execute(
            `BEGIN :eleccionId := FIDE_ELECCIONES_OBTENER_ID_POR_FECHA_FN(TO_DATE(:fecha, 'DD/MM/YYYY')); END;`,
            {
                fecha,
                eleccionId: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER }
            }
        );

        const eleccionId = eleccionResult.outBinds.eleccionId;

        if (!eleccionId) {
            return res.status(404).json({ mensaje: "Fecha de elección no encontrada." });
        }

        // Insertar las credenciales en la base de datos usando el procedimiento almacenado
        await connection.execute(
            `BEGIN FIDE_CREDENCIALES_INSERTAR_SP(:votanteId, :eleccionId); END;`,
            { votanteId, eleccionId }
        );

        console.log("Credenciales generadas correctamente.");

        // Obtener las credenciales generadas (Código y Fecha de Emisión)
        const credencialesResult = await connection.execute(
            `BEGIN FIDE_CREDENCIALES_SELEC_CODIGO_SP(:p_votante_id, :p_cursor); END;`,
            {
                p_votante_id: votanteId,
                p_cursor: { dir: oracledb.BIND_OUT, type: oracledb.CURSOR }
            }
            
        );

        const resultSet = credencialesResult.outBinds.p_cursor;
        const credenciales = [];
        console.log("Contenido de credencialesA:", credenciales);

        let row;
        while ((row = await resultSet.getRow())) {
            console.log("Datos obtenidos del cursor EN EL WILE:", row);
            credenciales.push({ codigo: row.CODIGO, fechaEmision: row.FECHAEMISION });

        }
        console.log("Contenido de credencialesD:", credenciales);

        // Cerrar el cursor
        await resultSet.close();

        if (credenciales.length > 0) {
            const ultimaCredencial = credenciales[credenciales.length - 1];
            res.json(ultimaCredencial);
            console.log("ultimacredencial ",ultimaCredencial);
        } else {
            res.status(404).json({ mensaje: "No se encontraron credenciales para el votante." });
        }
    } catch (err) {
        console.error("Error al generar o obtener credenciales:", err);
        res.status(500).json({ mensaje: "Error interno del servidor." });
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (closeErr) {
                console.error("Error al cerrar la conexión:", closeErr);
            }
        }
    }
});

app.post('/proceso-votacion', async (req, res) => {
    let connection;
    const { tipo, eleccionId, candidatoId, votanteId } = req.body;

    console.log("Solicitud recibida:", req.body); // Para depuración

    try {
        connection = await oracledb.getConnection(dbConfig);

        if (tipo === "cargar-candidatos") {
            console.log("Cargando candidatos para eleccionId:", eleccionId);

            const result = await connection.execute(
                `BEGIN FIDE_CANDIDATOS_SELEC_POR_ELECCIONID_SP(:eleccionId, :cursor); END;`,
                {
                    eleccionId: eleccionId,
                    cursor: { dir: oracledb.BIND_OUT, type: oracledb.CURSOR }
                }
            );

            const resultSet = result.outBinds.cursor;
            const candidatos = [];
            let row;

            while ((row = await resultSet.getRow())) {
                console.log("Candidato encontrado:", row);
                candidatos.push({
                    id: row.CANDIDATO_ID,
                    nombre: row.NOMBRE,
                    apellido: row.APELLIDO
                });
            }

            await resultSet.close();
            res.json(candidatos);
        } else if (tipo === "insertar-voto") {
            console.log("Insertando voto para votanteId:", votanteId, "EleccionId:",eleccionId, "candidatoId:", candidatoId);

            await connection.execute(
                `BEGIN FIDE_VOTOS_INSERT_SP(:votanteId, :eleccionId, :candidatoId); END;`,
                { votanteId, eleccionId, candidatoId }
            );

            res.json({ exito: true });
        } else {
            res.status(400).json({ mensaje: "Tipo de operación no válida." });
        }
    } catch (error) {
        console.error("Error en el endpoint:", error);
        res.status(500).json({ mensaje: "Error interno del servidor." });
    } finally {
        if (connection) {
            try {
                await connection.close();
                console.log("Conexión cerrada.");
            } catch (closeErr) {
                console.error("Error al cerrar la conexión:", closeErr);
            }
        }
    }
});

app.post('/cerrar-sesion', cors({ origin: "http://192.168.100.23:5501", credentials: true }), async (req, res) => {
    console.log("📌 Iniciando proceso de cierre de sesión...");
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);
        console.log("✅ Conexión a la base de datos establecida.");

        let usuarioID;

        // Ejecutar el procedimiento FIDE_SESIONES_OBTENER_ULTIMO_USERID_SP
        const obtenerUsuario = await connection.execute(
            `BEGIN 
                FIDE_SESIONES_OBTENER_ULTIMO_USERID_SP(:p_usuarioID);
            END;`,
            { p_usuarioID: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER } }
        );

        usuarioID = obtenerUsuario.outBinds.p_usuarioID;
        console.log(`🔹 Usuario ID obtenido: ${usuarioID}`);

        if (!usuarioID) {
            console.log("⚠️ No se pudo recuperar el Usuario ID.");
            return res.status(401).json({ mensaje: "No hay sesión activa." });
        }

        // Ejecutar FIDE_SESIONES_ACTUALIZAR_SP para cerrar la sesión
        const fechaFin = new Date().toISOString(); // Obtener fecha/hora actual en formato ISO
        await connection.execute(
            `BEGIN 
                FIDE_SESIONES_ACTUALIZAR_SP(:p_Usuario_ID, :p_FechaFin);
            END;`,
            {
                p_Usuario_ID: usuarioID,
                p_FechaFin: null
            }
        );
        await connection.commit();
        console.log("🔄 Procedimiento FIDE_SESIONES_ACTUALIZAR_SP ejecutado con éxito.");

        // Destruir la sesión del usuario
        req.session.destroy((err) => {
            if (err) {
                console.error("❌ Error al cerrar sesión:", err);
                return res.status(500).json({ mensaje: "Error al cerrar sesión." });
            }
            console.log("✅ Sesión destruida correctamente.");
            res.json({ mensaje: "Sesión cerrada correctamente." });
        });

    } catch (err) {
        console.error("❌ Error en el procedimiento de cierre de sesión:", err);
        res.status(500).json({ mensaje: "Error interno del servidor." });
    } finally {
        if (connection) {
            try {
                await connection.close();
                console.log("🔒 Conexión cerrada correctamente.");
            } catch (closeErr) {
                console.error("❌ Error al cerrar la conexión:", closeErr);
            }
        }
    }
});

// Endpoint para insertar eleccion en server.js
app.post('/insertar-eleccion', async (req, res) => {
    console.log("Llega a insertar datos");
    console.log("Datos recibidos:", req.body);
    const { nombre, fecha_inicio, fecha_fin, descripcion, estadoID} = req.body;
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);
        console.log("Llega al try del PS");
        console.log("Parámetros enviados al procedimiento:", {
            
            p_Nombre: nombre,
            p_fecha_inicio: fecha_inicio,
            p_fecha_fin: fecha_fin,
            p_descripcion: descripcion,
            p_Estado_ID: estadoID
        });
        
        // Llamada al procedimiento almacenado
        const result = await connection.execute(
            `BEGIN FIDE_ELECCIONES_INSERT_SP(:p_Nombre, :p_fecha_inicio, 
            :p_fecha_fin, :p_descripcion, :p_Estado_ID); END;`,
            {
                p_Nombre: nombre,
                p_fecha_inicio: fecha_inicio,
                p_fecha_fin: fecha_fin,
                p_descripcion: descripcion,
                p_Estado_ID: estadoID
            }
        );
        
    } catch (err) {
        console.error("Error al Insertar eleccion:", err);
        res.status(500).json({ message: "Error interno del servidor." });
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (closeErr) {
                console.error("Error al cerrar la conexión:", closeErr);
            }
        }
    }
    res.status(200).json({ message: 'eleccion insertado correctamente.' });
});

// Endpoint para eliminar elecciones utilizando el procedimiento almacenado
app.delete('/eliminar-eleccion/:id', async (req, res) => {
    console.log("Datos recibidos:");
    const eleccionID = req.params.id; // Recuperar el ID del eleccion desde los parámetros de la URL
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        // Llamamos al procedimiento almacenado para eliminar el usuario
        await connection.execute(
            `BEGIN FIDE_eleccionES_ELIMINAR_SP(:p_eleccion_ID); END;`,
            { p_eleccion_ID: Number(eleccionID) } // Enviamos el ID como parámetro
        );

        res.json({ message: 'eleccion eliminado exitosamente.' });
    } catch (err) {
        console.error('Error al eliminar eleccion:', err);
        res.status(500).send({ message: 'Error al eliminar eleccion.' });
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (err) {
                console.error('Error al cerrar conexión:', err);
            }
        }
    }
});

// Endpoint para actualizar eleccion utilizando el procedimiento almacenado
app.put('/actualizar-eleccion', async (req, res) => {
    console.log("Datos recibidos para actualización:", req.body);
    const { eleccionID, nombre, fecha_inicio, fecha_fin, descripcion, estadoID } = req.body;
    let connection;
  
    try {
      connection = await oracledb.getConnection(dbConfig);
  
      console.log("Ejecutando procedimiento para actualizar elecciones...");
      await connection.execute(
        `BEGIN FIDE_CADIDATOS_ACTUALIZAR_SP(:p_eleccion_ID, :p_Nombre, :p_fecha_inicio, 
            :p_fecha_fin, :p_descripcion, :p_Estado_ID); END;`,

            {
                p_eleccion_ID: eleccionID,
                p_Nombre: nombre,
                p_fecha_inicio: fecha_inicio,
                p_fecha_fin: fecha_fin,
                p_descripcion: descripcion,
                p_Estado_ID: estadoID
            }
      );
  
      res.json({ message: "eleccion actualizado correctamente." });
    } catch (err) {
      console.error("Error al actualizar eleccion:", err);
      res.status(500).json({ message: "Error interno del servidor." });
    } finally {
      if (connection) {
        try {
          await connection.close();
        } catch (closeErr) {
          console.error("Error al cerrar conexión:", closeErr);
        }
      }
    }
  });
  

// Endpoint para obtener todos los eleccions
app.get('/elecciones', async (req, res) => {
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        // Ejecutar una consulta directa desde la tabla, porque el procedimiento actual solo imprime texto
        const result = await connection.execute(
            `SELECT eleccion_ID, Nombre, Apellido, Partido_ID, Eleccion_ID, Estado_ID FROM FIDE_eleccionS_TB`,
            [], // Sin parámetros en este caso
            { outFormat: oracledb.OUT_FORMAT_OBJECT } // Formato de salida como objeto
        );

        res.json(result.rows); // Devuelve los datos al frontend
    } catch (err) {
        console.error('Error al obtener eleccions:', err);
        res.status(500).send('Error al obtener eleccions.');
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (err) {
                console.error('Error al cerrar conexión:', err);
            }
        }
    }
});


// Iniciar el servidor en el puerto correspondiente
app.listen(3000, '0.0.0.0', () => {
    console.log("Servidor corriendo en puerto 3000");
});
