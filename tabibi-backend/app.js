// Buffer polyfill for Node.js v25 compatibility
global.Buffer = global.Buffer || require('buffer').Buffer;

const express = require("express");
const app = express();
const cors = require("cors");
const passport = require("./routes/passport");
const cookieParser = require('cookie-parser')
const db = require('./config/db')
const adminPosts = require('./routes/admin/posts')
const cases = require('./routes/user/case')
const doctor = require('./routes/doctor/doctor')
const home = require('./routes/user/home')
const profile = require('./routes/user/profile')
const roles = require('./routes/admin/roles')
const adminCase = require('./routes/admin/case')
const category = require('./routes/admin/category')
const diagnose = require('./routes/diagnose/diagnose')
const notifications = require('./routes/user/notifications')
const fcmToken = require('./routes/user/fcm-token')
const healthTips = require('./routes/admin/health-tips')
require("dotenv").config({ path: "./key.env" });
const paymentRoutes = require("./routes/doctor/payment");

let PORT = 3000;

app.use(cors({
  origin: '*', // Allow all origins for development, restrict in production
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Accept', 'Origin', 'X-Requested-With'],
  credentials: true
}));

// Handle preflight OPTIONS requests
app.options('*', (req, res) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Accept, Origin, X-Requested-With');
  res.header('Access-Control-Allow-Credentials', 'true');
  res.status(200).send();
});

// Handle JSON and URL-encoded data
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser())
app.use(express.static("public"))

app.use("/passport", passport);
app.use('/admin/post', adminPosts)
app.use('/case', cases)
app.use('/home', home)
app.use('/doctor', doctor)
app.use('/doctor/payment', paymentRoutes);
app.use('/profile', profile)
app.use('/admin/role', roles)
app.use('/admin/case', adminCase)
app.use('/admin/category', category)
app.use('/diagnose', diagnose)
app.use('/notifications', notifications)
app.use('/users', fcmToken)
app.use('/admin/health-tips', healthTips)
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});