const mongoose = require('mongoose')
const userModel = mongoose.Schema({
    name:{
        type: String,
        required: true
    },

    age:{
        type: Number,
        required: true
    },

    city:{
        type: String,
        required: true
    },

    email:{
        type: String,
        required: true
    },

    password:{
        type: String,
        required: true
    },

    isAdmin: {
        type: Boolean,
        default: false
    },

    inCase: {
        type: Boolean,
        default: false,
    },

    isDoctor: {
        type: Boolean,
        default: false
    }
})

const User = mongoose.model("User", userModel, "User")
module.exports = User