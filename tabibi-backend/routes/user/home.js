const express = require('express')
const router = express.Router()
const Post = require('../../model/Post')

router.get('/', async (req, res) => {
    try {
        const posts = await Post.find({}).sort({ sortDate: -1 })
        res.json(posts)
    } catch (err) {
        console.log(err);
    }
})

router.get('/post/get/:id', async (req, res) => {
    try {
        const data = await Post.findOne({ _id: req.params.id })
        res.json(data)
    } catch (err) {
        console.log(err);
    }
})

module.exports = router