const express = require('express')
const app = express()
const db = require('./src/config/db')
const route = require('./src/routes/home')


app.use("/images/user",express.static('src/resources/user'));
app.use("/images/comment",express.static('src/resources/comments'));
app.use("/images/category",express.static('src/resources/category'));
//body-parser
app.use(express.urlencoded({ extended: true }))
app.use(express.json())

db.connect((error)=>{
    if(error){
        throw error
    }
    console.log("Connect database successful")
})

route(app)


app.listen(8000, () => {
    console.log("Sever is running")
})