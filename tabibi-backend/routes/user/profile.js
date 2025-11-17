const express = require('express')
const router = express.Router()
const isUserMiddleWare = require('../../middleware/isUser')
const getUserInfo = require('../../middleware/getUser')
const Case = require('../../model/Case')
const User = require('../../model/User')
const moment = require('moment')
const multer = require('multer')

router.use(isUserMiddleWare)
router.use(getUserInfo)

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

router.get('/', async (req, res) => {
    try {
        const cases = await Case.find({ userId: req.user.id }).sort({ sortDate: -1 })
        
        // Enrich each case with user gender
        const enrichedCases = cases.map(caseItem => {
            const caseObj = caseItem.toObject();
            caseObj.gender = req.user.gender || 'unknown';
            return caseObj;
        });
        
        res.json({ userData: req.user, cases: enrichedCases })
    } catch (err) {
        console.log(err);
        
    }
})

router.get('/info/update', async (req, res) => {
    try {
        res.json(req.user)
    } catch (err) {
        console.log(err);
        
    }
})

router.put('/info/update', async (req, res) => {
    try {
        const { name, age, city, zone } = req.body
        if(name == "" || age == "", city == ""){
            res.status(500).send({ message: 'You must enter all required info (name, age ,city)'})
        } else {
            await User.updateOne({ _id: req.user.id }, {
                $set: {
                    name: name,
                    age: age,
                    city: city,
                    zone: zone || ''
                }
            })

            res.status(200).send({ message: "info updated"})
        }
    } catch (err) {
        console.log(err);
        
    }
})

router.delete('/info/delete/', async (req, res) =>{
    try {
        await User.deleteOne({ _id: req.user.id })
        res.status(200).send({ message: "Account Deleted"})
    } catch (err) {
        console.log(err);
        
    }
})

router.get('/case/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id })
        if(caseData.userId == req.user.id){
            // Enrich case with user gender
            let enrichedCase = caseData.toObject();
            const user = await User.findById(caseData.userId).select('gender');
            enrichedCase.gender = user?.gender || 'unknown';
            
            res.json(enrichedCase)
        }
    } catch (err) {
        console.log(err);
        
    }
})

router.get('/role/doctor', async (req, res) => {
    try {
       const data = await User.findOne({ _id: req.user.id })
       res.json(data)
    } catch (err) {
        console.log(err);
    }
})

router.put('/role/doctor', upload.single('image'), async (req, res) => {
    try {
        if (typeof req.file === "undefined") {
            res.status(500).send("Image must be uploaded")
        } else if(req.user.role == "hold") {
            res.status(500).send("Request already sent")
        } else if(req.user.role == "Accepted") {
            res.status(500).send("You are already doctor")
        } else {
            await User.updateOne({ _id: req.user.id }, { $set: {
                role: 'hold',
                id_card: req.file.filename,
                telegram: req.body.telegram,
                uni: req.body.uni,
                role_req_date: moment().locale('ar-kw').format('l'),
                role_req_date_sort: Date.now(),
            }})

            res.status(200).send("Info sent successfully")
        }
    } catch (err) {
        console.log(err);
    }
})
module.exports = router