const express = require("express");
const router = express.Router();
const User = require("../model/User");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
require("dotenv").config({ path: "key.env" });

const JWT_SECRET = process.env.JWT_SECRET;


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

module.exports = router;
