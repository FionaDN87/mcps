const db = require('./db');
const helper = require('../helper');
const config = require('..config');

async function getMultiple(page = 1){
    const offset = helper.getOffset(page, config.listPerPage);
    const rows = await db.query(
        `SELECT id, proj_id, turbine_id, sensor_id, sensor_type_id, sensor_value
         FROM sensor_data`,
         [offset, config.listPerPage]
    );
    console.log(rows);
    const data = helper.emptyOrRows(rows);
    const meta = {page};

    console.log(data);

    return{
        data,
        meta
    }
}

module.exports = {
    getMultiple
}