const express = require('express')
const mysql = require('mysql2')
const fs = require('fs')

const app = express()
app.use(express.json())

const port = process.env.PORT || 4000

var con = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: '', //put your password here
    database: 'ImAlreadyTracer',
});

con.connect((err) => {
    if (err) {
        console.log(err);
        process.exit(1)
    }

    console.log('connected');

    app.listen(port, () => console.log(`listening on port ${port}`))

    app.post('/signup', (req, res) => {
        // fetch username from user
        con.query(`SELECT * FROM user WHERE username = ?`, [req.body.username], (err, result) => {
            if (err) throw err
            console.log(result);
            if (result.length === 0) {
                con.query(`INSERT INTO user(username,password) VALUES('${req.body.username.split('\'').join('\'\'')}','${req.body.password}')`, (err, result) => {
                    if (err) {
                        console.log({ err, result });
                        res.send({ success: false, code: 'db error' })
                    }
                    res.send({ success: true })
                })
            } else {
                res.status(500).send({ success: false, code: 'existed' })
            }
        })

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
})