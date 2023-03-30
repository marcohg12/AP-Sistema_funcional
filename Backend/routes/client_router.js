// Importación de dependencias
const router = require("express").Router()

router.get("/hotel_list", async (req, res) => {

    var is_authenticated = false
    if (req.isAuthenticated()){
        is_authenticated = true

    }

    res.render("client_hotel_list", {hotels: [{name: "Hotel Maracuyá", classification: "4 Estrellas", province: "Guanacaste" }, 
                                              {name: "Hotel Vista Buena", classification: "3 Estrellas", province: "Puntarenas"}],
                                     is_authenticated: is_authenticated})
})


module.exports = router;