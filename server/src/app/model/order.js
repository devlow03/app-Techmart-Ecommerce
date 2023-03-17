const db = require('../../config/db')


const order = {


    CreateOrder: function ([idOder, fullname, city, district, ward, phone, total, userID], callback) {
        return db.query("INSERT INTO `order` (`id_order`, `fullname`, `city`,`district`,`ward`, `phone`, `total`, `userID`)VALUES (?, ?,?,?,?, ?, ?, ?);SELECT * FROM cart inner join products on cart.id like products.id WHERE cart.userID = ?", [idOder, fullname, city, district, ward, phone, total, userID, userID], callback)
    },

    CreateDetail: function ({id, name, image, amount, price, idOder, userID}, callback) {
        return db.query("INSERT INTO `order_detail` (`idDetail`, `id`, `name`, `image`, `amount`, `price`, `id_order`) VALUES (NULL, ?, ?, ?,?, ?, ?);DELETE FROM cart WHERE userID = ?", [id, name, image, amount, price, idOder, userID], callback)
    },
    ShowOrder: function (userID, callback) {
        return db.query("SELECT * FROM `order` INNER JOIN order_detail on `order`.`id_order`like order_detail.id_order WHERE `order`.userID = ?", [userID], callback)
    },

    OrderOne: function ([idOder, fullname, city, district, ward, phone, total, userID, id, name, image, amount, price], callback) {
        return db.query("INSERT INTO `order` (`id_order`, `fullname`, `city`,`district`,`ward`, `phone`, `total`, `userID`)VALUES (?, ?,?,?,?, ?, ?, ?);INSERT INTO `order_detail` (`idDetail`, `id`, `name`, `image`, `amount`, `price`, `id_order`) VALUES (NULL, ?, ?, ?,?, ?, ?)", [idOder, fullname, city, district, ward, phone, total, userID, id, name, image, amount, price,idOder], callback)
    },









}


module.exports = order