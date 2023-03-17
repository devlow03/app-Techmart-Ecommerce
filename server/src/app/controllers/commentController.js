const Comment = require("../model/comment")
if (typeof localStorage === "undefined" || localStorage === null) {
    var LocalStorage = require('node-localstorage').LocalStorage;
    localStorage = new LocalStorage('./scratch');
}

class CommentController {
    
    show(req, res) {
        
        Comment.showComment(req.params.id, function (err, re) {
            if (err) res.json(err)
            res.status(200).json({

                Comment: re
            })

        })
    }

    create(req, res) {

        const comment = req.body.comment

        const img = "/images/comment/" + req.file.filename
        var date = new Date()
        var day = date.getDate() + '/' + (date.getMonth() + 1) + '/' + date.getFullYear()
        var hours = date.getHours() + ':' + date.getMinutes()
        const userID = req.body.userID
        const id = req.body.id


        Comment.createComment([comment, img, day, hours, userID, id], function (err, re) {
            if (err) res.json(err)

            res.status(200).json({ message: "create comment success" })

        })
    }



}

module.exports = new CommentController