const express = require('express')
const router = express.Router()
const verifyToken = require("../middleware/auth")

const orderController = require("../app/controllers/orderController")
    router.post('/v1/prod/order', verifyToken,orderController.createOrder)
    router.post('/v1/prod/order/one', verifyToken,orderController.orderOne)
    router.get('/v1/prod/order',verifyToken,orderController.show)


module.exports = router