const Product = require("../model/product")

class ProductController {

    showCategory(req, res) {
        Product.Category(function (err, re) {
            if (err) res.json(err)
            res.status(200).json({

                category: re
            })

        })
    }

    showProdCategory(req, res) {
        Product.ProdCategory(req.params.id, function (err, re) {
            if (err) res.json(err)
            res.status(200).json({

                prod_category: re
            })
        })
    }

    showProd(req, res) {
        Product.Product(function (err, re) {
            if (err) res.json(err)
            res.status(200).json({
                prod: re
            })
        })
    }


    // showProdOne(req, res) {
    //     Product.ProductById(req.params.id, function (err, re) {
    //         if (err) res.json(err)
    //         res.status(200).json({

    //             prod_id: re
    //         })
    //     })
    // }

    showSlider(req, res) {
        Product.SliderProduct(req.params.id, function (err, re) {
            if (err) res.json(err)
            res.status(200).json({
                slider: re
            })
        })
    }
    search(req,res){
        Product.SearchProduct(req.params.name,function(err,re){
            if (err) res.status(400).json({
                message:"Product not exist"
            })
            res.status(200).json({
                searchProducts: re
            })
        })
    }
}

module.exports = new ProductController