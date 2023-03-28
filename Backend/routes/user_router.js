// Importación de dependencias
const route = require("express").Router()
const passport = require("passport")
const { login } = require("../controllers/user_controller")

//route.(post, get)("/rutaMandarMarco", nombreFuncion)
route.post("/home", login)

module.exports = route;