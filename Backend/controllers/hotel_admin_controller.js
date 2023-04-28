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

// Función para obtener las habitaciones de in hotel
async function get_rooms(hotel_id){
    const fields = [hotel_id]
    const query = "CALL get_rooms(?);"
    return await execute_query(query, fields)
}

// Función para registrar una habitación
async function register_room(name, capacity, units, price, discount_code, discount_rate, hotel_id){

    if ((discount_code == "" && discount_rate != "") || (discount_code != "" && discount_rate == "")){
        return {error: true, message: "Error: el código de descuento y el porcentaje no pueden estar vacíos"}  
    }

    if (discount_code == ""){
        discount_code = null
    }
    if (discount_rate == ""){
        discount_rate = null
    }
    
    const fields = [name, capacity, price, units, discount_code, discount_rate, hotel_id]
    const query = "CALL register_room(?,?,?,?,?,?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1) {
        return {error: true, message: "Ocurrió un error inesperado"}
    } else if (execution_code == -2) {
        return {error: true, message: "Error: el código de descuento ya está en uso"}
    } else {
        return {error: false, message: "Habitación registrada exitosamente"}
    }
}

// Función para actualizar una habitación
async function update_room(room_id, new_name, new_capacity, new_units, new_price, new_discount_code, new_discount_rate){

    if ((new_discount_code == "" && new_discount_rate != "") || (new_discount_code != "" && new_discount_rate == "")){
        return {error: true, message: "Error: el código de descuento y el porcentaje no pueden estar vacíos"}  
    }

    if (new_discount_code == ""){
        new_discount_code = null
    }
    if (new_discount_rate == ""){
        new_discount_rate = null
    }

    const fields = [room_id, new_name, new_capacity, new_price, new_units, new_discount_code, new_discount_rate]
    const query = "CALL update_room(?,?,?,?,?,?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -2) {
        return {error: true, message: "Error: el código de descuento ya está en uso"}
    }else {
        return ({error: false, message: "Habitación actualizada correctamente"})
    }
}

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

// Función para obtener las amenidades de una habitación
async function get_amenities_in_room(room_id){
    const fields = [room_id]
    const query = "CALL get_amenities_in_room(?);"
    return await execute_query(query, fields)
}

// Función para obtener las amenidades que no son de una habitación
async function get_amenities_not_in_room(room_id, hotel_id){
    const fields = [room_id, hotel_id]
    const query = "CALL get_amenities_not_in_room(?,?);"
    return await execute_query(query, fields)
}

// Función para agregar una amenidad a una habitación
async function add_amenity_to_room(room_id, amenity_id){
    const fields = [room_id, amenity_id]
    const query = "CALL add_amenity_to_room(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1) {
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Amenidad registrada exitosamente"})
    }
}

// Función para eliminar una amenidad de una habitación
async function delete_amenity_from_room(room_id, amenity_id){
    const fields = [room_id, amenity_id]
    const query = "CALL delete_amenity_from_room(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1) {
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Amenidad eliminada exitosamente"})
    }
}

// RUD de amenidades   ----------------------------------------------------------------------------------------- //

// Función para obtener las amenidades de un hotel
async function get_amenities(hotel_id){
    const fields = [hotel_id]
    const query = "CALL get_amenities(?);"
    return await execute_query(query, fields)
}

// Función para registrar una amenidad
async function register_amenity(name, hotel_id){
    const fields = [name, hotel_id]
    const query = "CALL register_amenity(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1) {
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Amenidad registrada exitosamente"})
    }
}

// Función para actualizar una amenidad
async function update_amenity(amenity_id, new_name){
    const fields = [amenity_id, new_name]
    const query = "CALL update_amenity(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Amenidad actualizada correctamente"})
    }
}

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

// Función para obtener las ofertas de un hotel
async function get_deals(hotel_id){
    const fields = [hotel_id]
    const query = "CALL get_deals(?);"
    return await execute_query(query, fields)
}

// Función para obtener los datos de una oferta
async function get_deal_data(deal_id){
    const fields = [deal_id]
    const query = "CALL get_deal_data(?);"
    return await execute_query(query, fields)  
}

// Función para obtener las habitaciones disponibles para una oferta
async function get_rooms_available_for_deal(deal_id){
    const fields = [deal_id]
    const query = "CALL get_rooms_available_for_deal(?);"
    return await execute_query(query, fields)  
}

// Función para obtener las habitaciones de una oferta
async function get_rooms_in_deal(deal_id){
    const fields = [deal_id]
    const query = "CALL get_rooms_in_deal(?);"
    return await execute_query(query, fields)  
}

// Función para agregar una habitación a una oferta
async function add_room_to_deal(room_id, deal_id){
    const fields = [room_id, deal_id]
    const query = "CALL add_room_to_deal(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields) 
    
    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -11){
        return ({error: true, message: "Error: la habitación ya está en una oferta"})
    } else {
        return ({error: false, message: "Habitación agregada exitosamente"})
    }
}

// Función para eliminar una habitación de una oferta
async function delete_room_from_deal(room_id, deal_id){
    const fields = [room_id, deal_id]
    const query = "CALL delete_room_from_deal(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields) 
    
    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Habitación eliminada exitosamente"})
    }  
}

// Función para registrar una oferta
async function register_deal(name, start_date, ending_date, discount_rate, minimum_days, hotel_id){
    const fields = [name, start_date, ending_date, discount_rate, minimum_days, hotel_id]
    const query = "CALL register_deal(?,?,?,?,?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1) {
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Oferta registrada exitosamente"})
    }
}

// Función para actualizar una oferta
async function update_deal(deal_id, new_name, new_start_date, new_ending_date, new_discount_rate, new_minimum_days){
    const fields = [deal_id, new_name, new_start_date, new_ending_date, new_discount_rate, new_minimum_days]
    const query = "CALL update_deal(?,?,?,?,?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -11){
        return ({error: true, message: "Error: hay habitaciones que quedarían en dos ofertas con las nuevas fechas ingresadas"})
    } else {
        return ({error: false, message: "Oferta actualizada correctamente"})
    }
}

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

// Función para obtener los métodos de pago de un hotel
async function get_payment_methods(hotel_id){
    const fields = [hotel_id]
    const query = "CALL get_payment_methods(?);"
    return await execute_query(query, fields)
}

// Función para registrar un método de pago
async function register_payment_method(name, hotel_id){
    const fields = [name, hotel_id]
    const query = "CALL register_payment_method(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1) {
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Método de pago registrado exitosamente"})
    }
}

// Función para actualizar un método de pago
async function update_payment_method(payment_method_id, new_name){
    const fields = [payment_method_id, new_name]
    const query = "CALL update_payment_method(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Método de pago actualizado correctamente"})
    }
}

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

// Función para obtener las políticas de cancelación de un hotel
async function get_cancelation_policies(hotel_id){
    const fields = [hotel_id]
    const query = "CALL get_cancelation_policies(?);"
    return await execute_query(query, fields)
}

// Función para registrar una política de cancelación
async function register_cancelation_policy(name, anticipation_time, cancelation_fee, hotel_id){
    const fields = [name, anticipation_time, cancelation_fee, hotel_id]
    const query = "CALL register_cancelation_policy(?,?,?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1) {
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -3){
        return ({error: true, message: "Error: ya existe una política con la misma anticipación"})
    } else {
        return ({error: false, message: "Política de cancelación registrado exitosamente"})
    }
}

// Función para actualizar una política de cancelación
async function update_cancelation_policy(policy_id, new_name, new_anticipation_time, new_cancelation_fee){
    const fields = [policy_id, new_name, new_anticipation_time, new_cancelation_fee]
    const query = "CALL update_cancelation_policy(?,?,?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else if (execution_code == -3){
        return ({error: true, message: "Error: ya existe una política con la misma anticipación"})
    } else {
        return ({error: false, message: "Política de cancelación actualizada correctamente"})
    }
}

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

// RUD de reservas --------------------------------------------------------------------------------------------- //

// Función para obtener las reservas de un hotel
async function get_bookins(hotel_id){
    const fields = [hotel_id]
    const query = "CALL get_bookins(?);"
    return await execute_query(query, fields)
}

// Función para obtener los datos de una reserva
async function get_booking_data(booking_id){
    const fields = [booking_id]
    const query = "CALL get_booking_data(?);"
    const data = await execute_query(query, fields)
    return data[0]
}

// Función para obtener las habitaciones de una reserva
async function get_rooms_in_booking(booking_id){
    const fields = [booking_id]
    const query = "CALL get_rooms_in_booking(?);"
    return await execute_query(query, fields)
}

// Función para obtener las habitaciones disponibles para reservar
async function get_rooms_to_book(hotel_id){
    const fields = [hotel_id]
    const query = "CALL get_rooms_to_book(?);"
    return await execute_query(query, fields)
}

// Función para obtener un usuario por nombre de usuario
async function get_person_by_username(username){
    const fields = [username]
    const query = "CALL get_person_by_username(?);"
    const user = await execute_query(query, fields)

    // Generación de la respuesta
    if (user.length == 0){
        return ({error: true, message: "Error: no se encontró el usuario con el nombre ingresado"})
    } else {
        return ({error: false, message: "", user: user[0]})
    }
}

// Función para obtener un usuario por email
async function get_person_by_email(email){
    const fields = [email]
    const query = "CALL get_person_by_email(?);"
    const user = await execute_query(query, fields)

    // Generación de la respuesta
    if (user.length == 0){
        return ({error: true, message: "Error: no se encontró el usuario con el email ingresado"})
    } else {
        return ({error: false, message: "", user: user[0]})
    }
}

// Función para obtener un usuario por número de identificación
async function get_person_by_id_number(id_number, id_type_id){
    const fields = [id_number, id_type_id]
    const query = "CALL get_person_by_id_number(?,?);"
    const user = await execute_query(query, fields)

    // Generación de la respuesta
    if (user.length == 0){
        return ({error: true, message: "Error: no se encontró el usuario con el número de identificación ingresado"})
    } else {
        return ({error: false, message: "", user: user[0]})
    }
}


// Función para registrar una reserva en la base de datos
// Retorna el código de ejecución y el id de la reserva registrada
function register_booking_in_db(query, fields){
    return new Promise(async (resolve, reject) => {
        const connection = await get_connection()
        connection.query(query, fields, (error, result) => {
            return resolve({execution_code: result[1][0].execution_code, booking_id: result[1][0].booking_id})
        })
        connection.end()
    })
}

// Función para registrar una reserva
async function register_booking(username, check_in, check_out, hotel_id){
    const fields = [username, check_in, check_out, hotel_id]
    const query = "CALL register_booking(?,?,?,?,@execution_code, @booking_id); SELECT @execution_code AS execution_code, @booking_id AS booking_id;"
    const response = await register_booking_in_db(query, fields)

    // Generación de la respuesta
    if (response.execute_operation == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "", booking_id: response.booking_id})
    } 
}

// Función para eliminar una reserva
async function delete_booking(booking_id){
    const fields = [booking_id]
    const query = "CALL delete_booking(?,@execution_code); SELECT @execution_code AS execution_code;"
    const response = await execute_operation(query, fields)

    // Generación de la respuesta
    if (response.execute_operation == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Reserva eliminada exitosamente"})
    } 
}

// Edición del hotel ------------------------------------------------------------------------------------------- //

// Función para obtener las fotos de un hotel
async function get_hotel_photos(hotel_id){
    const query = "CALL get_hotel_photos(?);"
    return await execute_query(query, [hotel_id])
}

// Función que retorna los datos de un hotel
async function get_hotel_data(hotel_id){
    const query = "CALL get_hotel_data(?);"
    return await execute_query(query, [hotel_id])
}

// Función que actualiza los datos de un hotel
async function update_hotel(name, address, classification_id, district_id, hotel_id){
    const fields = [name, address, classification_id, district_id, hotel_id]
    const query = "CALL update_hotel(?,?,?,?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const response = await execute_operation(query, fields)

    // Generación de la respuesta
    if (response.execute_operation == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Datos actualizados exitosamente"})
    } 
}

// Función para agregar una foto a un hotel
async function add_photo_to_hotel(hotel_id, photo){
    const fields = [hotel_id, photo]
    const query = "CALL add_photo_to_hotel(?,?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Foto agregada exitosamente"})
    } 
}

// Función para eliminar una foto de un hotel
async function delete_photo_from_hotel(photo_id){
    const fields = [photo_id]
    const query = "CALL delete_photo_from_hotel(?,@execution_code); SELECT @execution_code AS execution_code;"
    const execution_code = await execute_operation(query, fields)

    // Generación de la respuesta
    if (execution_code == -1){
        return ({error: true, message: "Ocurrió un error inesperado"})
    } else {
        return ({error: false, message: "Foto eliminada exitosamente"})
    }  
}

// Nombres de cada funcion que hay arriba
module.exports = {
    get_rooms,
    register_room,
    update_room,
    delete_room,
    register_amenity,
    update_amenity,
    delete_amenity,
    register_deal,
    update_deal,
    delete_deal,
    register_cancelation_policy,
    update_cancelation_policy,
    delete_cancelation_policy,
    register_payment_method,
    update_payment_method,
    delete_payment_method,
    get_hotel_data,
    get_amenities,
    get_payment_methods,
    get_cancelation_policies,
    get_deals,
    get_bookins,
    get_amenities_in_room,
    get_amenities_not_in_room,
    add_amenity_to_room,
    delete_amenity_from_room,
    get_deal_data,
    get_rooms_available_for_deal,
    get_rooms_in_deal,
    add_room_to_deal,
    delete_room_from_deal,
    get_person_by_email,
    get_person_by_id_number,
    get_person_by_username,
    register_booking,
    delete_booking,
    update_hotel,
    add_photo_to_hotel,
    get_hotel_photos,
    delete_photo_from_hotel,
    get_booking_data
}