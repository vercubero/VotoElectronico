const express = require('express');
const oracledb = require('oracledb');
const cors = require('cors');

const app = express();

// Lista de orígenes permitidos
const allowedOrigins = ['http://192.168.100.10:5501', 'http://localhost:5500', 'http://localhost', 'http://127.0.0.1:5501'];

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

// Iniciar el servidor en el puerto correspondiente
app.listen(3000, () => {
    console.log("Servidor corriendo en puerto 3000");
});
