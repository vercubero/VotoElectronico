import cx_Oracle
import datetime

# Configuración de conexión a la base de datos
def connect_to_db():
    try:
        connection = cx_Oracle.connect(
            user="FIDE_VOTO_ELECTRONICO",
            password="123",
            dsn="localhost:1521/XE"  # Modifica con el host y servicio de tu base de dato
        )
        print("Conexión exitosa a la base de datos")
        return connection
    except cx_Oracle.Error as error:
        print("Error al conectar a la base de datos:", error)
        return None

# Función para autenticar al votante
def authenticate_voter(connection, voter_id, clave):
    cursor = connection.cursor()
    query = """
        SELECT Votante_ID 
        FROM FIDE_CLAVES_SEGURIDAD_TB
        WHERE Votante_ID = :voter_id AND Clave = :clave
    """
    cursor.execute(query, {"voter_id": voter_id, "clave": clave})
    result = cursor.fetchone()
    cursor.close()
    if result:
        return True
    else:
        return False

# Función para registrar el voto
def cast_vote(connection, votante_id, eleccion_id, candidato_id):
    try:
        cursor = connection.cursor()
        # Verificar si el votante ya ha votado
        query_check = """
            SELECT COUNT(*) 
            FROM FIDE_VOTOS_TB 
            WHERE Votante_ID = :votante_id AND Eleccion_ID = :eleccion_id
        """
        cursor.execute(query_check, {"votante_id": votante_id, "eleccion_id": eleccion_id})
        already_voted = cursor.fetchone()[0]

        if already_voted > 0:
            print("Ya has emitido tu voto para esta elección.")
            return False

        # Registrar el voto
        query_insert = """
    INSERT INTO FIDE_VOTOS_TB (
        Voto_ID, Votante_ID, Eleccion_ID, Candidato_ID, Fecha_Voto, Detalle_Voto,
        creado_por, modificado_por, fecha_creacion, fecha_modificacion, accion
    )
    VALUES (
        FIDE_VOTOS_SEQ.NEXTVAL, :votante_id, :eleccion_id, :candidato_id, :fecha_voto, :detalle_voto,
        NULL, NULL, NULL, NULL, NULL
    )
"""
        cursor.execute(query_insert, {
            "votante_id": votante_id,
            "eleccion_id": eleccion_id,
            "candidato_id": candidato_id,
            "fecha_voto": datetime.datetime.now(),
            "detalle_voto": "Voto registrado electrónicamente"
        })
        connection.commit()
        print("¡Voto emitido exitosamente!")
        return True
    except cx_Oracle.Error as error:
        print("Error al registrar el voto:", error)
        return False
    finally:
        cursor.close()

# Menú principal
def main():
    connection = connect_to_db()
    if not connection:
        return

    print("\n--- Bienvenido al Sistema de Voto Electrónico ---")
    voter_id = int(input("Ingresa tu ID de votante: "))
    clave = input("Ingresa tu clave de seguridad: ")

    if authenticate_voter(connection, voter_id, clave):
        print("Autenticación exitosa.")
        eleccion_id = int(input("Ingresa el ID de la elección: "))
        candidato_id = int(input("Ingresa el ID del candidato por el que deseas votar: "))
        
        if cast_vote(connection, voter_id, eleccion_id, candidato_id):
            print("Gracias por participar en esta elección.")
        else:
            print("No se pudo completar el proceso de votación.")
    else:
        print("Autenticación fallida. Por favor, verifica tus credenciales.")

    connection.close()

if __name__ == "__main__":
    main()
