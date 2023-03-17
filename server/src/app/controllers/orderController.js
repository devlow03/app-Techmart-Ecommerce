const { v4: uuidv4 } = require('uuid');
const Order = require("../model/order")


if (typeof localStorage === "undefined" || localStorage === null) {
    var LocalStorage = require('node-localstorage').LocalStorage;
    localStorage = new LocalStorage('./scratch');
}
class OrderController {

    createOrder(req, res) {

        const idOrder = "DH" + uuidv4()
        localStorage.setItem("idOrder", idOrder)
        const fullname = req.body.fullname
        const city = req.body.city
        const district = req.body.district
        const ward = req.body.ward
        const phone = req.body.phone
        const total = req.body.total
        const userID = localStorage.getItem('userID')
        Order.CreateOrder([idOrder, fullname, city, district, ward, phone, total, userID, userID], function (err, re) {
            if (err) return res.json(err)
            else {
                // res.json(re[1])
                if (Object.keys(re[1]).length > 0) {
                    Object.keys(re[1]).forEach(function (key) {
                        const row = re[1][key]
                        const id = row.id
                        const name = row.name
                        const image = row.img_link
                        const amount = row.amount
                        const price = row.price
                        const idOder = localStorage.getItem('idOrder')
                        const userID = localStorage.getItem('userID')
                        Order.CreateDetail({ id, name, image, amount, price, idOder, userID }, function (err, re) {
                            if (err) return res.json(err)
                            else {
                                res.status(200).json({
                                    status: true,
                                    message: "Order successful"
                                })

                            }
                        })
                    })
                }
                else {
                    res.status(400).json({
                        status: false,
                        message: "Not product in cart"

                    })
                }
            }

        })



    }

    show(req, res) {
        const userID = localStorage.getItem('userID')
        Order.ShowOrder(userID, function (err, re) {
            if (err) res.status(400).json({
                status: false,
                message: "Order is wrong"
            })
            else {
                res.status(200).json({
                    status: true,
                    order: re
                })
            }
        })
    }

    orderOne(req, res) {
        const idOrder = "DH" + uuidv4()
        localStorage.setItem("idOrder", idOrder)
        const fullname = req.body.fullname
        const city = req.body.city
        const district = req.body.district
        const ward = req.body.ward
        const phone = req.body.phone
        const total = req.body.total
        const userID = localStorage.getItem('userID')
        const id = req.body.id
        const name = req.body.name
        const image = req.body.image
        const amount = req.body.amount
        const price = req.body.price
        Order.OrderOne([idOrder, fullname, city, district, ward, phone, total, userID, id, name, image, amount, price], function (err, re) {
            if (err) return res.json(err)
            else {
                res.status(200).json({
                    status: true,
                    message: "Order successful"
                })

            }
        })
    }


}

module.exports = new OrderController