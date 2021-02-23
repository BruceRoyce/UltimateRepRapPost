# UltimateRepRapPost
The ULTIMATE Duet3D RepRap CNC Post-Processor for Autodesk Fusion 360

<img src="https://i.ibb.co/4Zbxk3g/Ultimate-Post-Processor-Banner.jpg" alt="Ultimate-Post-Processor-Banner" style="width: 100% !important;" border="0">
<b>Post Properties</b>

Post properties are decided into logical sections, each controlling a specific aspect of the output

<ol>
<li><b>Work Space</b>
  <ul>
    <li><i>Audible signal when operator's attention needed</i>
      <br>Check this to get an audible notifications whenever special attention required such as when the tool is ready for change, or where the extreme caution is adviced, such as when failure to remove a probe can cause damages to the tool, part, machine or even the operator.  
    The audible signal is generated on the computer that runs the control and NOT the controller board. So, this requires your PC to be audio enabled and volume is up.
    <p> </p>
    </li>
  
  <li><i>Corner Probe Placement</i>
  <br>Depending on your setup, you may place your corner probe on any of the four corner of your stock. This will let the program to know and therefore to adjust for your corner probe location. If you choose nnot to use corner probe at all, these parameters will be ignored.
  <p> </p>
  </li>
    
  <li><i>Corner Probe on initial start [1st Tool must be pre-mounted]</i>
  <br>Preforms XYZ-Corner Probe on start of script. It takes the corner probe dimensions and placemennnt from the options you specify in this stage, under sectionn <u>3- Probes</u>
  <p> </p>
  </li>
  
  <li><i>Spindle RPM catch up time for 6K (in sec.)</i>
  <br>How many seconds does the Spindle motor need to catch up from 0 to 6000. Determines time needed for all other speeds as well. For example if catch-up time for 6000 (6K) is 15 seconds, it will be 30 seconds for 12000 and 7.5 for 3000 and so forth. 
  <p> </p>
  </li>
  </ul>
</li>
</ol>
... to be completed
