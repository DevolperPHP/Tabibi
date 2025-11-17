const jwt = require("jsonwebtoken");
const User = require("../model/User");
require("dotenv").config({ path: "key.env" });

const JWT_SECRET = process.env.JWT_SECRET;

const isUserMiddleware = async (req, res, next) => {
    try {
        const token = req.headers["authorization"];
        console.log(token);
        

        if (!token) {
            return res.status(401).json({ message: "Access denied. No token provided." });
        }

        const decoded = jwt.verify(token.split(" ")[1], JWT_SECRET);
        
        const user = await User.findById(decoded.id);

        if (!user) {
            return res.status(401).json({ message: "Invalid token. User not found." });
        }

        req.user = user; // Attach user to request object
        next();
    } catch (err) {
        console.error("Auth Error:", err);
        res.status(401).json({ message: "Invalid token" });
    }
};

module.exports = isUserMiddleware;
