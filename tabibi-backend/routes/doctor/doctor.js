const express = require('express');
const router = express.Router();
const isDoctorMiddleWare = require('../../middleware/isDoctor');
const getUser = require('../../middleware/getUser');
const Case = require('../../model/Case');
const User = require('../../model/User');
const moment = require('moment');
const Category = require('../../model/Category');
const Notification = require('../../model/Notification');
const axios = require('axios');
const https = require("https");
const FCMService = require('../../services/fcmService');

router.use(isDoctorMiddleWare);
router.use(getUser);

const PAYTABS_PROFILE_ID = process.env.PAYTABS_PROFILE_ID;
const PAYTABS_SERVER_KEY = process.env.PAYTABS_SERVER_KEY;
const PAYTABS_BASE_URL = process.env.PAYTABS_BASE_URL;

const agent = new https.Agent({ rejectUnauthorized: false });

router.get('/cases', async (req, res) => {
    try {
        const cases = await Case.find(
            { status: 'free', adminStatus: 'accept' }
        )
        .sort({ sortedDate: -1 })
        .select('-name -phone -telegram'); // 👈 Exclude name, phone, and telegram

        // Enrich cases with user gender
        const enrichedCases = await Promise.all(
            cases.map(async (caseItem) => {
                const user = await User.findById(caseItem.userId).select('gender');
                return {
                    ...caseItem.toObject(),
                    gender: user?.gender || 'unknown'
                };
            })
        );

        const category = await Category.find({});

        res.json({ cases: enrichedCases, category });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

router.get('/cases/category/:name', async (req, res) => {
    try {
        const cases = await Case.find({ status: 'free', category: req.params.name })
            .sort({ sortedDate: -1 })
            .select('-name -phone -telegram');
        
        // Enrich cases with user gender
        const enrichedCases = await Promise.all(
            cases.map(async (caseItem) => {
                const user = await User.findById(caseItem.userId).select('gender');
                return {
                    ...caseItem.toObject(),
                    gender: user?.gender || 'unknown'
                };
            })
        );
        
        const category = await Category.find({});
        res.json({ cases: enrichedCases, category });
    } catch (err) {
        console.log(err);
    }
});

router.get('/case/info/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id });
        res.json(caseData);
    } catch (err) {
        console.log(err);
    }
});

// -------------------------
// Payment flow
// -------------------------

// Step 1: Start payment for a case
router.get('/case/pay/:id', async (req, res) => {
    try {
        const caseData = await Case.findById(req.params.id);
        if (!caseData) return res.status(404).send('Case not found');

        const payload = {
            profile_id: process.env.PAYTABS_PROFILE_ID,
            tran_type: 'sale',
            tran_class: 'ecom',
            cart_id: `${caseData._id}-${Date.now()}`,
            cart_description: `Payment for case ${caseData._id}`,
            cart_currency: 'IQD',
            cart_amount: 10000, // set your case price
            callback: 'https://www.tabibi-iq.net/doctor/payment/callback',
            return: 'http://165.232.78.163/doctor/payment/return',
            customer_details: {
                name: req.user.name,
                email: req.user.email,
                phone: req.user.phone,
                country: 'IQ',
                ip: req.ip
            }
        };

        const response = await axios.post(
            `${process.env.PAYTABS_BASE_URL}/payment/request`,
            payload,
            {
                headers: {
                    Authorization: process.env.PAYTABS_SERVER_KEY, // your 32-char Mobile SDK key
                    'Content-Type': 'application/json'
                }
            }
        );

        // redirect user to PayTabs hosted page
        if (response.data.redirect_url) {
            return res.redirect(response.data.redirect_url);
        }

        res.status(500).send('Unable to get payment redirect URL');
    } catch (err) {
        console.error('Payment request error:', err.response?.data || err.message);
        res.status(500).send('Payment request failed');
    }
});



// Step 3: Return route (doctor browser lands here)
router.get('/payment/return', (req, res) => {
    res.send(`
        <!DOCTYPE html>
        <html dir="rtl" lang="ar">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>تم الدفع بنجاح</title>
            <style>
                body {
                    font-family: 'Cairo', Arial, sans-serif;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                    margin: 0;
                }
                .success-box {
                    background: white;
                    border-radius: 20px;
                    padding: 40px;
                    text-align: center;
                    box-shadow: 0 10px 40px rgba(0,0,0,0.2);
                }
                .checkmark {
                    width: 80px;
                    height: 80px;
                    border-radius: 50%;
                    background: #4BB543;
                    margin: 0 auto 20px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }
                .checkmark::after {
                    content: '✓';
                    color: white;
                    font-size: 50px;
                }
                h1 { color: #333; margin: 0 0 10px; }
                p { color: #666; margin: 10px 0; }
                .loading { color: #667eea; font-size: 14px; margin-top: 20px; }
            </style>
        </head>
        <body>
            <div class="success-box">
                <div class="checkmark"></div>
                <h1>تم الدفع بنجاح!</h1>
                <p>تم اختيار الحالة بنجاح</p>
                <p class="loading">جاري التحميل...</p>
            </div>
            <script>
                // Auto-close signal for WebView
                setTimeout(() => {
                    window.location.href = 'tabibi://payment-success';
                }, 1000);
            </script>
        </body>
        </html>
    `);
});

// -------------------------
// Doctor’s cases
// -------------------------
router.get('/my-cases', async (req, res) => {
    try {
        const caseData = await Case.find({ doctorId: req.user.id }).sort({ startSortedDate: -1 });

        // Enrich cases with user gender
        const enrichedCases = await Promise.all(
            caseData.map(async (caseItem) => {
                const user = await User.findById(caseItem.userId).select('gender');
                return {
                    ...caseItem.toObject(),
                    gender: user?.gender || 'unknown'
                };
            })
        );

        res.json(enrichedCases);
    } catch (err) {
        console.log(err);
    }
});

router.get('/my-case/get/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id });
        if (caseData.doctorId == req.user.id) {
            // Enrich case with user gender
            let enrichedCase = caseData.toObject();
            if (caseData.userId) {
                const user = await User.findById(caseData.userId).select('gender');
                enrichedCase.gender = user?.gender || 'unknown';
            }
            res.json(enrichedCase);
        }
    } catch (err) {
        console.log(err);
    }
});

router.get('/my-case/details/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id });
        if (caseData.doctorId == req.user.id) {
            // Enrich case with user gender
            let enrichedCase = caseData.toObject();
            if (caseData.userId) {
                const user = await User.findById(caseData.userId).select('gender');
                enrichedCase.gender = user?.gender || 'unknown';
            }
            res.json(enrichedCase);
        }
    } catch (err) {
        console.log(err);
    }
});

router.put('/my-case/details/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id });
        const { diagnose, doctorNote } = req.body;
        if (caseData.doctorId == req.user.id) {
            await Case.updateOne(
                { _id: req.params.id },
                {
                    $set: {
                        diagnose,
                        doctorNote
                    }
                }
            );
            res.status(200).send({ message: 'Info updated' });
        }
    } catch (err) {
        console.log(err);
    }
});

router.get('/my-case/done/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id });
        if (caseData.doctorId == req.user.id) {
            // Enrich case with user gender
            let enrichedCase = caseData.toObject();
            if (caseData.userId) {
                const user = await User.findById(caseData.userId).select('gender');
                enrichedCase.gender = user?.gender || 'unknown';
            }
            res.json(enrichedCase);
        }
    } catch (err) {
        console.log(err);
    }
});

router.put('/my-case/done/:id', async (req, res) => {
    try {
        const caseData = await Case.findOne({ _id: req.params.id });
        if (caseData.doctorId == req.user.id) {
            if (caseData.report == '') {
                res.status(500).send({ message: 'Medical report must be entered' });
            } else {
                await Case.updateOne(
                    { _id: req.params.id },
                    {
                        $set: {
                            status: 'done',
                            report: req.body.report,
                            diagnose: req.body.diagnose
                        }
                    }
                );

                await User.updateOne({ _id: caseData.userId }, {
                    $set: {
                        inCase: false
                    }
                });

                // Send notification to user about case completion
                await Notification.create({
                    userId: caseData.userId,
                    title: 'تم علاج حالتك بنجاح ✅!',
                    body: 'سعدنا بخدمتك، ونتمنى لك دوام الصحة والعافية زرنا مجددًا إذا احتجت أي رعاية طبية مستقبلية ⚕️🦷',
                    type: 'case_completed',
                    relatedId: req.params.id,
                });

                // Send FCM push notification to user
                const user = await User.findById(caseData.userId);
                if (user && user.fcmToken) {
                    await FCMService.sendToDevice(
                        user.fcmToken,
                        'تم علاج حالتك بنجاح ✅!',
                        'سعدنا بخدمتك، ونتمنى لك دوام الصحة والعافية زرنا مجددًا إذا احتجت أي رعاية طبية مستقبلية ⚕️🦷',
                        {
                            type: 'case_completed',
                            relatedId: req.params.id,
                        }
                    );
                }

                res.status(200).send({ message: 'Info updated' });
            }
        }
    } catch (err) {
        console.log(err);
    }
});

module.exports = router;
