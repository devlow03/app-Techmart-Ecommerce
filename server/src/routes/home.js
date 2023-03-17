const prodRoute = require('./product')
const cartRoute = require('./cart')
const commentRoute = require('./comment')
const userRoute = require('./user')
const orderRoute = require('./order')
const homeController = require("../app/controllers/homeController")


function route(app) {
    app.use('/api', commentRoute)
    app.use('/api', cartRoute)
    app.use('/api', prodRoute)
    app.use('/api', orderRoute)
    app.use('/api', userRoute)
    app.get('/api/v1/banner', homeController.show)

}


module.exports = route