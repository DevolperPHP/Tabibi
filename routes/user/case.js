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
  destination: (req, file, cb) => {
    cb(null, './public/upload/images');
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + '-' + file.originalname);
  }
});

const upload = multer({
  storage,
  limits: { fileSize: 1024 * 1024 * 100 }, // 100 MB max
});

router.post('/new', upload.any(), async (req, res) => {
  try {
    const {
      note,
      toothRemoved,
      category,
      type,
      pain,
      pain_eat,
      pain_cold_drink,
      pain_hot_drink,
      pain_sleep,
      pain_sweet,
      malignant,
      allergic_to_liqued,
      unstable_teeth,
      smell,
      bleeding_brush,
      bleeding_clean,
      gum_pain,
      gum_pain_eat,
    } = req.body;
    const files = req.files || [];
    if (files.length < 3) {
      return res.status(400).json({ error: 'At least 3 images must be uploaded' });
    }
    const fileMap = {};
    files.forEach(file => {
      fileMap[file.fieldname] = file.filename;
    });

    if (req.user?.inCase === true) {
      return res.status(400).json({ error: 'User already in case' });
    }

    const {name , age, bp, diabetic, tf, phone, telegram} = req.user
    const newCase = new Case({
      name,
      age,
      userId: req.user.id,
      phone,
      telegram,
      bp,
      diabetic,
      toothRemoved: toothRemoved,
      tf,
      imageLeft: fileMap['imageLeft'] || null,
      imageRight: fileMap['imageRight'] || null,
      imageTop: fileMap['imageTop'] || null,
      imageBottom: fileMap['imageBottom'] || null,
      imageChock: fileMap['imageChock'] || null,
      imageFront: fileMap['imageFront'] || null,
      imageCheek: fileMap['imageCheek'] || null,
      imageToung: fileMap['imageToung'] || null,
      drugsImage: fileMap['drugsImage'] || null,
      note,
      sortedDate: Date.now(),
      Date: moment().locale('ar-kw').format('l'),
      category,
      type,
      pain,
      pain_eat,
      pain_cold_drink,
      pain_hot_drink,
      pain_sleep,
      pain_sweet,
      malignant,
      allergic_to_liqued,
      unstable_teeth,
      smell,
      bleeding_brush,
      bleeding_clean,
      gum_pain,
      gum_pain_eat,
    });

    await newCase.save();

    // Mark user as "in case"
    await User.updateOne({ _id: req.user.id }, { $set: { inCase: true } });

    res.status(200).json({ message: 'Case sent successfully' });

  } catch (err) {
    console.error('Error creating case:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

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
                        note: note,
                        adminStatus: 'waiting'
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
                        adminStatus: 'waiting'
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