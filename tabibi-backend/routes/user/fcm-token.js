const express = require('express');
const router = express.Router();
const User = require('../../model/User');

// Save or update FCM token for a user
router.put('/:userId', async (req, res) => {
    try {
        const { token } = req.body;

        if (!token) {
            return res.status(400).json({ msg: "FCM token is required" });
        }

        const user = await User.findByIdAndUpdate(
            req.params.userId,
            { fcmToken: token },
            { new: true, runValidators: true }
        );

        if (!user) {
            return res.status(404).json({ msg: "User not found" });
        }

        res.json({
            msg: "FCM token saved successfully",
            user: user,
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ msg: "Error saving FCM token", error: err.message });
    }
});

module.exports = router;
