// Importación de dependencias
const router = require("express").Router()
const user_controller = require("../controllers/user_controller")
const master_admin_controller = require("../controllers/master_admin_controller")
const hotel_admin_controller = require("../controllers/hotel_admin_controller")
const client_controller = require("../controllers/client_controller")

// Atiende la petición de ventana de lista de hoteles
router.get("/hotel_list", async (req, res) => {

    var is_authenticated = false
    var profile
    if (req.isAuthenticated()){
        is_authenticated = true
        profile = req.user.photo
    }

    const hotels = await client_controller.get_hotels()
    res.render("client_hotel_list", {hotels: hotels, is_authenticated: is_authenticated, profile: profile})
})

// Atiende la petición de ventana de información de un hotel
router.get("/hotel_info/:hotel_id", async (req, res) => {

    var is_authenticated = false
    var profile
    if (req.isAuthenticated()){
        is_authenticated = true
        profile = req.user.photo
    }

    const hotel_data = await client_controller.get_hotel_data(req.params.hotel_id)
    const photos = await hotel_admin_controller.get_hotel_photos(req.params.hotel_id)
    const amenities = await hotel_admin_controller.get_amenities(req.params.hotel_id)
    const payment_methods = await hotel_admin_controller.get_payment_methods(req.params.hotel_id)
    const rooms = await  client_controller.get_rooms_to_book(req.params.hotel_id)
    const offers = await client_controller.get_hotel_deals_for_clients(req.params.hotel_id)
    const avarage = await hotel_admin_controller.get_review_avarage(req.params.hotel_id)
    const comments = await hotel_admin_controller.get_hotel_comments(req.params.hotel_id)               
    const reviews = await hotel_admin_controller.get_hotel_reviews(req.params.hotel_id)
    
    var is_hotel_favorite = -1
    if (is_authenticated){
        is_hotel_favorite = await client_controller.is_hotel_favorite(req.user.username, req.params.hotel_id)
    }

    var is_default = -1
    if (is_authenticated){
        is_default = req.user.hotel_client_id == req.params.hotel_id
    }
    
    res.render("client_hotel_main", {hotel_data: hotel_data, amenities: amenities, payment_methods: payment_methods, photos: photos,
                                     avarage: avarage, comments: comments, reviews: reviews, is_hotel_favorite: is_hotel_favorite,
                                     is_default: is_default, offers: offers, rooms: rooms, is_authenticated: is_authenticated, profile: profile})

})

// Atiende la petición de ventana de información de una oferta
router.get("/deal_info/:deal_id", async (req, res) => {

    var is_authenticated = false
    var profile
    if (req.isAuthenticated()){
        is_authenticated = true
        profile = req.user.photo
    }

    const deal = await hotel_admin_controller.get_deal_data(req.params.deal_id)
    const rooms = await hotel_admin_controller.get_rooms_in_deal(req.params.deal_id)

    res.render("client_deal_detail", {deal: deal[0], rooms: rooms, is_authenticated: is_authenticated, profile: profile})
    
})

// Atiende la petición de ventana de información de una habitación
router.get("/room_info/:room_id", async (req, res) => {

    var is_authenticated = false
    var profile
    if (req.isAuthenticated()){
        is_authenticated = true
        profile = req.user.photo
    }

    const room = await client_controller.get_room_detail(req.params.room_id)
    var offer = []
    if (room.is_in_offer){
        offer = await hotel_admin_controller.get_deal_data(room.offer_id)
    }
    const amenities = await hotel_admin_controller.get_amenities_in_room(req.params.room_id)

    res.render("client_room_detail", {room: room, offer: offer[0], amenities: amenities, is_authenticated: is_authenticated, profile: profile})   
})

// Atiende la petición de ventana de lista de hoteles favoritos del cliente
router.get("/favorite_hotels", check_authenticated, async (req, res) => {
    const hotels = await client_controller.get_user_favorite_hotels(req.user.username)
    res.render("client_favorite_hotels", {hotels: hotels, profile:req.user.photo})
})

// Atiende la petición de ventana de consulta de ofertas de hoteles
router.get("/deal_list", async (req, res) => {

    var is_authenticated = false
    var profile
    if (req.isAuthenticated()){
        is_authenticated = true
        profile = req.user.photo
    }

    var offers
    const countries = await master_admin_controller.get_countries()

    if (req.query.province){
        offers = await client_controller.get_deals(req.query.province)
        const provinces = await master_admin_controller.get_provinces(req.query.country)
        res.render("client_deals_list", {provinces: provinces, province_id: req.query.province, country_id: req.query.country,
                                         offers: offers, countries: countries, is_authenticated: is_authenticated, profile: profile}) 
    } else {
        offers = await client_controller.get_deals(null)
        res.render("client_deals_list", {offers: offers, countries: countries, is_authenticated: is_authenticated, profile: profile}) 
    }
})

// Atiende la petición de ventana de reservas del cliente
router.get("/my_bookings", check_authenticated, async (req, res) => {
    const bookings = await client_controller.get_user_bookings(req.user.username)
    res.render("client_booking_list", {bookings: bookings, profile:req.user.photo}) 
})

// Atiende la petición de ventana de detalle de una reserva
router.get("/get_booking_detail/:booking_id", check_authenticated, async (req, res) => {
    const booking_data = await hotel_admin_controller.get_booking_data(req.params.booking_id)
    const rooms = await client_controller.get_rooms_in_booking(req.params.booking_id)

    var cancel_policy
    var cancel_message
    var is_cancelable

    if (booking_data.status_id == 1){

        // Configuración de los mensajes de cancelación
        cancel_policy = await hotel_admin_controller.get_cancel_policy_to_apply_in_booking(req.params.booking_id)

        if (cancel_policy){
            cancel_message = "Si cancela su reserva hoy, se aplicará una multa del " + cancel_policy.value + "% del precio final de su reserva. La multa sería de " 
                              + (booking_data.price_with_fee * (cancel_policy.value/100)) + "$"
            is_cancelable = cancel_policy.is_cancelable
        } else {
            cancel_message = "Cancele su reserva hoy gratuitamente"
            is_cancelable = 1
        }

        // Configuración de comentarios y reviews


    } else if (booking_data.status_id == 2){

        // Configuración de los mensajes de cancelación
        if (booking_data.cancellation_policy_id){
            cancel_message = "Su reserva fue cancelada, se aplicó una multa del " 
                             + booking_data.cancelation_fee + "%. El monto de multa fue de " + (booking_data.price_with_fee * (booking_data.cancelation_fee/100)) + "$"
        } else {
            cancel_message = "Su reserva fue cancelada gratuitamente"
        }
    }

    res.render("client_booking_detail", {booking_data: booking_data, is_cancelable: is_cancelable, cancel_message: cancel_message, rooms: rooms, profile:req.user.photo}) 
})

// Atiende la petición de ventana de edición de habitaciones en una reserva
router.get("/booking_room_edition/:booking_id/:hotel_id", check_authenticated, async (req, res) => {

    const booking_id = req.params.booking_id

    const booking_data = await hotel_admin_controller.get_booking_data(booking_id)
    booking_data.check_in_date = booking_data.check_in_date.toISOString().split("T")[0]
    booking_data.check_out_date = booking_data.check_out_date.toISOString().split("T")[0]

    const rooms = await client_controller.get_rooms_to_book(req.params.hotel_id)

    const rooms_in_booking = await client_controller.get_rooms_in_booking(req.params.booking_id)

    res.render("client_booking_room_edition", {booking_id: booking_id, booking_data: booking_data, rooms: rooms, rooms_in_booking: rooms_in_booking, profile:req.user.photo}) 
})

// Atiende la petición de ventana de confirmación de reserva
router.get("/confirm_booking_view/:booking_id", check_authenticated, async (req, res) => {

    const booking_data = await hotel_admin_controller.get_booking_data(req.params.booking_id)

    if (booking_data.room_count == 0){
        return res.redirect("/clients/booking_room_edition/" + req.params.booking_id + "/" + booking_data.hotel_id)
    }
    const rooms = await client_controller.get_rooms_in_booking(req.params.booking_id)
    const payment_methods = await hotel_admin_controller.get_payment_methods(booking_data.hotel_id)

    return res.render("client_booking_confirmation", {payment_methods: payment_methods, booking_data: booking_data, rooms: rooms, profile:req.user.photo}) 
})

// RU de hoteles favoritos -------------------------------------------------------------------- //

// Atiende la petición de agregar un hotel a la lista de favoritos
router.post("/add_hotel_to_favorites", check_authenticated, async (req, res) => {
    const response = await client_controller.add_hotel_to_favorites(req.body.hotel_id, req.user.username)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Atiende la petición de eliminar un hotel de la lista de favoritos
router.post("/delete_hotel_from_favorites", check_authenticated, async (req, res) => {
    const response = await client_controller.delete_hotel_from_favorites(req.body.hotel_id, req.user.username)
    res.status(200)
    res.send(JSON.stringify(response))
})

// RU de hoteles de conexión ------------------------------------------------------------------ //

// Atiende la petición de definir un hotel como de conexión predeterminada
router.post("/set_hotel_as_default", check_authenticated, async (req, res) => {
    const response = await client_controller.set_hotel_as_default(req.body.hotel_id, req.user.username)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Atiende la petición de eliminar un hotel de conexión predeterminada
router.post("/delete_hotel_from_default", check_authenticated, async (req, res) => {
    const response = await client_controller.delete_hotel_from_default(req.user.username)
    res.status(200)
    res.send(JSON.stringify(response))
})

// RUD de reserva ----------------------------------------------------------------------------- //

// Atiende la petición de registrar una reserva en un hotel para un usuario
router.post("/register_booking/:hotel_id", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.register_booking(req.user.username, req.body.check_in,
                                                                   req.body.check_out, req.params.hotel_id)
    if (!response.error){
        return res.redirect("/clients/booking_room_edition/" + response.booking_id + "/" + req.params.hotel_id)
    } else {
        return res.redirect("/clients/hotel_info/" + req.params.hotel_id)
    }
})

// Atiende la petición de agregar una habitación a una reserva
router.post("/add_room_to_booking", check_authenticated, async (req, res) => {
    const response = await client_controller.add_room_to_booking(req.body.booking_id, req.body.room_id,
                                                                 req.body.units, "")
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

// Responde a la solicitud de cancelar una reserva
router.post("/cancel_booking", check_authenticated, async (req, res) => {
    const response = await hotel_admin_controller.cancel_booking(req.body.booking_id)
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

// Atiende la petición de enviar un comentario
router.post("/send_comment", check_authenticated, async (req, res) => {
    const response = await client_controller.send_comment(req.body.booking_id, req.body.comment)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Atiende la petición de enviar una review
router.post("/send_review", check_authenticated, async (req, res) => {
    const response = await client_controller.send_review(req.body.booking_id, req.body.review)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Funciones de verificación de autenticación
function check_authenticated(req, res, next){
    if (req.isAuthenticated()){
        return next()
    }
    res.redirect("/login")
}

module.exports = router;