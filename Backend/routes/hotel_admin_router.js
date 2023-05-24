// Importación de dependencias
const router = require("express").Router()
const user_controller = require("../controllers/user_controller")
const master_admin_controller = require("../controllers/master_admin_controller")
const hotel_admin_controller = require("../controllers/hotel_admin_controller")
const client_controller = require("../controllers/client_controller")
const multer = require("multer")
const upload = multer({storage:multer.memoryStorage()})

// Atiende la petición de ventana de menú principal
router.get("/", check_authenticated, async (req, res) => {
    const hotel_data = await hotel_admin_controller.get_hotel_data(req.user.hotel_admin_id)
    const hotel_name = hotel_data[0].name
    res.render("hotel_ad_main", {hotel_name: hotel_name, profile:req.user.photo})
})

// Atiende la petición de ventana de edición del hotel
router.get("/edit_hotel", check_authenticated, async (req, res) => {

    const hotel_data = await hotel_admin_controller.get_hotel_data(req.user.hotel_admin_id)
    const classifications = await master_admin_controller.get_classifications()
    const countries = await master_admin_controller.get_countries()
    const provinces = await master_admin_controller.get_provinces(hotel_data[0].country_id)
    const cantons = await master_admin_controller.get_cantons(hotel_data[0].province_id)
    const districts = await master_admin_controller.get_districts(hotel_data[0].canton_id)
    const photos = await hotel_admin_controller.get_hotel_photos(req.user.hotel_admin_id)

    res.render("hotel_ad_hotel_edition", {hotel_data: hotel_data[0], classifications: classifications, 
                                          countries: countries, provinces: provinces,
                                          cantons: cantons, districts: districts, photos: photos, profile:req.user.photo})
})

// Responde a la solicitud de vista del catálogo de habitaciones
router.get("/room_catalog", check_authenticated, async (req, res) => {
    const rooms = await hotel_admin_controller.get_rooms(req.user.hotel_admin_id)
    res.render("hotel_ad_room_edition", {rooms: rooms, profile:req.user.photo})
})

// Responde a la solicitud de vista del catálogo de ofertas
router.get("/deal_catalog", check_authenticated, async (req, res) => {
    const deals = await hotel_admin_controller.get_deals(req.user.hotel_admin_id)
    res.render("hotel_ad_deal_edition", {deals: deals, profile:req.user.photo})
})

// Responde a la solicitud de vista del edición de una oferta
router.get("/edit_deal/:deal_id", check_authenticated, async (req, res) => {

    const deal =  (await hotel_admin_controller.get_deal_data(req.params.deal_id))[0]
    deal.start_date = deal.start_date.toISOString().split("T")[0]
    deal.ending_date = deal.ending_date.toISOString().split("T")[0]

    const rooms = await hotel_admin_controller.get_rooms_available_for_deal(req.params.deal_id)

    const rooms_in_deal = await hotel_admin_controller.get_rooms_in_deal(req.params.deal_id)

    res.render("hotel_ad_edit_deal", {deal: deal, rooms: rooms, rooms_in_deal: rooms_in_deal, profile:req.user.photo})
})

// Responde a la solicitud de vista del catálogo de amenidades
router.get("/amenity_catalog", check_authenticated, async (req, res) => {
    const amenities = await hotel_admin_controller.get_amenities(req.user.hotel_admin_id)
    res.render("hotel_ad_amenity_edition", {amenities: amenities, profile:req.user.photo})
})

// Responde a la solicitud de vista del catálogo de métodos de pago
router.get("/payment_method_catalog", check_authenticated, async (req, res) => {
    const payment_methods = await hotel_admin_controller.get_payment_methods(req.user.hotel_admin_id)
    res.render("hotel_ad_payment_method_edition", {payment_methods: payment_methods, profile:req.user.photo})
})

// Responde a la solicitud de vista del catálogo de políticas de cancelación
router.get("/cancelation_policy_catalog", check_authenticated, async (req, res) => {
    const policies = await hotel_admin_controller.get_cancelation_policies(req.user.hotel_admin_id)
    res.render("hotel_ad_cancelation_policy_edition", {policies: policies, profile:req.user.photo})
})

// Responde a la solicitud de vista del catálogo de políticas de cancelación
router.get("/bookin_catalog", check_authenticated, async (req, res) => {
    const bookins = await hotel_admin_controller.get_bookins(req.user.hotel_admin_id)
    res.render("hotel_ad_bookin_edition", {bookins: bookins, profile:req.user.photo})
})

// Response a la solicitud de vista de la ventana de creación de reserva, paso 1
router.get("/register_bookin_step_1", check_authenticated, async (req, res) => {
    const id_types = await user_controller.get_id_types()
    res.render("hotel_ad_register_booking", {id_types: id_types, profile:req.user.photo})
})

// Response a la solicitud de vista de la ventana de edición de habitaciones para la reserva
router.get("/edit_bookin_rooms/:bookin_id", check_authenticated, async (req, res) => {
    const booking_id = req.params.bookin_id

    const booking_data = await hotel_admin_controller.get_booking_data(booking_id)
    booking_data.check_in_date = booking_data.check_in_date.toISOString().split("T")[0]
    booking_data.check_out_date = booking_data.check_out_date.toISOString().split("T")[0]

    const rooms = await client_controller.get_rooms_to_book(req.user.hotel_admin_id)

    const rooms_in_booking = await client_controller.get_rooms_in_booking(req.params.bookin_id)
    res.render("hotel_ad_booking_room_edition", {booking_id: booking_id, booking_data: booking_data, rooms: rooms, rooms_in_booking: rooms_in_booking, profile:req.user.photo})
})

// Atiende la petición de ventana de confirmación de reserva
router.get("/confirm_booking_view/:booking_id", check_authenticated, async (req, res) => {
    const booking_data = await hotel_admin_controller.get_booking_data(req.params.booking_id)

    if (booking_data.room_count == 0){
        return res.redirect("/hotel_admins/edit_bookin_rooms/" + req.params.booking_id)
    }
    const rooms = await client_controller.get_rooms_in_booking(req.params.booking_id)
    const payment_methods = await hotel_admin_controller.get_payment_methods(booking_data.hotel_id);

    return res.render("hotel_ad_booking_confirmation", {payment_methods: payment_methods, booking_data: booking_data, rooms: rooms, profile:req.user.photo}) 
})

// Atiende la petición de ventana de detalle de una reserva
router.get("/get_booking_detail/:booking_id", check_authenticated, async (req, res) => {
    const booking_data = await hotel_admin_controller.get_booking_data(req.params.booking_id)
    const rooms = await client_controller.get_rooms_in_booking(req.params.booking_id)

    var cancel_policy
    var cancel_message
    var is_cancelable

    if (booking_data.status_id == 1){
        cancel_policy = await hotel_admin_controller.get_cancel_policy_to_apply_in_booking(req.params.booking_id)

        if (cancel_policy){
            cancel_message = "Si cancela su reserva hoy, se aplicará una multa del " + cancel_policy.value + "% del precio final de su reserva. La multa sería de " 
                              + (booking_data.price_with_fee * (cancel_policy.value/100)) + "$"
            is_cancelable = cancel_policy.is_cancelable
        } else {
            cancel_message = "Cancele su reserva hoy gratuitamente"
            is_cancelable = 1
        }
    } else if (booking_data.status_id == 2){

        if (booking_data.cancellation_policy_id){
            cancel_message = "Su reserva fue cancelada, se aplicó una multa del " 
                             + booking_data.cancelation_fee + "%. El monto de multa fue de " + (booking_data.price_with_fee * (booking_data.cancelation_fee/100)) + "$"
        } else {
            cancel_message = "Su reserva fue cancelada gratuitamente"
        }
    }

    res.render("hotel_ad_booking_detail", {booking_data: booking_data, is_cancelable: is_cancelable, cancel_message: cancel_message, rooms: rooms, profile:req.user.photo}) 
})

// Responde a la solicitud de cancelar una reserva
router.post("/cancel_booking", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.cancel_booking(req.body.booking_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de distritos de un cantón
router.get("/get_districts/:canton_id", check_authenticated, async (req, res) => {
    const districts = await master_admin_controller.get_districts(req.params.canton_id)
    res.status(200)
    res.send(JSON.stringify(districts))
})

// Responde a la solicitud de cantones de una provincia
router.get("/get_cantons/:province_id", check_authenticated, async (req, res) => {
    const cantons = await master_admin_controller.get_cantons(req.params.province_id)
    res.status(200)
    res.send(JSON.stringify(cantons))
})

// Responde a la solicitud de provincias de un país
router.get("/get_provinces/:country_id", async (req, res) => {
    const provinces = await master_admin_controller.get_provinces(req.params.country_id)
    res.status(200)
    res.send(JSON.stringify(provinces))
})

// Responde a la solicitud de amenidades de una habitación
router.get("/get_amenities_in_room/:room_id", check_authenticated, async (req, res) => {
    const amenities = await hotel_admin_controller.get_amenities_in_room(req.params.room_id)
    res.status(200)
    res.send(JSON.stringify(amenities))
})

// Responde a la solicitud de amenidades que no pertenecen
router.get("/get_amenities_not_in_room/:room_id", check_authenticated, async (req, res) => {
    const amenities = await hotel_admin_controller.get_amenities_not_in_room(req.params.room_id, req.user.hotel_admin_id)
    res.status(200)
    res.send(JSON.stringify(amenities))
})

// Responde a la solicitud de consulta de personas hospedadas
router.get("/get_booked_people", check_authenticated, async (req, res) => {
    const data = await hotel_admin_controller.get_booked_people_query(req.user.hotel_admin_id, '', '', '', '', '', '', '', '')
    const id_types = await user_controller.get_id_types()
    res.render("hotel_ad_booked_people_query", {data: data, id_types: id_types, profile: req.user.photo})
})

// Responde a la solicitud de consulta de personas hospedadas filtrada
router.post("/get_booked_people", check_authenticated, async (req, res) => {
    const data = await hotel_admin_controller.get_booked_people_query(req.user.hotel_admin_id, req.body.column, req.body.order,
                                                                      req.body.name, req.body.id_type, req.body.id_num,
                                                                      req.body.check_in, req.body.check_out, req.body.price)
    const id_types = await user_controller.get_id_types()
    res.render("hotel_ad_booked_people_query", {data: data, id_types: id_types, column: req.body.column,
                                                name: req.body.name, id_type: req.body.id_type, id_num: req.body.id_num,
                                                check_in: req.body.check_in, check_out: req.body.check_out,
                                                price: req.body.price, order: req.body.order, profile: req.user.photo})
})

// Responde a la solicitud de consulta de reporte de ofertas
router.get("/get_deals_report", check_authenticated, async (req, res) => {
    const data = await hotel_admin_controller.get_deals_report(req.user.hotel_admin_id, '', '', '')
    res.render("hotel_ad_deal_report_query", {data: data, profile: req.user.photo})  
})

// Responde a la solicitud de consulta de reporte de ofertas con filtros del usuario
router.post("/get_deals_report", check_authenticated, async (req, res) => {
    const data = await hotel_admin_controller.get_deals_report(req.user.hotel_admin_id, req.body.name, 
                                                               req.body.start_date, req.body.ending_date)
    res.render("hotel_ad_deal_report_query", {data: data, name_filter: req.body.name,
                                              start_date_filter: req.body.start_date, ending_date_filter: req.body.ending_date, 
                                              profile: req.user.photo})  
})

// Responde a la solicitud de promedio de reviews del hotel
router.get("/get_review_avarage", check_authenticated, async (req, res) => {
    const data = await hotel_admin_controller.get_hotel_review_average_report(req.user.hotel_admin_id)
    const avarage = await hotel_admin_controller.get_review_avarage(req.user.hotel_admin_id)
    res.render("hotel_ad_review_avarage_query", {data: data, avarage: avarage, profile: req.user.photo})
})

// Responde a la solicitud de obtener los comentarios de una reserva
router.get("/get_booking_comments/:booking_id/:username", check_authenticated, async (req, res) => {
    const comments = await hotel_admin_controller.get_booking_comments(req.params.booking_id)
    const user_data = await user_controller.get_user_by_username(req.params.username)
    
    var photo = null
    if (user_data.photo){
        photo = user_data.photo.toString('ascii')
    }
    res.status(200)
    res.send(JSON.stringify({comments: comments, user_data: {name: user_data.name, photo: photo}}))
})

// Responde a la solicitud de consulta de tops de ventas por días
router.get("/get_top_days_bookings", check_authenticated, async (req, res) => {
    const data = await hotel_admin_controller.get_top_n_days_with_most_booking(req.user.hotel_admin_id, null)
    res.render("hotel_ad_top_days_bookings_query", {data: data, profile: req.user.photo})
})

// Responde a la solicitud de consulta de tops de ventas por días filtrada
router.post("/get_top_days_bookings", check_authenticated, async (req, res) => {

    var data
    var top = req.body.top_n

    if (top == ""){
        top = null
    }

    if (req.body.type_of_top == 1){
        data = await hotel_admin_controller.get_top_n_days_with_most_booking(req.user.hotel_admin_id, top, req.body.start_date, req.body.ending_date)
    } else if (req.body.type_of_top == 2){
        data = await hotel_admin_controller.get_top_n_days_with_fewer_booking(req.user.hotel_admin_id, top, req.body.start_date, req.body.ending_date)
    }

    res.render("hotel_ad_top_days_bookings_query", {data: data, type_of_top: req.body.type_of_top, 
                                                    top_n: req.body.top_n, start_date: req.body.start_date, ending_date: req.body.ending_date, 
                                                    profile: req.user.photo})
})

// Responde a la solicitud de consulta de habitaciones disponibles (del job)
router.get("/get_rooms_available", check_authenticated, async (req, res) => {
    const rooms = await hotel_admin_controller.get_rooms_view(req.user.hotel_admin_id)
    res.render("hotel_ad_room_available_query", {rooms: rooms, profile: req.user.photo})
})

// Responde a la solicitud de consulta de comentarios de un hotel
router.get("/get_hotel_comments", check_authenticated, async (req, res) => {
    const comments = await hotel_admin_controller.get_hotel_comments(req.user.hotel_admin_id)
    res.render("hotel_ad_comments_query", {comments: comments, profile: req.user.photo})
})

// Responde a la solicitud de consulta de reviews de un hotel
router.get("/get_hotel_reviews", check_authenticated, async (req, res) => {
    const reviews = await hotel_admin_controller.get_hotel_reviews(req.user.hotel_admin_id)
    res.render("hotel_ad_reviews_query", {reviews: reviews, profile: req.user.photo})
})

// Responde a la solicitud de vista de estadística de clientes por rango de edad
router.get("/get_clients_by_age_stat", check_authenticated, async (req, res) => {
    const genders = await user_controller.get_genders()
    res.render("hotel_ad_clients_by_age_stat", {genders: genders, profile: req.user.photo})
})

// Responde a la solicitud de datos estadística de clientes por rango de edad
router.post("/get_clients_by_age_range", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.get_clients_by_age_range(req.user.hotel_admin_id, req.body.gender_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de vista de estadística de top N habitaciones con más reservas
router.get("/get_top_n_rooms_stat", check_authenticated, async (req, res) => {
    res.render("hotel_ad_top_n_rooms_stat", {profile: req.user.photo})
})

// Responde a la solicitud de datos de estadística de top N habitaciones con más reservas
router.post("/get_top_most_booked_rooms", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.get_top_most_booked_rooms(req.user.hotel_admin_id, req.body.top)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de consulta de bitácora de cambios
router.get("/get_log_query", check_authenticated, async (req, res) => {
    const data = await hotel_admin_controller.get_log_query(req.user.hotel_admin_id, "", "", "", "", "", "")
    res.render("hotel_ad_log_query", {data: data, profile: req.user.photo})
})

// Responde a la solicitud de consulta de bitácora de cambios filtrada
router.post("/get_log_query", check_authenticated, async (req, res) => {
    const data = await hotel_admin_controller.get_log_query(req.user.hotel_admin_id, req.body.username, req.body.old_price,
                                                            req.body.new_price, req.body.room_name, req.body.start_date,
                                                            req.body.ending_date)
    res.render("hotel_ad_log_query", {data: data, username: req.body.username, old_price: req.body.old_price,
                                      new_price: req.body.new_price, room_name: req.body.room_name,
                                      start_date: req.body.start_date, ending_date: req.body.ending_date, profile: req.user.photo})
})

// Responde a la solicitud de consulta de usuario por nombre de usuario
router.get("/get_person_by_username/:username", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.get_person_by_username(req.params.username)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de consulta de usuario por email
router.get("/get_person_by_email/:email", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.get_person_by_email(req.params.email)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de consulta de usuario por número de identificación
router.get("/get_person_by_id_number/:id_number/:id_type_id", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.get_person_by_id_number(req.params.id_number, req.params.id_type_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de habitaciones de una reserva
router.get("/get_rooms_in_booking/:booking_id", check_authenticated, async (req, res) => {
    const response = await client_controller.get_rooms_in_booking(req.params.booking_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de habitaciones de una reserva
router.get("/get_user_nationalities/:username", check_authenticated, async (req, res) => {
    const response = await user_controller.get_user_nationalities(req.params.username)
    res.status(200)
    res.send(JSON.stringify(response))
})

// RUD de habitaciones ----------------------------------------------------------------------------------------- //

// Responde a la solicitud de registro de una habitación
router.post("/register_room", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.register_room(req.body.name, req.body.capacity, req.body.units,
                                                                req.body.price, req.body.discount_code, req.body.discount_rate,
                                                                req.user.hotel_admin_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de actualización de una habitación
router.post("/update_room", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.update_room(req.body.room_id, req.body.name, req.body.capacity, req.body.units,
                                                              req.body.price, req.body.discount_code, req.body.discount_rate, req.user.username)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de eliminación de una habitación
router.post("/delete_room", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.delete_room(req.body.room_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de agregar una amenidad a una habitación
router.post("/add_amenity_to_room", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.add_amenity_to_room(req.body.room_id, req.body.amenity_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de eliminar una amenidad de una habitación
router.post("/delete_amenity_from_room", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.delete_amenity_from_room(req.body.room_id, req.body.amenity_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// RUD de amenidades   ----------------------------------------------------------------------------------------- //

// Responde a la solicitud de registro de una amenidad
router.post("/register_amenity", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.register_amenity(req.body.name, req.user.hotel_admin_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de actualización de una amenidad
router.post("/update_amenity", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.update_amenity(req.body.amenity_id, req.body.new_name)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de eliminación de una amenidad
router.post("/delete_amenity", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.delete_amenity(req.body.amenity_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// RUD de ofertas      ----------------------------------------------------------------------------------------- //

// Responde a la solicitud de registro de una oferta
router.post("/register_deal", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.register_deal(req.body.name, req.body.start_date, req.body.ending_date,
                                                                req.body.discount_rate, req.body.minimun_days, req.user.hotel_admin_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de actualización de una oferta
router.post("/update_deal", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.update_deal(req.body.deal_id, req.body.name, req.body.start_date, req.body.ending_date,
                                                              req.body.discount_rate, req.body.minimun_days)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de eliminación de una oferta
router.post("/delete_deal", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.delete_deal(req.body.deal_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de agregar una habitación a una oferta
router.post("/add_room_to_deal", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.add_room_to_deal(req.body.room_id, req.body.deal_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de eliminar una habitación de una oferta
router.post("/delete_room_from_deal", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.delete_room_from_deal(req.body.room_id, req.body.deal_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// RUD de métodos de pago -------------------------------------------------------------------------------------- //

// Responde a la solicitud de registro de un método de pago
router.post("/register_payment_method", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.register_payment_method(req.body.name, req.user.hotel_admin_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de actualización de un método de pago
router.post("/update_payment_method", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.update_payment_method(req.body.method_id, req.body.new_name)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de eliminación de un método de pago
router.post("/delete_payment_method", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.delete_payment_method(req.body.method_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// RUD de políticas de cancelación ----------------------------------------------------------------------------- //

// Responde a la solicitud de registro de una política de cancelación
router.post("/register_cancelation_policy", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.register_cancelation_policy(req.body.name, req.body.anticipation_time, 
                                                                              req.body.cancelation_fee, req.user.hotel_admin_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de actualización de una política de cancelación
router.post("/update_cancelation_policy", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.update_cancelation_policy(req.body.policy_id, req.body.new_name, 
                                                                            req.body.new_anticipation_time, req.body.new_cancelation_fee)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de eliminación de una política de cancelación
router.post("/delete_cancelation_policy", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.delete_cancelation_policy(req.body.policy_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Edición del hotel ------------------------------------------------------------------------------------------- //

// Responde a la solicitud de actualización del hotel
router.post("/update_hotel", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.update_hotel(req.body.name, req.body.address,
                                                               req.body.classification_id, req.body.district_id, req.user.hotel_admin_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de agregar una foto a un hotel
router.post("/add_photo_to_hotel", check_authenticated, upload.single("photo"), async (req, res) => {
    const response = await hotel_admin_controller.add_photo_to_hotel(req.user.hotel_admin_id, req.file.buffer.toString("base64"))
    res.redirect("/hotel_admins/edit_hotel")
})

// Responde a la solicitud de eliminar una foto de un hotel
router.post("/delete_photo_from_hotel", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.delete_photo_from_hotel(req.body.photo_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// RUD de reserva -------------------------------------------------------------------------------------------- //

// Atiende la petición de registrar una reserva
router.post("/register_booking", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.register_booking(req.body.username, req.body.check_in,
                                                                   req.body.check_out, req.user.hotel_admin_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Atiende la petición de eliminar una reserva
router.post("/delete_booking", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.delete_booking(req.body.booking_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Atiende la petición de agregar una habitación a una reserva
router.post("/add_room_to_booking", check_authenticated, async (req, res) => {
    const response = await client_controller.add_room_to_booking(req.body.booking_id, req.body.room_id,
                                                                 req.body.units, req.body.price)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Atiende la petición de eliminar una habitación de una reserva
router.post("/delete_room_from_booking", check_authenticated, async (req, res) => {
    const response = await client_controller.delete_room_from_booking(req.body.booking_id, req.body.room_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Atiende la petición de confirmar una reserva
router.post("/confirm_booking", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.confirm_booking(req.body.booking_id, req.body.payment_method_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Atiende la petición de aplicar un código de descuento a una reserva
router.post("/apply_discount_code", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.apply_discount_code(req.body.booking_id, req.body.code)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Atiende la petición de actualizar las fechas de una reserva
router.post("/update_booking_dates", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.update_booking_dates(req.body.check_in, req.body.check_out, req.body.booking_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Funciones de verificación de autenticación
function check_authenticated(req, res, next){
    if (req.isAuthenticated()){
        return next()
    }
    res.redirect("/")
}

function check_not_authenticated(req, res, next){
    if (req.isAuthenticated()){
        return res.redirect("/")
    }
    next()
}

module.exports = router;