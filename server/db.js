const mysql = require('mysql2')

var con = mysql.createConnection({
    host: "18.188.195.49",
    user: "tracer",
    password: 'ImAlreadyTracer',
    database: 'ImAlreadyTracer',
});

con.connect(err => {
    if (err) {
        console.log(err);
        process.exit(1)
    }

    //37.533410, -122.518526
    //37.616571, -122.385992
    //37.806112, -122.474559

    console.log('connected')
    var counter = 0

    setInterval(() => {
        var lat1 = 37.533410 + 0.272702 * Math.random()
        var long1 = -122.518526 + 0.132534 * Math.random()
        var lat2 = 37.533410 + 0.272702 * Math.random()
        var long2 = -122.518526 + 0.132534 * Math.random()

        console.log({
            counter,
            lat1: lat1.toFixed(6),
            long1: long1.toFixed(6),
            lat2: lat2.toFixed(6),
            long2: long2.toFixed(6),
        })

        con.query(`INSERT INTO location (user_id,latitude,longtitude,time,infected) VALUES(1, '${lat1.toFixed(6)}', '${long1.toFixed(6)}', NOW(), 0)`)
        con.query(`INSERT INTO location (user_id,latitude,longtitude,time,infected) VALUES(2, '${lat2.toFixed(6)}', '${long2.toFixed(6)}', NOW(), 0)`)

        counter++
    }, 300000);
})