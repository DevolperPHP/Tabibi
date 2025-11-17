const jwt = require("jsonwebtoken");
const User = require("../model/User");
require("dotenv").config({ path: "key.env" });

const JWT_SECRET = process.env.JWT_SECRET;

const isDoctorMiddleware = async (req, res, next) => {
    try {
        // Skip JWT check for PayTabs callback and return routes
        if (req.path.startsWith("/payment/")) {
            return next();
        }

        const token = req.headers["authorization"]?.split(" ")[1];

        if (!token) {
            return res.status(401).json({ message: "Access denied. No token provided." });
        }

        const decoded = jwt.verify(token, JWT_SECRET);
        const user = await User.findById(decoded.id);

        if (!user) {
            return res.status(401).json({ message: "Invalid token. User not found." });
        }

        if (!user.isDoctor && !user.isAdmin) {
            return res.status(403).json({ message: "Access denied. User is not a doctor." });
        }

        req.user = user; // Attach user to request
        next();
    } catch (err) {
        console.error("Doctor Auth Error:", err);
        res.status(401).json({ message: "Invalid or expired token" });
    }
};

module.exports = isDoctorMiddleware;
