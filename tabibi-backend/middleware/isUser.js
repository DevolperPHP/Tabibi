const jwt = require("jsonwebtoken");
const User = require("../model/User");
require("dotenv").config({ path: "key.env" });

const JWT_SECRET = process.env.JWT_SECRET;

const isUserMiddleware = async (req, res, next) => {
    try {
        const authHeader = req.headers["authorization"];
        console.log('🔐 Auth header:', authHeader ? authHeader.substring(0, 20) + '...' : 'null');
        
        // Check if JWT_SECRET is defined
        if (!JWT_SECRET) {
            console.error('❌ JWT_SECRET is not defined in environment variables');
            return res.status(500).json({ message: "Server configuration error" });
        }

        if (!authHeader) {
            console.log('⚠️  No authorization header provided');
            return res.status(401).json({ message: "Access denied. No token provided." });
        }

        // Check if it starts with "Bearer "
        if (!authHeader.startsWith('Bearer ')) {
            console.log('⚠️  Invalid authorization header format');
            return res.status(401).json({ message: "Invalid token format" });
        }

        const token = authHeader.split(" ")[1];
        console.log('🔑 Token extracted:', token.substring(0, 20) + '...');

        const decoded = jwt.verify(token, JWT_SECRET);
        console.log('✅ Token verified successfully for user ID:', decoded.id);

        const user = await User.findById(decoded.id);

        if (!user) {
            console.log('❌ User not found for ID:', decoded.id);
            return res.status(401).json({ message: "Invalid token. User not found." });
        }

        console.log('👤 User authenticated:', user.name || user.email);
        req.user = user; // Attach user to request object
        next();
    } catch (err) {
        console.error("❌ Auth Error:", err.message);
        if (err.name === 'JsonWebTokenError') {
            res.status(401).json({ message: "Invalid token" });
        } else if (err.name === 'TokenExpiredError') {
            res.status(401).json({ message: "Token expired" });
        } else {
            res.status(401).json({ message: "Authentication failed" });
        }
    }
};

module.exports = isUserMiddleware;
