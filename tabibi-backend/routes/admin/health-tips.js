const express = require('express');
const router = express.Router();
const isAdminMiddleWare = require('../../middleware/isAdmin');
const getUser = require('../../middleware/getUser');
const Notification = require('../../model/Notification');
const User = require('../../model/User');

router.use(isAdminMiddleWare);
router.use(getUser);

// Get all health tips (notifications with type 'health_tip')
router.get('/', async (req, res) => {
    try {
        const healthTips = await Notification.find({ type: 'health_tip' })
            .sort({ createdAt: -1 });
        res.json(healthTips);
    } catch (err) {
        console.log(err);
        res.status(500).json({ msg: "Error fetching health tips", error: err.message });
    }
});

// Send health tip to all users
router.post('/send-to-all', async (req, res) => {
    try {
        const { title, body } = req.body;

        if (!title || !body) {
            return res.status(400).json({ msg: "Title and body are required" });
        }

        // Get all user IDs
        const users = await User.find({}).select('_id');
        const userIds = users.map(user => user._id.toString());

        // Create notifications for all users
        const notifications = userIds.map(userId => ({
            userId,
            title,
            body,
            type: 'health_tip',
            relatedId: null,
        }));

        await Notification.insertMany(notifications);

        res.json({
            msg: "Health tip sent successfully to all users",
            count: notifications.length,
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ msg: "Error sending health tip", error: err.message });
    }
});

// Send health tip to specific users
router.post('/send', async (req, res) => {
    try {
        const { userIds, title, body } = req.body;

        if (!userIds || !Array.isArray(userIds) || !title || !body) {
            return res.status(400).json({ msg: "userIds array, title and body are required" });
        }

        // Create notifications for specific users
        const notifications = userIds.map(userId => ({
            userId,
            title,
            body,
            type: 'health_tip',
            relatedId: null,
        }));

        await Notification.insertMany(notifications);

        res.json({
            msg: "Health tip sent successfully",
            count: notifications.length,
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ msg: "Error sending health tip", error: err.message });
    }
});

// Delete health tip
router.delete('/:id', async (req, res) => {
    try {
        const notification = await Notification.findOne({
            _id: req.params.id,
            type: 'health_tip'
        });

        if (!notification) {
            return res.status(404).json({ msg: "Health tip not found" });
        }

        await Notification.deleteOne({ _id: req.params.id });

        res.json({
            msg: "Health tip deleted successfully",
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ msg: "Error deleting health tip", error: err.message });
    }
});

module.exports = router;
