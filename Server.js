// Inclusión de bibliotecas
const express = require("express")

// Configuraciones del servidor
const app = express();
app.use(express.urlencoded({extended: false}))
app.use(express.static(__dirname))
app.set("view engine", "ejs")

// Funciones de atención de peticiones
app.get("/", async (req, res) => {
    res.render("login")
});

// Configuración del puerto
app.listen(4500)
