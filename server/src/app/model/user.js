const db = require('../../config/db')
const user = {
    
    SignUp: function ([email, password], callback) {

        return db.query("INSERT INTO `user` (`userID`, `email`, `password`) VALUES ( NULL,?, ?)", [email, password], callback)
    },

    SearchEmail: function (email, callback) {

        return db.query("select * from user where email = ?", [email], callback)
    },

    SearchUserID: function (user, callback) {

        return db.query("select * from  `user_detail` where userID = ?", [user.userID], callback)
    },

    info: function ([avatar, fullname, city, district, ward, phone, userID], callback) {
        return db.query("INSERT INTO `user_detail` (`id_detail`, `avatar`, `fullname`, `city`, `district`, `ward`, `phone`, `userID`) VALUES (NULL,?, ?, ?, ?, ?, ?, ?)", [avatar, fullname, city, district, ward, phone, userID], callback)
    },
    update:function([fullname, city, district, ward, phone, userID],callback){
        return db.query("UPDATE `user_detail` SET `fullname` = ?,`city` = ? , `district` = ?, `ward` = ?,`phone` = ? WHERE `user_detail`.`userID` = ?",[fullname, city, district, ward, phone, userID],callback)
    },
    updateAvatar:function([avatar,userID],callback){
        return db.query("UPDATE `user_detail` SET `avatar` = ? WHERE `user_detail`.`userID` = ?",[avatar,userID],callback)
    },
    Showinfo:function(userID,callback){
        return db.query("SELECT * FROM `user_detail` where userID = ?",[userID],callback)
    }
}


module.exports = user