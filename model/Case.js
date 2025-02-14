const mongoose = require('mongoose')

const caseSchema = mongoose.Schema({
    name: {
        type: String,
    },

    userId: {
        type: String
    },

    age: {
        type: String,
    },

    bp: {
        type: String,
    },

    diabetic: {
        type: String,
    },

    toothRemoved: {
        type: String,
    },

    tf: {
        type: String,
    },

    image: {
        type: String,
    },

    note: {
        type: String,
    },
    
    status: {
        type: String,
        default: 'free',
    },

    doctor: {
        type: String,
    },

    doctorId: {
        type: String,
    },

    startDate: {
        type: String
    },

    startSortedDate: {
        type: String
    },

    Date: {
        type: String
    },

    sortedDate: {
        type:String,
    },

    endDate: {
        type: String
    },

    diagnose: {
        type: String
    },

    doctorNote: {
        type: String
    },
    
    report:{
        type: String
    }
})

const Case = mongoose.model('Case', caseSchema, 'Case')
module.exports = Case