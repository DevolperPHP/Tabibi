const express = require('express');
const router = express.Router();
const User = require('../../model/User');

// Save or update FCM token for a user
router.put('/:userId', async (req, res) => {
    try {
        const { token, fcmToken } = req.body;
        const tokenToSave = token || fcmToken;

        if (!tokenToSave) {
            return res.status(400).json({ msg: "FCM token is required" });
        }

        console.log(`📝 [FCM Token] Saving token for user: ${req.params.userId}`);
        console.log(`🔑 [FCM Token] Token: ${tokenToSave.substring(0, 20)}...`);

        const user = await User.findByIdAndUpdate(
            req.params.userId,
            { fcmToken: tokenToSave },
            { new: true, runValidators: true }
        );

        if (!user) {
            console.error(`❌ [FCM Token] User not found: ${req.params.userId}`);
            return res.status(404).json({ msg: "User not found" });
        }

        console.log(`✅ [FCM Token] Token saved successfully for user: ${user.name}`);

        res.json({
            msg: "FCM token saved successfully",
            userId: user._id,
            userName: user.name,
        });
    } catch (err) {
        console.error(`❌ [FCM Token] Error: ${err.message}`);
        res.status(500).json({ msg: "Error saving FCM token", error: err.message });
    }
});

module.exports = router;
