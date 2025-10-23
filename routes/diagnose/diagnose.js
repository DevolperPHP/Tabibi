const express = require('express')
const router = express.Router()
const isDiagnoserMiddleWare = require('../../middleware/isDiagnoser')
const getUser = require('../../middleware/getUser')
const Case = require('../../model/Case')

router.use(isDiagnoserMiddleWare)
router.use(getUser)

router.get('/pending', async (req, res) => {
    try {
        const cases = await Case.find({ adminStatus: 'waiting' }).sort({ sortedDate: -1 })
        res.json(cases)
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
        await Case.updateOne({ _id: req.params.id }, {
            $set: {
                adminStatus: 'reject',
                rejectNote: rejectNote,
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