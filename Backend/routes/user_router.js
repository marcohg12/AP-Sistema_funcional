// Importación de dependencias
const router = require("express").Router()
const user_controller = require("../controllers/user_controller")
const multer = require("multer");
const upload = multer({storage:multer.memoryStorage()});

// Renderiza la ventana de actualización de datos generales del usuario
async function render_update_user_data_window(response = false, req, res){

    const genders = await user_controller.get_genders()
    const id_types = await user_controller.get_id_types()
    const user_data = await user_controller.get_user_data(req.user.username)

    // Limpieza de datos
    user_data.name = (user_data.name).trim()
    user_data.last_name = (user_data.last_name).trim()
    user_data.birthdate = user_data.birthdate.toISOString().split("T")[0];

    if (response){
        return res.render("user_data_edition_1", {genders: genders, id_types: id_types, user_data: user_data, 
                                                  error: response.error, message: response.message}) 
    }
    return res.render("user_data_edition_1", {genders: genders, id_types: id_types, user_data: user_data})

}

// Renderiza la ventana de actualización de datos (nacionalidades, teléfonos, emails) del usuario
async function render_update_user_data_2_window(response = false, req, res){

    const nationalities = await user_controller.get_nationalities_not_in_user(req.user.username)
    const user_nationalities = await user_controller.get_user_nationalities(req.user.username)
    const telephones = await user_controller.get_user_telephones(req.user.username)
    const emails = await user_controller.get_user_emails(req.user.username)

    if (response){
        return res.render("user_data_edition_2", {nationalities: nationalities, user_nationalities: user_nationalities, 
                                                  telephones: telephones, emails: emails,
                                                  error: response.error, message: response.message}) 
    }
    return res.render("user_data_edition_2", {nationalities: nationalities, user_nationalities: user_nationalities, 
                                              telephones: telephones, emails: emails})
}

// Atiende la petición de ventana de registro
router.get("/register", check_not_authenticated,async (req, res) => {
    const nationalities = await user_controller.get_nationalities()
    const genders = await user_controller.get_genders()
    const id_types = await user_controller.get_id_types()
    res.render("user_register", {nationalities: nationalities, genders: genders, id_types: id_types})
})

// Atiende la petición de ventana de actualización de datos del usuario
router.get("/my_profile_1", check_authenticated, async (req, res) => {
    await render_update_user_data_window(undefined, req, res)
})

// Atiende la petició de ventana de actualización de datos (email, teléfono y nacionalidad) del usuario
router.get("/my_profile_2", check_authenticated, async (req, res) => {
    await render_update_user_data_2_window(undefined, req, res)
})

// Atiende el registro de un usuario
router.post("/", check_not_authenticated, upload.single("photo"), async (req, res) => {
    const name = req.body.name
    const last_name = req.body.last_name
    const names = name.split(" ")
    const last_names = last_name.split(" ")
    
    const first_name = names.shift()
    const second_name = names.join(" ")
    const first_last_name = last_names.shift()
    const second_last_name = last_names.join(" ")

    const photo = req.file.buffer.toString("base64");

    response = await user_controller.register_user(first_name, second_name, first_last_name, second_last_name,
                  req.body.birthdate, req.body.identification_number, req.body.username,
                  req.body.password, photo, req.body.nationality, req.body.telephone,
                  req.body.email, req.body.gender, req.body.id_type)

    if (response.error){
        res.render("user_register", response) 
    } else {
        res.redirect("/login") 
    }
})

// Atiende la actualización de datos generales del usuario
router.post("/update_data", check_authenticated, upload.single("photo"), async (req, res) => {
    const name = req.body.name
    const last_name = req.body.last_name
    const names = name.split(" ")
    const last_names = last_name.split(" ")
    
    const first_name = names.shift()
    const second_name = names.join(" ")
    const first_last_name = last_names.shift()
    const second_last_name = last_names.join(" ")

    var photo = req.user.photo
    if (req.file != null){
        photo = req.file.buffer.toString("base64");
    }

    var password
    var update_password = true
    if (req.body.password == ""){
        password = req.user.password
        update_password = false
    }

    response = await user_controller.update_user_data(req.user.username, first_name, second_name, first_last_name, second_last_name,
                                                      req.body.birthdate, req.body.identification_number, req.body.id_type,
                                                      req.body.gender, password, photo, update_password)
    render_update_user_data_window(response, req, res)

})

// Atiende la actualización de un teléfono del usuario
router.post("/update_phone/:phone_id", check_authenticated, async (req, res) => {
    response = await user_controller.update_user_phone(req.params.phone_id, req.body.new_phone)
    render_update_user_data_2_window(response, req, res)
})

// Atiende la actualización de un email del usuario
router.post("/update_email/:old_email", check_authenticated, async (req, res) => {
    response = await user_controller.update_user_email(req.user.username, req.params.old_email, req.body.new_email)
    render_update_user_data_2_window(response, req, res)
})

// Atiende la adición de un teléfono al usuario
router.post("/add_phone", check_authenticated, async (req, res) => {
    response = await user_controller.add_phone_to_user(req.user.username, req.body.new_phone)
    render_update_user_data_2_window(response, req, res)
})
// Atiende la adición de un email al usuario
router.post("/add_email", check_authenticated, async (req, res) => {
    response = await user_controller.add_email_to_user(req.user.username, req.body.new_email)
    render_update_user_data_2_window(response, req, res)
})

// Atiende la adición de una nacionalidad al usuario
router.post("/add_nationality", check_authenticated, async (req, res) => {
    response = await user_controller.add_nationality_to_user(req.user.username, req.body.new_nationality)
    render_update_user_data_2_window(response, req, res)
})

// Atiende la eliminación de una nacionalidad al usuario
router.post("/delete_nationality", check_authenticated, async (req, res) => {
    response = await user_controller.delete_nationality_from_user(req.user.username, req.body.user_nationality)
    render_update_user_data_2_window(response, req, res)
})

// Atiende la eliminación de un email al usuario
router.post("/delete_email", check_authenticated, async (req, res) => {
    response = await user_controller.delete_email_from_user(req.user.username, req.body.email)
    render_update_user_data_2_window(response, req, res)
})

// Atiende la eliminación de un teléfono al usuario
router.post("/delete_phone", check_authenticated, async (req, res) => {
    response = await user_controller.delete_phone_from_user(req.user.username, req.body.phone)
    render_update_user_data_2_window(response, req, res)
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