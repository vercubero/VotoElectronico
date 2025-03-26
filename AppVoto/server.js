const express = require('express');
const oracledb = require('oracledb');
const cors = require('cors');

const app = express();

// Lista de orígenes permitidos
const allowedOrigins = ['http://192.168.100.23:5501', 'http://localhost:5500', 'http://localhost', 
    'http://127.0.0.1:5501', 'http://localhost:3000'];

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

// Otras configuraciones
app.use(express.json());
app.use(express.static('public'));

oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;

// Configuración de conexión
const dbConfig = {
    user: "Proyecto_Lenguaje",
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

// Endpoint para insertar
app.post('/insertar', async (req, res) => {
  const { tabla, datos } = req.body; // Recibe la tabla y los datos a insertar
  try {
    const connection = await oracledb.getConnection(dbConfig);
    const result = await connection.execute(
      `BEGIN insertar_${tabla}(:datos); END;`,
      { datos: datos },
      { autoCommit: true }
    );
    res.status(200).send('Registro insertado correctamente');
    await connection.close();
  } catch (err) {
    console.error(err);
    res.status(500).send('Error al insertar');
  }
});

// Endpoint para actualizar
app.put('/actualizar', async (req, res) => {
  const { tabla, id, datos } = req.body; // Recibe la tabla, el ID del registro y los datos a actualizar
  try {
    const connection = await oracledb.getConnection(dbConfig);
    const result = await connection.execute(
      `BEGIN actualizar_${tabla}(:id, :datos); END;`,
      { id: id, datos: datos },
      { autoCommit: true }
    );
    res.status(200).send('Registro actualizado correctamente');
    await connection.close();
  } catch (err) {
    console.error(err);
    res.status(500).send('Error al actualizar');
  }
});

// Endpoint para eliminar
app.delete('/eliminar', async (req, res) => {
  const { tabla, id } = req.body; // Recibe la tabla y el ID del registro a eliminar
  try {
    const connection = await oracledb.getConnection(dbConfig);
    const result = await connection.execute(
      `BEGIN eliminar_${tabla}(:id); END;`,
      { id: id },
      { autoCommit: true }
    );
    res.status(200).send('Registro eliminado correctamente');
    await connection.close();
  } catch (err) {
    console.error(err);
    res.status(500).send('Error al eliminar');
  }
});

// Iniciar el servidor en el puerto correspondiente
app.listen(3000, () => {
    console.log("Servidor corriendo en puerto 3000");
});
