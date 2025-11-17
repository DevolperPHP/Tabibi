const express = require('express')
const router = express.Router()
const isAdminMiddleWare = require('../../middleware/isAdmin')
const User = require('../../model/User')
const multer = require('multer')
const Post = require('../../model/Post')
const getUser = require('../../middleware/getUser')
const moment = require('moment')
const fs = require('fs')

router.use(isAdminMiddleWare)
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

// Route to handle form-data
router.post("/new", upload.single("image"), async (req, res) => {
    try {
        const { title, des } = req.body
        
        const newPost = [
            new Post({
                title: title,
                des: des,
                user: req.user.name,
                sortDate: Date.now(),
                Date: moment().locale('ar-kw').format('l'),
                image: req.file.filename,
            })
        ]

        newPost.forEach((data) => {
            data.save()
        })
        res.status(200).send({ message: "success", data: req.body });
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ message: "Error" });
    }
});


router.get("/posts", async (req, res) => {
    try {
        const posts = await Post.find({}).sort({ sortDate: -1 })
        res.json(posts)
    } catch (err) {
        console.log(err);
    }
})

router.get('/get/:id', async (req, res) => {
    try {
        const data = await Post.findOne({ _id: req.params.id })
        res.json(data)
    } catch (err) {
        console.log(err);
        
    }
})

router.get('/edit/:id', async (req, res) => {
    try {
        const data = await Post.findOne({ _id: req.params.id })
        res.json(data)
    } catch (err) {
        console.log(err);
        
    }
})

router.put('/edit/:id', upload.single('image'), async (req, res) => {
    try {
        const { title, des } = req.body
        if(typeof req.file === "undefined"){
            await Post.updateOne({ _id: req.params.id }, {
                $set: {
                    title: title,
                    des: des,
                    user: req.user.name,
                }
            })
        } else {
            await Post.updateOne({ _id: req.params.id }, {
                $set: {
                    title: title,
                    des: des,
                    user: req.user.name,
                    image: req.file.filename
                }
            })
        }

        res.status(200).send("Info updated")
    } catch (err) {
        console.log(err);
    }
})

router.delete('/delete/:id', async (req, res) => {
    try {
        const data = await Post.findOne({ _id: req.params.id })
        fs.unlinkSync(`./public/upload/images/${data.image}`)
        await Post.deleteOne({ _id: req.params.id })
        res.status(200).send("Post deleted")
    } catch (err) {
        console.log(err);
        
    }
})

module.exports = router