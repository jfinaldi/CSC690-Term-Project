const express = require('express')
const bodyParser = require('body-parser')
const mysql = require('mysql2')
const fs = require('fs')
const apn = require('apn')

const app = express()
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: false }))

const port = process.env.PORT || 4000

var con = mysql.createConnection({
    host: "18.188.195.49",
    user: "tracer",
    password: 'ImAlreadyTracer',
    database: 'ImAlreadyTracer',
});

var options = new apn.Provider({
    token: {
        key: "./AuthKey_P8HZ99H54P.p8",
        keyId: 'P8HZ99H54P',
        teamId: 'W7H8D6BF3X',
    }
})

var note = new apn.Notification()
note.title = 'You have been in close contact with covid'
note.body = 'You should start quarantining and get a test'
note.badge = 1
note.sound = 'default'
note.topic = 'jfinaldi.sfsu.ContactTracing'

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
                    res.status(200).send({ success: false, code: 'existed' })
                }
            })
        } else {
            res.status(500).send({ error: 'invalid input' })
        }
    })

    //app login req(username: string, password: string, device_token: string) res(login_token: string)
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
                        token: token.toString()
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

    //get locations of the user req(username: string, login_token: string) res(locations: [Location])
    app.post('/getLocation', (req, res) => {
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

    //save user location req(username: string, login_token: string, latitude: double, longtitude: double) res()
    app.post('/loglocation', (req, res) => {
        console.log(`${req.body.username} loging location`);
        // insert username, location to location
        if (req.body.username && req.body.login_token) {
            con.query(`SELECT login_token, user_id FROM user WHERE username=?`, [req.body.username], (err, result) => {
                if (err) throw err
                console.log(result[0].login_token)
                if (result[0].login_token === req.body.login_token) {
                    con.query(`INSERT INTO location (user_id,latitude,longtitude,time,infected) VALUES(${result[0].user_id}, '${req.body.latitude}', '${req.body.longtitude}', NOW(), 0)`, (err, result) => {
                        if (err) throw err
                        console.log(result)
                        res.send(result)
                    })
                } else {
                    res.status(500).send({ error: 'invalid session' })
                }
            })
        } else {
            res.status(500).send({ error: 'invalid session' })
        }
    })

    //report infection and notify other users req(username: string, login_token: string)
    app.post('/report', (req, res) => {
        console.log(`${req.body.username} reporting infection`);
        // fetch all location of user from location
        var users = []
        if (req.body.username && req.body.login_token) {
            con.query(`SELECT login_token, user_id FROM user WHERE username='${req.body.username}'`, (err, result) => {
                if (err) throw err
                console.log(result[0].login_token)
                if (result[0].login_token === req.body.login_token) {
                    con.query(`SELECT latitude, longtitude, time FROM location WHERE user_id=${result[0].user_id}`, (err, result) => {
                        if (err) throw err
                        console.log(result.length)


                        // for each location, fetch username from location
                        for (let index = 0; index < result.length; index++) {
                            var time = `${result[index].time.getFullYear()}-${result[index].time.getMonth() + 1}-${result[index].time.getDate()} ${result[index].time.getHours()}:${result[index].time.getMinutes()}:${result[index].time.getSeconds()}`
                            con.query(`SELECT location.location_id, user.username, user.device_token FROM location RIGHT JOIN user ON location.user_id=user.user_id \
                            WHERE location.latitude BETWEEN '${result[index].latitude - 0.0005}' AND '${(result[index].latitude + 0.0005).toFixed(6)}' \
                            AND location.longtitude BETWEEN '${result[index].longtitude - 0.001}' AND '${result[index].longtitude + 0.001}' \
                            AND location.time BETWEEN '${time}' AND DATE_ADD('${time}', INTERVAL 1 HOUR)`, (err, result) => {
                                if (err) throw err

                                // send out notification to each user
                                result.forEach(element => {
                                    if (element.username !== req.body.username && !users.includes(element.username)) {
                                        con.query(`UPDATE location SET infected = '1' WHERE location_id = '${element.location_id}'`)
                                        console.log(`send to ${element.username}`)
                                        users.push(element.username)
                                        options.send(note, element.device_token)
                                            .then(res => console.log(res))
                                            .catch(e => console.log({ e }))
                                    }
                                });
                            })
                        }
                    })
                    res.send('done')
                } else {
                    res.status(500).send({ error: 'invalid session' })
                }
            })
        } else {
            res.status(500).send({ error: 'invalid session' })
        }
    })
})