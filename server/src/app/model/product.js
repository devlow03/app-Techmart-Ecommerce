const db = require('../../config/db')
const product = {


    Category: function (callback) {
        return db.query("SELECT * FROM `category`", callback)
    },


    ProdCategory: function (id, callback) {
        return db.query("SELECT * FROM category inner join products on products.id_category like category.id_category WHERE products.id_category=?", [id], callback)
    },

    Product: function (callback) {
        return db.query("SELECT * FROM `products`", callback)
    },

    ProductById: function (id, callback) {
        return db.query("SELECT * FROM `products` WHERE id = ?", [id], callback)
    },

    SliderProduct: function (id, callback) {
        return db.query("SELECT * FROM img_slider WHERE id = ?", [id], callback)
 },
    SearchProduct:function(name,callback){
        return db.query("SELECT * FROM products inner join category on category.id_category  LIKE products.id_category WHERE MATCH(products.name) AGAINST('"+name+"') OR MATCH(category.name_type) AGAINST('"+name+"')",[name,name],callback)
    }   

}


module.exports = product