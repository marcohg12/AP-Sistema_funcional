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

// RUD de habitaciones ----------------------------------------------------------------------------------------- //

// Función para registrar una habitación


// Función para actualizar una habitación


// Función para eliminar una habitación

async function delete_room(room_id){

    const fields = [room_id]
    const query = "CALL delete_room(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -8){
        return ({error: true, message: "Error: la habitación se encuentra en uso"})
    } else {
        return ({error: false, message: "Habitación eliminada exitosamente"})
    }
}

// RUD de amenidades   ----------------------------------------------------------------------------------------- //

// Función para registrar una amenidad


// Función para actualizar una amenidad


// Función para eliminar una amenidad
async function delete_amenity(amenity_id){

    const fields = [amenity_id]
    const query = "CALL delete_amenity(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -8){
        return ({error: true, message: "Error: la amenidad se encuentra en uso"})
    } else {
        return ({error: false, message: "Amenidad eliminada exitosamente"})
    }
}

// RUD de ofertas      ----------------------------------------------------------------------------------------- //

// Función para registrar una oferta


// Función para actualizar una oferta


// Función para eliminar una oferta
async function delete_deal(deal_id){

    const fields = [deal_id]
    const query = "CALL delete_deal(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -8){
        return ({error: true, message: "Error: la oferta se encuentra en uso"})
    } else {
        return ({error: false, message: "Oferta eliminada exitosamente"})
    }
}

// RUD de métodos de pago -------------------------------------------------------------------------------------- //

// Función para registrar un método de pago


// Función para actualizar un método de pago


// Función para eliminar un método de pago
async function delete_payment_method(payment_method_id){

    const fields = [payment_method_id]
    const query = "CALL delete_payment_method(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -8){
        return ({error: true, message: "Error: el método de pago se encuentra en uso"})
    } else {
        return ({error: false, message: "Método de pago eliminado exitosamente"})
    }
}


// RUD de políticas de cancelación ----------------------------------------------------------------------------- //

// Función para registrar una política de cancelación


// Función para actualizar una política de cancelación


// Función para eliminar una política de cancelación
async function delete_cancelation_policy(policy_id){

    const fields = [policy_id]
    const query = "CALL delete_cancelation_policy(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -8){
        return ({error: true, message: "Error: la política de cancelación se encuentra en uso"})
    } else {
        return ({error: false, message: "Política de cancelación eliminada exitosamente"})
    }
}


// Edición del hotel ------------------------------------------------------------------------------------------- //

// Función para actualizar un hotel

// Nombres de cada funcion que hay arriba
module.exports = {
    delete_room,
    delete_amenity,
    delete_deal,
    delete_cancelation_policy,
    delete_payment_method

}