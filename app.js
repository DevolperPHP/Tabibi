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
require("dotenv").config({ path: "./key.env" });


let PORT = 3000;

app.use(cors());

// Handle JSON and URL-encoded data
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser())

app.use("/passport", passport);
app.use('/admin/post', adminPosts)
app.use('/case', cases)
app.use('/home', home)
app.use('/doctor', doctor)
app.use('/profile', profile)

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});