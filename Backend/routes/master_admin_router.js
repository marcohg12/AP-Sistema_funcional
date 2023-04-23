// Importación de dependencias
const router = require("express").Router()
const user_controller = require("../controllers/user_controller")
const master_admin_controller = require("../controllers/master_admin_controller")
const hotel_admin_controller = require("../controllers/hotel_admin_controller")

// Responde a la solicitud de vista del menú principal
router.get("/", check_authenticated, async (req, res) => {
    res.render("master_ad_main", {profile: req.user.photo})
})

// Responde a la solicitud de vista del catálogo de géneros
router.get("/gender_catalog", check_authenticated, async (req, res) => {
    const genders = await user_controller.get_genders()
    res.render("master_ad_gender_edition", {genders: genders, profile: req.user.photo})
})

// Responde a la solicitud de vista del catálogo de nacionalidades
router.get("/nationality_catalog", check_authenticated, async (req, res) => {
    const nationalities = await user_controller.get_nationalities()
    res.render("master_ad_nationality_edition", {nationalities: nationalities, profile: req.user.photo})
})

// Responde a la solicitud de vista del catálogo de tipos de identificación
router.get("/id_type_catalog", check_authenticated, async (req, res) => {
    const id_types = await user_controller.get_id_types()
    res.render("master_ad_id_type_edition", {id_types: id_types, profile: req.user.photo})
})

// Responde a la solicitud de vista del catálogo de ubicaciones
router.get("/location_catalog", check_authenticated, async (req, res) => {
    const countries = await master_admin_controller.get_countries()
    res.render("master_ad_location_edition", {countries: countries, profile: req.user.photo})
})

// Responde a la solicitud de vista del catálogo de provincias
router.get("/province_catalog/:country_id", check_authenticated, async (req, res) => {
    const provinces = await master_admin_controller.get_provinces(req.params.country_id)
    res.render("master_ad_province_edition", {country_id: req.params.country_id, provinces: provinces, profile: req.user.photo})
})

// Responde a la solicitud de vista del catálogo de cantones
router.get("/canton_catalog/:country_id/:province_id", check_authenticated, async (req, res) => {
    const cantons = await master_admin_controller.get_cantons(req.params.province_id)
    const country_id = req.params.country_id
    res.render("master_ad_canton_edition", {country_id: country_id, province_id: req.params.province_id, cantons: cantons, profile: req.user.photo})
})

// Responde a la solicitud de vista del catálogo de distritos
router.get("/district_catalog/:country_id/:province_id/:canton_id", check_authenticated, async (req, res) => {
    const districts = await master_admin_controller.get_districts(req.params.canton_id)
    const province_id = req.params.province_id
    const country_id = req.params.country_id
    res.render("master_ad_district_edition", {country_id: country_id, province_id: province_id, canton_id: req.params.canton_id, districts: districts, profile: req.user.photo})
})

// Responde a la solicitud de vista del catálogo de clasificaciones
router.get("/classification_catalog", check_authenticated, async (req, res) => {
    const classifications = await master_admin_controller.get_classifications()
    res.render("master_ad_classification_edition", {classifications: classifications, profile: req.user.photo})
})

// Responde a la solicitud de vista del catálogo de hoteles
router.get("/hotel_catalog", check_authenticated, async (req, res) => {
    const hotels = await master_admin_controller.get_hotel_catalog()
    const countries = await master_admin_controller.get_countries()
    const classifications = await master_admin_controller.get_classifications()
    res.render("master_ad_hotel_edition", {hotels: hotels, countries: countries, classifications: classifications, profile: req.user.photo})
})

// Responde a la solicitud de vista del catálogo de parámetros
router.get("/parameter_catalog", check_authenticated, async (req, res) => {
    const parameters = await master_admin_controller.get_parameters()
    res.render("master_ad_parameter_edition", {parameters: parameters, profile: req.user.photo})
})

// Responde a la solicitud de vista del catálogo de usuarios
router.get("/user_catalog", check_authenticated, async (req, res) => {
    const users = await master_admin_controller.get_users(req.user.username)
    return res.render("master_ad_user_edition", {users: users, profile: req.user.photo})
})

// Responde a la solicitud de obtener los tipos de usuario
router.get("/get_user_types", check_authenticated, async (req, res) => {
    const user_types = await master_admin_controller.get_user_types() 
    res.status(200)
    res.send(JSON.stringify(user_types))
})

// Responde a la solicitud de obtener los hoteles para administrar
router.get("/get_hotels_to_admin", check_authenticated, async (req, res) => {
    const hotels = await master_admin_controller.get_hotels_to_admin() 
    res.status(200)
    res.send(JSON.stringify(hotels))
})

// Responde a la solicitud de obtener la consulta de hoteles registrados en el sistema
router.get("/get_hotels_query", check_authenticated, async (req, res) => {
    res.render("master_ad_hotels_query", {profile: req.user.photo})
})

// Responde a la solicitud de obtener la vista de edición de hotel
router.get("/edit_hotel/:hotel_id", check_authenticated, async (req, res) => {

    const hotel_data = await hotel_admin_controller.get_hotel_data(req.params.hotel_id)
    const classifications = await master_admin_controller.get_classifications()
    const countries = await master_admin_controller.get_countries()
    const provinces = await master_admin_controller.get_provinces(hotel_data[0].country_id)
    const cantons = await master_admin_controller.get_cantons(hotel_data[0].province_id)
    const districts = await master_admin_controller.get_districts(hotel_data[0].canton_id)

    res.render("master_ad_edit_hotel", {hotel_data: hotel_data[0], classifications: classifications, 
                                          countries: countries, provinces: provinces,
                                          cantons: cantons, districts: districts, profile:req.user.photo})
})

// RUD de género ---------------------------------------------------------------------------------------------------------------- //

// Responde a la solicitud de registro de género
router.post("/register_gender", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.register_gender(req.body.name)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de actualización de género
router.post("/update_gender", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.update_gender(req.body.gender_id, req.body.new_name)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de eliminación de género
router.post("/delete_gender", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.delete_gender(req.body.gender_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// RUD de nacionalidad ---------------------------------------------------------------------------------------------------------------- //

// Responde a la solicitud de registro de nacionalidad
router.post("/register_nationality", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.register_nationality(req.body.name)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de actualización de nacionalidad
router.post("/update_nationality", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.update_nationality(req.body.nationality_id, req.body.new_name)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de eliminación de nacionalidad
router.post("/delete_nationality", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.delete_nationality(req.body.nationality_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// RUD de tipo de identificación  ---------------------------------------------------------------------------------------------------------------- //

// Responde a la solicitud de registro de tipo de identificación
router.post("/register_id_type", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.register_id_type(req.body.name, req.body.max_characters, req.body.is_alphanumeric)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de actualización de tipo de identificación
router.post("/update_id_type", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.update_id_type(req.body.id_type_id, req.body.new_name, 
                                                                  req.body.new_max_characters, req.body.new_is_alphanumeric)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de eliminación de tipo de identificación
router.post("/delete_id_type", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.delete_id_type(req.body.id_type_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// RUD de país ---------------------------------------------------------------------------------------------------------------- //

// Responde a la solicitud de registro de país
router.post("/register_country", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.register_country(req.body.name)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de actualización de país
router.post("/update_country", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.update_country(req.body.country_id, req.body.new_name)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de eliminación de país
router.post("/delete_country", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.delete_country(req.body.country_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// RUD de provincia ---------------------------------------------------------------------------------------------------------------- //

// Responde a la solicitud de registro de provincia
router.post("/register_province", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.register_province(req.body.country_id, req.body.name)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de actualización de provincia
router.post("/update_province", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.update_province(req.body.province_id, req.body.new_name)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de eliminación de provincia
router.post("/delete_province", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.delete_province(req.body.province_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// RUD de cantón ---------------------------------------------------------------------------------------------------------------- //

// Responde a la solicitud de registro de cantón
router.post("/register_canton", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.register_canton(req.body.province_id, req.body.name)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de actualización de cantón
router.post("/update_canton", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.update_canton(req.body.canton_id, req.body.new_name)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de eliminación de cantón
router.post("/delete_canton", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.delete_canton(req.body.canton_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// RUD de distrito ---------------------------------------------------------------------------------------------------------------- //

// Responde a la solicitud de registro de distrito
router.post("/register_district", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.register_district(req.body.canton_id, req.body.name)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de actualización de distrito
router.post("/update_district", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.update_district(req.body.district_id, req.body.new_name)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de eliminación de distrito
router.post("/delete_district", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.delete_district(req.body.district_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// RUD de clasificación ---------------------------------------------------------------------------------------------------------------- //

// Responde a la solicitud de registro de clasificación de hotel
router.post("/register_classification", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.register_classification(req.body.name)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de actualización de clasificación de hotel
router.post("/update_classification", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.update_classification(req.body.classification_id, req.body.new_name)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de eliminación de clasificación de hotel
router.post("/delete_classification", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.delete_classification(req.body.classification_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// RUD de hotel ---------------------------------------------------------------------------------------------------------------- //

// Responde a la solicitud de registro de hotel
router.post("/register_hotel", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.register_hotel(req.body.name, req.body.address,
                                                                  req.body.district_id, req.body.classification_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de actualización de hotel
router.post("/update_hotel", check_authenticated, async (req, res) => {
    const response = null
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de eliminación de hotel
router.post("/delete_hotel", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.delete_hotel(req.body.hotel_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// RUD de parámetro ---------------------------------------------------------------------------------------------------------------- //

// Responde a la solicitud de registro de parámetro
router.post("/register_parameter", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.register_parameter(req.body.name ,req.body.value)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de actualización de parámetro
router.post("/update_parameter", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.update_parameter(req.body.parameter_id, req.body.new_name ,req.body.new_value)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de eliminación de parámetro
router.post("/delete_parameter", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.delete_parameter(req.body.parameter_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// UD de usuario ---------------------------------------------------------------------------------------------------------------- //

// Responde a la solicitud de actualización de rol de usuario
router.post("/update_user_role", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.update_user_role(req.body.username, req.body.user_type_id, req.body.hotel_id)
    res.status(200)
    res.send(JSON.stringify(response))
})

// Responde a la solicitud de eliminación de usuario
router.post("/delete_user", check_authenticated, async (req, res) => {
    const response = await master_admin_controller.delete_user(req.body.username)
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