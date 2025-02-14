const express = require('express')
const router = express.Router()
const isUser = require('../../middleware/isUser')
const getUser = require('../../middleware/getUser')
const Case = require('../../model/Case')
const multer = require('multer')
const User = require('../../model/User')
const fs = require('fs')
const moment = require('moment')

router.use(isUser)
router.use(getUser)


const storage = multer.diskStorage({
    destination: function (req, file, callback) {
        callback(null, "./public/upload/images");
    },

    filename: function (req, file, callback) {
        callback(null, Date.now() + file.originalname);
    },
});

const upload = multer({
    storage: storage,
    limits: {
        fileSize: 1024 * 1024 * 1000 * 1000,
    },
});

router.post('/new', upload.single('image'), async (req, res) => {
    try {
        const { bp, diabetic, toothRemoved, tf, note } = req.body
        if (typeof req.file === "undefined") {
            res.status(500).send("Image must be uploaded")
        } else if (req.user.inCase == true) {
            res.status(500).send("User already in case")

        } else {
            const newCase = [
                new Case({
                    name: req.user.name,
                    aeg: req.user.age,
                    userId: req.user.id,
                    bp: bp,
                    diabetic: diabetic,
                    toothRemoved: toothRemoved,
                    tf: tf,
                    image: req.file.filename,
                    note: note,
                    sortedDate: Date.now(),
                    Date: moment().locale('ar-kw').format('l')
                })
            ]

            newCase.forEach((data) => {
                data.save()
            })

            await User.updateOne({ _id: req.user.id }, {
                $set: {
                    inCase: true,
                }
            })

            res.status(200).send({ message: "Case sent successfully" })
        }
    } catch (err) {
        console.log(err);
    }
})

router.delete('/cancel/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id })
        if (req.user.id == caseData.userId || req.user.isAdmin == true) {
            await User.updateOne({ _id: caseData.userId }, {
                $set: {
                    inCase: false,
                }
            })
            fs.unlinkSync(`./public/upload/images/${caseData.image}`)
            await Case.deleteOne({ _id: req.params.id })
            res.status(200).send("Case deleted successfully")
        }
    } catch (err) {
        console.log(err);

    }
})

router.get('/edit/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id })
        if (req.user.id == caseData.userId || req.user.isAdmin == true) {
            res.json(caseData)
        }
    } catch (err) {
        console.log(err);
    }
})

router.put('/edit/:id', upload.single('image'), async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id })
        if (req.user.id == caseData.userId || req.user.isAdmin == true) {
            const { bp, diabetic, toothRemoved, tf, note } = req.body
            if (typeof req.file === "undefined") {
                await Case.updateOne({ _id: req.params.id }, {
                    $set: {
                        bp: bp,
                        diabetic: diabetic,
                        toothRemoved: toothRemoved,
                        tf: tf,
                        note: note
                    }
                })
            } else {
                fs.unlinkSync(`./public/upload/images/${caseData.image}`)
                await Case.updateOne({ _id: req.params.id }, {
                    $set: {
                        bp: bp,
                        diabetic: diabetic,
                        toothRemoved: toothRemoved,
                        tf: tf,
                        note: note,
                        image: req.file.filename,
                    }
                })
            }

            res.status(200).send("Info updated successfully")
        }
    } catch (err) {
        console.log(err);
    }
})

module.exports = router