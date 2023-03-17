const User = require("../model/user")
const jwt = require('jsonwebtoken')
const Cryptr = require('cryptr');
const cryptr = new Cryptr('myTotallySecretKey');
const dotenv = require('dotenv');
const { json } = require("express");
if (typeof localStorage === "undefined" || localStorage === null) {
    var LocalStorage = require('node-localstorage').LocalStorage;
    localStorage = new LocalStorage('./scratch');
}

dotenv.config()
class UserController {

    createInfo(req, res) {
        const avatar ="/images/user/" + req.file.filename
        const fullname = req.body.fullname
        const city = req.body.city
        const district = req.body.district
        const ward = req.body.ward
        const userID = localStorage.getItem('userID')
        const phone = req.body.phone
        User.SearchUserID(userID, function (err, re) {
            if (err) res.json(err)
            else {
                if (Object.keys(re).length > 0) {
                    res.status(404).json({
                        status: false,
                        message: "User is exist"
                    })
                }
                else {

                    User.info([avatar, fullname, city, district, ward, phone, userID], function (err, re) {
                        if (err) res.status(400).json({
                            status: false,
                            message: "Create info fail"
                        })
                        else {
                            res.status(200).json({
                                status: "true",
                                message: "Create info Success",

                            })
                        }


                    })
                }
            }
        })





    }


    updateInfo(req, res) {
        const fullname = req.body.fullname
        const city = req.body.city
        const district = req.body.district
        const ward = req.body.ward
        const userID = localStorage.getItem('userID')
        const phone = req.body.phone
        User.update([fullname, city, district, ward, phone, userID], function (err, re) {
            if (err) res.status(400).json({
                status:false,
                message:"Update user failed"
            })
           
            res.status(200).json({
                status:true,
                message:"Update user successful"
            })
           
        })





    }

    updateAv(req,res){
        const userID = localStorage.getItem('userID')
        const avatar = "/images/user/"+req.file.filename
        User.updateAvatar([avatar,userID],(err,e)=>{
            if (err) res.status(400).json({
                status:false,
                message:"Update avatar failed"
            })
            res.status(200).json({
                status:true,
                message:"Update avatar successful"
            })
        })
    }


    login(req, res) {
        const email = req.body.email
        const password = req.body.password
        User.SearchEmail([email], function (err, re) {
            if (err) {
                res.json(err)
            }
            else {

                if (Object.keys(re).length > 0) {
                    Object.keys(re).forEach(function (key) {
                        const row = re[key]
                        const pass = row.password
                        const user =
                        {
                            userID: row.userID,
                            email: row.email
                        }
                        if (password == pass) {
                            if (Object.keys(re).length > 0) {
                                const accsessToken = jwt.sign(user, process.env.ACCESS_TOKEN_SECRET, {
                                    expiresIn: '30 day'
                                })
                                res.status(200).json({
                                    status: "true",
                                    message: "Login sucessful",
                                    jwt: accsessToken,

                                })



                            }
                            else {

                                res.status(400).json({ message: "Login fail" })
                            }
                        }

                    })
                }
                else {
                    res.status(403).json({
                        status: false,
                        message: "Email not exists",
                        email: email
                    })
                }

            }
        })


    }


    createUser(req, res) {
        const email = req.body.email
        const password = req.body.password
        User.SearchEmail([email], function (err, re) {
            if (err) res.json(err)
            else {
                if (Object.keys(re).length > 0) {
                    res.status(403).json({
                        status: false,
                        message: "Email already exists"
                    })
                }
                else {
                    User.SignUp([email, password], function (err, re) {
                        if (err) res.json(err)
                        else {
                            res.status(200).json({
                                status: "true",
                                message: "Create user sucessful",

                            })
                        }
                    })
                }
            }
        })

    }

    show(req,res){
        const userID = localStorage.getItem('userID')
        User.Showinfo(userID,function(err,re){
            if(err)res.json(err)
            else{
                res.status(200).json({
                    user:re
                })
            }
        })
    }
}

module.exports = new UserController 