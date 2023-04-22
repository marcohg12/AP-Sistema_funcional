// Importación de dependencias
const router = require("express").Router()
const user_controller = require("../controllers/user_controller")
const master_admin_controller = require("../controllers/master_admin_controller")
const hotel_admin_controller = require("../controllers/hotel_admin_controller")

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
    res.render("hotel_ad_hotel_edition", {hotel_data: hotel_data[0], classifications: classifications, 
                                          countries: countries, provinces: provinces,
                                          cantons: cantons, districts: districts, profile:req.user.photo})
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
    const deal =  {id: "1", name: "40% Descuento en Habitaciones Doble", initial_date: "2023-03-25", ending_date: "2023-03-30", minimun_reservation_days: 10, discount: 50}
    const rooms = [{id: "0", name: "Habitación sencilla", price: 150, capacity: 2, units:1},
                   {id: "1", name: "Habitación doble", price: 290, capacity: 4, units:2},
                   {id: "2", name: "Habitación deluxe", price: 350, capacity: 2, units:4},
                   {id: "3", name: "Habitación deluxe doble", price: 600, capacity: 4, units:2}]

    const rooms_in_deal = [{id: "0", name: "Habitación sencilla", price: 150, capacity: 2, units:1, current_price: 100},
                              {id: "1", name: "Habitación doble", price: 290, capacity: 4, units:1, current_price: 145},
                              {id: "2", name: "Habitación deluxe", price: 350, capacity: 2, units:2, current_price: 175}]
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
    res.render("hotel_ad_register_booking", {profile:req.user.photo})
})


// Response a la solicitud de vista de la ventana de edición de habitaciones para la reserva
router.get("/edit_bookin_rooms/:bookin_id", check_authenticated, async (req, res) => {
    const booking_id = req.params.bookin_id
    const rooms = [{id: "0", name: "Habitación sencilla", price: 150, capacity: 2,  units:1, is_in_offer: 1, current_price: 100},
                   {id: "1", name: "Habitación doble", price: 290, capacity: 4,  units:2, is_in_offer: 0, current_price: 290},
                   {id: "2", name: "Habitación deluxe", price: 350, capacity: 2,  units:4, is_in_offer: 0, current_price: 350},
                   {id: "3", name: "Habitación deluxe doble", price: 600, capacity: 4,  units:2, is_in_offer: 1, current_price: 550}]

    const rooms_in_booking = [{id: "0", name: "Habitación sencilla", price: 150, capacity: 2, units:1, is_in_offer: 1, current_price: 100},
                              {id: "1", name: "Habitación doble", price: 290, capacity: 4, units:1, is_in_offer: 0, current_price: 290},
                              {id: "2", name: "Habitación deluxe", price: 350, capacity: 2, units:2, is_in_offer: 0, current_price: 350}]
    res.render("hotel_ad_booking_room_edition", {booking_id: booking_id, rooms: rooms, rooms_in_booking: rooms_in_booking, profile:req.user.photo})
})

// Atiende la petición de ventana de confirmación de reserva
router.get("/confirm_booking_view/:booking_id", check_authenticated, async (req, res) => {

    const booking = {hotel_id: 1, booking_id: 1, check_in_date: "2023-03-25", check_out_date: "2023-03-25", status_id: 1, status_name: "Confirmada"}
    const rooms = [{id: "0", name: "Habitación sencilla", price: 150, capacity: 2,  units:1, is_in_offer: 1, current_price: 100},
                   {id: "1", name: "Habitación doble", price: 290, capacity: 4,  units:2, is_in_offer: 0, current_price: 290},
                   {id: "2", name: "Habitación deluxe", price: 350, capacity: 2,  units:4, is_in_offer: 0, current_price: 350},
                   {id: "3", name: "Habitación deluxe doble", price: 600, capacity: 4,  units:2, is_in_offer: 1, current_price: 550}]
    const payment_methods = await hotel_admin_controller.get_payment_methods(booking.hotel_id);


    res.render("hotel_ad_booking_confirmation", {payment_methods: payment_methods, booking: booking, rooms: rooms, profile:req.user.photo}) 
})

// Atiende la petición de ventana de detalle de una reserva
router.get("/get_booking_detail/:booking_id", check_authenticated, async (req, res) => {

    const booking = {is_checked_in: 1, is_reviewed: 0, booking_id: 1, check_in_date: "2023-03-25", check_out_date: "2023-03-25", status_id: 1, status_name: "Confirmada"}
    const rooms = [{id: "0", name: "Habitación sencilla", price: 150, capacity: 2, units: 1},
                   {id: "1", name: "Habitación doble", price: 290, capacity: 4, units: 1},
                   {id: "2", name: "Habitación deluxe", price: 350, capacity: 2, units: 2},
                   {id: "3", name: "Habitación deluxe doble", price: 600, capacity: 4, units:1}]

    res.render("hotel_ad_booking_detail", {booking: booking, rooms: rooms, profile:req.user.photo}) 
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
router.get("/get_provinces/:country_id", check_authenticated, async (req, res) => {
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
    res.render("hotel_ad_booked_people_query", {profile: req.user.photo})
})

// Responde a la solicitud de consulta de reporte de ofertas
router.get("/get_deals_report", check_authenticated, async (req, res) => {
    res.render("hotel_ad_deal_report_query", {profile: req.user.photo})  
})

// Responde a la solicitud de promedio de reviews del hotel
router.get("/get_review_avarage", check_authenticated, async (req, res) => {
    res.render("hotel_ad_review_avarage_query", {profile: req.user.photo})
})

// Responde a la solicitud de consulta de tops de ventas por días
router.get("/get_top_days_bookings", check_authenticated, async (req, res) => {
    res.render("hotel_ad_top_days_bookings_query", {profile: req.user.photo})
})

// Responde a la solicitud de consulta de habitaciones disponibles (del job)
router.get("/get_rooms_available", check_authenticated, async (req, res) => {
    res.render("hotel_ad_room_available_query", {profile: req.user.photo})
})

// Responde a la solicitud de consulta de comentarios de un hotel
router.get("/get_hotel_comments", check_authenticated, async (req, res) => {
    res.render("hotel_ad_comments_query", {profile: req.user.photo})
})

// Responde a la solicitud de consulta de reviews de un hotel
router.get("/get_hotel_reviews", check_authenticated, async (req, res) => {
    res.render("hotel_ad_reviews_query", {profile: req.user.photo})
})

// Responde a la solicitud de estadística de clientes por rango de edad
router.get("/get_clients_by_age_stat", check_authenticated, async (req, res) => {
    const genders = await user_controller.get_genders()
    res.render("hotel_ad_clients_by_age_stat", {genders: genders, profile: req.user.photo})
})

// Responde a la solicitud de estadística de top N habitaciones con más reservas
router.get("/get_top_n_rooms_stat", check_authenticated, async (req, res) => {
    res.render("hotel_ad_top_n_rooms_stat", {profile: req.user.photo})
})

// Responde a la solicitud de consulta de bitácora de cambios
router.get("/get_log_query", check_authenticated, async (req, res) => {
    res.render("hotel_ad_log_query", {profile: req.user.photo})
})

// RUD de habitaciones ----------------------------------------------------------------------------------------- //


// Responde a la solicitud de registro de una habitación
router.post("/register_room", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.register_room(req.body.name, req.body.capacity, req.body.units,
                                                                req.body.price, req.body.discount_code, req.body.discount_rate,
                                                                req.user.hotel_admin_id)
    res.status(200)
    res.send(JSON.stringify(response));
})

// Responde a la solicitud de actualización de una habitación
router.post("/update_room", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.update_room(req.body.room_id, req.body.name, req.body.capacity, req.body.units,
                                                              req.body.price, req.body.discount_code, req.body.discount_rate)
    res.status(200)
    res.send(JSON.stringify(response));
})

// Responde a la solicitud de eliminación de una habitación
router.post("/delete_room", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.delete_room(req.body.room_id)
    res.status(200)
    res.send(JSON.stringify(response));
})

// RUD de amenidades   ----------------------------------------------------------------------------------------- //

// Responde a la solicitud de registro de una amenidad
router.post("/register_amenity", check_authenticated, async (req, res) => {
    const response = null
    res.status(200)
    res.send(JSON.stringify(response));
})

// Responde a la solicitud de actualización de una amenidad
router.post("/update_amenity", check_authenticated, async (req, res) => {
    const response = null
    res.status(200)
    res.send(JSON.stringify(response));
})

// Responde a la solicitud de eliminación de una amenidad
router.post("/delete_amenity", check_authenticated, async (req, res) => {
    const response = null
    res.status(200)
    res.send(JSON.stringify(response));
})

// RUD de ofertas      ----------------------------------------------------------------------------------------- //

// Responde a la solicitud de registro de una oferta
router.post("/register_deal", check_authenticated, async (req, res) => {
    const response = null
    res.status(200)
    res.send(JSON.stringify(response));
})

// Responde a la solicitud de actualización de una oferta
router.post("/update_deal", check_authenticated, async (req, res) => {
    const response = null
    res.status(200)
    res.send(JSON.stringify(response));
})

// Responde a la solicitud de eliminación de una oferta
router.post("/delete_deal", check_authenticated, async (req, res) => {
    const response = null
    res.status(200)
    res.send(JSON.stringify(response));
})

// RUD de métodos de pago -------------------------------------------------------------------------------------- //

// Responde a la solicitud de registro de un método de pago
router.post("/register_payment_method", check_authenticated, async (req, res) => {
    const response = null
    res.status(200)
    res.send(JSON.stringify(response));
})

// Responde a la solicitud de actualización de un método de pago
router.post("/update_payment_method", check_authenticated, async (req, res) => {
    const response = null
    res.status(200)
    res.send(JSON.stringify(response));
})

// Responde a la solicitud de eliminación de un método de pago
router.post("/delete_payment_method", check_authenticated, async (req, res) => {
    const response = null
    res.status(200)
    res.send(JSON.stringify(response));
})

// RUD de políticas de cancelación ----------------------------------------------------------------------------- //

// Responde a la solicitud de registro de una política de cancelación
router.post("/register_cancelation_policy", check_authenticated, async (req, res) => {
    const response = null
    res.status(200)
    res.send(JSON.stringify(response));
})

// Responde a la solicitud de actualización de una política de cancelación
router.post("/update_cancelation_policy", check_authenticated, async (req, res) => {
    const response = null
    res.status(200)
    res.send(JSON.stringify(response));
})

// Responde a la solicitud de eliminación de una política de cancelación
router.post("/delete_cancelation_policy", check_authenticated, async (req, res) => {
    const response = null
    res.status(200)
    res.send(JSON.stringify(response));
})

// Edición del hotel ------------------------------------------------------------------------------------------- //

// Responde a la solicitud de actualización del hotel
router.post("/update_hotel", check_authenticated, async (req, res) => {
    const response = null
    res.status(200)
    res.send(JSON.stringify(response));
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