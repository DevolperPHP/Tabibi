const express = require("express");
const router = express.Router();
const Case = require("../../model/Case");
const User = require("../../model/User");
const moment = require("moment");
const Notification = require("../../model/Notification");
const FCMService = require("../../services/fcmService");

router.post("/callback", async (req, res) => {
  try {
    console.log("==== RAW CALLBACK BODYYY ====");
    console.log(JSON.stringify(req.body, null, 2));

    const paymentStatus = req.body.payment_result?.response_status;
    const paymentMessage = req.body.payment_result?.response_message;
    const caseId = req.body.cart_id?.split("-")[0];
    const doctorEmail = req.body.customer_details?.email;

    console.log("Payment Status:", paymentStatus);
    console.log("CaseId:", caseId);
    console.log("Doctor Email:", doctorEmail);

    const doctor = await User.findOne({ email: doctorEmail });

    if (paymentStatus === "A") {
      // Get case data before update to send notification
      const caseData = await Case.findOne({ _id: caseId });

      const result = await Case.updateOne(
        { _id: caseId },
        {
          $set: {
            doctor: doctor?.name || "Unknown",
            doctorId: doctor?._id,
            doctorPhone: doctor?.phone || null,
            doctorTelegram: doctor?.telegram || null,
            doctorUni: doctor?.uni || null,
            startDate: moment().locale("ar-kw").format("l"),
            status: "in-treatment",
            startSortedDate: Date.now(),
          },
        }
      );
      console.log("✅ Case updated (Approved):", result);

      // Send notification to user about doctor taking the case
      if (caseData) {
        console.log("📨 Sending notification to patient:", caseData.userId);
        
        const notificationTitle = '👨‍⚕️ طبيب اختار حالتك!';
        const notificationBody = `الدكتور ${doctor?.name || 'طبيب'} اختار حالتك وسيبدأ العلاج قريباً 🦷✨`;
        
        // Save notification to database
        await Notification.create({
          userId: caseData.userId,
          title: notificationTitle,
          body: notificationBody,
          type: 'case_taken',
          relatedId: caseId,
        });
        console.log("✅ Notification saved to database");

        // Send FCM push notification to patient
        const patient = await User.findById(caseData.userId);
        if (patient && patient.fcmToken) {
          console.log("� Sending FCM push notification to patient...");
          try {
            const fcmResult = await FCMService.sendToDevice(
              patient.fcmToken,
              notificationTitle,
              notificationBody,
              {
                type: 'case_taken',
                relatedId: caseId,
                doctorName: doctor?.name || 'طبيب',
              }
            );
            console.log("✅ FCM notification sent successfully:", fcmResult);
          } catch (fcmError) {
            console.error("❌ Failed to send FCM notification:", fcmError);
          }
        } else {
          console.warn("⚠️  Patient has no FCM token, notification saved to DB only");
        }
      }
    } else {
      const result = await Case.updateOne(
        { _id: caseId },
        {
          $set: {
            status: "payment-failed",
            paymentMessage,
            paymentStatus,
          },
        }
      );
      console.log("Case updated (Failed):", result);
    }

    res.sendStatus(200); // Always reply OK to PayTabs
  } catch (err) {
    console.error("Callback error:", err);
    res.sendStatus(500);
  }
});



module.exports = router;
