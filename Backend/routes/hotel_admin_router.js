// Importación de dependencias
const router = require("express").Router()

// Atiende la petición de ventana de menú principal
router.get("/", check_authenticated, async (req, res) => {
    res.render("hotel_ad_main", {profile:req.user.photo})
})

// Atiende la petición de ventana de edición del hotel
router.get("/edit_hotel", check_authenticated, async (req, res) => {
    
})

// Atiende la petición de ventana de lista de habitaciones
router.get("/rooms_list", check_authenticated, async (req, res) => {
    
})

// Atiende la petición de ventana de registro de habitación
router.get("/register_room", check_authenticated, async (req, res) => {
    
})

// Atiende la petición de ventana de edición de habitación
router.get("/edit_room/:room_id", check_authenticated, async (req, res) => {
    
})

// Atiende la petición de ventana de lista de ofertas
router.get("/deals_list", check_authenticated, async (req, res) => {
    
})

// Atiende la petición de ventana de registro de oferta
router.get("/register_deal", check_authenticated, async (req, res) => {
    
})

// Atiende la petición de ventana de edición de oferta
router.get("/edit_deal/:deal_id", check_authenticated, async (req, res) => {
    
})

// Atiende la petición de ventana de métodos de pago
router.get("/payment_methods", check_authenticated, async (req, res) => {
    
})

// Atiende la petición de ventana de amenidades
router.get("/amenities", check_authenticated, async (req, res) => {
    
})

// Atiende la petición de ventana de lista de políticas de cancelación
router.get("/cancelation_policies", check_authenticated, async (req, res) => {
    
})

// Atiende la petición de ventana de registro de política de cancelación
router.get("/register_cancelation_policy", check_authenticated, async (req, res) => {
    
})

// Atiende la petición de ventana de edición de política de cancelación
router.get("/edit_cancelation_policy/:policy_id", check_authenticated, async (req, res) => {
    
})

// Atiende la petición de ventana de lista de reservas
router.get("/bookings_list", check_authenticated, async (req, res) => {
    
})

// Atiende la petición de ventana de registro de reserva paso 1
router.get("/register_booking_step_1", check_authenticated, async (req, res) => {
    
})

// Atiende la petición de ventana de registro de reserva paso 2
router.get("/register_booking_step_2", check_authenticated, async (req, res) => {
    
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