<h2>UltimateRepRapPost</h2>
<h1>The ULTIMATE Duet3D RepRap CNC Post-Processor for Autodesk Fusion 360</h1>

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
        <br>Get a chronometer and start your spindle motor from stationary to 6000 RPM and measure how many seconds it takes for it to catch up and settle on the RPM and input that number here.
        <p> </p>
      </li>

   <li><i>WCS to be used [If Setup WCS isn't 0, it overrides this]</i>
        <br>Choose the correct Work Coordinate System that is in use from 8 available slots. The post reserves WCS 9 for manual tool change operations. For the sake of file portability, this setting will be entirely ignored if you have specified WCS in your Fusion360 setup. This ensures that you don't accidentally override the intended WCS choice if you recieved the file from an another place.
        <br>If you want the ability to choose your WCS in the post, you should leave the WCS offset on 0 when you setup your model for operations.
        <p> </p>
      </li>
    </ul>
 <li><b>Multi-Tools</b>
   <ul>
     <li><i>Home axis on tool change</i>
       <br>Homes all axis after tool is changed and before it is potentailly probed
       <p> </p>
     </li>

   <li><i>Manual tool change</i>
     <br>If checked, manual tool change procedure will be preformed as needed. The spindle stops and the machine waits and asks for the tool to be replaced, and the program is interrupted until tool change is confirmed for the operators safety. The machine will only resume after operator connfirms the new tool is secured and after a 3 seconds back up time. Then the tool will retrun to where it was last and spindle restarts. If other operation such as Z-Probe where requested on tool change, they will be preformed before the spindle restart.
     <br>During the tool change the WCS 0,0,0 and all other parameters are reseverd and new tool diameter will be taken into consideration for continues flawless machining.
     <br><i><b>Note: </b>In an unlikely event if accidentally confirmed the tool is changed while still dealing with the spindle, let go of the spindle as soon as it starts to move back to it's position and while the spindle motor is still off, and preform Emergency Stop.
     <p> </p>
   </li>

   <li><i>Probe Tool on each tool change</i>
     <br>Preforms probe after every tool change. There are three probing options available:
      <ul>
        <li>No probe
          <br>No probing to undertake after tool changes
        </li>
        <li>Z-probe
          <br>Preforms Z-probe after tool changes. Z-Probe thickness will be taken from <i>Probes</i> section below
        </li>
        <li>Corner Probe
          <br>Preforms corner after tool changes. Corner Probe dimensionns will be taken from <i>Probes</i> section below
        </li>
      </ul>
     <p> </p>
   </li>

   <li><i>X for Tool Change [ignored if WCS9 is used]</i></li>
   <li><i>Y for Tool Change [ignored if WCS9 is used]</i></li>
   <li><i>Z for Tool Change [ignored if WCS9 is used]</i>
     <br>These are absolute X, Y and Z position suitable for tool change. If manual tool change is selected, the Spindle will be turned off and moved to this position and stays there for the tool to be changed. The spinndle will then returns to the exact location before tool change annd carryies on.
     <br>If probe after tool change is selected, the program pauses and an on screen messages appears to let you mount the probe before requested probe to be preformed, after the probe, the program pauses with anothe on screen message to allow you to remove probe before resuming machining.
     <br>On moving to the tool change position, and in order to minimize the risk of collision, the spindle moves a dog leg in this order:
     <br>Move to specified Z
     <br>Move to specified X
     <br>and finally move to specified Y
     <br>Similar move sequences are used for the spindle to go back and to probe
     <br><b>Note1:</b> If you choose the WCS9 Home to be used for tool change, these XYZ values are ignored and WCS9 will be used instead.
     <br><b>Note2:</b> If you choose specify XYZ for tool change instead of using WCS9, the WCS9 Home will be updated with specified values in the Post
     <p> </p>
    </li>
    <li><i>Use WCS9 Home as tool change position</i>
      <br>Check this to use your pre-defined 0,0,0 position you have saved in WCS9 for tool change. 
      <br><b>Note:</b> Uncheking this will result for the WCS9 values to be overwritten by above XYZ Tool Change position values. Please see above for more information.
      <p> </p>
    </li>
      


   
  </ul>

  </li>
</ol>
... to be completed
