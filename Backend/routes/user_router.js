// Importación de dependencias
const express = require("express")
const passport = require("passport")
const get_connection = require(".././mysql-config")
const router = express.Router();

router.get("/", async (req, res) => {
    const connection = await get_connection()
    const query = `SELECT * FROM Country;`
    connection.query(query, (err, rows) => {
        console.log(rows)
        res.render("client_hotel_list", {content: rows, error: false, message: ""})
    })
    connection.end()
})

module.exports = router;