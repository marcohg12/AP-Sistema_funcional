const local_strategy = require("passport-local").Strategy
const bcrypt = require("bcrypt")

function initialize(passport, get_user_by_username){

    const authenticate_user = async (username, password, done) => {
        const user = await get_user_by_username(username)
    
        if (user == null){
            return done(null, false, {message: "Usuario no encontrado"})
        }
    
        try {
            if (await bcrypt.compare(password, user.password)){
                return done(null, user)
            } else {
                return done(null, false, {message: "Contraseña incorrecta"})
            }
    
        } catch (error){
            return done(error)
    
        }
    }

    passport.use(new local_strategy({usernameField: "username"}, authenticate_user))
    passport.serializeUser((user, done) => done(null, user.username))
    passport.deserializeUser(async (username, done) => {
        return done(null, await get_user_by_username(username))
    })
}

module.exports = initialize