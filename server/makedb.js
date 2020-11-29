const mysql = require('mysql')
const fs = require('fs')

fs.readFile('ImAlreadyTracer.sql', 'utf-8', (err, data) => {
    if (err) throw err;

    // Converting Raw Buffer to text 
    // data using tostring function. 
    console.log({data});

    /*
    var con = mysql.createConnection({
        host: "localhost",
        user: "root",
        password: "strang3rThing5",
    });

    con.connect(err => {
        if (err) {
            process.exit(1)
        }
        con.query(data, (err, result) => {
            if (err) {
                console.log(err)
            }
            console.log(result);
        })
    })
    */
})

