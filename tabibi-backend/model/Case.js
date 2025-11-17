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

    // New medical questions
    heartProblems: {
        type: String,
    },

    surgicalOperations: {
        type: String,
    },

    currentDisease: {
        type: String,
    },

    currentDiseaseDetails: {
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

    doctorPhone: {
        type: String,
    },

    doctorTelegram: {
        type: String,
    },

    doctorUni: {
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
    
    phone: {
        type: String,
    },
    
    telegram: {
        type: String,
    },

    // case-sheet
    pain_continues: String,
    pain_eat: String,
    pain_eat_type: String, // Sub-question: ألم حاد ومستمر / ألم بسيط ويختفي
    pain_caild_drink: String,
    pain_caild_drink_type: String, // Sub-question: يستمر بعد بلع الماء البارد / ينقطع بعد بلع الماء البارد
    pain_hot_drink: String,
    pain_sleep: String,
    inflamation: String,
    teeth_movement: String,
    calcifications: String,
    pigmentation: String,
    pain_continues_gum: String,
    pain_eat_gum: String,
    roots: String,
    mouth_inflammation: String,
    mouth_ulcer: String,
    tooth_decay: String,
    bleeding_during_brushing: String,
    
    zone: {
        type: String,
    },
})

const Case = mongoose.model('Case', caseSchema, 'Case')
module.exports = Case