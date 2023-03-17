const db = require('../../config/db')
const cart = {


    getCart: function (id, callback) {
        return db.query("SELECT * FROM cart inner join products on cart.id like products.id WHERE cart.userID = ?;SELECT sum(products.price * cart.amount)as total FROM cart inner join products on cart.id like products.id WHERE cart.userID = ?", [id, id], callback)
    },

    getCartById: function ([id, userID], callback) {
        return db.query("select * from cart inner join user on user.userID like cart.userID where cart.id = ? and cart.userID = ? ", [id, userID], callback)
    },

    createCart: function ([userID, id, amount], callback) {
        return db.query("INSERT INTO `cart` (`idCart`, `userID`, `id`, `amount`) VALUES (NULL, ?, ?, ?)", [userID, id, amount], callback)
    },


    updateQuantum: function ([amount, idCart], callback) {
        return db.query("UPDATE `cart` SET `amount` = ? WHERE `cart`.`idCart` = ?", [amount, idCart], callback)
    },

    totalCart: function (userID, callback) {
        return db.query("SELECT sum(products.price * cart.amount)as total FROM cart inner join products on cart.id like products.id WHERE cart.userID = ?", [userID], callback)
    },

    removeCart: function (idCart, callback) {
        return db.query("DELETE FROM cart WHERE idCart = ?", [idCart], callback)
    }

}


module.exports = cart