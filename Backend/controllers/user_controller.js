const get_connection = require(".././mysql-config")

//funciones
async function login (req, res){
    const connection = await get_connection()
    const query = `SELECT * FROM Country;`
    connection.query(query, (err, rows) => {
        res.render("client_hotel_list", {content: rows, error: false, message: ""})
    })
    connection.end()
}

//nombres de cada funcion que hay arriba
module.exports = {
    login
}