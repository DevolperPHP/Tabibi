const express = require('express')
const router = express.Router()
const isUserMiddleWare = require('../../middleware/isUser')
const getUserInfo = require('../../middleware/getUser')
const Case = require('../../model/Case')
const User = require('../../model/User')

router.use(isUserMiddleWare)
router.use(getUserInfo)

router.get('/', async (req, res) => {
    try {
        const cases = await Case.find({ userId: req.user.id }).sort({ sortDate: -1 })
        res.json({ userData: req.user, cases: cases})
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
        const { name, age, city } = req.body
        if(name == "" || age == "", city == ""){
            res.status(500).send({ message: 'You must enter all required info (name, age ,city)'})
        } else {
            await User.updateOne({ _id: req.user.id }, {
                $set: {
                    name: name,
                    age: age,
                    city: city
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
            res.json(caseData)
        }
    } catch (err) {
        console.log(err);
        
    }
})
module.exports = router