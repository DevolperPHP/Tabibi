const express = require('express')
const router = express.Router()
const isAdminMiddleWare = require('../../middleware/isAdmin')
const getUser = require('../../middleware/getUser')
const User = require('../../model/User')
const Notification = require('../../model/Notification')
const FCMService = require('../../services/fcmService')

router.use(isAdminMiddleWare)
router.use(getUser)

router.get('/requests', async (req, res) => {
    try {
        const data = await User.find({ role: "hold" }).sort({ role_req_date_sort: -1 });
        const formattedData = data.map(user => ({
            name: user.name,
            Date: user.role_req_date,
            city: user.city,
            id: user.id,
            telegram: user.telegram,
            id_card: user.id_card,
            email: user.email,
            age: user.age,
            gender: user.gender,
            zone: user.zone,
            uni: user.uni,
            phone: user.phone
        }));

        res.status(200).json(formattedData)
    } catch (err) {
        console.log(err);
    }
})

router.get('/requests/get/:id', async (req, res) => {
    try {
        const user = await User.findOne({ _id: req.params.id })
        res.status(200).json({
            id: user.id,
            name: user.name,
            Date: user.role_req_date,
            city: user.city,
            age: user.age,
            email: user.email,
            id_card: user.id_card,
            telegram: user.telegram,
            gender: user.gender,
            zone: user.zone,
            uni: user.uni,
            phone: user.phone,
        })
    } catch (err) {
        console.log(err);
    }
})

router.put('/requests/update/accept/:id', async (req, res) => {
    try {
        const user = await User.findById(req.params.id);
        await User.updateOne({ _id: req.params.id }, { $set: {
            isDoctor: true,
            role: 'Accepted',
        }});

        // Send notification to user about doctor role acceptance
        await Notification.create({
            userId: req.params.id,
            title: 'قبول حساب الطبيب',
            body: 'اهلا بك في عائلة طبيبي🧑🏻‍⚕️🦷!\n\nتمت الموافقة على طلب حسابك، يمكنك الآن البدء باستقبال المرضى وعلاجهم داخل المنصة.',
            type: 'doctor_role_accepted',
            relatedId: req.params.id,
        });

        // Send FCM push notification to user
        if (user && user.fcmToken) {
            await FCMService.sendToDevice(
                user.fcmToken,
                'قبول حساب الطبيب',
                'اهلا بك في عائلة طبيبي🧑🏻‍⚕️🦷!\n\nتمت الموافقة على طلب حسابك، يمكنك الآن البدء باستقبال المرضى وعلاجهم داخل المنصة.',
                {
                    type: 'doctor_role_accepted',
                    relatedId: req.params.id,
                }
            );
        }

        res.status(200).json("User accepted as doctor, info updated")
    } catch (err) {
        
    }
})

router.put('/requests/update/reject/:id', async (req, res) => {
    try {
        const user = await User.findById(req.params.id);
        await User.updateOne({ _id: req.params.id }, { $set: {
            isDoctor: false,
            role: 'Rejected',
        }});

        // Send notification to user about doctor role rejection
        await Notification.create({
            userId: req.params.id,
            title: '❌ رفض حساب الطبيب',
            body: '⚠️ نأسف،لم يتم قبول طلب حسابك حاليًا.\n\nيُرجى مراجعة البيانات المرسلة أو التواصل مع الدعم لتوضيح سبب الرفض.',
            type: 'doctor_role_rejected',
            relatedId: req.params.id,
        });

        // Send FCM push notification to user
        if (user && user.fcmToken) {
            await FCMService.sendToDevice(
                user.fcmToken,
                '❌ رفض حساب الطبيب',
                '⚠️ نأسف،لم يتم قبول طلب حسابك حاليًا.\n\nيُرجى مراجعة البيانات المرسلة أو التواصل مع الدعم لتوضيح سبب الرفض.',
                {
                    type: 'doctor_role_rejected',
                    relatedId: req.params.id,
                }
            );
        }

        res.status(200).json("User rejected")
    } catch (err) {
        
    }
})

module.exports = router