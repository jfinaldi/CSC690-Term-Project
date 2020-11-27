const express = require('express')
const mysql = require('mysql')

const app = express()
app.use(express.json())

const port = process.env.PORT || 3000

app.listen(port, () => console.log(`listening on port ${port}`))

app.post('/signup', (req, res) => {

})

app.post('/login', (req, res) => {

})

app.post('/loglocation', (req, res) => {

})

app.post('/report', (req, res) => {

})