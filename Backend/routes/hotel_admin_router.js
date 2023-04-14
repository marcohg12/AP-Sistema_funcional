// Importación de dependencias
const router = require("express").Router()

// Atiende la petición de ventana de menú principal
router.get("/", check_authenticated, async (req, res) => {
    res.render("hotel_ad_main", {hotel_id: req.user.hotel_id, profile:req.user.photo})
})

// Atiende la petición de ventana de edición del hotel
router.get("/edit_hotel/:hotel_id", check_authenticated, async (req, res) => {
    res.render("hotel_ad_hotel_edition", {hotel_id: req.user.hotel_id, profile:req.user.photo})
})

// Responde a la solicitud de vista del catálogo de habitaciones
router.get("/room_catalog/:hotel_id", check_authenticated, async (req, res) => {
    res.render("hotel_ad_room_edition", {hotel_id: req.user.hotel_id, profile:req.user.photo})
})

// Responde a la solicitud de vista del catálogo de ofertas
router.get("/deal_catalog/:hotel_id", check_authenticated, async (req, res) => {
    res.render("hotel_ad_deal_edition", {hotel_id: req.user.hotel_id, profile:req.user.photo})
})

// Responde a la solicitud de vista del catálogo de amenidades
router.get("/amenity_catalog/:hotel_id", check_authenticated, async (req, res) => {
    res.render("hotel_ad_amenity_edition", {hotel_id: req.user.hotel_id, profile:req.user.photo})
})

// Responde a la solicitud de vista del catálogo de métodos de pago
router.get("/payment_method_catalog/:hotel_id", check_authenticated, async (req, res) => {
    res.render("hotel_ad_payment_method_edition", {hotel_id: req.user.hotel_id, profile:req.user.photo})
})

// Responde a la solicitud de vista del catálogo de políticas de cancelación
router.get("/cancelation_policy_catalog/:hotel_id", check_authenticated, async (req, res) => {
    res.render("hotel_ad_cancelation_policy_edition", {hotel_id: req.user.hotel_id, profile:req.user.photo})
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