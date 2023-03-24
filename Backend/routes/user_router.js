// Importación de dependencias
const route = require("express").Router()
const passport = require("passport")

//route.(post, get)("/rutaMandarMarco", nombreFuncion)
route.get("/", register_user)

module.exports = route;