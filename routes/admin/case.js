const express = require('express')
const router = express.Router()
const isAdminMiddleWare = require('../../middleware/isAdmin')
const getUser = require('../../middleware/getUser')
const Case = require('../../model/Case')
const Category = require('../../model/Category')

router.use(isAdminMiddleWare)
router.use(getUser)

router.get('/', async (req, res) => {
    try {
        const cases = await Case.find({ adminStatus: 'waiting' }).sort({ sortedDate: -1 })
        res.json(cases)
    } catch (err) {
        console.log(err);
    }
})

router.get('/get/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id })
        const category = await Category.find({})
        res.json({
            case_data: caseData,
            category: category
        })
    } catch (err) {
        console.log(err);
    }
})

router.put('/accept/:id', async (req, res) => {
    try {
        const { diagnose, category, note } = req.body
        await Case.updateOne({ _id: req.params.id }, {
            $set: {
                diagnose: diagnose,
                category: category,
                note: note,
                adminStatus: 'accept'
            }
        })

        const data = await Case.findOne({ _id: req.params.id })
        return res.json({
            msg: 'Case accepted successfully , updated info: ',
            data: data
        })
    } catch (err) {
        console.log(err);

    }
})

router.put('/reject/:id', async (req, res) => {
    try {
        const rejectNote = req.body.rejectNote
        const caseData = await Case.findOne({ _id: req.params.id })
        
        await Case.updateOne({ _id: req.params.id }, {
            $set: {
                adminStatus: 'reject',
                rejectNote: rejectNote,
            }
        })
        
        // Allow user to apply again by setting inCase to false
        await User.updateOne({ _id: caseData.userId }, {
            $set: {
                inCase: false,
            }
        })
        
        return res.json({
            msg: "Case rejected successfully",
        })
    } catch (err) {
        console.log(err);
    }
})

module.exports = router