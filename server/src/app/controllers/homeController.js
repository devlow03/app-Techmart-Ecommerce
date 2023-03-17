const Home = require("../model/home")

class HomeController {

    show(req, res) {
        Home.Banner(function (err, re) {
            if (err) res.json(err)
            res.status(200).json({
                message: "success",
                data: re
            })

        })
    }


}

module.exports = new HomeController