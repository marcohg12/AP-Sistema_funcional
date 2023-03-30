// Importación de dependencias
const router = require("express").Router()
const passport = require("passport")
const user_controller = require("../controllers/user_controller")

// Atiende la petición de ventana de registro
router.get("/register", async (req, res) => {
    const nationalities = await user_controller.get_nationalities()
    const genders = await user_controller.get_genders()
    const id_types = await user_controller.get_id_types()
    res.render("user_register", {nationalities: nationalities, genders: genders, id_types: id_types})
})

// Atiende la petición de ventana de actualización de datos del usuario
router.get("/my_profile_1", async (req, res) => {
    const genders = await user_controller.get_genders()
    const id_types = await user_controller.get_id_types()
    const user_data = await user_controller.get_user_data(req.user.username)

    // Limpieza de datos
    user_data.name = (user_data.name).trim()
    user_data.last_name = (user_data.last_name).trim()

    res.render("user_data_edition_1", {genders: genders, id_types: id_types, user_data: user_data})
})

router.get("/my_profile_2", async (req, res) => {
    const nationalities = await user_controller.get_nationalities()
    res.render("user_data_edition_2", {nationalities: nationalities})
})

// Atiende el registro de un usuario
router.post("/", async (req, res) => {
    const name = req.body.name
    const last_name = req.body.last_name
    const names = name.split(" ")
    const last_names = last_name.split(" ")
    
    const first_name = names.shift()
    const second_name = names.join(" ")
    const first_last_name = last_names.shift()
    const second_last_name = last_names.join(" ")

    response = await user_controller.register_user(first_name, second_name, first_last_name, second_last_name,
                  req.body.birthdate, req.body.identification_number, req.body.username,
                  req.body.password, req.body.photo, req.body.nationality, req.body.telephone,
                  req.body.email, req.body.gender, req.body.id_type)

    if (response.error){
        res.render("user_register", response) 
    } else {
        res.redirect("/login") 
    }
})

// Atiende la actualización de datos generales del usuario
router.post("/update_data", async (req, res) => {

})

// Atiende la actualización de un teléfono del usuario
// Atiende la actualización de un email del usuario
// Atiende la adición de un teléfono al usuario
// Atiende la adición de un email al usuario

module.exports = router;