const express = require('express')
const router = express.Router()
const isUser = require('../../middleware/isUser')
const getUser = require('../../middleware/getUser')
const Case = require('../../model/Case')
const multer = require('multer')
const User = require('../../model/User')
const fs = require('fs')
const moment = require('moment')
const Notification = require('../../model/Notification')
const FCMService = require('../../services/fcmService')

router.use(isUser)
router.use(getUser)


const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, './public/upload/images');
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + '-' + file.originalname);
    }
});

const upload = multer({
    storage,
    limits: { fileSize: 1024 * 1024 * 100 }, // 100 MB max
});

router.post('/new', upload.any(), async (req, res) => {
    try {
        const {
            note,
            bp,
            diabetic,
            // New medical questions
            heartProblems,
            surgicalOperations,
            currentDisease,
            currentDiseaseDetails,
            category,
            type,
            pain_continues,
            pain_eat,
            pain_eat_type,
            pain_caild_drink,
            pain_caild_drink_type,
            pain_hot_drink,
            pain_sleep,
            inflamation,
            teeth_movement,
            calcifications,
            pigmentation,
            pain_continues_gum,
            pain_eat_gum,
            roots,
            mouth_inflammation,
            mouth_ulcer,
            tooth_decay,
            bleeding_during_brushing,
        } = req.body;
        const files = req.files || [];
        
        // Dynamic image validation based on service type
        let minImages = 3; // default
        if (type === 'معالجة الاسنان') {
            minImages = 3; // imageChock, imageCheek, imageToung
        } else if (type === 'تنظيف الاسنان') {
            minImages = 4; // imageFront, imageLeft, imageRight, imageTop, imageBottom (actually 5 but we'll check 4)
        } else if (type === 'تعويض الاسنان') {
            minImages = 2; // imageTop, imageBottom
        }
        
        if (files.length < minImages) {
            return res.status(400).json({ error: `At least ${minImages} images must be uploaded for ${type}` });
        }
        const fileMap = {};
        files.forEach(file => {
            fileMap[file.fieldname] = file.filename;
        });

        // Check if user has an active case
        if (req.user?.inCase === true) {
            // Verify there's actually a case in the database
            const existingCase = await Case.findOne({ userId: req.user.id });
            if (!existingCase) {
                // No case found but inCase flag is true - reset the flag
                console.log(`Resetting inCase flag for user ${req.user.id} - no case found in database`);
                await User.updateOne({ _id: req.user.id }, { $set: { inCase: false } });
            } else {
                // Case exists - check if it's completed/cancelled
                if (existingCase.status === 'done') {
                    // Case is done but flag wasn't reset - fix it
                    console.log(`Resetting inCase flag for user ${req.user.id} - case is already done`);
                    await User.updateOne({ _id: req.user.id }, { $set: { inCase: false } });
                } else {
                    // Active case exists
                    return res.status(400).json({ error: 'تم رفع حالة مسبقا و ما زال العمل عليها' });
                }
            }
        }

        const { name, age, phone, telegram, zone } = req.user
        const newCase = new Case({
            name,
            age,
            userId: req.user.id,
            phone,
            telegram,
            zone,
            bp: bp || 'no',
            diabetic: diabetic || 'no',
            // New medical questions
            heartProblems: heartProblems || 'no',
            surgicalOperations: surgicalOperations || 'no',
            currentDisease: currentDisease || 'no',
            currentDiseaseDetails: currentDiseaseDetails || '',
            imageLeft: fileMap['imageLeft'] || null,
            imageRight: fileMap['imageRight'] || null,
            imageTop: fileMap['imageTop'] || null,
            imageBottom: fileMap['imageBottom'] || null,
            imageChock: fileMap['imageChock'] || null,
            imageFront: fileMap['imageFront'] || null,
            imageCheek: fileMap['imageCheek'] || null,
            imageToung: fileMap['imageToung'] || null,
            drugsImage: fileMap['drugsImage'] || null,
            note,
            sortedDate: Date.now(),
            Date: moment().locale('ar-kw').format('l'),
            category,
            type,
            pain_continues,
            pain_eat,
            pain_eat_type,
            pain_caild_drink,
            pain_caild_drink_type,
            pain_hot_drink,
            pain_sleep,
            inflamation,
            teeth_movement,
            calcifications,
            pigmentation,
            pain_continues_gum,
            pain_eat_gum,
            roots,
            mouth_inflammation,
            mouth_ulcer,
            tooth_decay,
            bleeding_during_brushing,
        });

        await newCase.save();

        // Mark user as "in case"
        await User.updateOne({ _id: req.user.id }, { $set: { inCase: true } });

        // Get all admin users to notify them about the new case
        const admins = await User.find({ isAdmin: true });

        // Create notifications for all admins
        const notifications = admins.map(admin => ({
            userId: admin._id.toString(),
            title: 'حالة جديدة',
            body: `تم إرسال حالة جديدة من ${name} - ${category}`,
            type: 'case_created',
            relatedId: newCase._id.toString(),
        }));

        await Notification.insertMany(notifications);

        // Send FCM push notifications to all admins
        const adminTokens = admins.filter(admin => admin.fcmToken).map(admin => admin.fcmToken);
        if (adminTokens.length > 0) {
            await FCMService.sendToMultipleDevices(
                adminTokens,
                'حالة جديدة',
                `تم إرسال حالة جديدة من ${name} - ${category}`,
                {
                    type: 'case_created',
                    relatedId: newCase._id.toString(),
                }
            );
        }

        res.status(200).json({ message: 'Case sent successfully' });

    } catch (err) {
        console.error('Error creating case:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

router.delete('/cancel/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id })
        if (req.user.id == caseData.userId || req.user.isAdmin == true) {
            // Update user status
            await User.updateOne({ _id: caseData.userId }, {
                $set: {
                    inCase: false,
                }
            })

            // Delete all case images
            const imageFields = [
                'imageLeft', 'imageRight', 'imageTop', 'imageBottom',
                'imageFront', 'imageChock', 'imageToung', 'imageCheek',
                'drugsImage'
            ];

            imageFields.forEach(field => {
                if (caseData[field]) {
                    try {
                        fs.unlinkSync(`./public/upload/images/${caseData[field]}`);
                    } catch (err) {
                        console.log(`Failed to delete ${field}:`, err.message);
                    }
                }
            });

            // Delete the case from database
            await Case.deleteOne({ _id: req.params.id })
            res.status(200).json({ message: "Case deleted successfully" })
        } else {
            res.status(403).json({ error: "Unauthorized" })
        }
    } catch (err) {
        console.log('Error canceling case:', err);
        res.status(500).json({ error: 'Failed to cancel case' })
    }
})

router.get('/edit/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id })
        if (req.user.id == caseData.userId || req.user.isAdmin == true) {
            // Enrich case data with user gender
            const caseObj = caseData.toObject();
            caseObj.gender = req.user.gender || 'unknown';
            res.json(caseObj)
        }
    } catch (err) {
        console.log(err);
    }
})

router.put('/edit/:id', upload.any(), async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id })

        if (!caseData) {
            return res.status(404).json({ error: 'Case not found' });
        }

        if (req.user.id == caseData.userId || req.user.isAdmin == true) {
            const {
                note,
                bp,
                diabetic,
                // New medical questions
                heartProblems,
                surgicalOperations,
                currentDisease,
                currentDiseaseDetails,
                category,
                type,
                pain_continues,
                pain_eat,
                pain_eat_type,
                pain_caild_drink,
                pain_caild_drink_type,
                pain_hot_drink,
                pain_sleep,
                inflamation,
                teeth_movement,
                calcifications,
                pigmentation,
                pain_continues_gum,
                pain_eat_gum,
                roots,
                mouth_inflammation,
                mouth_ulcer,
                tooth_decay,
                bleeding_during_brushing,
                clearImages, // New flag to indicate if images should be cleared
            } = req.body;

            // Process uploaded files
            const files = req.files || [];
            const fileMap = {};
            files.forEach(file => {
                fileMap[file.fieldname] = file.filename;
            });

            // Build update object
            const updateData = {
                note,
                bp,
                diabetic,
                // New medical questions
                heartProblems,
                surgicalOperations,
                currentDisease,
                currentDiseaseDetails,
                category,
                type,
                pain_continues,
                pain_eat,
                pain_eat_type,
                pain_caild_drink,
                pain_caild_drink_type,
                pain_hot_drink,
                pain_sleep,
                inflamation,
                teeth_movement,
                calcifications,
                pigmentation,
                pain_continues_gum,
                pain_eat_gum,
                roots,
                mouth_inflammation,
                mouth_ulcer,
                tooth_decay,
                bleeding_during_brushing,
                adminStatus: 'waiting' // Reset to waiting when edited
            };

            // Handle image replacements
            const imageFields = [
                'imageLeft', 'imageRight', 'imageTop', 'imageBottom',
                'imageFront', 'imageChock', 'imageToung', 'imageCheek',
                'drugsImage'
            ];

            // Check if case type is changing and clearImages flag is set
            const isChangingType = caseData.type !== type;
            const shouldClearImages = clearImages === 'true' || clearImages === true;
            
            // Debug logging
            console.log('DEBUG: Case type change detected');
            console.log('DEBUG: Old type:', caseData.type);
            console.log('DEBUG: New type:', type);
            console.log('DEBUG: isChangingType:', isChangingType);
            console.log('DEBUG: clearImages flag:', clearImages);
            console.log('DEBUG: shouldClearImages:', shouldClearImages);

            imageFields.forEach(field => {
                if (fileMap[field]) {
                    // Delete old image if it exists
                    if (caseData[field]) {
                        try {
                            fs.unlinkSync(`./public/upload/images/${caseData[field]}`);
                        } catch (err) {
                            console.log(`Failed to delete old ${field}:`, err.message);
                        }
                    }
                    // Set new image
                    updateData[field] = fileMap[field];
                } else if (isChangingType && shouldClearImages) {
                    // Clear image if type is changing and clearImages flag is set
                    if (caseData[field]) {
                        try {
                            fs.unlinkSync(`./public/upload/images/${caseData[field]}`);
                            console.log(`Deleted ${field} due to case type change`);
                        } catch (err) {
                            console.log(`Failed to delete ${field}:`, err.message);
                        }
                    }
                    // Set to null to clear the image
                    updateData[field] = null;
                }
            });

            await Case.updateOne(
                { _id: req.params.id },
                { $set: updateData }
            );

            res.status(200).json({ message: "Case updated successfully" });
        } else {
            res.status(403).json({ error: "Unauthorized" });
        }
    } catch (err) {
        console.log('Error editing case:', err);
        res.status(500).json({ error: 'Failed to update case' });
    }
})

module.exports = router