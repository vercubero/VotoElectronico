
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
app.get('/eleccions', async (req, res) => {
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