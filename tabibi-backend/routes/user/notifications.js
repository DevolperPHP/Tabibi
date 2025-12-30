const express = require('express');
const router = express.Router();
const getUser = require('../../middleware/getUser');
const Notification = require('../../model/Notification');
const User = require('../../model/User');
const FCMService = require('../../services/fcmService');

router.use(getUser);

// Test endpoint to send a test notification
router.post('/test', async (req, res) => {
    try {
        const { userId, title, body } = req.body;

        if (!userId) {
            return res.status(400).json({ msg: "userId is required" });
        }

        console.log('🧪 Testing notification for user:', userId);
        console.log('📱 Title:', title || 'Test Notification');
        console.log('📝 Body:', body || 'This is a test notification from Tabibi app');

        // Get user's FCM token
        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ msg: "User not found" });
        }

        if (!user.fcmToken) {
            return res.status(400).json({ 
                msg: "User has no FCM token saved", 
                userId: userId 
            });
        }

        console.log('🔑 FCM Token found:', user.fcmToken.substring(0, 10) + '...');

        // Send test notification
        const result = await FCMService.sendToDevice(
            user.fcmToken, 
            title || 'Test Notification', 
            body || 'This is a test notification from Tabibi app',
            {
                type: 'test',
                testId: Date.now().toString(),
            }
        );

        res.json({
            msg: "Test notification sent",
            result: result,
            userId: userId,
            fcmToken: user.fcmToken.substring(0, 10) + '...'
        });
    } catch (err) {
        console.log('❌ Error sending test notification:', err);
        res.status(500).json({ msg: "Error sending test notification", error: err.message });
    }
});

// Get notifications for a user
router.get('/:userId', async (req, res) => {
    try {
        const notifications = await Notification.find({ userId: req.params.userId })
            .sort({ createdAt: -1 });

        res.json({
            notifications: notifications,
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ msg: "Error fetching notifications", error: err.message });
    }
});

// Mark notification as read
router.put('/:id/mark-read', async (req, res) => {
    try {
        await Notification.updateOne({ _id: req.params.id }, {
            $set: { isRead: true }
        });

        res.json({
            msg: "Notification marked as read",
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ msg: "Error marking notification as read", error: err.message });
    }
});

// Mark all notifications as read for a user
router.put('/:userId/mark-all-read', async (req, res) => {
    try {
        await Notification.updateMany({ userId: req.params.userId }, {
            $set: { isRead: true }
        });

        res.json({
            msg: "All notifications marked as read",
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ msg: "Error marking all notifications as read", error: err.message });
    }
});

// Delete notification
router.delete('/:id/delete', async (req, res) => {
    try {
        await Notification.deleteOne({ _id: req.params.id });

        res.json({
            msg: "Notification deleted successfully",
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ msg: "Error deleting notification", error: err.message });
    }
});

// Send notification to a user
router.post('/send', async (req, res) => {
    try {
        const { userId, title, body, type, relatedId } = req.body;

        // Save notification to database
        const notification = new Notification({
            userId,
            title,
            body,
            type,
            relatedId,
        });

        await notification.save();

        // Get user's FCM token
        const user = await User.findById(userId);
        if (user && user.fcmToken) {
            // Send push notification
            await FCMService.sendToDevice(user.fcmToken, title, body, {
                type: type,
                relatedId: relatedId || '',
            });
        }

        res.json({
            msg: "Notification sent successfully",
            notification: notification,
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ msg: "Error sending notification", error: err.message });
    }
});

// Send bulk notifications to multiple users
router.post('/send-bulk', async (req, res) => {
    try {
        const { userIds, title, body, type, relatedId } = req.body;

        const notifications = userIds.map(userId => ({
            userId,
            title,
            body,
            type,
            relatedId,
        }));

        await Notification.insertMany(notifications);

        // Get FCM tokens for all users
        const users = await User.find({ _id: { $in: userIds } });
        const fcmTokens = users
            .filter(user => user.fcmToken)
            .map(user => user.fcmToken);

        // Send push notifications to all users with FCM tokens
        if (fcmTokens.length > 0) {
            await FCMService.sendToMultipleDevices(fcmTokens, title, body, {
                type: type,
                relatedId: relatedId || '',
            });
        }

        res.json({
            msg: "Bulk notifications sent successfully",
            count: notifications.length,
            pushNotificationsSent: fcmTokens.length,
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ msg: "Error sending bulk notifications", error: err.message });
    }
});

module.exports = router;
