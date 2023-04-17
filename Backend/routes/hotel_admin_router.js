// Importación de dependencias
const router = require("express").Router()
const user_controller = require("../controllers/user_controller")
const master_admin_controller = require("../controllers/master_admin_controller")
const hotel_admin_controller = require("../controllers/hotel_admin_controller")

// Atiende la petición de ventana de menú principal
router.get("/", check_authenticated, async (req, res) => {
    const hotel_name = "Hotel Maracuyá"
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
    res.render("hotel_ad_register_reservation_step_1", {profile:req.user.photo})
})


// Response a la solicitud de vista de la ventana de edición de habitaciones para la reserva
router.get("/edit_bookin_rooms/:bookin_id", check_authenticated, async (req, res) => {
    const rooms = await hotel_admin_controller.get_rooms(req.user.hotel_admin_id)
    res.render("hotel_ad_register_reservation_step_2", {rooms: rooms, profile:req.user.photo})
})

// Response a la solicitud de vista de la ventana de creación de reserva, paso 3 
router.get("/register_bookin_step_3", check_authenticated, async (req, res) => {
    res.render("hotel_ad_register_reservation_step_3", {profile:req.user.photo})
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
    const provinces = await master_admin_controller.get_districts(req.params.country_id)
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

// RUD de habitaciones ----------------------------------------------------------------------------------------- //

// Responde a la solicitud de registro de una habitación
router.post("/register_room", check_authenticated, async (req, res) => {
    const response = null
    res.status(200)
    res.send(JSON.stringify(response));
})

// Responde a la solicitud de actualización de una habitación
router.post("/update_room", check_authenticated, async (req, res) => {
    const response = null
    res.status(200)
    res.send(JSON.stringify(response));
})

// Responde a la solicitud de eliminación de una habitación
router.post("/delete_room", check_authenticated, async (req, res) => {
    const response = null
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