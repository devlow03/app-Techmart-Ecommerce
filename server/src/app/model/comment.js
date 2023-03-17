const db = require('../../config/db')


const comment = {


    showComment: function (id, callback) {
        return db.query("SELECT * FROM `comment`inner join `user_detail` on `user_detail`.userID like `comment`.userID where id =?", [id], callback)
    },

    createComment: function ([comment, img, date, time, userID, id], callback) {
        return db.query("INSERT INTO `comment` (`idComment`, `comment`, `img`, `date`, `time`, `userID`, `id`) VALUES (NULL, ?, ?, ?, ?, ?, ?)", [comment, img, date, time, userID, id], callback)
    }





}


module.exports = comment