const express = require('express');
const oracledb = require('oracledb');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();

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

        // Llamada al procedimiento almacenado
        const result = await connection.execute(
            `BEGIN FIDE_PROYECTO_FINAL_PKG.FIDE_USUARIOS_VALIDAR_USUARIO_SP(:p_username, :p_password, :p_valido); END;`,
            {
                p_username: username,
                p_password: password,
                p_valido: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER }
            }
        );

        const valido = result.outBinds.p_valido;
        if (valido > 0) {
            res.json({ mensaje: "Usuario válido." });
        } else {
            res.status(401).json({ mensaje: "Usuario o contraseña incorrectos." });
        }
    } catch (err) {
        console.error("Error al validar usuario:", err);
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

// Iniciar el servidor en el puerto correspondiente
app.listen(3000, '0.0.0.0', () => {
    console.log("Servidor corriendo en puerto 3000");
});
