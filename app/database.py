import cx_Oracle
import datetime

# Configuración de conexión a la base de datos
def connect_to_db():
    try:
        connection = cx_Oracle.connect(
            user="FIDE_VOTO_ELECTRONICO",
            password="123",
            dsn="localhost:1521/XE"
        )
        print("Conexión exitosa a la base de datos")
        return connection
    except cx_Oracle.Error as error:
        print("Error al conectar a la base de datos:", error)
        return None

# Función para insertar datos
def insertar_votante(connection):
    try:
        cursor = connection.cursor()
        print("Insertar nuevo votante:")
        Votante_ID = int(input("ID del votante: "))
        Nombre = input("Nombre: ")
        Apellido = input("Apellido: ")
        Fecha_Nacimiento = input("Fecha de nacimiento (YYYY-MM-DD): ")
        Email = input("Email: ")
        Telefono = input("Teléfono: ")
        Genero_ID = int(input("ID del género: "))
        Direccion_ID = int(input("ID de la dirección: "))
        Estado_ID = int(input("ID del estado: "))
        creado_por = input("Creado por: ")
        modificado_por = input("Modificado por: ")
        Fecha_Creacion = input("Fecha de creacion (YYYY-MM-DD): ")
        Fecha_Modificacion = input("Fecha de modificacion (YYYY-MM-DD): ")
        accion = input("Acción: ")

        cursor.callproc("FIDE_VOTANTES_INSERT_SP", [
            Votante_ID, Nombre, Apellido, 
            datetime.datetime.strptime(Fecha_Nacimiento, '%Y-%m-%d'),
            Email, Telefono, Genero_ID, Direccion_ID, Estado_ID, 
            creado_por, modificado_por, datetime.datetime.strptime(Fecha_Creacion, '%Y-%m-%d'),
            datetime.datetime.strptime(Fecha_Modificacion, '%Y-%m-%d'), accion
        ])
        connection.commit()
        print("¡Votante insertado exitosamente!")
    except cx_Oracle.Error as error:
        print("Error al insertar votante:", error)

# Función para actualizar datos
def actualizar_votante(connection):
    try:
        cursor = connection.cursor()
        print("Actualizar votante existente:")
        Votante_ID = int(input("ID del votante a actualizar: "))
        Nombre = input("Nuevo nombre: ")
        Apellido = input("Nuevo apellido: ")
        Fecha_Nacimiento = input("Nueva fecha de nacimiento (YYYY-MM-DD): ")
        Email = input("Nuevo email: ")
        Telefono = input("Nuevo teléfono: ")
        Genero_ID = int(input("Nuevo ID del género: "))
        Direccion_ID = int(input("Nuevo ID de la dirección: "))
        Estado_ID = int(input("Nuevo ID del estado: "))
        creado_por = input("Creado por: ")
        modificado_por = input("Modificado por: ")
        Fecha_Creacion = input("Fecha de creacion (YYYY-MM-DD): ")
        Fecha_Modificacion = input("Fecha de modificacion (YYYY-MM-DD): ")
        accion = input("Acción: ")

        cursor.callproc("FIDE_VOTANTES_UPDATE_SP", [
            Votante_ID, Nombre, Apellido, 
            datetime.datetime.strptime(Fecha_Nacimiento, '%Y-%m-%d'),
            Email, Telefono, Genero_ID, Direccion_ID, Estado_ID, 
            creado_por, modificado_por,datetime.datetime.strptime(Fecha_Creacion, '%Y-%m-%d'),
            datetime.datetime.strptime(Fecha_Modificacion, '%Y-%m-%d'), accion
        ])
        connection.commit()
        print("¡Votante actualizado exitosamente!")
    except cx_Oracle.Error as error:
        print("Error al actualizar votante:", error)

# Función para eliminar datos
def eliminar_votante(connection):
    try:
        cursor = connection.cursor()
        print("Eliminar votante:")
        Votante_ID = int(input("ID del votante a eliminar: "))

        cursor.callproc("FIDE_VOTANTES_DELETE_SP", [Votante_ID])
        connection.commit()
        print("¡Votante eliminado exitosamente!")
    except cx_Oracle.Error as error:
        print("Error al eliminar votante:", error)

# Menú principal
def main():
    connection = connect_to_db()
    if not connection:
        return
    try:
        while True:
            print("\n--- Menú Principal ---")
            print("1. Insertar Votante")
            print("2. Actualizar Votante")
            print("3. Eliminar Votante")
            print("4. Salir")

            opcion = input("Elige una opción: ")

            if opcion == "1":
                insertar_votante(connection)
            elif opcion == "2":
                actualizar_votante(connection)
            elif opcion == "3":
                eliminar_votante(connection)
            elif opcion == "4":
                print("Saliendo del programa...")
                break
            else:
                print("Opción inválida. Por favor, elige una opción válida.")
    finally:
        connection.close()
        print("Conexión cerrada.")


if __name__ == "__main__":
    main()
