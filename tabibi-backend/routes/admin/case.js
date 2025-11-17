const express = require('express')
const router = express.Router()
const isAdminMiddleWare = require('../../middleware/isAdmin')
const getUser = require('../../middleware/getUser')
const Case = require('../../model/Case')
const Category = require('../../model/Category')
const User = require('../../model/User')
const Notification = require('../../model/Notification')
const FCMService = require('../../services/fcmService')

router.use(isAdminMiddleWare)
router.use(getUser)

// Helper function to get service-specific notification messages
function getServiceTypeNotification(serviceType, action) {
    const messages = {
        'تنظيف الاسنان': {
            accept: {
                title: '✨🦷 تم قبول حالتك لتنظيف الأسنان !',
                body: 'أطبائنا بانتظارك لإعادة ابتسامتك إلى إشراقتها 😁💙'
            },
            reject: {
                title: '❌ رفض حالة تنظيف',
                body: '⚠️ نأسف، لم يتم قبول حالتك لتنظيف الأسنان.\nيمكنك التواصل معنا لمعرفة تفاصيل حالتك.'
            }
        },
        'معالجة الاسنان': {
            accept: {
                title: 'قبول حالة معالجة',
                body: '🦷✨ تم قبول حالتك لمعالجة الأسنان!\n\nخطوتك القادمة نحو أسنان سليمة تبدأ قريبًا مع طبيبك 💙🧑🏻‍⚕️'
            },
            reject: {
                title: 'رفض حالة معالجة',
                body: '⚠️ نأسف، لم يتم قبول حالتك لمعالجة الأسنان.\n يمكنك التواصل معنا لمعرفة تفاصيل حالتك.'
            }
        },
        'تعويض الاسنان': {
            accept: {
                title: '✅ قبول حالة تعويض',
                body: '🦷✨تم قبول حالتك لتعويض الأسنان! \n\nطبيبك سيحدد موعد العلاج قريبًا. نحن متحمسون لرؤيتك تستعيد ابتسامتك بثقة 😁💙'
            },
            reject: {
                title: 'رفض حالة تعويض',
                body: '⚠️ نأسف، لم يتم قبول حالتك لتعويض الاسنان.\n\nيمكنك تواصل معنا لمعرفة تفاصيل حالتك. '
            }
        }
    };

    return messages[serviceType]?.[action] || {
        title: action === 'accept' ? 'تم قبول حالتك' : 'تم رفض حالتك',
        body: action === 'accept' ? 'تمت مراجعة حالتك وتم قبولها' : 'تمت مراجعة حالتك وتم رفضها'
    };
}

router.get('/', async (req, res) => {
    try {
        // Get all cases regardless of adminStatus for tabs filtering
        const cases = await Case.find({}).sort({ sortedDate: -1 })
        res.json(cases)
    } catch (err) {
        console.log(err);
    }
})

router.get('/get/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id })
        const category = await Category.find({})
        
        // Enrich case with user gender
        let enrichedCase = caseData.toObject();
        if (caseData.userId) {
            const user = await User.findById(caseData.userId).select('gender');
            enrichedCase.gender = user?.gender || 'unknown';
        }
        
        res.json({
            case_data: enrichedCase,
            category: category
        })
    } catch (err) {
        console.log(err);
    }
})

router.put('/accept/:id', async (req, res) => {
    try {
        const { diagnose, category, note } = req.body
        const caseData = await Case.findOne({ _id: req.params.id })

        await Case.updateOne({ _id: req.params.id }, {
            $set: {
                diagnose: diagnose,
                category: category,
                note: note,
                adminStatus: 'accept'
            }
        })

        // Get service-specific notification messages
        const { title, body } = getServiceTypeNotification(caseData.type, 'accept');

        // Send notification to user about case acceptance
        await Notification.create({
            userId: caseData.userId,
            title: title,
            body: body,
            type: 'case_accepted',
            relatedId: req.params.id,
        });

        // Send FCM push notification to user
        const user = await User.findById(caseData.userId);
        if (user && user.fcmToken) {
            await FCMService.sendToDevice(
                user.fcmToken,
                title,
                body,
                {
                    type: 'case_accepted',
                    relatedId: req.params.id,
                }
            );
        }

        const data = await Case.findOne({ _id: req.params.id })
        return res.json({
            msg: 'Case accepted successfully , updated info: ',
            data: data
        })
    } catch (err) {
        console.log(err);

    }
})

router.put('/reject/:id', async (req, res) => {
    try {
        const rejectNote = req.body.rejectNote
        const caseData = await Case.findOne({ _id: req.params.id })

        await Case.updateOne({ _id: req.params.id }, {
            $set: {
                adminStatus: 'reject',
                rejectNote: rejectNote,
            }
        })

        // Get service-specific notification messages
        const { title, body } = getServiceTypeNotification(caseData.type, 'reject');

        // Send notification to user about case rejection
        await Notification.create({
            userId: caseData.userId,
            title: title,
            body: body,
            type: 'case_rejected',
            relatedId: req.params.id,
        });

        // Send FCM push notification to user
        const user = await User.findById(caseData.userId);
        if (user && user.fcmToken) {
            await FCMService.sendToDevice(
                user.fcmToken,
                title,
                body,
                {
                    type: 'case_rejected',
                    relatedId: req.params.id,
                }
            );
        }

        return res.json({
            msg: "Case rejected successfully",
        })
    } catch (err) {
        console.log(err);
    }
})

// Delete a case (for waiting cases) - allows user to apply again
router.delete('/delete/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id })

        if (!caseData) {
            return res.status(404).json({ msg: "Case not found" })
        }

        // Delete the case
        await Case.deleteOne({ _id: req.params.id })

        // Allow user to apply for another case by setting inCase to false
        if (caseData.userId) {
            await User.updateOne({ _id: caseData.userId }, {
                $set: {
                    inCase: false
                }
            })
        }

        return res.json({
            msg: "Case deleted successfully - user can apply for new case",
            deletedCaseId: req.params.id
        })
    } catch (err) {
        console.log(err);
        return res.status(500).json({ msg: "Error deleting case", error: err.message })
    }
})

// Move case back to waiting/review (for accepted cases)
router.put('/review-again/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id })

        if (!caseData) {
            return res.status(404).json({ msg: "Case not found" })
        }

        // Move back to waiting status
        await Case.updateOne({ _id: req.params.id }, {
            $set: {
                adminStatus: 'waiting'
            }
        })

        return res.json({
            msg: "Case moved back to review/waiting successfully",
            caseId: req.params.id
        })
    } catch (err) {
        console.log(err);
        return res.status(500).json({ msg: "Error moving case to review", error: err.message })
    }
})

// Re-accept a rejected case (move to waiting for re-review)
router.put('/accept-again/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id })

        if (!caseData) {
            return res.status(404).json({ msg: "Case not found" })
        }

        // Move rejected case back to waiting for re-review
        await Case.updateOne({ _id: req.params.id }, {
            $set: {
                adminStatus: 'waiting'
            }
        })

        return res.json({
            msg: "Rejected case moved back to waiting for re-review",
            caseId: req.params.id
        })
    } catch (err) {
        console.log(err);
        return res.status(500).json({ msg: "Error re-accepting case", error: err.message })
    }
})

module.exports = router