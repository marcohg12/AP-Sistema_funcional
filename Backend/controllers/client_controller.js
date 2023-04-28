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

async function get_rooms_in_booking(booking_id){
    const query = "CALL get_rooms_in_booking(?);"
    return await execute_query(query, [booking_id])
}

// Pantalla de detalles de habitación --------------------------------------------------------------------- //

async function get_room_detail(room_id){
    const query = "CALL get_room_detail(?);"
    const data = await execute_query(query, [room_id])
    return data[0]
}

// Pantalla de lista de ofertas --------------------------------------------------------------------------- //
// Pantalla de hoteles favoritos -------------------------------------------------------------------------- //
// Pantalla de reservas del cliente ----------------------------------------------------------------------- //

// Nombres de cada funcion que hay arriba
module.exports = {
    get_hotels,
    get_hotel_data,
    get_rooms_to_book,
    get_rooms_in_booking,
    get_room_detail
}