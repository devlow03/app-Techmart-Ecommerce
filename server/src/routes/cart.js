const express = require('express')
const router = express.Router()
const verifyToken = require("../middleware/auth")

const cartController = require("../app/controllers/cartController")

router.get('/v1/cart', verifyToken, cartController.show)
router.get('/v1/cart/sum', verifyToken, cartController.sum)
router.delete('/v1/cart/remove/:id', verifyToken, cartController.remove)
router.post('/v1/cart/create', verifyToken, cartController.create)
router.put('/v1/cart/update',verifyToken, cartController.update)


module.exports = router