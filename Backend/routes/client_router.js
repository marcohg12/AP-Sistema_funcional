// Importación de dependencias
const router = require("express").Router()
const hotel_admin_controller = require("../controllers/hotel_admin_controller")

// Atiende la petición de ventana de lista de hoteles
router.get("/hotel_list", async (req, res) => {

    var is_authenticated = false
    var profile
    if (req.isAuthenticated()){
        is_authenticated = true
        profile = req.user.photo
    }

    res.render("client_hotel_list", {hotels: [{name: "Hotel Maracuyá", classification: "4 Estrellas", province: "Guanacaste" }, 
                                              {name: "Hotel Vista Buena", classification: "3 Estrellas", province: "Puntarenas"}],
                                     is_authenticated: is_authenticated, profile: profile})
})

// Atiende la petición de ventana de información de un hotel
router.get("/hotel_info/:hotel_id", async (req, res) => {

    var is_authenticated = false
    var profile
    if (req.isAuthenticated()){
        is_authenticated = true
        profile = req.user.photo
    }

    const comments = [{name: "Marco Herrera", date: "2023-04-05", content: "Habitaciones muy ordenadas"},
                      {name: "Cristina Solís", date: "2023-04-03", content: "La comida del restaurantes es muy buena"},
                      {name: "Andrés Carvajal", date: "2023-01-23", content: "Muy buena atención del personal"}]
                      
    const reviews = [{name: "Marco Herrera", date: "2023-04-05", value: 5},
                     {name: "Cristina Solís", date: "2023-04-03", value: 4},
                     {name: "Marcela Ramos", date: "2023-01-23", value: 3}]

    res.render("client_hotel_main", {hotel_id: "", hotel_name: "Hotel Linda Vista", hotel_classification: "4 Estrellas", 
                                     hotel_address: "Playa Tamarindo, Tamarindo, Guanacaste", 
                                     amenities: ["Piscina", "Restaurante", "Gimnasio", "Campo de golf"],
                                     payment_methods: ["Tarjeta", "Efectivo", "Transferencia"],
                                     hotel_review_avg: 4.6, comments: comments, reviews: reviews,
                                     offers: [{id: "1", name: "40% Descuento en Habitaciones Doble", 
                                               initial_date: "2023-03-25", ending_date: "2023-03-30"},
                                               {id: "2", name: "50% Descuento en Habitaciones Sencillas", 
                                               initial_date: "2023-03-25", ending_date: "2023-03-30"}],
                                     rooms: [{id: "1", name: "Habitación sencilla", price: 150, capacity: 2, is_in_offer: 1, current_price: 75},
                                             {id: "2", name: "Habitación doble", price: 290, capacity: 4, is_in_offer: 0, current_price: 550},
                                             {id: "3", name: "Habitación deluxe", price: 350, capacity: 2, is_in_offer: 0, current_price: 550},
                                             {id: "4", name: "Habitación deluxe doble", price: 600, capacity: 4, is_in_offer: 1, current_price: 300},
                                             {id: "5", name: "Habitación royal", price: 750, capacity: 2, is_in_offer: 0, current_price: 550}],
                                     is_authenticated: is_authenticated, profile: profile})

})

// Atiende la petición de ventana de información de una oferta
router.get("/deal_info/:deal_id", async (req, res) => {

    var is_authenticated = false
    var profile
    if (req.isAuthenticated()){
        is_authenticated = true
        profile = req.user.photo
    }

    res.render("client_deal_detail", {name: "50% Descuento en Habitaciones Sencillas", 
                                     initial_date: "2023-03-25", ending_date: "2023-03-30", discount_rate: 50,
                                     minimun_days: 5,
                                     rooms: [{id: "0", name: "Habitación sencilla", price: 150, current_price: 75, capacity: 2},
                                     {id: "1", name: "Habitación doble", price: 290, current_price: 145, capacity: 4},
                                     {id: "2", name: "Habitación deluxe", price: 350, current_price: 175, capacity: 2},
                                     {id: "3", name: "Habitación deluxe doble", price: 600, current_price: 300, capacity: 4},
                                     {id: "4", name: "Habitación royal", price: 750, current_price: 375, capacity: 2}],
                                     is_authenticated: is_authenticated, profile: profile})
    
})

// Atiende la petición de ventana de información de una habitación
router.get("/room_info/:room_id", async (req, res) => {

    var is_authenticated = false
    var profile
    if (req.isAuthenticated()){
        is_authenticated = true
        profile = req.user.photo
    }

    res.render("client_room_detail", {id: "", name: "Habitación sencilla", capacity: 2, price: 150, is_in_offer: true,
                                     offer_data: {id: "1", name: "50% Descuento en Habitaciones Sencillas", 
                                                  initial_date: "2023-03-25", ending_date: "2023-03-30",
                                                  discount_rate: 50}, 
                                     discount_code: "AJDFBVF", discount_rate: 15,
                                     amenities: ["Vista al mar", "Agua caliente", "Cama doble", "Aire acondicionado"],
                                     is_authenticated: is_authenticated, profile: profile})
    
})

// Atiende la petición de ventana de lista de hoteles favoritos del cliente
router.get("/favorite_hotels", check_authenticated, async (req, res) => {

    const hotels = [{name: "Hotel Maracuyá", classification: "4 Estrellas", province: "Guanacaste" }, 
                    {name: "Hotel Vista Buena", classification: "3 Estrellas", province: "Puntarenas"}]

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

    const offers = [{id: 1, hotel_name: "Hotal Maracuyá", name: "40% Descuento en Habitaciones Doble", initial_date: "2023-03-25", ending_date: "2023-03-30"},
                    {id: 1, hotel_name: "Hotal Barceló", name: "30% Descuento en Habitaciones Sencillas", initial_date: "2023-03-25", ending_date: "2023-03-30"},
                    {id: 1, hotel_name: "Hotal Buena Vista", name: "15% Descuento en Habitaciones Deluxe", initial_date: "2023-03-25", ending_date: "2023-03-30"},
                    {id: 1, hotel_name: "Hotal Casona Vieja", name: "20% Descuento en Habitaciones Doble", initial_date: "2023-03-25", ending_date: "2023-03-30"}]

    res.render("client_deals_list", {offers: offers, is_authenticated: is_authenticated, profile: profile}) 
})

// Atiende la petición de ventana de reservas del cliente
router.get("/my_bookings", check_authenticated, async (req, res) => {

    const bookings = [{booking_id: 1, hotel_name: "Hotal Maracuyá", check_in_date: "2023-03-25", check_out_date: "2023-03-25", status_id: 1, status_name: "Confirmada"},
                      {booking_id: 1, hotel_name: "Hotal Barceló", check_in_date: "2023-03-25", check_out_date: "2023-03-25", status_id: 2, status_name: "Cancelada"},
                      {booking_id: 1, hotel_name: "Hotal Buena Vista", check_in_date: "2023-03-25", check_out_date: "2023-03-25", status_id: 3, status_name: "En proceso"}]

    res.render("client_booking_list", {bookings: bookings, profile:req.user.photo}) 
})

// Atiende la petición de ventana de detalle de una reserva
router.get("/get_booking_detail/:booking_id", check_authenticated, async (req, res) => {

    const booking = {is_checked_in: 1, is_reviewed: 0, booking_id: 1, check_in_date: "2023-03-25", check_out_date: "2023-03-25", status_id: 1, status_name: "Confirmada"}
    const rooms = [{id: "0", name: "Habitación sencilla", price: 150, capacity: 2, units: 1},
                   {id: "1", name: "Habitación doble", price: 290, capacity: 4, units: 1},
                   {id: "2", name: "Habitación deluxe", price: 350, capacity: 2, units: 2},
                   {id: "3", name: "Habitación deluxe doble", price: 600, capacity: 4, units:1}]

    res.render("client_booking_detail", {booking: booking, rooms: rooms, profile:req.user.photo}) 
})

// Atiende la petición de ventana de edición de habitaciones en una reserva
router.get("/booking_room_edition/:booking_id", check_authenticated, async (req, res) => {

    const booking_id = req.params.booking_id
    const rooms = [{id: "0", name: "Habitación sencilla", price: 150, capacity: 2,  units:1, is_in_offer: 1, current_price: 100},
                   {id: "1", name: "Habitación doble", price: 290, capacity: 4,  units:2, is_in_offer: 0, current_price: 290},
                   {id: "2", name: "Habitación deluxe", price: 350, capacity: 2,  units:4, is_in_offer: 0, current_price: 350},
                   {id: "3", name: "Habitación deluxe doble", price: 600, capacity: 4,  units:2, is_in_offer: 1, current_price: 550}]

    const rooms_in_booking = [{id: "0", name: "Habitación sencilla", price: 150, capacity: 2, units:1, is_in_offer: 1, current_price: 100},
                              {id: "1", name: "Habitación doble", price: 290, capacity: 4, units:1, is_in_offer: 0, current_price: 290},
                              {id: "2", name: "Habitación deluxe", price: 350, capacity: 2, units:2, is_in_offer: 0, current_price: 350}]

    res.render("client_booking_room_edition", {booking_id: booking_id, rooms: rooms, rooms_in_booking: rooms_in_booking, profile:req.user.photo}) 
})

// Atiende la petición de ventana de confirmación de reserva
router.get("/confirm_booking_view/:booking_id", check_authenticated, async (req, res) => {

    const booking = {hotel_id: 1, booking_id: 1, check_in_date: "2023-03-25", check_out_date: "2023-03-25", status_id: 1, status_name: "Confirmada"}
    const rooms = [{id: "0", name: "Habitación sencilla", price: 150, capacity: 2,  units:1, is_in_offer: 1, current_price: 100},
                   {id: "1", name: "Habitación doble", price: 290, capacity: 4,  units:2, is_in_offer: 0, current_price: 290},
                   {id: "2", name: "Habitación deluxe", price: 350, capacity: 2,  units:4, is_in_offer: 0, current_price: 350},
                   {id: "3", name: "Habitación deluxe doble", price: 600, capacity: 4,  units:2, is_in_offer: 1, current_price: 550}]
    const payment_methods = await hotel_admin_controller.get_payment_methods(booking.hotel_id);


    res.render("client_booking_confirmation", {payment_methods: payment_methods, booking: booking, rooms: rooms, profile:req.user.photo}) 
})

// Funciones de verificación de autenticación
function check_authenticated(req, res, next){
    if (req.isAuthenticated()){
        return next()
    }
    res.redirect("/login")
}

module.exports = router;