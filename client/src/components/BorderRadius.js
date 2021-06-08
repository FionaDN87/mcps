import React from 'react'
import'../style/BorderRadius.css'
import { parse } from 'papaparse'
import { RemoveCircleOutlineRounded } from '@material-ui/icons';


export default function BorderRadius() {
    const [highlighted, setHighlighted] = React.useState(false);
    const [datas, setData] = React.useState([
      {
      case_id: "XXXXXXX", 
      faa_ors:"blank", 
      faa_asn:"blank", 
      usgs_pr_id:"XXXX", 
      eia_id:"XXXXX",
      t_state:"State",
      t_country:"Country",
      t_fips:"XXXX",
      p_name:"Turbine Name",
      p_year:"XXXX",
      p_tnum:"XXX",
      p_cap: "XX.XX",
      t_manu:"Manu",
      t_model:"blank",
      t_cap:"95",
    }
    ]);
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
            ).forEach(async file => {                    //iteratte each element in array  
                
                const text =await file.text();
                const result = parse(text, {header:true})
                //console.log(text);                    //Display raw file imported
                setData(existing => [...existing, ...result.data])
                console.log(result.data.length);      //Check array length
                
              
                
            }
            )       
        }
      }
      >
              DROP HERE (.csv)
        </div>
        </div> </center>
        <ul>
          {datas.slice(0,50).map((data)=>(
            <li key={data.case_id}>
              {data.case_id}   |  {data.p_name}
            </li>
          ))}
        </ul>
        
        
    </div>
    
  );
}
