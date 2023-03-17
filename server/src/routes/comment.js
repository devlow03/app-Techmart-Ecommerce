const express = require('express')
const router = express.Router()
const commentController = require("../app/controllers/commentController")
const path = require('path')
const multer = require('multer')
const verifyToken = require("../middleware/auth")


const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'src/resources/comments')
  },

  filename: function (req, file, cb) {
    return cb(null, `${file.fieldname}${Date.now()}${path.extname(file.originalname)}`)
  }
})



const upload = multer({ storage: storage }).single('img')

router.get('/v1/prod/comment',verifyToken, commentController.show)
router.post('/v1/prod/comment/create',verifyToken, upload, commentController.create)



module.exports = router