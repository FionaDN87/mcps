const db = require('./db');
const helper = require('../helper');
const config = require('..config');

async function create(sensor_data){

    const proj_id = sensor_data.proj_id;
    const turbine_id = sensor_data.turbine_id;
    const sensor_id = sensor_data.sensor_id;
    const sensor_type_id = sensor_data.sensor_type_id;
    const sensor_value = sensor_data.sensor_value;

    const result = await db.query(`INSERT INTO sensor_data (proj_id, turbine_id, sensor_id, sensor_type_id, sensor_value) VALUES
    (?, ?, ?, ?, ?)`,
    [
        proj_id, turbine_id, sensor_id, sensor_type_id,sensor_value
    ]);
    let message = 'Error in creating sensor data';

    if(result.affectRows){
        message = 'Sensor data was recorded successfully';
    }
    return (message);
}

module.exports = {
    create
}