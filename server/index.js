const express = require('express')
const mysql = require('mysql2')
const fs = require('fs')

const app = express()
app.use(express.json())

const port = process.env.PORT || 4000

var con = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: 'Spacey32!', //put your password here
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
                // no result -> insert to user and return success
                con.query(`INSERT INTO user(username,password) VALUES('${req.body.username.split('\'').join('\'\'')}','${req.body.password}')`, (err, result) => {
                    if (err) {
                        console.log({ err, result });
                        res.send({ success: false, code: 'db error' })
                    }
                    res.send({ success: true })
                })
            } else {
                // yes result -> user existed, return fail
                res.status(500).send({ success: false, code: 'existed' })
            }
        })
    })

    app.post('/login', (req, res) => {
        // fetch password from user
        con.query(`SELECT password FROM user WHERE username=?`, [req.body.username], (err, result) => {
            if (err) throw err
            if (result.length === 0) {
                //user not found
                res.send({
                    success: false,
                    code: 'not exist'
                })
            } else {
                console.log(result[0].password);
                if (result[0].password === req.body.password) {
                    // password matches -> create login token, return success
                    var token = Date.now()
                    console.log(token)
                    con.query(`UPDATE user SET login_token = '${token}' WHERE username = '${req.body.username}'`)
                    res.send({
                        success: true,
                        token: token
                    })
                } else {
                    // password not match -> return fail
                    console.log('not match');
                    res.send({
                        success: false,
                        code: 'wrong password'
                    })
                }
            }
        })

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