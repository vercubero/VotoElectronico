const oracledb = require('oracledb');
oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;

async function fun() {
    let con;

    try{
        con = await oracledb.getConnection({
            user : "FIDE_VOTO_ELECTRONICO",
            password : "123",
            connectionString : "localhost:1521/XE"
        });
        console.log("Conexion Exitosa a la BD ");
    } catch (err) {
        console.error(err);
    }
}
fun();