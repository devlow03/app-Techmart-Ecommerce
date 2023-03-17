const express = require('express')
const router = express.Router()


const productController = require("../app/controllers/productController")

router.get('/v1/prod',productController.showProd)
router.get('/v1/category',productController.showCategory)
router.get('/v1/category/:id',productController.showProdCategory)
// router.get('/v1/prod/:id',productController.showProdOne)
router.get('/v1/prod/slider/:id',productController.showSlider)
router.get('/v1/prod/search/:name',productController.search)


module.exports = router