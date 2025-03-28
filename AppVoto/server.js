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
            `BEGIN FIDE_USUARIOS_VALIDAR_USUARIO_SP(:p_username, :p_password, :p_valido); END;`,
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
    const { usuarioId, userName, password, email, rolId, estadoId } = req.body;
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);
        console.log("Llega al try del PS");
        console.log("Parámetros enviados al procedimiento:", {
            p_Usuario_ID: usuarioId,
            p_User_name: userName,
            p_password: password,
            p_Email: email,
            p_Rol_ID: rolId,
            p_Estado_ID: estadoId
        });
        
        // Llamada al procedimiento almacenado
        const result = await connection.execute(
            `BEGIN FIDE_USUARIOS_INSERTAR_SP(:p_Usuario_ID, :p_User_name, :p_password, 
            :p_Email, :p_Rol_ID, :p_Estado_ID); END;`,
            {
                p_Usuario_ID: usuarioId,
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
            `BEGIN FIDE_USUARIOS_ELIMINAR_SP(:p_Usuario_ID); END;`,
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
        `BEGIN FIDE_USUARIOS_ACTUALIZAR_SP(:p_Usuario_ID, :p_User_name, :p_Password, 
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

        // Ejecutar una consulta directa desde la tabla, porque el procedimiento actual solo imprime texto
        const result = await connection.execute(
            `SELECT Usuario_ID, User_name, Password, Email, Rol_ID, Estado_ID FROM FIDE_USUARIOS_TB`,
            [], // Sin parámetros en este caso
            { outFormat: oracledb.OUT_FORMAT_OBJECT } // Formato de salida como objeto
        );

        res.json(result.rows); // Devuelve los datos al frontend
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
// Iniciar el servidor en el puerto correspondiente
app.listen(3000, '0.0.0.0', () => {
    console.log("Servidor corriendo en puerto 3000");
});
