// Inclusión de bibliotecas
const express = require("express")
const bcrypt = require("bcrypt")
const initialize_passport = require("./passport-config")
const passport = require("passport")
const flash = require("express-flash")
const session = require("express-session")
const get_connection = require("./Backend/mysql-config")
const user_router = require("./Backend/routes/user_router");
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
    (username) => {},
    (id) => {}
)

// Funciones de atención de peticiones
app.get("/", check_not_authenticated, async (req, res) => {
    //res.render("client_hotel_list", {hotels: [{name: "Hotel Maracuyá", classification: "4 Estrellas", province: "Guanacaste" }, {name: "Hotel Vista Buena", classification: "3 Estrellas", province: "Puntarenas"}]})
    /*
    res.render("client_hotel_main", {hotel_id: "", hotel_name: "Hotel Linda Vista", hotel_classification: "4 Estrellas", 
                                     hotel_address: "Playa Tamarindo, Tamarindo, Guanacaste", amenities: ["Piscina", "Restaurante", "Gimnasio", "Campo de golf"],
                                     hotel_review_avg: 4.6, 
                                     offers: [{id: "", name: "40% Descuento en Habitaciones Doble", 
                                               initial_date: "2023-03-25", ending_date: "2023-03-30"},
                                               {id: "", name: "50% Descuento en Habitaciones Sencillas", 
                                               initial_date: "2023-03-25", ending_date: "2023-03-30"}],
                                     rooms: [{id: "", name: "Habitación sencilla", price: 150, capacity: 2},
                                             {id: "", name: "Habitación doble", price: 290, capacity: 4},
                                             {id: "", name: "Habitación deluxe", price: 350, capacity: 2},
                                             {id: "", name: "Habitación deluxe doble", price: 600, capacity: 4},
                                             {id: "", name: "Habitación royal", price: 750, capacity: 2}] })
    */
   res.render("user_data_edition_2")
                                             

})

app.post("/logout", async (req, res) => {
    req.logOut()
    req.redirect("/")
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
app.use(user_router);

// Configuración del puerto

app.listen(port,() => {
    console.log('Server is up!');
})