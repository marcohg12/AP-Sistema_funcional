const mysql = require("mysql")

// Configuración de MySQL
async function get_connection(){
    const connection = mysql.createConnection({
        host: "localhost",
        user: "root",
        password: "bryan",
        database: "reservation_system",
        multipleStatements: true
    })
    connection.connect()
    return connection
}

module.exports = get_connection