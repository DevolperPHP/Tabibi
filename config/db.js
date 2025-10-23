const mongoose = require('mongoose')
const URI = 'mongodb://localhost:27017/tabibi'

mongoose.connect(URI)
    .then(() => {
        console.log("Database connected");

    })
    .catch((err) => {
        console.log(err);

    })
