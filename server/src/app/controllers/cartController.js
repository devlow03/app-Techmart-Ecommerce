const Cart = require("../model/cart")
if (typeof localStorage === "undefined" || localStorage === null) {
    var LocalStorage = require('node-localstorage').LocalStorage;
    localStorage = new LocalStorage('./scratch');
}


class CartController {

    show(req, res) {
        const userID = localStorage.getItem('userID')
        Cart.getCart(userID, function (err, re) {
            if (err) res.json(err)
            else {
                if (Object.keys(re[0]).length > 0) {
                    Object.keys(re[1]).forEach(function (key) {
                        const row = re[1][key]
                        const total = row.total

                        res.status(200).json({
                            status: true,
                            cart: re[0],
                            total: total
                        })
                    })

                }

                else {
                    res.status(404).json({
                        status: false,
                        message: "Cart is not exist",

                    })
                }
            }

        })
    }

    create(req, res) {
        const userID = localStorage.getItem('userID')
        const id = req.body.id

        Cart.getCartById([id, userID], function (err, re) {
            if (err) {
                res.status(400).json({
                    status: false,
                    message: "Create cart failed"
                })
            }
            else {

                if (Object.keys(re).length > 0) {
                    //data to object
                    Object.keys(re).forEach(function (key) {
                        const row = re[key]
                        const amount = row.amount + 1
                        const id = req.body.id

                        Cart.updateQuantum({ amount, id, userID }, function (err, re) {
                            if (err) res.status(400).json({
                                status: false,
                                message: "Create cart failed"
                            })
                            res.status(200).json({
                                status: true,
                                message: "Update quantum cart success"
                            })
                        })
                    })


                }
                else {
                    const amount = req.body.amount
                    const id = req.body.id
                    Cart.createCart([userID, id, amount], function (err, re) {
                        if (err) res.json(err)
                        res.status(200).json({
                            status: true,
                            message: "Create cart success"
                        })
                    })
                }
            }
        })
    }



    sum(req, res) {
        const userID = localStorage.getItem('userID')
        Cart.totalCart(userID, function (err, re) {
            if (err) res.json(re)
            res.status(200).json({
                status: true,
                message: "Success",
                data: re
            })
        })
    }

    remove(req, res) {

        Cart.removeCart(req.params.id, function (err,re) {
            if (err) res.status(400).json({
                status: false,
                message: "remove failed"
            })
            res.status(200).json({
                status: true,
                message: "remove cart success"
            })
        })
    }

    update(req,res){
       
        const amount = req.body.amount
        const idCart = req.body.idCart
        Cart.updateQuantum([amount,idCart],function(err,re){
            if(err) res.json(err)
            // if(err) res.status(400).json({
            //     status:false,
            //     message:"update amount fail"
            // })
            res.status(200).json({
                status:true,
                message:"update amount success"
            })
        })
        
    }

}

module.exports = new CartController