// Inclusión de bibliotecas
const express = require("express")
const bcrypt = require("bcrypt")
const initialize_passport = require("./passport-config")
const passport = require("passport")
const flash = require("express-flash")
const session = require("express-session")
const user_router = require("./Backend/routes/user_router")
const client_router = require("./Backend/routes/client_router")
const hotel_admin_router = require("./Backend/routes/hotel_admin_router")
const master_admin_router = require("./Backend/routes/master_admin_router")
const { get_user_by_username } = require("./Backend/controllers/user_controller")
const cors = require('cors')
const bodyParser = require("body-parser")
const port = 4500

// Configuraciones del servidor
const app = express();
app.use(express.urlencoded({extended: true}));
app.use(bodyParser.json())
app.use(express.static(__dirname));
app.set("view engine", "ejs")
app.use(flash())
app.use(session({
    secret: "Ok6I7urIEstRyxn",
    resave: false,
    saveUninitialized: false
}))
app.use(passport.initialize())
app.use(passport.session())

// Configuración de la sesión
initialize_passport(
    passport, 
    (username) => {
        return get_user_by_username(username)
    }
)

// Configuración para peticiones

//Configuración de peticiones
const corsOptions ={
    origin:'http://localhost:4500', 
    credentials:true,           
    optionSuccessStatus:200
}
app.use(cors(corsOptions));

// Funciones de atención de peticiones
app.get("/", async (req, res) => {    
    res.redirect("/clients/hotel_list")              
})

app.get("/login", check_not_authenticated, async (req, res) => {
    res.render("user_login")
})

app.get("/user_logged_in", async (req, res) => {
    if (req.user.user_type_id == 1){
        res.redirect("/hotel_admins")
    } else if (req.user.user_type_id == 2){
        res.redirect("/master_admins")

    } else {
        res.redirect("/clients/hotel_list")
    }
}) 

app.post("/login", passport.authenticate("local", {
    successRedirect: "/user_logged_in",
    failureRedirect: "/login",
    failureFlash: true
}))

app.post("/logout", async (req, res) => {
    req.logOut(function(){
        res.redirect("/clients/hotel_list")
    })
})

// Funciones de verificación de autenticación
function check_not_authenticated(req, res, next){
    if (req.isAuthenticated()){
        return res.redirect("/")
    }
    next()
}

// Asignación de atención de los routers a las rutas
app.use("/register", user_router)
app.use("/my_account", user_router)
app.use("/clients", client_router)
app.use("/hotel_admins", hotel_admin_router)
app.use("/master_admins", master_admin_router)

// Configuración del puerto

app.listen(port,() => {})