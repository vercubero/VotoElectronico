/*
// Endpoint para insertar candidato en server.js
app.post('/insertar-candidato', async (req, res) => {
    console.log("Llega a insertar datos");
    console.log("Datos recibidos:", req.body);
    const { CandidatoID, nombre, apellido, PartidoID, EleccionID, EstadoID} = req.body;
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);
        console.log("Llega al try del PS");
        console.log("Parámetros enviados al procedimiento:", {
            p_Candidato_ID: candidatoID,
            p_Nombre: nombre,
            p_Apellido: apellido,
            p_Partido_ID: PartidoID,
            p_Eleccion_ID: EleccionID,
            p_Estado_ID: EstadoID
        });
        
        // Llamada al procedimiento almacenado
        const result = await connection.execute(
            `BEGIN FIDE_CADIDATOS_INSERTAR_SP(:p_candidato_ID, :p_Nombre, :p_Apellido, 
            :p_Partido_ID, :p_Eleccion_ID, :p_Estado_ID); END;`,
            {
                p_candidato_ID: candidatoID,
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

// Endpoint para eliminar candidatoes utilizando el procedimiento almacenado
app.delete('/eliminar-candidato/:id', async (req, res) => {
    console.log("Datos recibidos:");
    const candidatoID = req.params.id; // Recuperar el ID del candidato desde los parámetros de la URL
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        // Llamamos al procedimiento almacenado para eliminar el usuario
        await connection.execute(
            `BEGIN FIDE_candidatoES_ELIMINAR_SP(:p_candidato_ID); END;`,
            { p_candidato_ID: Number(candidatoID) } // Enviamos el ID como parámetro
        );

        res.json({ message: 'candidato eliminado exitosamente.' });
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
  
      console.log("Ejecutando procedimiento para actualizar candidatoes...");
      await connection.execute(
        `BEGIN FIDE_CADIDATOS_ACTUALIZAR_SP(:p_candidato_ID, :p_Nombre, :p_Apellido, 
            :p_Partido_ID, :p_Eleccion_ID, :p_Estado_ID); END;`,

            {
                p_candidato_ID: candidatoID,
                p_Nombre: nombre,
                p_Apellido: apellido,
                p_Partido_ID: PartidoID,
                p_Eleccion_ID: EleccionID,
                p_Estado_ID: EstadoID
            }
      );
  
      res.json({ message: "candidato actualizado correctamente." });
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

        // Ejecutar una consulta directa desde la tabla, porque el procedimiento actual solo imprime texto
        const result = await connection.execute(
            `SELECT Candidato_ID, Nombre, Apellido, Partido_ID, Eleccion_ID, Estado_ID FROM FIDE_CANDIDATOS_TB`,
            [], // Sin parámetros en este caso
            { outFormat: oracledb.OUT_FORMAT_OBJECT } // Formato de salida como objeto
        );

        res.json(result.rows); // Devuelve los datos al frontend
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
});*/