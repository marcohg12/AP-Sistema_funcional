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

// Función para ejecutar una consulta
function execute_query(query, fields){
    return new Promise(async (resolve, reject) => {
        const connection = await get_connection()
        connection.query(query, fields, (error, result) => {
            const query_result = result[0]
            return resolve(query_result);
        })
        connection.end()
    })
}

// RUD de género ---------------------------------------------------------------------------------------------------- //

// Función para registrar un género
async function register_gender(name){

    const fields = [name]
    const query = "CALL register_gender(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Género agregado exitosamente"})
    }
}

// Función para actualizar un género
async function update_gender(gender_id, new_name){
    const fields = [gender_id, new_name]
    const query = "CALL update_gender(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Género actualizado exitosamente"})
    }
}

// Función para eliminar un género
async function delete_gender(gender_id){
    const fields = [gender_id]
    const query = "CALL delete_gender(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -8){
        return ({error: true, message: "Error: el género se encuentra en uso"})
    }else {
        return ({error: false, message: "Género eliminado exitosamente"})
    }
}

// RUD de nacionalidad ---------------------------------------------------------------------------------------------------- //

// Función para registrar una nacionalidad
async function register_nationality(name){

    const fields = [name]
    const query = "CALL register_nationality(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Nacionalidad agregada exitosamente"})
    }
}

// Función para actualizar una nacionalidad
async function update_nationality(nationality_id, new_name){
    const fields = [nationality_id, new_name]
    const query = "CALL update_nationality(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Nacionalidad actualizada exitosamente"})
    }
}

// Función para eliminar una nacionalidad
async function delete_nationality(nationality_id){
    const fields = [nationality_id]
    const query = "CALL delete_nationality(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -8){
        return ({error: true, message: "Error: la nacionalidad se encuentra en uso"})
    }else {
        return ({error: false, message: "Nacionalidad eliminada exitosamente"})
    }
}


// RUD de tipo de identificación ---------------------------------------------------------------------------------------------------- //

// Función para registrar un tipo de identificación
async function register_id_type(name, max_characters, is_alphanumeric){

    const fields = [name, max_characters, is_alphanumeric]
    const query = "CALL register_id_type(?,?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Tipo de identificación agregado exitosamente"})
    }
}

// Función para actualizar un tipo de identificación
async function update_id_type(id_type_id, new_name, new_max_characters, new_is_alphanumeric){
    const fields = [id_type_id, new_name, new_max_characters, new_is_alphanumeric]
    const query = "CALL update_id_type(?,?,?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Tipo de identificación actualizado exitosamente"})
    }
}

// Función para eliminar un tipo de identificación
async function delete_id_type(id_type_id){
    const fields = [id_type_id]
    const query = "CALL delete_id_type(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -8){
        return ({error: true, message: "Error: el tipo de identificación se encuentra en uso"})
    }else {
        return ({error: false, message: "Tipo de identificación eliminada exitosamente"})
    }
}

// RUD de país ---------------------------------------------------------------------------------------------------- //

// Función para obtener los países
async function get_countries(){
    const query = "CALL get_countries();"
    return await execute_query(query, [])
}

// Función para registrar un país
async function register_country(name){

    const fields = [name]
    const query = "CALL register_country(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "País agregado exitosamente"})
    }
}

// Función para actualizar un país
async function update_country(country_id, new_name){
    const fields = [country_id, new_name]
    const query = "CALL update_country(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "País actualizado exitosamente"})
    }
}

// Función para eliminar un país
async function delete_country(country_id){
    const fields = [country_id]
    const query = "CALL delete_country(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -8){
        return ({error: true, message: "Error: el país se encuentra en uso"})
    }else {
        return ({error: false, message: "País eliminado exitosamente"})
    }
}

// RUD de provincia ---------------------------------------------------------------------------------------------------- //

// Función para obtener las provincias de un país
async function get_provinces(country_id){
    const query = "CALL get_provinces(?);"
    const fields = [country_id]
    return await execute_query(query, fields)
}

// Función para registrar una provincia
async function register_province(country_id, name){

    const fields = [country_id, name]
    const query = "CALL register_province(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Provincia agregada exitosamente"})
    }
}

// Función para actualizar una provincia
async function update_province(province_id, new_name){
    const fields = [province_id, new_name]
    const query = "CALL update_province(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Provincia actualizada exitosamente"})
    }
}

// Función para eliminar una provincia
async function delete_province(province_id){
    const fields = [province_id]
    const query = "CALL delete_province(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -8){
        return ({error: true, message: "Error: la provincia se encuentra en uso"})
    }else {
        return ({error: false, message: "Provincia eliminada exitosamente"})
    }
}

// RUD de cantón ---------------------------------------------------------------------------------------------------- //

// Función para obtener los cantones de una provincia
async function get_cantons(province_id){
    const query = "CALL get_cantons(?);"
    const fields = [province_id]
    return await execute_query(query, fields)
}

// Función para registrar un cantón
async function register_canton(province_id, name){

    const fields = [province_id, name]
    const query = "CALL register_canton(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Cantón agregado exitosamente"})
    }
}

// Función para actualizar un cantón
async function update_canton(canton_id, new_name){
    const fields = [canton_id, new_name]
    const query = "CALL update_canton(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Cantón actualizado exitosamente"})
    }
}

// Función para eliminar un cantón
async function delete_canton(canton_id){
    const fields = [canton_id]
    const query = "CALL delete_canton(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -8){
        return ({error: true, message: "Error: el cantón se encuentra en uso"})
    }else {
        return ({error: false, message: "Cantón eliminado exitosamente"})
    }
}

// RUD de distrito ---------------------------------------------------------------------------------------------------- //

// Función para obtener los cantones de un distrito
async function get_districts(canton_id){
    const query = "CALL get_districts(?);"
    const fields = [canton_id]
    return await execute_query(query, fields)
}

// Función para registrar un distrito
async function register_district(canton_id, name){

    const fields = [canton_id, name]
    const query = "CALL register_district(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Distrito agregado exitosamente"})
    }
}

// Función para actualizar un distrito
async function update_district(district_id, new_name){
    const fields = [district_id, new_name]
    const query = "CALL update_district(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Distrito actualizado exitosamente"})
    }
}

// Función para eliminar un distrito
async function delete_district(district_id){
    const fields = [district_id]
    const query = "CALL delete_district(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -8){
        return ({error: true, message: "Error: el distrito se encuentra en uso"})
    }else {
        return ({error: false, message: "Distrito eliminado exitosamente"})
    }
}

// RUD de parámetro ---------------------------------------------------------------------------------------------------- //

// Función para obtener los parámetros del sistema
async function get_parameters(){
    const query = "CALL get_parameters();"
    return await execute_query(query, [])
}

// Función para registrar un parámetro
async function register_parameter(name, value){

    const fields = [name, value]
    const query = "CALL register_parameter(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Parámetro agregado exitosamente"})
    }
}

// Función para actualizar un parámetro
async function update_parameter(parameter_id, new_name, new_value){
    const fields = [parameter_id, new_name, new_value]
    const query = "CALL update_parameter(?,?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Parámetro actualizado exitosamente"})
    }
}

// Función para eliminar un parámetro
async function delete_parameter(parameter_id){
    const fields = [parameter_id]
    const query = "CALL delete_parameter(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Parámetro eliminado exitosamente"})
    }
}

// RUD de clasificación de hotel ---------------------------------------------------------------------------------------------------- //

// Función para obtener las clasificaciones de un hotel
async function get_classifications(){
    const query = "CALL get_classifications();"
    return await execute_query(query, [])
}

// Función para registrar una clasificación de hotel
async function register_classification(name){

    const fields = [name]
    const query = "CALL register_classification(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Clasificación agregada exitosamente"})
    }
}

// Función para actualizar una clasificación de hotel
async function update_classification(classification_id, new_name){
    const fields = [classification_id, new_name]
    const query = "CALL update_classification(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Clasificación actualizada exitosamente"})
    }
}

// Función para eliminar una clasificación de hotel
async function delete_classification(classification_id){
    const fields = [classification_id]
    const query = "CALL delete_classification(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -8){
        return ({error: true, message: "Error: la clasificación se encuentra en uso"})
    }else {
        return ({error: false, message: "Clasificación eliminada exitosamente"})
    }
}

// UD de usuario ---------------------------------------------------------------------------------------------------- //

// Función para actualizar el rol de un usuario
async function update_user_role(username, user_type_id, hotel_id){
    const fields = [username, user_type_id, hotel_id]
    const query = "CALL update_user_role(?,?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Usuario actualizado exitosamente"})
    }
}

// Función para eliminar un usuario
async function delete_user(username){
    const fields = [username]
    const query = "CALL delete_user(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Usuario eliminado exitosamente"})
    }
}

// Función para obtener los usuarios del sistema
async function get_users(username){
    const query = "CALL get_users(?);"
    return await execute_query(query, [username])
}

// Función para obtener los tipos de usuario
async function get_user_types(){
    const query = "CALL get_user_types();"
    return await execute_query(query, [])
}

// RUD de hotel ---------------------------------------------------------------------------------------------- //

// Función para obtener el catálogo de hoteles
async function get_hotel_catalog(){
    const query = "CALL get_hotel_catalog();"
    return await execute_query(query, [])
}

// Función para obtener los hoteles para administrar
async function get_hotels_to_admin(){
    const query = "CALL get_hotels_to_admin();"
    return await execute_query(query, [])
}

async function register_hotel(name, adress, district_id, classification_id){
    const fields = [name, adress, district_id, classification_id]
    const query = "CALL register_hotel(?,?,?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Hotel agregado exitosamente"})
    }
}

async function delete_hotel(hotel_id){
    const fields = [hotel_id]
    const query = "CALL delete_hotel(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Hotel eliminado exitosamente"})
    }
}

// RUD de roles de usuario ------------------------------------------------------------------------------------------ //

async function register_user_type(name){
    const fields = [name]
    const query = "CALL register_user_type(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Rol de usuario agregado exitosamente"})
    }
}

async function update_user_type(type_id, new_name){
    const fields = [type_id, new_name]
    const query = "CALL update_user_type(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Rol de usuario actualizado exitosamente"})
    }
}

async function delete_user_type(type_id){
    const fields = [type_id]
    const query = "CALL delete_user_type(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Rol de usuario eliminado exitosamente"})
    }
}


// Funciones de consultas ------------------------------------------------------------------------------------------- //

// Retorna la consulta de hoteles (hoteles registrados con total de habitaciones, reservas y montos facturados)
async function get_hotels_query(name, start_date, ending_date){
    const fields = [name, start_date, ending_date]
    const query = "CALL get_hotels_query(?,?,?);"
    return await execute_query(query, fields)
}

// Nombres de cada funcion que hay arriba
module.exports = {
    register_user_type,
    update_user_type,
    delete_user_type,
    get_hotels_query,
    register_gender,
    update_gender,
    delete_gender,
    register_nationality,
    update_nationality,
    delete_nationality,
    register_id_type,
    update_id_type,
    delete_id_type,
    register_classification,
    update_classification,
    delete_classification,
    register_parameter,
    update_parameter,
    delete_parameter,
    register_district,
    update_district,
    delete_district,
    register_canton,
    update_canton,
    delete_canton,
    register_province,
    update_province,
    delete_province,
    register_country,
    update_country,
    delete_country,
    get_countries,
    get_provinces,
    get_cantons,
    get_districts,
    get_classifications,
    get_parameters,
    get_users,
    get_user_types,
    get_hotels_to_admin,
    update_user_role,
    get_hotel_catalog,
    delete_user,
    register_hotel,
    delete_hotel
}