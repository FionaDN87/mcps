const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const port = process.env.PORT || 3001;
const readSensorDataRouter = require('./routes/readSensorData.js');
const writeSensorDataRouter = require('./routes/writeSensorData.js');

app.use(bodyParser.json());
app.use(
    bodyParser.urlencoded({
        extended: true,
    })
);

app.get('/', (req,res) => {
    res.json({'message': 'ok'});
})

app.use('/readSensorData', readSensorDataRouter);
app.use('/writeSensorData', writeSensorDataRouter);

/*Error handler middleware*/
app.use((err, req, res, next) => {
    const statusCode = err.statusCode || 500;
    console.error(err.message, err.stack);
    res.status(statusCode).json({'messages': err.message});

    return;
}); 

app.listen(port, () => {
    console.log(`App is listerning at http://localhost:${port}`)
});