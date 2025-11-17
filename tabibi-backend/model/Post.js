const mongoose = require('mongoose')

const postSchema = mongoose.Schema({
    title: {
        type: String,
        required: true
    },

    des: {
        type: String,
        required: true
    },

    image: {
        type: String,
        required: true
    },

    user: {
        type: String,
    },

    sortDate: {
        type: String,
    },

    Date: {
        type: String,
    },
})

const Post = mongoose.model('Posts', postSchema, 'Posts')
module.exports = Post