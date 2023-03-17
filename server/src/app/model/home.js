const db = require('../../config/db')
const home = {
    Banner: function (callback) {
        return db.query("SELECT * FROM `bannerimg`", callback)
    },
}


module.exports = home