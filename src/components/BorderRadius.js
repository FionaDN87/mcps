import React from 'react';
import Box from '@material-ui/core/Box';
import { borderColor, color } from '@material-ui/system';
import '../style/BorderRadius.css'

const defaultProps = {
  bgcolor: 'background.paper',
  borderColor: 'text.primary',
  m: 1,
  border: 1,
  style: { width: '15rem', height: '1.5rem' },
  
};

export default function BorderRadius() {
    const [highlighted, setHighlighted] = React.useState(false);

  return (
    <div>
        <h1 style={{textAlign:"center"}}>Import File</h1>
      <center><div className={`"BorderRadius-Default" 
      ${highlighted ? "BorderRadius-Drag" : "BorderRadius-Default"}`} >
      <div
        onDragEnter={()=>{
            setHighlighted(true);
        }}
        onDragLeave={()=>{
            setHighlighted(false);
        }}
        onDragOver={(e)=>{
            e.preventDefault();
        }}
        onDrop={(e)=>{
            e.preventDefault();
            setHighlighted(false);
            //Convert file list to array and map
            Array.from(e.dataTransfer.files)
            .filter((file) => file.type ==="text/csv"    //filter only csv
            ).forEach(file => {                          //iteratte each element in array
                console.log(file)
            });
        }}
      >
              DROP HERE (.csv)
        </div>
        </div> </center>
    </div>
  );
}
