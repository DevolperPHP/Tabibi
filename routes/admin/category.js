const express = require('express')
const router = express.Router()
const isAdminMiddleWare = require('../../middleware/isAdmin')
const getUser = require('../../middleware/getUser')
const Category = require('../../model/Category')
const Case = require('../../model/Case')

router.use(isAdminMiddleWare)
router.use(getUser)

router.post('/new', async (req, res) => {
    try {
        const filter = await Category.find({ name: req.body.name })
        if (filter.length > 0) {
            return res.status(400).json("Category already added")
        } else {
            new Category({
                name: req.body.name,
            }).save()
            return res.json({
                msg: "category added successfuly", data: {
                    name: req.body.name
                }
            })
        }
    } catch (err) {
        console.log(err);
    }
})

router.put('/edit/:id', async (req, res) => {
    try {
        const catData = await Category.findOne({ _id: req.params.id })
        const name = req.body.name

        await Case.updateMany({ category: catData.name }, {
            $set: {
                category: name,
            }
        })


        await Category.updateOne({ _id: req.params.id }, {
            $set: {
                name: name
            }
        })

        return res.json("Category updated")
    } catch (err) {
        console.log(err);
    }
})

router.delete('/delete/:id', async (req, res) => {
    try {
        await Category.deleteOne({ _id: req.params.id })
        return res.json('Category deleted')
    } catch (err) {
        console.log(err);
    }
})
module.exports = router