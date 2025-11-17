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

    zone:{
        type: String,
        required: false
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
    },

    isDiagnoser: {
        type: Boolean,
        default: false,
    },

    role: {
        type: String,
    },

    role_req_date: {
        type: String
    },

    role_req_date_sort:{
        type: String,
    },

    id_card: {
        type: String,
    },

    telegram: {
        type: String,
    },

    gender: {
        type: String,
    },

    bp: {
        type: String,
        default: 'no'
    },

    diabetic: {
        type: String,
        default: 'no'
    },

    toothRemoved: {
        type: String,
        default: 'no'
    },

    tf: {
        type: String,
        default: 'no'
    },

    uni: {
        type: String,
        default: null
    },

    phone: String,

    fcmToken: {
        type: String,
        default: null
    },
})

const User = mongoose.model("User", userModel, "User")
module.exports = User