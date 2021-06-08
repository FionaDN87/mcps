const express = require ('express');
const router = express.Router();
const readSensorData = require('../services/readSensorData.js');

/* GET sensor data. */
router.get('/', async function (req,res,next) {
    try {
        res.json(await readSensorData.getMultiple(req.query.page));
    } catch (err){
        console.error(`Error while getting sensor data `, err.message);
        next(err);
    }
});
module.export = router