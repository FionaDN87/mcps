const express = require('express');
const router = express.Router();
const writeSensorData = require('../services/writeSensorData.js');

/* POST sensor data*/
router.post('/', async function(req, res, next){
    try{
        res.json(await writeSensorData.create(req.body));
    } catch (err) {
        console.error(`Error while creating sensor data`, err.message);
        next(err);
    }
})
module.export = router;