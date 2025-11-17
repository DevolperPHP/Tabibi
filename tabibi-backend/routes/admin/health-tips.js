const express = require('express');
const router = express.Router();
const isAdminMiddleWare = require('../../middleware/isAdmin');
const getUser = require('../../middleware/getUser');
const Notification = require('../../model/Notification');
const User = require('../../model/User');
const FCMService = require('../../services/fcmService');

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
        const users = await User.find({}).select('_id fcmToken');
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

        // Send FCM push notifications to all users with valid tokens
        const validTokens = users
            .filter(user => user.fcmToken && user.fcmToken.trim() !== '')
            .map(user => user.fcmToken);

        if (validTokens.length > 0) {
            await FCMService.sendToMultipleDevices(
                validTokens,
                title,
                body,
                {
                    type: 'health_tip',
                    relatedId: null,
                }
            );
        }

        res.json({
            msg: "Health tip sent successfully to all users",
            count: notifications.length,
            pushNotificationSent: validTokens.length,
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ msg: "Error sending health tip", error: err.message });
    }
});

// Daily health tip - automatic notification with dental health advice
router.post('/daily-tip', async (req, res) => {
    try {
        // Predefined daily health tips for teeth and dental care
        const dailyTips = [
            {
                title: '🦷 نصيحة يومية للعناية بأسنانك',
                body: 'استخدم خيط الأسنان يوميًا! هذا يساعد في إزالة البكتيريا والبقايا التي قد تسبب تسوس الأسنان والتهاب اللثة. ابدأ بخيط الأسنان قبل النوم بعد تفريش أسنانك. 💙✨'
            },
            {
                title: '🦷 نصيحة يومية للعناية بأسنانك',
                body: 'اجعل تفريش أسنانك عادة يومية منتظمة! نظف أسنانك مرتين يوميًا لمدة دقيقتين على الأقل. استخدم فرشاة أسنان ناعمة ومعجون أسنان يحتوي على الفلورايد لحماية أسنانك من التسوس. 😊🦷'
            },
            {
                title: '🦷 نصيحة يومية للعناية بأسنانك',
                body: 'انتبه لحمية أسنانك! إذا لاحظت نزيفاً عند تفريش أسنانك أو استخدام خيط الأسنان، قد تكون بداية التهاب اللثة. راجع طبيبك لتقييم حالة اللثة ووصف العلاج المناسب. ⚠️💙'
            },
            {
                title: '🦷 نصيحة يومية للعناية بأسنانك',
                body: 'الماء مفيد لصحة أسنانك! اشرب الكثير من الماء، خاصة بعد الوجبات. الماء يساعد في غسل بقايا الطعام والسكر من أسنانك ويقلل من حموضة الفم التي تسبب تآكل الأسنان. 💧✨'
            },
            {
                title: '🦷 نصيحة يومية للعناية بأسنانك',
                body: 'تجنب العادات الضارة! لا تستخدم أسنانك لفتح العبوات أو كسر الأشياء الصلبة. هذه العادات قد تسبب كسور في الأسنان أو ضرر في مينا الأسنان. استشر طبيبك للحصول على حماية إضافية. ⚠️🦷'
            }
        ];

        // Select a random tip for today
        const todayTip = dailyTips[Math.floor(Math.random() * dailyTips.length)];
        const title = todayTip.title;
        const body = todayTip.body;

        // Get all user IDs and their FCM tokens
        const users = await User.find({}).select('_id fcmToken');
        const userIds = users.map(user => user._id.toString());

        // Create notifications for all users
        const notifications = userIds.map(userId => ({
            userId,
            title,
            body,
            type: 'daily_health_tip',
            relatedId: null,
        }));

        await Notification.insertMany(notifications);

        // Send FCM push notifications to all users with valid tokens
        const validTokens = users
            .filter(user => user.fcmToken && user.fcmToken.trim() !== '')
            .map(user => user.fcmToken);

        if (validTokens.length > 0) {
            await FCMService.sendToMultipleDevices(
                validTokens,
                title,
                body,
                {
                    type: 'daily_health_tip',
                    relatedId: null,
                }
            );
        }

        res.json({
            msg: "Daily health tip sent successfully to all users",
            count: notifications.length,
            pushNotificationSent: validTokens.length,
            tip: title,
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ msg: "Error sending daily health tip", error: err.message });
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

        // Get FCM tokens for specific users
        const users = await User.find({ _id: { $in: userIds } }).select('fcmToken');
        const validTokens = users
            .filter(user => user.fcmToken && user.fcmToken.trim() !== '')
            .map(user => user.fcmToken);

        // Send FCM push notifications to specific users with valid tokens
        if (validTokens.length > 0) {
            await FCMService.sendToMultipleDevices(
                validTokens,
                title,
                body,
                {
                    type: 'health_tip',
                    relatedId: null,
                }
            );
        }

        res.json({
            msg: "Health tip sent successfully",
            count: notifications.length,
            pushNotificationSent: validTokens.length,
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
