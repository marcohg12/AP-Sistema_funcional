const local_strategy = require("passport-local").Strategy
const bcrypt = require("bcrypt")

function initialize(passport, get_user_by_username, get_user_by_id){

    const authenticate_user = async (username, password, done) => {
        const user = get_user_by_username(username)
    
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

    passport.use(new local_strategy({usernameField: "username"}, 
                 authenticate_user))
    passport.serializeUser((user, done) => done(null, user.id))
    passport.deserializeUser((id, done) => {
        return done(null, get_user_by_id(id))
    })
}

module.exports = initialize