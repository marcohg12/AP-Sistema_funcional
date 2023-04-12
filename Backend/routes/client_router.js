// Importación de dependencias
const router = require("express").Router()

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

    res.render("client_hotel_main", {hotel_id: "", hotel_name: "Hotel Linda Vista", hotel_classification: "4 Estrellas", 
                                     hotel_address: "Playa Tamarindo, Tamarindo, Guanacaste", 
                                     amenities: ["Piscina", "Restaurante", "Gimnasio", "Campo de golf"],
                                     payment_methods: ["Tarjeta", "Efectivo", "Transferencia"],
                                     hotel_review_avg: 4.6, 
                                     offers: [{id: "1", name: "40% Descuento en Habitaciones Doble", 
                                               initial_date: "2023-03-25", ending_date: "2023-03-30"},
                                               {id: "2", name: "50% Descuento en Habitaciones Sencillas", 
                                               initial_date: "2023-03-25", ending_date: "2023-03-30"}],
                                     rooms: [{id: "1", name: "Habitación sencilla", price: 150, capacity: 2},
                                             {id: "2", name: "Habitación doble", price: 290, capacity: 4},
                                             {id: "3", name: "Habitación deluxe", price: 350, capacity: 2},
                                             {id: "4", name: "Habitación deluxe doble", price: 600, capacity: 4},
                                             {id: "5", name: "Habitación royal", price: 750, capacity: 2}],
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
                                     rooms: [{id: "0", name: "Habitación sencilla", price: 150, capacity: 2},
                                     {id: "1", name: "Habitación doble", price: 290, capacity: 4},
                                     {id: "2", name: "Habitación deluxe", price: 350, capacity: 2},
                                     {id: "3", name: "Habitación deluxe doble", price: 600, capacity: 4},
                                     {id: "4", name: "Habitación royal", price: 750, capacity: 2}],
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
    res.render("client_favorite_hotels", {profile:req.user.photo})
})

// Atiende la petición de ventana de consulta de ofertas de hoteles
router.get("/deal_list", async (req, res) => {

    var is_authenticated = false
    var profile
    if (req.isAuthenticated()){
        is_authenticated = true
        profile = req.user.photo
    }

    res.render("client_deals_list", {is_authenticated: is_authenticated, profile: profile}) 
})

// Atiende la petición de ventana de reservas del cliente
router.get("/my_bookings", check_authenticated, async (req, res) => {
    res.render("client_booking_list", {profile:req.user.photo}) 
})

// Atiende la petición de ventana de reserva paso 1
router.get("", check_authenticated, async (req, res) => {
    res.render("client_booking_registration_step_1", {rooms: [{id: "1", name: "Habitación sencilla", price: 150, capacity: 2},
                                                      {id: "2", name: "Habitación doble", price: 290, capacity: 4},
                                                      {id: "3", name: "Habitación deluxe", price: 350, capacity: 2},
                                                      {id: "4", name: "Habitación deluxe doble", price: 600, capacity: 4},
                                                      {id: "5", name: "Habitación royal", price: 750, capacity: 2}],
                                                      profile:req.user.photo})
})

// Atiende la petición de ventana de reserva paso 2
router.get("", check_authenticated, async (req, res) => {
    res.render("client_booking_registration_step_2", {rooms: [{id: "1", name: "Habitación sencilla", price: 150, capacity: 2},
                                                      {id: "2", name: "Habitación doble", price: 290, capacity: 4},
                                                      {id: "3", name: "Habitación deluxe", price: 350, capacity: 2},
                                                      {id: "4", name: "Habitación deluxe doble", price: 600, capacity: 4},
                                                      {id: "5", name: "Habitación royal", price: 750, capacity: 2}],
                                                      total_price_no_tax: 1500, total_price: 1800,
                                                      check_in_date: "2023-03-25", check_out_date: "2023-03-30",
                                                      total_nights: 4, profile:req.user.photo})
})

// Funciones de verificación de autenticación
function check_authenticated(req, res, next){
    if (req.isAuthenticated()){
        return next()
    }
    res.redirect("/")
}

module.exports = router;