// Inclusión de bibliotecas
const express = require("express")
const bcrypt = require("bcrypt")
const initialize_passport = require("./passport-config")
const passport = require("passport")
const flash = require("express-flash")
const session = require("express-session")
const get_connection = require("./Backend/mysql-config")
const user_router = require("./Backend/routes/user_router");
const client_router = require("./Backend/routes/client_router");
const { get_user_by_username } = require("./Backend/controllers/user_controller")
const port = 4500;

// Configuraciones del servidor
const app = express();
app.use(express.urlencoded({extended: false}))
app.use(express.static(__dirname))
app.set("view engine", "ejs")
app.use(flash())
app.use(session({
    secret: "Ok6I7urIEstRyxn",
    resave: false,
    saveUninitialized: false
}))
app.use(passport.initialize())
app.use(passport.session())
initialize_passport(
    passport, 
    (username) => {
        return get_user_by_username(username)
    }
)

// Funciones de atención de peticiones
app.get("/", check_not_authenticated, async (req, res) => {    
    res.redirect("/clients/hotel_list")              
})

app.get("/login", (req, res) => {
    res.render("user_login")
})

app.post("/login", passport.authenticate("local", {
    successRedirect: "/clients/hotel_list",
    failureRedirect: "/",
    failureFlash: true
}))

app.post("/logout", async (req, res) => {
    req.logOut(function(){
        res.redirect("/clients/hotel_list")
    })
})

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

// Asignación de atención de los routers a las rutas
app.use("/register", user_router);
app.use("/clients", client_router)

// Configuración del puerto

app.listen(port,() => {})