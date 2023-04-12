const get_connection = require(".././mysql-config")

// Función para ejecutar una operación (insert, delete, update) en la base de datos
// Retorna el código de ejecución del prodecimiento
function execute_operation(query, fields){
    return new Promise(async (resolve, reject) => {
        const connection = await get_connection()
        connection.query(query, fields, (error, result) => {
            return resolve(result[1][0].execution_code)
        })
        connection.end()
    })
}