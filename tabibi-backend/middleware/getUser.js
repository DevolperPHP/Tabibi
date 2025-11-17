const jwt = require("jsonwebtoken");
const User = require("../model/User");
require("dotenv").config({ path: "key.env" });

const JWT_SECRET = process.env.JWT_SECRET;

const isLogginMiddleware = async (req, res, next) => {
    try {
        const token = req.headers["authorization"]?.split(" ")[1];

        if (token) {
            const decoded = jwt.verify(token, JWT_SECRET);
            req.user = await User.findById(decoded.id);
        }

        next();
    } catch (err) {
        console.error("Middleware Error:", err);
        next(); // Continue even if no valid user is found
    }
};

module.exports = isLogginMiddleware;
