const express = require('express')
const router = express.Router()
const verifyToken = require("../middleware/auth")
const userController = require("../app/controllers/userController")
const path = require('path')
const multer = require('multer')

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'src/resources/user')
  },

  filename: function (req, file, cb) {
    return cb(null, `${file.fieldname}${Date.now()}${path.extname(file.originalname)}`)
  }
})

const upload = multer({ storage: storage }).single('avatar')

router.post('/v1/user/login', userController.login)
router.post('/v1/user/create', userController.createUser)
router.put('/v1/user/info/update', verifyToken,userController.updateInfo)
router.put('/v1/user/info/avatar', verifyToken,upload,userController.updateInfo)
router.post('/v1/user/info/create', verifyToken, upload, userController.createInfo)
router.get('/v1/user',verifyToken,userController.show)

module.exports = router