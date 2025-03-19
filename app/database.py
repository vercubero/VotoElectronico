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

# Menú principal
def main():
    connection = connect_to_db()
    if not connection:
        return

    connection.close()

if __name__ == "__main__":
    main()
