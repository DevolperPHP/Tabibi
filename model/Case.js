const mongoose = require('mongoose')

const caseSchema = new mongoose.Schema({
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

    // images

    imageLeft: {
        type: String,
    },

    imageRight: {
        type: String,
    },

    imageTop: {
        type: String,
    },

    imageBottom: {
        type: String,
    },

    imageFront: {
        type: String,
    },

    imageChock: {
        type: String,
    },

    imageCheek: {
        type: String,
    },

    imageToung: {
        type: String,
    },

    // end images

    drugsImage: {
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
        type: String,
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

    report: {
        type: String
    },

    adminStatus: {
        type: String,
        default: 'waiting'
    },

    rejectNote: {
        type: String,
    },

    category: {
        type: String,
    },

    type: {
        type: String,
    },

    pain: String,
    pain_eat: String,
    pain_cold_drink: String,
    pain_hot_drink: String,
    pain_sleep: String,
    pain_sweet: String,
    malignant: String,
    allergic_to_liqued: String,
    unstable_teeth: String,
    smell: String,

    bleeding_brush: String,
    bleeding_clean: String,
    gum_pain: String,
    gum_pain_eat: String,
})

const Case = mongoose.model('Case', caseSchema, 'Case')
module.exports = Case