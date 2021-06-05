import React from 'react';
import { makeStyles } from '@material-ui/core/styles';
import Paper from '@material-ui/core/Paper';
import Grid from '@material-ui/core/Grid';
import '../style/Header.css';

const Body = makeStyles((theme) => ({
  root: {
    flexGrow: 1,
  },
  paper: {
    padding: theme.spacing(2),
    textAlign: 'center',
    color: theme.palette.text.secondary,
  },
}));

export default function FullWidthGrid() {
  const classes = Body();

  return (
    <div className={classes.root} >
      <Grid className ="Header" container spacing={3}>
        <Grid  item xs={6} sm={4}>
          <Paper className={classes.paper}>Monitored Windfarms</Paper>
        </Grid>
        <Grid item xs={6} sm={4}>
          <Paper className={classes.paper}>Turbine ID:</Paper>
        </Grid>
        <Grid item xs={6} sm={4}>
          <Paper className={classes.paper}>Diagnostics Information</Paper>
        </Grid>
      </Grid>
    </div>
  );
}
