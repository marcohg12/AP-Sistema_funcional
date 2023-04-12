const get_connection = require(".././mysql-config")
const bcrypt = require("bcrypt")

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

// Función para obtener un usuario por su username
function get_user_by_username(username){
    return new Promise(async (resolve, reject) => {
        const connection = await get_connection()
        const query = "CALL get_user_by_username(?)"
        connection.query(query, [username], (error, result) => {
            var user
            if (error){
                return null
            }
            if (result[0].length == 0){
                return resolve(user)
            }
            user = {username: result[0][0].username, password: result[0][0].user_password, 
                    photo: result[0][0].photo, user_type_id: result[0][0].user_type_ref,
                    hotel_admin_id: result[0][0].hotel_ref, hotel_client_id: result[0][0].hotel_client_id}
            return resolve(user);
        })
        connection.end()
    })
}

// Función para obtener todas las nacionalidades
function get_nationalities(){
    return new Promise(async (resolve, reject) => {
        const connection = await get_connection()
        const query = "CALL get_nationalities()"
        connection.query(query, (error, result) => {
            if (error){
                return null
            }
            const nationalities = result[0]
            return resolve(nationalities);
        })
        connection.end()
    })
}

// Función para obtener las nacionalidades que no pertenecen a un usuario
function get_nationalities_not_in_user(username){
    return new Promise(async (resolve, reject) => {
        const connection = await get_connection()
        const query = "CALL get_nationalities_not_in_user(?)"
        connection.query(query, [username], (error, result) => {
            const nationalities = result[0]
            return resolve(nationalities);
        })
        connection.end()
    })
}

// Función para obtener todos los géneros
function get_genders(){
    return new Promise(async (resolve, reject) => {
        const connection = await get_connection()
        const query = "CALL get_genders()"
        connection.query(query, (error, result) => {
            if (error){
                return null
            }
            const genders = result[0]
            return resolve(genders);
        })
        connection.end()
    })
}

// Función para obtener todos los tipos de identificación
function get_id_types(){
    return new Promise(async (resolve, reject) => {
        const connection = await get_connection()
        const query = "CALL get_id_types()"
        connection.query(query, (error, result) => {
            if (error){
                return null
            }
            const id_types = result[0]
            return resolve(id_types);
        })
        connection.end()
    })
}

// Función para obtener los datos de una persona por su nombre de usuario
function get_user_data(username){
    return new Promise(async (resolve, reject) => {
        const connection = await get_connection()
        const query = "CALL get_person_data(?)"
        connection.query(query, [username], (error, result) => {
            if (error){
                return null
            }
            const user_data = result[0][0]
            return resolve(user_data);
        })
        connection.end()
    })
}

// Función para obtener todos los teléfonos de una persona
function get_user_telephones(username){
    return new Promise(async (resolve, reject) => {
        const connection = await get_connection()
        const query = "CALL get_phones_from_user(?)"
        connection.query(query, [username], (error, result) => {
            if (error){
                return null
            }
            const phones = result[0]
            return resolve(phones);
        })
        connection.end()
    })
}

// Función para obtener todos los emails de una persona
function get_user_emails(username){
    return new Promise(async (resolve, reject) => {
        const connection = await get_connection()
        const query = "CALL get_emails_from_user(?)"
        connection.query(query, [username], (error, result) => {
            if (error){
                return null
            }
            const emails = result[0]
            return resolve(emails);
        })
        connection.end()
    })
}

// Función para obtener todas las nacionalidades de una persona
function get_user_nationalities(username){
    return new Promise(async (resolve, reject) => {
        const connection = await get_connection()
        const query = "CALL get_nationalities_from_user(?)"
        connection.query(query, [username], (error, result) => {
            if (error){
                return null
            }
            const nationalities = result[0]
            return resolve(nationalities);
        })
        connection.end()
    })
}

// Función para registrar un usuario
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
        const query = "CALL register_user(?,?,?,?,?,?,?,?,?,?,?,?,?,?,@execution_code); SELECT @execution_code AS execution_code;"

        // Registro del usuario en la base de datos
        execution_code = await execute_operation(query, fields)
        
        // Generación de la respuesta
        if (execution_code == -1){
            return ({error: true, message: "Ocurrió un error inesperado"})
        } else if (execution_code == -2){
            return ({error: true, message: "Error: el nombre de usuario ya está en uso"})
        } else if (execution_code == -3){
            return ({error: true, message: "Error: el email ya está en uso"})
        } else if (execution_code == -4){
            return ({error: true, message: "Error: la identificación ya está en uso"})
        } else {
            return ({error: false, message: ""})
        }
}

// Función para actualizar los datos generales de un usuario
async function update_user_data(username, first_name, second_name, first_last_name, second_last_name,
                                birthdate, identification_number, id_type_id, gender_id, password, photo,
                                update_password){
    
    if (update_password){
        // Encriptación de contraseña
        const salt = await bcrypt.genSalt();
        password = await bcrypt.hash(password, salt);
    }

    const fields = [username, first_name, second_name, first_last_name, second_last_name, birthdate, identification_number,
                    password, photo, gender_id, id_type_id]
    const query = "CALL update_user(?,?,?,?,?,?,?,?,?,?,?,@execution_code); SELECT @execution_code AS execution_code;"
                   
    // Actualización de los datos en la base de datos
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -4){
        return ({error: true, message: "Error: la identificación ya está en uso"})
    } else {
        return ({error: false, message: "Datos actualizados exitosamente"})
    }

}

// Función para actualizar el teléfono de una persona
async function update_user_phone(phone_id, new_phone){
    const fields = [phone_id, new_phone]
    const query = "CALL update_phone(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Teléfono actualizado exitosamente"})
    }
}

// Función para eliminar el teléfono de una persona
async function delete_phone_from_user(username, phone_id){
    const fields = [username, phone_id]
    const query = "CALL delete_phone_from_user(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -8){
        return ({error: true, message: "Error: debe tener al menos un teléfono"})
    } else {
        return ({error: false, message: "Nacionalidad eliminada exitosamente"})
    }
}

// Función para actualizar el email de una persona
async function update_user_email(username, old_email, new_email){
    //Limpieza de datos
    old_email = old_email.toLowerCase()
    new_email = new_email.toLowerCase()

    const fields = [username, old_email, new_email]
    const query = "CALL update_email(?,?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -2){
        return ({error: true, message: "Error: el email ya está en uso"})
    } else {
        return ({error: false, message: "Email actualizado exitosamente"})
    }
}

// Función para eliminar el email de una persona
async function delete_email_from_user(username, email){
    const fields = [username, email]
    const query = "CALL delete_email_from_user(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -8){
        return ({error: true, message: "Error: debe tener al menos un email"})
    } else {
        return ({error: false, message: "Nacionalidad eliminada exitosamente"})
    }
}

// Función para agregar una nacionalidad a una persona
async function add_nationality_to_user(username, nationality_id){
    const fields = [username, nationality_id]
    const query = "CALL add_nationality_to_user(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Nacionalidad agregada exitosamente"})
    }
}

// Función para eliminar una nacionalidad de una persona
async function delete_nationality_from_user(username, nationality_id){
    const fields = [username, nationality_id]
    const query = "CALL delete_nationality_from_user(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -8){
        return ({error: true, message: "Error: debe tener al menos una nacionalidad"})
    } else {
        return ({error: false, message: "Nacionalidad eliminada exitosamente"})
    }
}

// Función para agregar un email a una persona
async function add_email_to_user(username, email){

    // Limpieza de datos
    email = email.toLowerCase()

    const fields = [username, email]
    const query = "CALL add_email(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -2){
        return ({error: true, message: "Error: el email ya está en uso"})
    } else {
        return ({error: false, message: "Email agregado exitosamente"})
    }
}

// Función para agregar un teléfono a una persona
async function add_phone_to_user(username, phone){
    const fields = [username, phone]
    const query = "CALL add_phone(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Teléfono agregado exitosamente"})
    }
}

//nombres de cada funcion que hay arriba
module.exports = {
    register_user,
    get_user_by_username,
    get_nationalities,
    get_genders,
    get_id_types,
    get_user_data,
    update_user_data,
    update_user_phone,
    delete_phone_from_user,
    update_user_email,
    delete_email_from_user,
    add_nationality_to_user,
    add_email_to_user,
    add_phone_to_user,
    delete_nationality_from_user,
    get_user_telephones,
    get_user_emails,
    get_user_nationalities,
    get_nationalities_not_in_user
}