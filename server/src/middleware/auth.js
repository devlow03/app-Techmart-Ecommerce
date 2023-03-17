if (typeof localStorage === "undefined" || localStorage === null) {
    var LocalStorage = require('node-localstorage').LocalStorage;
    localStorage = new LocalStorage('./scratch');
}
const jwt = require('jsonwebtoken')
const dotenv = require('dotenv')
dotenv.config()
const verifyToken = (req, res, next) => {
    const authHeader = req.header('Authorization')
    const token = authHeader.substring(7, authHeader.length)
    //=> Bearer token




    if (!token) console.log(token)
    try {

        //decode token to json
        jwt.verify(token, process.env.ACCESS_TOKEN_SECRET,)
        //decode Token 
        const deToken = jwt.decode(token)

        Object.keys(deToken).forEach(function (key) {
            const userID = deToken.userID
            localStorage.setItem('userID', userID)


        })


        next()
    } catch (error) {
        console.log(error)
        return res.sendStatus(403)
    }

}

module.exports = verifyToken