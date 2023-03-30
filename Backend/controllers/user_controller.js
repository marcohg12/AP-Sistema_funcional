const get_connection = require(".././mysql-config")
const bcrypt = require("bcrypt")

//funciones
async function login (req, res){
    const connection = await get_connection()
    const query = `SELECT * FROM Country;`
    connection.query(query, (err, rows) => {
        res.render("client_hotel_list", {content: rows, error: false, message: ""})
    })
    connection.end()
}

// Función para obtener un usuario por su username
function get_user_by_username(username){
    return new Promise(async (resolve, reject) => {
        const connection = await get_connection()
        const query = "CALL get_user_by_username(?)"
        connection.query(query, [username], (error, result) => {
            if (error){
                return null
            }
            const user = {username: result[0][0].username, password: result[0][0].user_password}
            return resolve(user);
        })
        connection.end()
    })
}
// Función para registrar un usuario
function register_user_in_db(fields){
    return new Promise(async (resolve, reject) => {
        const connection = await get_connection()
        const query = "CALL register_user(?,?,?,?,?,?,?,?,?,?,?,?,?,?,@execution_code); SELECT @execution_code AS execution_code;"
        connection.query(query, fields, (error, result) => {
            return resolve(result[1][0].execution_code)
        })
        connection.end()
    })
}

async function register_user(first_name, second_name, first_surname, second_surname,
                             birthday, identification_number, username, password,
                             photo, nationality_id, telephone, email, gender_id, id_type_id){
        
        // Limpieza de datos
        username = username.toLowerCase()
        email = email.toLowerCase()

        // Encriptación de contraseña
        const salt = await bcrypt.genSalt();
        const hashed_password = await bcrypt.hash(password, salt);

        const fields = [first_name, second_name, first_surname, second_surname,
            birthday, identification_number, username, hashed_password, photo, nationality_id,
            telephone, email, gender_id, id_type_id]
        execution_code = await register_user_in_db(fields)
        
        if (execution_code == -1){
            return ({content: {}, error: true, message: "Ocurrió un error inesperado"})
        } else if (execution_code == -2){
            return ({content: {}, error: true, message: "Error: el nombre de usuario ya está en uso"})
        } else if (execution_code == -3){
            return ({content: {}, error: true, message: "Error: el email ya está en uso"})
        } else if (execution_code == -4){
            return ({content: {}, error: true, message: "Error: la identificación ya está en uso"})
        } else {
            return ({content: {}, error: false, message: ""})
        }
}

//nombres de cada funcion que hay arriba
module.exports = {
    login,
    register_user,
    get_user_by_username
}