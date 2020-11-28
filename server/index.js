const express = require('express')
const mysql = require('mysql')

const app = express()
app.use(express.json())

const port = process.env.PORT || 3000

app.listen(port, () => console.log(`listening on port ${port}`))

app.post('/signup', (req, res) => {
    // fetch username from user

    // no result -> insert to user and return success

    // yes result -> return fail
})

app.post('/login', (req, res) => {
    // fetch password from user

    // password matches -> return success

    // password not match -> return fail
})

app.post('/loglocation', (req, res) => {
    // insert username, location to location
})

app.post('/report', (req, res) => {
    // fetch all location of user from location

    // for each location, fetch username from location

    // send out notification to each user
})