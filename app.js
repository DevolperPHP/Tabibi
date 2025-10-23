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
require("dotenv").config({ path: "./key.env" });
const paymentRoutes = require("./routes/doctor/payment");

let PORT = 3000;

app.use(cors());

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
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});