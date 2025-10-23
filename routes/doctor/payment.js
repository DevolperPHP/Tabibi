const express = require("express");
const router = express.Router();
const Case = require("../../model/Case");
const User = require("../../model/User");
const moment = require("moment");

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
      const result = await Case.updateOne(
        { _id: caseId },
        {
          $set: {
            doctor: doctor?.name || "Unknown",
            doctorId: doctor?._id,
            startDate: moment().locale("ar-kw").format("l"),
            status: "in-treatment",
            startSortedDate: Date.now(),
          },
        }
      );
      console.log("✅ Case updated (Approved):", result);
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
