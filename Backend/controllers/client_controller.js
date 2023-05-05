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
            return resolve(query_result)
        })
        connection.end()
    })
}

// Pantalla de lista de hoteles --------------------------------------------------------------------------- //

// Retorna el lista de hoteles para el cliente
async function get_hotels(){
    const query = "CALL get_hotels_list();"
    return await execute_query(query, [])
}
// Pantalla de detalles del hotel ------------------------------------------------------------------------- //
async function get_hotel_data(hotel_id){
    const query = "CALL get_hotel_data_for_client(?);"
    const data = await execute_query(query, [hotel_id])
    return data[0]
}

async function get_rooms_to_book(hotel_id){
    const query = "CALL get_rooms_to_book(?);"
    return await execute_query(query, [hotel_id])
}

// Función para obtener las ofertas de un hotel disponibles en la fecha actual
async function get_hotel_deals_for_clients(hotel_id){
    const fields = [hotel_id]
    const query = "CALL get_hotel_deals_for_clients(?);"
    return await execute_query(query, fields)
}

// Pantalla de reservas ------------------------------------------------------------------------------------ //

async function get_rooms_in_booking(booking_id){
    const query = "CALL get_rooms_in_booking(?);"
    return await execute_query(query, [booking_id])
}

// Agrega una habitación a una reserva con las unidades y precio indicados
async function add_room_to_booking(booking_id, room_id, units, price){

    if (price == ""){
        price = null
    }
    const fields = [booking_id, room_id, units, price]
    const query = "CALL add_room_to_booking(?,?,?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Habitación agregada exitosamente"})
    }
}

// Elimina una habitación de una reserva
async function delete_room_from_booking(booking_id, room_id){
    const fields = [room_id, booking_id]
    const query = "CALL delete_room_from_booking(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Habitación eliminada exitosamente"})
    }
}

// Pantalla de detalles de habitación --------------------------------------------------------------------- //

// Obtiene los detalles de una habitación
async function get_room_detail(room_id){
    const query = "CALL get_room_detail(?);"
    const data = await execute_query(query, [room_id])
    return data[0]
}

// Pantalla de lista de ofertas --------------------------------------------------------------------------- //


// Pantalla de hoteles favoritos -------------------------------------------------------------------------- //

// Obtiene los hoteles favoritos de un usuario
async function get_user_favorite_hotels(username){
    const query = "CALL get_user_favorite_hotels(?);"
    return await execute_query(query, [username])
}

// Agregar un hotel a la lista de hoteles favoritos de un usuario
async function add_hotel_to_favorites(hotel_id, username){
    const fields = [hotel_id, username]
    const query = "CALL add_hotel_to_favorites(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Hotel agregado exitosamente"})
    }
}

// Elimina un hotel de la lista de hoteles favoritos de un usuario
async function delete_hotel_from_favorites(hotel_id, username){
    const fields = [hotel_id, username]
    const query = "CALL delete_hotel_from_favorites(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Hotel eliminado exitosamente"})
    }
}

// Retorna 1 si el hotel está marcado como favorito por un usuario
// Retorna 0 en el caso contrario
async function is_hotel_favorite(username, hotel_id){
    const query = "CALL is_hotel_favorite(?,?);"
    const result = await execute_query(query, [username, hotel_id])
    return result[0].count
}

// Define un hotel de conexión predeterminada a un usuario
async function set_hotel_as_default(hotel_id, username){
    const fields = [hotel_id, username]
    const query = "CALL set_hotel_as_default(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Hotel definido exitosamente"})
    }
}

// Elimina un hotel de conexión predeterminada de un usuario
async function delete_hotel_from_default(username){
    const fields = [username]
    const query = "CALL delete_hotel_from_default(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Hotel eliminado exitosamente"})
    }
}

// Agrega un comentario a una reserva
async function send_comment(username, bookin_id, comment){}

// Agregar una review a una reserva
async function send_review(username, booking_id, review){}

// Pantalla de reservas del cliente ----------------------------------------------------------------------- //

async function get_user_bookings(username){
    const query = "CALL get_user_bookings(?);"
    return await execute_query(query, [username])
}

// Nombres de cada funcion que hay arriba
module.exports = {
    get_hotel_deals_for_clients,
    is_hotel_favorite,
    get_user_favorite_hotels,
    add_hotel_to_favorites,
    delete_hotel_from_favorites,
    get_user_bookings,
    add_room_to_booking,
    delete_room_from_booking,
    get_hotels,
    get_hotel_data,
    get_rooms_to_book,
    get_rooms_in_booking,
    get_room_detail,
    set_hotel_as_default,
    delete_hotel_from_default
}