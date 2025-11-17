const jwt = require("jsonwebtoken");
const User = require("../model/User");
require("dotenv").config();

const JWT_SECRET = process.env.JWT_SECRET;

const isAdminMiddleware = async (req, res, next) => {
    try {
        const authHeader = req.headers["authorization"];
        console.log(authHeader);
        
        if (!authHeader || !authHeader.startsWith("Bearer ")) {
            return res.status(401).json({ message: "Access denied. No token provided." });
        }

        const token = authHeader.split(" ")[1];
        
        if (!token) {
            return res.status(401).json({ message: "Invalid token format." });
        }

        let decoded;
        try {
            decoded = jwt.verify(token, JWT_SECRET);
        } catch (error) {
            return res.status(400).json({ message: "Invalid or expired token", error: error.message });
        }

        // Fetch user from DB
        const user = await User.findById(decoded.id);
        if (!user) {
            return res.status(404).json({ message: "User not found." });
        }

        if (!user.isAdmin) {
            return res.status(403).json({ message: "Access denied. User is not an admin." });
        }

        req.user = user; // Attach user object to request
        next();
    } catch (err) {
        console.error("Admin Auth Error:", err);
        res.status(500).json({ message: "Something went wrong." });
    }
};

module.exports = isAdminMiddleware;
