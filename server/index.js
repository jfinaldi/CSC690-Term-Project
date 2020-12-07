const express = require('express')
const mysql = require('mysql2')
const fs = require('fs')

const app = express()
app.use(express.json())

const port = process.env.PORT || 4000

var con = mysql.createConnection({
    host: "18.188.195.49",
    user: "tracer",
    password: 'ImAlreadyTracer',
    database: 'ImAlreadyTracer',
});

con.connect((err) => {
    if (err) {
        console.log(err);
        process.exit(1)
    }

    console.log('connected');

    app.listen(port, () => console.log(`listening on port ${port}`))

    //app signup req(username: string, password: string) res(success: bool)
    app.post('/signup', (req, res) => {
        // fetch username from user
        console.log({
            endpoint: '/signup',
            username: req.body.username,
            password: req.body.password,
        })

        if (req.body.username && req.body.password) {
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
        } else {
            res.status(500).send({error: 'invalid input'})
        }
    })

    //app login req(username: string, password: string, device_token: string) res(login_token: int)
    app.post('/login', (req, res) => {
        // fetch password from user
        console.log({
            endpoint: '/login',
            username: req.body.username,
            password: req.body.password,
            device_token: req.body.device_token,
        })

        con.query(`SELECT password FROM user WHERE username=?`, [req.body.username], (err, result) => {
            if (err) throw err
            if (result.length === 0) {
                //user not found
                res.send({
                    token: null,
                    code: 'not exist'
                })
            } else {
                console.log(result[0].password);
                if (result[0].password === req.body.password) {
                    // password matches -> create login token, return success
                    var token = Date.now()
                    console.log(token)
                    if (req.body.device_token) {
                        con.query(`UPDATE user SET login_token = '${token}', device_token = '${req.body.device_token}' WHERE username = '${req.body.username}'`)   
                    } else {
                        con.query(`UPDATE user SET login_token = '${token}' WHERE username = '${req.body.username}'`)
                    }
                    res.send({
                        token: token
                    })
                } else {
                    // password not match -> return fail
                    console.log('not match');
                    res.send({
                        token: null,
                        code: 'wrong password'
                    })
                }
            }
        })
    })

    //get locations of the user req(username: string, login_token: int) res(locations: [Location])
    app.post('/getLocations', (req, res) => {
        console.log({
            endpoint: '/getLocations',
            username: req.body.username,
            password: req.body.password,
            device_token: req.body.device_token,
        })

        if (req.body.username && req.body.login_token) {
            con.query(`SELECT login_token, user_id FROM user WHERE username=?`, [req.body.username], (err, result) => {
                if (err) throw err
                console.log(result[0].login_token)
                if (result[0].login_token === req.body.login_token) {
                    con.query(`SELECT latitude, longtitude, time, infected FROM location WHERE user_id=?`, [result[0].user_id], (err, result) => {
                        if (err) throw err
                        console.log(result)
                        res.send({ locations: result })
                    })
                } else {
                    res.send({ locations: null })
                }
            })
        } else {
            res.status(500).send({ error: 'invalid session' })
        }
    })

    //save user location req(username: string, login_token: int, latitude: double, longtitude: double) res()
    app.post('/loglocation', (req, res) => {
        // insert username, location to location
    })

    //report infection and notify other users req(username: string, login_token: int)
    app.post('/report', (req, res) => {
        // fetch all location of user from location

        // for each location, fetch username from location

        // send out notification to each user
    })
})