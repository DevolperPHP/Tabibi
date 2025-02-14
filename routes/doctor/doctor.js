const express = require('express')
const router = express.Router()
const isDoctorMiddleWare = require('../../middleware/isDoctor')
const getUser = require('../../middleware/getUser')
const Case = require('../../model/Case')
const User = require('../../model/User')
const moment = require('moment')

router.use(isDoctorMiddleWare)
router.use(getUser)

router.get('/cases', async (req, res) => {
    try {
        const cases = await Case.find({ status: 'free'}).sort({ sortedDate: -1})
        res.send(cases)
    } catch (err) {
        console.log(err);
    }
})

router.get('/case/info/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id })
        res.json(caseData)
    } catch (err) {
        console.log(err);

    }
})

router.put('/case/take/:id', async (req, res) => {
    try {
        await Case.updateOne({ _id: req.params.id }, {
            $set: {
                doctor: req.user.name,
                doctorId: req.user.id,
                startDate: moment().locale('ar-kw').format('l'),
                status: 'in-treatment',
                startSortedDate: Date.now()
            }
        })

        res.status(200).send("Case updated")
    } catch (err) {
        console.log(err);
    }
})

router.get('/my-cases', async (req, res) => {
    try {
        const caseData = await Case.find({ doctorId: req.user.id }).sort({ startSortedDate: -1 })
        res.json(caseData)
    } catch (err) {
        console.log(err);

    }
})


router.get('/my-case/get/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id })
        if (caseData.doctorId == req.user.id) {
            res.json(caseData)
        }
    } catch (err) {
        console.log(err);

    }
})

router.get('/my-case/details/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id })
        if (caseData.doctorId == req.user.id) {
            res.json(caseData)
        }
    } catch (err) {
        console.log(err);

    }
})

router.put('/my-case/details/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id })
        const { diagnose, doctorNote } = req.body
        if (caseData.doctorId == req.user.id) {
            await Case.updateOne({ _id: req.params.id }, {
                $set: {
                    diagnose: diagnose,
                    doctorNote: doctorNote
                }
            })

            res.status(200).send({ message: 'Info updated' })
        }
    } catch (err) {
        console.log(err);

    }
})

router.get('/my-case/done/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id })
        if (caseData.doctorId == req.user.id) {
            res.json(caseData)
        }
    } catch (err) {
        console.log(err);

    }
})

router.put('/my-case/done/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id })
        if (caseData.doctorId == req.user.id) {
            if(caseData.report == ""){
                res.status(500).send({ message : "Medical report must be entered"})
            } else {
                await Case.updateOne({ _id: req.params.id }, {
                    $set: {
                        status: "done",
                        report: req.body.report,
                        diagnose: req.body.diagnose
                    }
                })

                res.status(200).send({ message: "Info updated"})
            }
        }
    } catch (err) {
        console.log(err);

    }
})
module.exports = router