// Importación de dependencias
const router = require("express").Router()
const passport = require("passport")
const { login, register_user } = require("../controllers/user_controller")

router.post("/", async (req, res) => {
    const name = req.body.name
    const last_name = req.body.last_name
    const names = name.split(" ")
    const last_names = last_name.split(" ")
    
    const first_name = names.shift()
    const second_name = names.join(" ")
    const first_last_name = last_names.shift()
    const second_last_name = last_names.join(" ")

    response = await register_user(first_name, second_name, first_last_name, second_last_name,
                  req.body.birthdate, req.body.identification_number, req.body.username,
                  req.body.password, req.body.photo, req.body.nationality, req.body.telephone,
                  req.body.email, req.body.gender, req.body.id_type)

    if (response.error){
        res.render("user_register", response) 
    } else {
        res.redirect("/login") 
    }
})

module.exports = router;