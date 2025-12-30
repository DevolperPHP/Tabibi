const express = require("express");
const router = express.Router();
const User = require("../model/User");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const axios = require("axios");
require("dotenv").config({ path: "key.env" });

const JWT_SECRET = process.env.JWT_SECRET;

// OTP Service Configuration
const OTP_API_KEY = 'otplive_CfRpHurNNt2sR2Y8s75JoivPjxmCOewA';
const OTP_API_URL = 'https://otp.arqam.tech/api/sms';

// Store OTP data temporarily (in production, use Redis)
const otpStore = new Map(); // messageId -> { phoneNumber, expiry, verified }


router.post("/register", async (req, res) => {
    try {
        const { name, age, telegram, city, zone, email, password, gender, bp, diabetic, toothRemoved, tf, phone } = req.body;
        const existingUser = await User.findOne({ email });

        if (existingUser) {
            return res.status(400).json({ message: "Account already exists" });
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const newUser = new User({
            name,
            age,
            city,
            zone,
            email,
            gender,
            password: hashedPassword,
            bp: bp || 'no',
            diabetic: diabetic || 'no',
            toothRemoved: toothRemoved || 'no',
            tf: tf || 'no',
            phone,
            telegram,
        });

        await newUser.save();

        res.status(201).json({ message: "User registered successfully",
            
         });
    } catch (err) {
        console.error("Registration Error:", err);
        res.status(500).json({ message: "Server error" });
    }
});

router.post("/login", async (req, res) => {
    try {
        const { email, password } = req.body;
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(401).json({ message: "Invalid credentials" });
        }
        const token = jwt.sign(
            { id: user._id, isAdmin: user.isAdmin },
            JWT_SECRET,
            { expiresIn: "10y" }
        );

        res.status(200).json({
            message: "Login successful",
            token,
            user: { id: user._id, name: user.name, email: user.email, isAdmin: user.isAdmin, isDoctor: user.isDoctor},
            userData: user,
        });
    } catch (err) {
        console.error("Login Error:", err.message);
        res.status(500).json({ message: "Server error" });
    }
});


router.post("/logout", (req, res) => {
    res.clearCookie("id")
    res.status(200).json({ message: "User logged out successfully" });
});

// ==================== OTP Routes ====================

// Send OTP
router.post("/otp/send", async (req, res) => {
    try {
        const { phoneNumber } = req.body;

        console.log("OTP Send Request - Phone:", phoneNumber);

        if (!phoneNumber) {
            return res.status(400).json({ message: "Phone number is required" });
        }

        // Format phone number
        let formattedPhone = phoneNumber;

        // Remove all non-digit characters first
        let digitsOnly = phoneNumber.replace(/\D/g, '');

        // If starts with 964 (country code without +), keep it
        // If starts with 0 (Iraqi local format), replace with 964
        // Otherwise, add 964
        if (digitsOnly.startsWith('964')) {
            formattedPhone = '+' + digitsOnly;
        } else if (digitsOnly.startsWith('0')) {
            formattedPhone = '+964' + digitsOnly.substring(1);
        } else {
            formattedPhone = '+964' + digitsOnly;
        }

        console.log("Formatted Phone:", formattedPhone);

        // Call OTP API using axios
        const otpResponse = await axios.post(`${OTP_API_URL}/otp`, {
            phoneNumber: formattedPhone,
        }, {
            headers: {
                'X-API-Key': OTP_API_KEY,
                'Content-Type': 'application/json',
            }
        });

        const data = otpResponse.data;
        console.log("OTP API Response:", data);

        if (data.success && data.messageId) {
            // Store OTP data with 10 minute expiry
            otpStore.set(data.messageId, {
                phoneNumber: formattedPhone,
                expiry: Date.now() + (10 * 60 * 1000), // 10 minutes
                verified: false
            });

            // Clean up expired OTPs
            cleanupExpiredOTPs();

            return res.status(200).json({
                success: true,
                messageId: data.messageId,
                status: "sent"
            });
        } else {
            console.error("OTP API Error Response:", data);
            return res.status(500).json({
                message: "Failed to send OTP",
                error: data.message || "Unknown error"
            });
        }
    } catch (err) {
        console.error("OTP Send Error:", err);
        // Log axios specific error details
        if (err.response) {
            console.error("Response data:", err.response.data);
            console.error("Response status:", err.response.status);
        }
        res.status(500).json({
            message: "Server error while sending OTP",
            error: err.message
        });
    }
});

// Verify OTP
router.post("/otp/verify", async (req, res) => {
    try {
        const { messageId, code } = req.body;

        console.log("=== OTP Verify Request ===");
        console.log("MessageID:", messageId);
        console.log("Code:", code, "Type:", typeof code);
        console.log("Current OTP Store:", Array.from(otpStore.entries()));

        if (!messageId || !code) {
            console.log("Missing messageId or code");
            return res.status(400).json({
                success: false,
                verified: false,
                message: "Message ID and code are required"
            });
        }

        // Check if OTP exists and is not expired
        const otpData = otpStore.get(messageId);

        if (!otpData) {
            console.log("OTP not found in store for messageId:", messageId);
            return res.status(404).json({
                success: false,
                verified: false,
                message: "OTP not found or expired"
            });
        }

        console.log("Found OTP data:", otpData);

        if (otpData.expiry < Date.now()) {
            console.log("OTP expired");
            otpStore.delete(messageId);
            return res.status(400).json({
                success: false,
                verified: false,
                message: "OTP has expired"
            });
        }

        if (otpData.verified) {
            console.log("OTP already used");
            return res.status(400).json({
                success: false,
                verified: false,
                message: "OTP already used"
            });
        }

        // Ensure code is a string
        const codeString = String(code).trim();
        console.log("Sending to OTP API - messageId:", messageId, "code:", codeString);

        // Call OTP Verify API using axios
        const verifyResponse = await axios.post(`${OTP_API_URL}/verify`, {
            messageId: messageId,
            code: codeString,
        }, {
            headers: {
                'X-API-Key': OTP_API_KEY,
                'Content-Type': 'application/json',
            }
        });

        const data = verifyResponse.data;
        console.log("=== OTP Verify API Response ===");
        console.log("Status:", verifyResponse.status);
        console.log("Data:", data);

        // Check both 'verified' and 'success' fields from API response
        // The API returns { success: true, message: 'OTP verified successfully' }
        const isVerified = data.verified === true || data.success === true;

        if (isVerified) {
            // Mark OTP as verified
            otpData.verified = true;
            console.log("OTP verified successfully!");

            return res.status(200).json({
                success: true,
                verified: true,
                message: "OTP verified successfully",
                phoneNumber: otpData.phoneNumber
            });
        } else {
            console.log("OTP verification failed - API returned:", data);
            return res.status(200).json({
                success: true,
                verified: false,
                message: data.message || "Invalid OTP code"
            });
        }
    } catch (err) {
        console.error("=== OTP Verify Error ===");
        console.error("Error:", err.message);
        // Log axios specific error details
        if (err.response) {
            console.error("Response data:", err.response.data);
            console.error("Response status:", err.response.status);
        }
        res.status(200).json({
            success: true,
            verified: false,
            message: err.response?.data?.message || err.message || "OTP verification failed"
        });
    }
});

// Helper function to clean up expired OTPs
function cleanupExpiredOTPs() {
    const now = Date.now();
    for (const [messageId, otpData] of otpStore.entries()) {
        if (otpData.expiry < now) {
            otpStore.delete(messageId);
        }
    }
}

module.exports = router;
