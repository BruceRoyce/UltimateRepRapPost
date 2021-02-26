/**
  Copyright (C) 2012-2018 by Autodesk, Inc.
  Copyright (C) 2021 by Bruce Royce
  All rights reserved.


  $R 1.02 $
  $Date: 2021-02-27 12:23:16 $

  FORKID {A4D747BD-FEEF-4CE2-86CD-0D56966792FA}
*/

description = "JINNI Post-Processor - Duet RepRap w/Tool Change";
vendor = "JINNITECH";
vendorUrl = "http://www.jinnitech.com";
legal = "Copyright (C) 2012-2018 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 24000;

longDescription = "JINNI's Post-Processor for Duet3D Cntrlr w/ RepRap by Bruce";
setCodePage("ascii");

capabilities = CAPABILITY_MILLING;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.1, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.1);
maximumCircularSweep = toRad(180);
allowHelicalMoves = true;

let groupNames = [
  "8- Unsupported or Future Development",  // was "1- Operation Type"
  "1- Workspace",
  "2- Multi-Tools",
  "3- Probes",
  "5- General",
  "6- Optionals",
  "7- Descriptive Comments",
  "8- Unsupported or Future Development",
  "4- Linear Backlash Compensation"
];

// user-defined properties
properties = {
  printType: ".cnc", // changes the file extension and leaves a comment. To be developed
  beepOn: true, // if true beeps when operator attention is required
  useWhichWCS: "54", // only if not set in Fusion 360 Setup, what is the prefered WCS for the probes
  manualToolChange: true, //Asks for manual tool change and program is interrupted until tool change is confirmed.
  useWCS9AsToolChangeHome: true,  // uses pre-recorded WCS 9 0,0,0 as tool change home
  toolChangeXPos: 100, // only if not using WCS9, the x position for tool change
  toolChangeYPos: 250, // only if not using WCS9, the y position for tool change
  toolChangeZPos: 23,  // only if not using WCS9, the z position for tool change operation
  probeToolOnChange: "1", // probes a tool after changed in with by calling /macros/Tool Probe Auto
  probeZThickness: 3, // ZProbe thickness in millimetre's
  probeZRetract: 5,  // how far to retract to release probe after z-probe
  homeOnToolChange: false,  //homes all axis after tool is changed and before it is potentailly probed
  probe3dOnStart: false, // If true preforms a corner probe at the start of the script
  probe3DPlacement: 0, // which corner is the corner probe sitting at (see values below)
  probe3DLength: 50, // x dimension of the corner probe
  probe3DWidth: 50, // y dimension of the corner probe
  probe3DThickness: 5, // z dimension of the corner probe
  probe3DRetract: 10, // how far (in all directions) to retract to release corner probe after probing

  showSequenceNumbers: false, // show sequence numbers
  sequenceNumberStart: 10, // first sequence number
  sequenceNumberIncrement: 5, // increment for sequence numbers
  separateWordsWithSpace: true, // specifies that the words should be separated with a white space

  useRadius: true, // specifies that arcs should be output using the radius (R word) instead of the I, J, and K words.
  dwellInSeconds: true, // specifies the unit for dwelling: true:seconds and false:milliseconds.
  useDustCollector: false, // specifies if M7 and M9 are output for dust collector
  useRigidTapping: "whitout", // output rigid tapping block

  writeMachine: true, // write machine
  writeTools: true, // writes the tools
  writeVersion: true, // include version info

  optionalStop: false, // optional stop. Kills the gcode execution if used with manual tool change. Keep unchecked in that case
  useG28: false, // disable to avoid G28 output for safe machine retracts - when disabled you must manually ensure safe retracts
  useM6: false, // disable to avoid M6 output - preload is also disabled when M6 is disabled
  preloadTool: false, // (Unsupported)preloads next tool on tool change if any
  applyBacklashCompensation: true,
  measuredBacklashXFor1mm:0, // in millimetre
  measuredBacklashXFor10mm:0, // in millimetre
  measuredBacklashYFor1mm:0, // in millimetre
  measuredBacklashYFor10mm:0, // in millimetre
  measuredBacklashZFor1mm:0, // in millimetre
  measuredBacklashZFor10mm:0, // in millimetre
  emptyAccumulatedCompensationError: false,
  bCompensationCount: 0,
  spindleRPMCatchupTime6K: 15 // in seconds
};

// user-defined property definitions
propertyDefinitions = {
  printType: {
    title: "Operation is for:",
    description: "Choose the operation type",
    group: groupNames[0],
    type: "enum",
    values: [
      { title: "CNC", id: ".cnc" },
      { title: "Laser", id: ".laser" },
      { title: "Plasma", id: ".plasma" },
      { title: "Addedtive", id: ".3dPrinter" }
    ]
  },
  useWhichWCS: {
    title: "WCS to be used [If Setup WCS isn't 0, it overrides this]",
    description: "Which Work Coordinate System is in use from 1 to 8 (9 is reserved for tool change)",
    group: groupNames[1],
    type: "enum",
    values: [
      {title: "WCS 1", id:"54"},
      {title: "WCS 2", id:"55"},
      {title: "WCS 3", id:"56"},
      {title: "WCS 4", id:"57"},
      {title: "WCS 5", id:"58"},
      {title: "WCS 6", id:"59"},
      {title: "WCS 7", id:"59.1"},
      {title: "WCS 8", id:"59.2"}
    ]
  },
    manualToolChange: {
      title: "Manual tool change",
      description: "Asks for manual tool change and program is interrupted until tool change is confirmed.",
      group: groupNames[2],
      type: "boolean"
    },
    useWCS9AsToolChangeHome: {
      title: "Use WCS9 home as tool change position",
      description: "If checked the [0,0,0] in WCS9 will be used to home when changing tools. otherwise tool change positionn will be used",
      group: groupNames[2],
      type: "boolean"
    },
    toolChangeXPos: {
      title: "X for Tool change [ignored if WCS9 is used]",
      description: "Tool change abs. X [ignored if WCS9 is used]",
      group: groupNames[2],
      type: "integer"
    },
    toolChangeYPos: {
      title: "Y for Tool change [ignored if WCS9 is used]",
      description: "Tool change abs. Y [ignored if WCS9 is used]",
      group: groupNames[2],
      type: "integer"
    },
    toolChangeZPos: {
      title: "Z for Tool change [ignored if WCS9 is used]",
      description: "Tool change abs. Z [ignored if WCS9 is used]",
      group: groupNames[2],
      type: "integer"
    },
    beepOn : {
      title: "Audible signal when operator's attention needed",
      description: "Makes a beep when attention required",
      group: groupNames[1],
      type: "boolean"
    },
    probeToolOnChange: {
      title: "Probe tool on each tool change",
      description: "Creates Probe routine after each tool change",
      group: groupNames[2],
      type: "enum",
      values: [
        { title: "No probe", id: "0" },
        { title: "Z-Probe", id: "1" },
        { title: "Corner Probe", id: "2" }
      ]
    },
    probeZThickness: {
      title: "Z-Probe thickness",
      description: "Thickness of Z-Probe",
      group: groupNames[3],
      type: "integer"
    },
    probeZRetract: {
      title: "Safe distance to retract after Z-Probe",
      description: "Safe distance to retract to release the Z-Probe",
      group: groupNames[3],
      type: "integer"
    },
  probe3dOnStart: {
    title: "Corner Probe on initial start [1st Tool must be pre-mounted]",
    description: "Preforms XYZ-Corner Probe on start of script",
    group: groupNames[1],
    type: "boolean" },
  probe3DPlacement: {
    title: "Corner Probe Placement",
    description: "Choose the placement of the corner probe",
    group: groupNames[1],
    type: "enum",
    values: [
      { title: "Bottom-Left", id: "0" },
      { title: "Top-Left", id: "1" },
      { title: "Top-Right", id: "2" },
      { title: "Bottom-Right", id: "3" }
    ]
  },
  probe3DLength: {
    title: "Corner Probe Length (X dimension)",
    description: "Corner Probe X dimension",
    group: groupNames[3],
    type: "integer" },
  probe3DWidth: {
    title: "Corner Probe Width (Y dimension)",
    description: "Corner Probe Y dimension",
    group: groupNames[3],
    type: "integer" },
  probe3DThickness: {
    title: "Corner Probe Thickness (Z dimension)",
    description: "Corner Probe Thickness (Z dimension)",
    group: groupNames[3],
    type: "integer" },
  probe3DRetract: {
    title: "Safe distance to retract after probe",
    description: "Distance the tool can retract back up to release the probe when done",
    group: groupNames[3],
    type: "integer" },
  homeOnToolChange: {
    title: "Home axis on tool change",
    description: "Homes all axis after tool is changed and before it is potentailly probed.",
    group: groupNames[2],
    type: "boolean"
  },
  sequenceNumberStart: {
    title: "Start sequence number",
    description: "The number at which to start the sequence numbers.",
    group: groupNames[5],
    type: "integer" },
  sequenceNumberIncrement: {
    title: "Sequence number increment",
    description: "The amount by which the sequence number is incremented by in each block.",
    group: groupNames[5],
    type: "integer" },
  separateWordsWithSpace: {
    title: "Separate words with space",
    description: "Adds spaces between words if 'yes' is selected.",
    group: groupNames[5],
    type: "boolean" },
  writeMachine: {
    title: "Write machine",
    description: "Output the machine settings in the header of the code.",
    group: groupNames[6],
    type: "boolean" },
  writeTools: {
    title: "Write tool list",
    description: "Output a tool list in the header of the code.",
    group: groupNames[6],
    type: "boolean" },
  writeVersion: {
    title: "Write version",
    description: "Write the version number in the header of the code.",
    group: groupNames[6],
    type: "boolean" },
  useG28: {
    title: "G28 Safe retracts",
    description: "Disable to avoid G28 output for safe machine retracts. When disabled, you must manually ensure safe retracts.",
    group: groupNames[7],
    type: "boolean" },
  useM6: {
    title: "Use M6",
    description: "Disable to avoid outputting M6. If disabled Preload is also disabled",
    group: groupNames[7],
    type: "boolean" },
  showSequenceNumbers: {
    title: "Use sequence numbers",
    description: "Use sequence numbers for each block of outputted code.",
    group: groupNames[5],
    type: "boolean" },
  preloadTool: {
    title: "Preload tool - Unsupported",
    description: "Preloads the next tool at a tool change (if any).",
    group: groupNames[7],
    type: "boolean" },
  optionalStop: {
    title: "Optional stop. Uncheck in multi-tool Ops.",
    description: "Bad idea! Outputs optional stop code during when necessary in the code. It stops GCode execution in RepRap firmware",
    group: groupNames[7],
    type: "boolean" },
  useRadius: {
    title: "Radius arcs",
    description: "If yes is selected, arcs are outputted using radius values rather than IJK.",
    group: groupNames[4],
    type: "boolean" },
  dwellInSeconds: {
    title: "Dwell in seconds (Keep checked)",
    description: "Specifies the unit for dwelling, set to 'Yes' for seconds and 'No' for milliseconds.",
     group: groupNames[4],
     type: "boolean" },
  useDustCollector: {
    title: "Use dust collector",
    description: "Specifies if M7 and M9 are output for the dust collector.",
    group: groupNames[4],
    type: "boolean" },
  useRigidTapping: {
    title: "Use rigid tapping",
    description: "Select 'Yes' to enable, 'No' to disable, or 'Without spindle direction' to enable rigid tapping without outputting the spindle direction block.",
    group: groupNames[4],
    type: "enum",
    values: [
      { title: "Yes", id: "yes" },
      { title: "No", id: "no" },
      { title: "Without spindle direction", id: "without" }
    ]
  },

  applyBacklashCompensation: {
    title: "Apply Backlash Compensation",
    description: "Compensate for backlash in motion motor direction changes",
    group: groupNames[8],
    type: "boolean"
  },
  measuredBacklashXFor1mm:{
    title: "X axis measured backlash for 1mm",
    description: "The amount of measured error that the backlash causes in 1mm motion on X axis change of direction. In other words how much boost the motion requirs to sit on its intended place on change of direction",
    group: groupNames[8],
    type: "number"
  },
  measuredBacklashXFor10mm:{
    title: "X axis measured backlash for 10mm",
    description: "The amount of measured error that the backlash causes in 10mm motion on X axis change of direction. In other words how much boost the motion requirs to sit on its intended place on change of direction",
    group: groupNames[8],
    type: "number"
  },
  measuredBacklashYFor1mm:{
    title: "Y axis measured backlash for 1mm",
    description: "The amount of measured error that the backlash causes in 1mm motion on Y axis change of direction. In other words how much boost the motion requirs to sit on its intended place on change of direction",
    group: groupNames[8],
    type: "number"
  },
  measuredBacklashYFor10mm:{
    title: "Y axis measured backlash for 10mm",
    description: "The amount of measured error that the backlash causes in 10mm motion on Y axis change of direction. In other words how much boost the motion requirs to sit on its intended place on change of direction",
    group: groupNames[8],
    type: "number"
  },
  measuredBacklashZFor1mm:{
    title: "Z axis measured backlash for 1mm",
    description: "The amount of measured error that the backlash causes in 1mm motion on Z axis change of direction. In other words how much boost the motion requirs to sit on its intended place on change of direction",
    group: groupNames[8],
    type: "number"
  },
  measuredBacklashZFor10mm:{
    title: "Z axis measured backlash for 1mm",
    description: "The amount of measured error that the backlash causes in 10mm motion on Z axis change of direction. In other words how much boost the motion requirs to sit on its intended place on change of direction",
    group: groupNames[8],
    type: "number"
  },
  emptyAccumulatedCompensationError: {
    title: "Flush accumulated Compensation error on start of each operation",
    description: "Flushes accumulated Compensation error on start of each operation by restarting from WCS",
    group: groupNames[8],
    type: "boolean"
  },
  bCompensationCount: {
    title: "Flush accumulated compensation on interval",
    description: "Flush accumulated compensation on interval",
    group: groupNames[8],
    type: "enum",
    values: [
      {title: "None", id: "0"},
      {title: "Every 500 moves", id: "500"},
      {title: "Every 1000 moves", id: "1000"}
    ]
  },
  spindleRPMCatchupTime6K: {
    title: "Spindle RPM catch up time for 6K (in sec.)",
    description: "How many seconds does the Spindle motor need to catch up from 0 to 6000. Determines time needed for all other speeds as well. For example if catch-up time for 6000 (6K) is 15 seconds, it will be 30 seconds for 12000 and 7.5 for 3000 and so forth.",
    group: groupNames[1],
    type: "integer"
  }
};

// samples:
// throughTool: {on: 88, off: 89}
// throughTool: {on: [8, 88], off: [9, 89]}
  extension = properties.printType + ".gcode";
var coolants = {
  flood: { on: 8 },
  mist: { on: 7 },
  throughTool: { on: 8 },
  air: { on: 7 },
  airThroughTool: { on: 8 },
  suction: { on: 8 },
  floodMist: {},
  floodThroughTool: {},
  off: 9
};

var bWCS = properties.useWhichWCS; // keeps track of WCS RepRap Gcode number (54 to 59.3)
var bZProbe = {
  thickness: Number(properties.probeZThickness), // in z axis and in milimiters
  safeInside: 5, // how much of a square can tool go inside on the probe to avoid touching very conrner
  retract: Number(properties.probeZRetract) // distance tools go away to release the probe when they're done with it
};
var bCompensation = {
  x1: Number(properties.measuredBacklashXFor1mm),
  y1: Number(properties.measuredBacklashYFor1mm),
  z1: Number(properties.measuredBacklashZFor1mm),
  x10: Number(properties.measuredBacklashXFor10mm),
  y10: Number(properties.measuredBacklashYFor10mm),
  z10: Number(properties.measuredBacklashZFor10mm),
  firstTime: [true, true, true], // for x, y, z
  firstMove: [true, true, true],
  lastRequestedPosition: [0, 0, 0],
  lastFeed: 0,
  oldPos: [0, 0, 0],
  lastDir: ["none", "none", "none"],
  axis: "none",
  isFirstTime: function (axis) {
      if (this.firstTime[axis]) {
        this.firstTime[axis] = false;
        return true;
      } else {
        return false ;}
      },
  isFirstMove: function (axis) {
      if (this.firstMove[axis]) {
        this.firstMove[axis] = false;
        return true;
      } else {
        return false ;}
      },
  x : function() {
    return (this.x1 >0 || this.x10>0);
    },
  y : function() {
    return (this.y1 >0 || this.y10>0);
    },
  z : function() {
      return (this.z1 >0 || this.z10>0);
    },
 motionCounter: 0
};
var motionBox = {
  // x:[0,0], // min, max
  // y:[0,0],
  // z:[0,0],
  mBox: [
    [0, 0],
    [0, 0],
    [0, 0]
  ],
  setBox: function (axis, _value) {
    // setting minimum
    if (_value < this.mBox[axis][0]) {
      this.mBox[axis][0] = _value;
    } else if (_value > this.mBox[axis][1]) {  // setting maximum
      this.mBox[axis][1] = _value;
    }
  }, // setter Ends
  getBox: function () {
    var boxText="";
    for (i=0; i>3; i++) {
      boxText += (";["+this.mBox[i][0]+" "+this.mBox[i][1]+"]");
    }
    return boxText;
  }
}
var bTool = {
  name: "",
  rpm: 0,
  dir: 3,
  lastRpm: 0,
  lastDir: 3,
  diameter: 0,
  flute: 0
}
var permittedCommentChars = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,=_->";
var nFormat = createFormat({ prefix: "N", decimals: 0 });
var gFormat = createFormat({ prefix: "G", decimals: 1 });
var mFormat = createFormat({ prefix: "M", decimals: 0 });
var hFormat = createFormat({ prefix: "H", decimals: 0 });
var pFormat = createFormat({ prefix: "P", decimals: (unit == MM ? 3 : 4), scale: 0.5 });
var xyzFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: false });
var rFormat = xyzFormat; // radius
var abcFormat = createFormat({ decimals: 3, forceDecimal: false, scale: DEG });
var feedFormat = createFormat({ decimals: (unit == MM ? 0 : 1), forceDecimal: false });
var toolFormat = createFormat({ decimals: 0 });
var rpmFormat = createFormat({ decimals: 0 });
var secFormat = createFormat({ decimals: 3, forceDecimal: false }); // seconds - range 0.001-99999.999
var milliFormat = createFormat({ decimals: 0 }); // milliseconds // range 1-9999
var taperFormat = createFormat({ decimals: 1, scale: DEG });

var xOutput = createVariable({ prefix: "X" }, xyzFormat);
var yOutput = createVariable({ prefix: "Y" }, xyzFormat);
var zOutput = createVariable({ onchange: function () { retracted = false; }, prefix: "Z" }, xyzFormat);
var aOutput = createVariable({ prefix: "A" }, abcFormat);
var bOutput = createVariable({ prefix: "B" }, abcFormat);
var cOutput = createVariable({ prefix: "C" }, abcFormat);
var feedOutput = createVariable({ prefix: "F", force: false }, feedFormat);
var sOutput = createVariable({ prefix: "S", force: false }, rpmFormat);
var pOutput = createVariable({}, pFormat);

// circular output
var iOutput = createReferenceVariable({ prefix: "I", force: false }, xyzFormat);
var jOutput = createReferenceVariable({ prefix: "J", force: false }, xyzFormat);
var kOutput = createReferenceVariable({ prefix: "K", force: false }, xyzFormat);

var gMotionModal = createModal({ force: true }, gFormat); // modal group 1 // G0-G3, ...
var gPlaneModal = createModal({ onchange: function () { gMotionModal.reset(); } }, gFormat); // modal group 2 // G17-19
var gAbsIncModal = createModal({}, gFormat); // modal group 3 // G90-91
var gFeedModeModal = createModal({}, gFormat); // modal group 5 // G93-94
var gUnitModal = createModal({}, gFormat); // modal group 6 // G20-21
var gCycleModal = createModal({}, gFormat); // modal group 9 // G81, ...
var gRetractModal = createModal({}, gFormat); // modal group 10 // G98-99

var WARNING_WORK_OFFSET = 0;

// collected state
var sequenceNumber;
var currentWorkOffset;
var retracted = false; // specifies that the tool has been retracted to the safe plane
var isRpmChanged = false; // will be true if RPM or Direction changes - It's true for the first time is RPM changes from 0
/**
  Writes the specified block.
*/
function writeBlock() {
  var text = formatWords(arguments);
  if (!text) {
    return;
  }
  if (properties.showSequenceNumbers) {
    writeWords2(nFormat.format(sequenceNumber % 100000), arguments);
    sequenceNumber += properties.sequenceNumberIncrement;
  } else {
    writeWords(arguments);
  }
}

/**
  Output a comment.
*/
function writeComment(text) {
  writeln(";" + filterText(String(text).toUpperCase(), permittedCommentChars));
}

function onOpen() {
  if (properties.useRadius) {
    maximumCircularSweep = toRad(90); // avoid potential center calculation errors for CNC
    writeComment("This is an output of "+longDescription);
    writeComment("This is prepared to be used on "+properties.printType);
    setupBacklashCompensation();
  }

  if (false) {
    var aAxis = createAxis({ coordinate: 0, table: true, axis: [-1, 0, 0], cyclic: true, preference: 1 });
    machineConfiguration = new MachineConfiguration(aAxis);

    setMachineConfiguration(machineConfiguration);
    optimizeMachineAngles2(1); // map tip mode
  }

  if (!machineConfiguration.isMachineCoordinate(0)) {
    aOutput.disable();
  }
  if (!machineConfiguration.isMachineCoordinate(1)) {
    bOutput.disable();
  }
  if (!machineConfiguration.isMachineCoordinate(2)) {
    cOutput.disable();
  }

  if (!properties.separateWordsWithSpace) {
    setWordSeparator("");
  }

  sequenceNumber = properties.sequenceNumberStart;

  if (programName) {
    writeln("");
    writeComment("Program Name: "+programName);
  }
  if (programComment) {
    write(";// ");
    writeComment(programComment);
  }

  //write program generation date and time
  let current_datetime = new Date();
  var date = current_datetime.getDate();
  var month = current_datetime.getMonth() + 1;
  var year = current_datetime.getFullYear();
  var hours = current_datetime.getHours();
  var minutes = current_datetime.getMinutes();
  var seconds = current_datetime.getSeconds();
  yearFormatted = year;
  monthFormatted = month < 10 ? "0" + month : month;
  dateFormatted = date < 10 ? "0" + date : date;
  hoursFormatted = hours < 10 ? "0" + hours : hours;
  minutesFormatted = minutes < 10 ? "0" + minutes : minutes;
  secondsFormatted = seconds < 10 ? "0" + seconds : seconds;
  writeComment("GCode created on" + yearFormatted + "-" + monthFormatted + "-" + dateFormatted + " at " + hoursFormatted + "-" + minutesFormatted + "-" + secondsFormatted);
  writeln("");

  if (properties.writeVersion) {
    writeComment(localize("About this post-processor:"));
    if ((typeof getHeaderVersion == "function") && getHeaderVersion()) {
      writeComment(localize("   post version") + ": " + getHeaderVersion());
    }
    if ((typeof getHeaderDate == "function") && getHeaderDate()) {
      writeComment(localize("   post modified") + ": " + getHeaderDate().replace(/:/g, "-"));
    }
    writeln("; - Generated for RepRap firmware 2.x running on Duet3D controller that works in CNC mode")
    writeln(";                 -------------------            ------                          --------");
  }

  // dump machine configuration
  var vendor = machineConfiguration.getVendor();
  var model = machineConfiguration.getModel();
  var description = machineConfiguration.getDescription();

  if (properties.writeMachine && (vendor || model || description)) {
    writeComment(localize("Machine this post is generated for:"));
    if (vendor) {
      writeComment("  " + localize("vendor") + ": " + vendor);
    }
    if (model) {
      writeComment("  " + localize("model") + ": " + model);
    }
    if (description) {
      writeComment("  " + localize("description") + ": " + description);
    }
  }

  // dump tool information
  if (properties.writeTools) {
    writeComment("List of tools in this program");
    var zRanges = {};
    if (is3D()) {
      var numberOfSections = getNumberOfSections();
      for (var i = 0; i < numberOfSections; ++i) {
        var section = getSection(i);
        var zRange = section.getGlobalZRange();
        var tool = section.getTool();
        if (zRanges[tool.number]) {
          zRanges[tool.number].expandToRange(zRange);
        } else {
          zRanges[tool.number] = zRange;
        }
      }
    }

    var tools = getToolTable();
    if (tools.getNumberOfTools() > 0) {
      for (var i = 0; i < tools.getNumberOfTools(); ++i) {
        var tool = tools.getTool(i);
        var comment = "   "+"T" + toolFormat.format(tool.number) + "  " +
          "D=" + xyzFormat.format(tool.diameter) + " " +
          localize("CR") + "=" + xyzFormat.format(tool.cornerRadius);
        if ((tool.taperAngle > 0) && (tool.taperAngle < Math.PI)) {
          comment += " " + localize("TAPER") + "=" + taperFormat.format(tool.taperAngle) + localize("deg");
        }
        if (zRanges[tool.number]) {
          comment += " - " + localize("Z-MIN") + "=" + xyzFormat.format(zRanges[tool.number].getMinimum());
        }
        comment += " - " + getToolTypeName(tool.type);
        writeComment(comment);
        if (properties.applyBacklashCompensation) {
          writeln("; Backlash Compensation is ON and can affect tools motion boxs.");
          writeln("; - Check the actual Min/Max at the bottom of this program. (scroll all the way down)")
        }
      }
    }
  }
  // write tools ENDS
  writeln("");
  writeln("; -+- Program begins here -+-");
  if (false) {
    // check for duplicate tool number
    for (var i = 0; i < getNumberOfSections(); ++i) {
      var sectioni = getSection(i);
      var tooli = sectioni.getTool();
      for (var j = i + 1; j < getNumberOfSections(); ++j) {
        var sectionj = getSection(j);
        var toolj = sectionj.getTool();
        if (tooli.number == toolj.number) {
          if (xyzFormat.areDifferent(tooli.diameter, toolj.diameter) ||
            xyzFormat.areDifferent(tooli.cornerRadius, toolj.cornerRadius) ||
            abcFormat.areDifferent(tooli.taperAngle, toolj.taperAngle) ||
            (tooli.numberOfFlutes != toolj.numberOfFlutes)) {
            error(
              subst(
                localize("Using the same tool number for different cutter geometry for operation '%1' and '%2'."),
                sectioni.hasParameter("operation-comment") ? sectioni.getParameter("operation-comment") : ("#" + (i + 1)),
                sectionj.hasParameter("operation-comment") ? sectionj.getParameter("operation-comment") : ("#" + (j + 1))
              )
            );
            return;
          }
        }
      }
    }
  }

  if ((getNumberOfSections() > 0) && (getSection(0).workOffset == 0)) {
    for (var i = 0; i < getNumberOfSections(); ++i) {
      if (getSection(i).workOffset > 0) {
        error(localize("Using multiple work offsets is not possible if the initial work offset is 0."));
        return;
      }
    }
  }
  // print caution message
  bCautious();
  // setting WCS9 for tool change if not preset
  bWCS9 ();
  // absolute coordinates and feed per min
  writeBlock(gAbsIncModal.format(90));
  // movement units - Keep milimiters for the best results
  switch (unit) {
    case IN:
      writeBlock(gUnitModal.format(20));
      break;
    case MM:
      writeBlock(gUnitModal.format(21));
      break;
  }
  // dust collector is not in use. If got a controlled one, uncomment below
  // if (properties.useDustCollector) {
  // writeBlock(mFormat.format(7)); // turns on dust collector
  // }
}

function onComment(message) {
  var comments = String(message).split(";");
  for (comment in comments) {
    writeComment(comments[comment]);
  }
}

/** Force output of X, Y, and Z. */
function forceXYZ() {
  xOutput.reset();
  yOutput.reset();
  zOutput.reset();
}

/** Force output of A, B, and C. */
function forceABC() {
  aOutput.reset();
  bOutput.reset();
  cOutput.reset();
}

/** Force output of X, Y, Z, A, B, C, and F on next output. */
function forceAny() {
  forceXYZ();
  forceABC();
  feedOutput.reset();
}

var currentWorkPlaneABC = undefined;

function forceWorkPlane() {
  currentWorkPlaneABC = undefined;
}

function setWorkPlane(abc) {
  if (!machineConfiguration.isMultiAxisConfiguration()) {
    return; // ignore
  }

  if (!((currentWorkPlaneABC == undefined) ||
    abcFormat.areDifferent(abc.x, currentWorkPlaneABC.x) ||
    abcFormat.areDifferent(abc.y, currentWorkPlaneABC.y) ||
    abcFormat.areDifferent(abc.z, currentWorkPlaneABC.z))) {
    return; // no change
  }

  onCommand(COMMAND_UNLOCK_MULTI_AXIS);

  if (!retracted) {
    writeRetract(Z);
  }

  writeBlock(
    gMotionModal.format(0),
    conditional(machineConfiguration.isMachineCoordinate(0), "A" + abcFormat.format(abc.x)),
    conditional(machineConfiguration.isMachineCoordinate(1), "B" + abcFormat.format(abc.y)),
    conditional(machineConfiguration.isMachineCoordinate(2), "C" + abcFormat.format(abc.z))
  );

  onCommand(COMMAND_LOCK_MULTI_AXIS);

  currentWorkPlaneABC = abc;
}

var closestABC = false; // choose closest machine angles
var currentMachineABC;

function getWorkPlaneMachineABC(workPlane) {
  var W = workPlane; // map to global frame

  var abc = machineConfiguration.getABC(W);
  if (closestABC) {
    if (currentMachineABC) {
      abc = machineConfiguration.remapToABC(abc, currentMachineABC);
    } else {
      abc = machineConfiguration.getPreferredABC(abc);
    }
  } else {
    abc = machineConfiguration.getPreferredABC(abc);
  }

  try {
    abc = machineConfiguration.remapABC(abc);
    currentMachineABC = abc;
  } catch (e) {
    error(
      localize("Machine angles not supported") + ":"
      + conditional(machineConfiguration.isMachineCoordinate(0), " A" + abcFormat.format(abc.x))
      + conditional(machineConfiguration.isMachineCoordinate(1), " B" + abcFormat.format(abc.y))
      + conditional(machineConfiguration.isMachineCoordinate(2), " C" + abcFormat.format(abc.z))
    );
  }

  var direction = machineConfiguration.getDirection(abc);
  if (!isSameDirection(direction, W.forward)) {
    error(localize("Orientation not supported."));
  }

  if (!machineConfiguration.isABCSupported(abc)) {
    error(
      localize("Work plane is not supported") + ":"
      + conditional(machineConfiguration.isMachineCoordinate(0), " A" + abcFormat.format(abc.x))
      + conditional(machineConfiguration.isMachineCoordinate(1), " B" + abcFormat.format(abc.y))
      + conditional(machineConfiguration.isMachineCoordinate(2), " C" + abcFormat.format(abc.z))
    );
  }

  var tcp = true;
  if (tcp) {
    setRotation(W); // TCP mode
  } else {
    var O = machineConfiguration.getOrientation(abc);
    var R = machineConfiguration.getRemainingOrientation(abc, W);
    setRotation(R);
  }

  return abc;
}

function isProbeOperation() {
  return hasParameter("operation-strategy") && (getParameter("operation-strategy") == "probe");
}

function onSection() {
  // if corner probing is requested on start
  if (isFirstSection() && properties.probe3dOnStart) {
    bCornerProbeBlock(bGetWorkOffset(getSection(0).workOffset));
  }

  var insertToolCall = isFirstSection() ||
    currentSection.getForceToolChange && currentSection.getForceToolChange() ||
    (tool.number != getPreviousSection().getTool().number);

  retracted = false;
  var newWorkOffset = isFirstSection() ||
    (getPreviousSection().workOffset != currentSection.workOffset); // work offset changes
  var newWorkPlane = isFirstSection() ||
    !isSameDirection(getPreviousSection().getGlobalFinalToolAxis(), currentSection.getGlobalInitialToolAxis()) ||
    (currentSection.isOptimizedForMachine() && getPreviousSection().isOptimizedForMachine() &&
      Vector.diff(getPreviousSection().getFinalToolAxisABC(), currentSection.getInitialToolAxisABC()).length > 1e-4) ||
    (!machineConfiguration.isMultiAxisConfiguration() && currentSection.isMultiAxis()) ||
    (!getPreviousSection().isMultiAxis() && currentSection.isMultiAxis() ||
      getPreviousSection().isMultiAxis() && !currentSection.isMultiAxis()); // force newWorkPlane between indexing and simultaneous operations
  if (insertToolCall || newWorkOffset || newWorkPlane) {

    if (properties.useG28) {
      // retract to safe plane
      writeBlock(gFormat.format(28), gAbsIncModal.format(91), "Z" + xyzFormat.format(0)); // retract
      writeBlock(gAbsIncModal.format(90));
      zOutput.reset();
    }
  }

  writeln("");

  if (hasParameter("operation-comment")) {
    var comment = getParameter("operation-comment");
    if (comment) {
      bDialog ("Now operating: "+comment , "CURRENT OPERATION", 0, false)
      writeComment("TITLE-> Operation "+ comment+"");
    }
  }
  if (properties.emptyAccumulatedCompensationError && !insertToolCall) {
    // restart each operationn from WCS to reduce the risk of accumulation
    bFlushAccumulatedCompensationError();
  }

  if (insertToolCall) {
    forceWorkPlane();

    onCommand(COMMAND_STOP_SPINDLE);
    if (!properties.useDustCollector) {
      setCoolant(COOLANT_OFF);
    }

    // using optional stop (M1) is a bad idea for multi-tools, it stops the whole process and jumps out of the gcode. Uncomment if needed
    //if (!isFirstSection() && properties.optionalStop) {
      // onCommand(COMMAND_OPTIONAL_STOP);
    //}

    if (tool.number > 256) {
      warning(localize("Tool number exceeds maximum value."));
    }

    if (properties.useM6) {
      writeBlock("T" + toolFormat.format(tool.number), mFormat.format(6));
    } else {
      writeBlock("T" + toolFormat.format(tool.number));
    }

    if (properties.manualToolChange) {
      bManualToolChangeRoutine (currentSection.workOffset);
    }

    if (properties.homeOnToolChange) {
      writeBlock(gFormat.format(28));
    }

    // this is not needed because we do sophisticated probing
    // if (properties.probeToolOnChange) {
    //   //writeBlock(mFormat.format(98) + " P\"/macros/Tool Probe Auto\"");
    // }

    if (tool.comment) {
      writeComment(tool.comment);
    }
    var showToolZMin = false;
    if (showToolZMin) {
      if (is3D()) {
        var numberOfSections = getNumberOfSections();
        var zRange = currentSection.getGlobalZRange();
        var number = tool.number;
        for (var i = currentSection.getId() + 1; i < numberOfSections; ++i) {
          var section = getSection(i);
          if (section.getTool().number != number) {
            break;
          }
          zRange.expandToRange(section.getGlobalZRange());
        }
        writeComment(localize("ZMIN") + "=" + zRange.getMinimum());
      }
    }

    if (properties.preloadTool && properties.useM6) {
      var nextTool = getNextTool(tool.number);
      if (nextTool) {
        writeBlock("T" + toolFormat.format(nextTool.number));
      } else {
        // preload first tool
        var section = getSection(0);
        var firstToolNumber = section.getTool().number;
        if (tool.number != firstToolNumber) {
          writeBlock("T" + toolFormat.format(firstToolNumber));
        }
      }
    }
  }

// rpm change and spindle catchup handeler
// my strategy is to always output M3/M4 with S(rpm) parameter indicated even if its unchanged
  isRpmChanged = ((rpmFormat.areDifferent(tool.spindleRPM, sOutput.getCurrent())) ||  (tool.clockwise != getPreviousSection().getTool().clockwise));
  var bRprmChangeCheck = false;
  var catchupTimeMultiplier = 1;
  // series of checks to determine spindle state
  bTool.dir = (tool.clockwise ? 3 : 4); // determines current direction
  if ((insertToolCall || isFirstSection() || isRpmChanged)) bRprmChangeCheck = true;
  if (bTool.lastRpm == tool.spindleRPM && bTool.lastDir == bTool.dir) {
    bRprmChangeCheck = false;
    // no change in rpm or direction
  } else {
    bRprmChangeCheck = true;
    // either direction or rpm is changed
    if (bTool.lastDir != bTool.dir && bTool.lastRpm != 0) {
      // updating last direction recodr for the next use
      bTool.lastDir = bTool.dir;
      // since the spindle direction is changed the catchup time is doubled
      catchupTimeMultiplier = 2;
    }
  }
  if (bRprmChangeCheck) {
    // this block runs only if a change is detected
    // checking rpm validity
    if (tool.spindleRPM < 1) {
      error(localize("Spindle speed out of range."));
      return;
    }
    if (tool.spindleRPM > 99999) {
      warning(localize("Spindle speed exceeds maximum value."));
    }
    // if we are here change is accepted to go ahead

    // determing if we are tapping so no catchup in that case
    var tapping = hasParameter("operation:cycleType") &&
      ((getParameter("operation:cycleType") == "tapping") ||
        (getParameter("operation:cycleType") == "right-tapping") ||
        (getParameter("operation:cycleType") == "left-tapping") ||
        (getParameter("operation:cycleType") == "tapping-with-chip-breaking"));
        if (!tapping || (tapping && !(properties.useRigidTapping == "without"))) {
          // either not tapping or tapping with options`
          // output spindle + speed command (ie M3 S10000)
          writeBlock(mFormat.format(bTool.dir), "S"+parseInt(tool.spindleRPM));
          // handelling dwell for catchup
          // dwell for spindle rpm to settle (30Second for each 12000rpm - Min 5 sec)
          // but only dwell if RPM or direction is changed
          if (parseInt(bTool.lastRpm) != parseInt(tool.spindleRPM)) {
            // rpms are different
            var rpmDiff = parseInt(Math.abs(bTool.lastRpm - tool.spindleRPM));
            // updating the last rpm value for the next use
            bTool.lastRpm = parseInt(tool.spindleRPM);
            // calculating required dwell duration
            var bruceDwellSec = secFormat.format(rpmDiff * Number(properties.spindleRPMCatchupTime6K) / 6000);
            bruceDwellSec *= catchupTimeMultiplier;
            var toMilli = 1;
            if (properties.dwellInSeconds) {
              // system is set to milliseconds
              toMilli = 1000;
            } else {
              toMilli = 1;
            }
            if (bruceDwellSec < 5) {
              bruceDwellSec = 5;
            }
            writeComment("LOGGING-> Dwelling for Spindle RPM change to catchup");
            bDialog("Dwelling for "+bruceDwellSec+" seconds, for the spindle RPM to catch up", "Dwelling "+programName, 100+bruceDwellSec, false);
            // breaking dwell in smaller chunks if longer than 20 seconds to keep RepRap happy :)
            if (bruceDwellSec > 20) {
              while (bruceDwellSec > 15) {
                  onDwell(15*toMilli);
                  writeBlock("M450 ;LOGGING-> Here used as a harmless stalling command that reports status");
                  bruceDwellSec = parseInt(Number(bruceDwellSec)-15);
              }
            }
            if (parseInt(bruceDwellSec) > 1) {
                onDwell(bruceDwellSec*toMilli);
            }
          }
        } // if not tapping
  } // bRprmChangeCheck

  // getting wcs
  if (insertToolCall) { // force work offset when changing tool
    currentWorkOffset = undefined;
  }
  var workOffset = bGetWorkOffset(currentSection.workOffset);
  currentWorkOffset = bSetAndPrintCurrentWorkOffset (workOffset, currentWorkOffset);

  forceXYZ();
  if (machineConfiguration.isMultiAxisConfiguration()) { // use 5-axis indexing for multi-axis mode
    // set working plane after datum shift

    var abc = new Vector(0, 0, 0);
    if (currentSection.isMultiAxis()) {
      forceWorkPlane();
      cancelTransformation();
    } else {
      abc = getWorkPlaneMachineABC(currentSection.workPlane);
    }
    setWorkPlane(abc);
  } else { // pure 3D
    var remaining = currentSection.workPlane;
    if (!isSameDirection(remaining.forward, new Vector(0, 0, 1))) {
      error(localize("Tool orientation is not supported."));
      return;
    }
    setRotation(remaining);
  }

  // set coolant after we have positioned at Z
  if (!properties.useDustCollector) {
    setCoolant(tool.coolant);
  }

  forceAny();
  gMotionModal.reset();

  var initialPosition = getFramePosition(currentSection.getInitialPosition());
  if (!retracted && !insertToolCall) {
    if (getCurrentPosition().z < initialPosition.z) {
      writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
    }
  }

  if (insertToolCall || retracted) {
    var lengthOffset = tool.lengthOffset;
    if (lengthOffset > 256) {
      error(localize("Length offset out of range."));
      return;
    }

    gMotionModal.reset();
    //writeBlock(gPlaneModal.format(17));

    if (!machineConfiguration.isHeadConfiguration()) {
      writeBlock(
        gAbsIncModal.format(90),
        gMotionModal.format(0), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y)
      );
      writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
    } else {
      writeBlock(
        gAbsIncModal.format(90),
        gMotionModal.format(0),
        gFormat.format(43), xOutput.format(initialPosition.x),
        yOutput.format(initialPosition.y),
        zOutput.format(initialPosition.z), hFormat.format(lengthOffset)
      );
    }
  } else {
    writeBlock(
      gAbsIncModal.format(90),
      gMotionModal.format(0),
      xOutput.format(initialPosition.x),
      yOutput.format(initialPosition.y)
    );
  }
}

function onDwell(seconds) {
  if (seconds > 90000) {
    warning(localize("Dwelling time is way too long."));
  }
  if (properties.dwellInSeconds) {
    writeBlock(gFormat.format(4), "P" + secFormat.format(seconds));
  } else {
    milliseconds = clamp(1, seconds * 1000, 20000);
    writeBlock(gFormat.format(4), "P" + milliFormat.format(milliseconds));
  }
}

function onSpindleSpeed(spindleSpeed) {
  writeBlock(sOutput.format(spindleSpeed));
  writeBlock(gFormat.format(4), "P" + milliFormat.format(15000));
  writeBlock(gFormat.format(4), "P" + milliFormat.format(15000));
}


var pendingRadiusCompensation = -1;

function onRadiusCompensation() {
  pendingRadiusCompensation = radiusCompensation;
}

function onRapid(_x, _y, _z) {
  // var x = xOutput.format(_x);
  // var y = yOutput.format(_y);
  // var z = zOutput.format(_z);
  bflushAcCompErPerMotionCount();
  var x = xOutput.format(axialBacklashCompensation(0,_x));
  var y = yOutput.format(axialBacklashCompensation(1,_y));
  var z = zOutput.format(axialBacklashCompensation(2,_z));
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      error(localize("Radius compensation mode cannot be changed at rapid traversal."));
      return;
    }
    writeBlock(gMotionModal.format(0), x, y, z);
    feedOutput.reset();
  }
}

function onLinear(_x, _y, _z, feed) {
  // var x = xOutput.format(_x);
  // var y = yOutput.format(_y);
  // var z = zOutput.format(_z);
  bflushAcCompErPerMotionCount();
  var x = xOutput.format(axialBacklashCompensation(0,_x));
  var y = yOutput.format(axialBacklashCompensation(1,_y));
  var z = zOutput.format(axialBacklashCompensation(2,_z));
  var f = feedOutput.format(feed);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      //writeBlock(gPlaneModal.format(17));
      switch (radiusCompensation) {
        case RADIUS_COMPENSATION_LEFT:
          pOutput.reset();
          writeBlock(gMotionModal.format(1), pOutput.format(tool.diameter), gFormat.format(41), x, y, z, f);
          break;
        case RADIUS_COMPENSATION_RIGHT:
          pOutput.reset();
          writeBlock(gMotionModal.format(1), pOutput.format(tool.diameter), gFormat.format(42), x, y, z, f);
          break;
        default:
          writeBlock(gMotionModal.format(1), gFormat.format(40), x, y, z, f);
      }
    } else {
      writeBlock(gMotionModal.format(1), x, y, z, f);
    }
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      feedOutput.reset(); // force feed on next line
    } else {
      writeBlock(gMotionModal.format(1), f);
    }
  }
}

function onRapid5D(_x, _y, _z, _a, _b, _c) {
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("This post configuration has not been customized for 5-axis simultaneous toolpath."));
    return;
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation mode cannot be changed at rapid traversal."));
    return;
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var a = aOutput.format(_a);
  var b = bOutput.format(_b);
  var c = cOutput.format(_c);
  writeBlock(gMotionModal.format(0), x, y, z, a, b, c);
  feedOutput.reset();
}

function onLinear5D(_x, _y, _z, _a, _b, _c, feed) {
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("This post configuration has not been customized for 5-axis simultaneous toolpath."));
    return;
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for 5-axis move."));
    return;
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var a = aOutput.format(_a);
  var b = bOutput.format(_b);
  var c = cOutput.format(_c);
  var f = feedOutput.format(feed);
  if (x || y || z || a || b || c) {
    writeBlock(gMotionModal.format(1), x, y, z, a, b, c, f);
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      feedOutput.reset(); // force feed on next line
    } else {
      writeBlock(gMotionModal.format(1), f);
    }
  }
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
    return;
  }

  var start = getCurrentPosition();

  if (isFullCircle()) {
    if (properties.useRadius || isHelical()) { // radius mode does not support full arcs
      linearize(tolerance);
      return;
    }
    switch (getCircularPlane()) {
      case PLANE_XY:
        writeBlock(gAbsIncModal.format(90), gMotionModal.format(clockwise ? 2 : 3), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), feedOutput.format(feed));
        break;
      // case PLANE_ZX:
      // writeBlock(gAbsIncModal.format(90), gPlaneModal.format(18), gMotionModal.format(clockwise ? 2 : 3), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), feedOutput.format(feed));
      // break;
      // case PLANE_YZ:
      // writeBlock(gAbsIncModal.format(90), gPlaneModal.format(19), gMotionModal.format(clockwise ? 2 : 3), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), feedOutput.format(feed));
      // break;
      default:
        linearize(tolerance);
    }
  } else if (!properties.useRadius) {
    switch (getCircularPlane()) {
      case PLANE_XY:
        writeBlock(gAbsIncModal.format(90), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), feedOutput.format(feed));
        break;
      // case PLANE_ZX:
      // writeBlock(gAbsIncModal.format(90), gPlaneModal.format(18), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), feedOutput.format(feed));
      // break;
      // case PLANE_YZ:
      // writeBlock(gAbsIncModal.format(90), gPlaneModal.format(19), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), feedOutput.format(feed));
      // break;
      default:
        linearize(tolerance);
    }
  } else { // use radius mode
    var r = getCircularRadius();
    if (toDeg(getCircularSweep()) > (180 + 1e-9)) {
      r = -r; // allow up to <360 deg arcs
    }
    switch (getCircularPlane()) {
      case PLANE_XY:
        writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), feedOutput.format(feed));
        break;
      // case PLANE_ZX:
      // writeBlock(gPlaneModal.format(18), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), feedOutput.format(feed));
      // break;
      // case PLANE_YZ:
      // writeBlock(gPlaneModal.format(19), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), feedOutput.format(feed));
      // break;
      default:
        linearize(tolerance);
    }
  }
}

var currentCoolantMode = undefined;
var coolantOff = undefined;

function setCoolant(coolant) {
  var coolantCodes = getCoolantCodes(coolant);
  if (Array.isArray(coolantCodes)) {
    for (var c in coolantCodes) {
      //writeBlock(coolantCodes[c]);
    }
    return undefined;
  }
  return coolantCodes;
}

function getCoolantCodes(coolant) {
  if (!coolants) {
    error(localize("Coolants have not been defined."));
  }
  if (!coolantOff) { // use the default coolant off command when an 'off' value is not specified for the previous coolant mode
    coolantOff = coolants.off;
  }

  if (isProbeOperation()) { // avoid coolant output for probing
    coolant = COOLANT_OFF;
  }

  if (coolant == currentCoolantMode) {
    return undefined; // coolant is already active
  }

  var multipleCoolantBlocks = new Array(); // create a formatted array to be passed into the outputted line
  if ((coolant != COOLANT_OFF) && (currentCoolantMode != COOLANT_OFF)) {
    multipleCoolantBlocks.push(mFormat.format(coolantOff));
  }

  var m;
  if (coolant == COOLANT_OFF) {
    m = coolantOff;
    coolantOff = coolants.off;
  }

  switch (coolant) {
    case COOLANT_FLOOD:
      if (!coolants.flood) {
        break;
      }
      m = coolants.flood.on;
      coolantOff = coolants.flood.off;
      break;
    case COOLANT_THROUGH_TOOL:
      if (!coolants.throughTool) {
        break;
      }
      m = coolants.throughTool.on;
      coolantOff = coolants.throughTool.off;
      break;
    case COOLANT_AIR:
      if (!coolants.air) {
        break;
      }
      m = coolants.air.on;
      coolantOff = coolants.air.off;
      break;
    case COOLANT_AIR_THROUGH_TOOL:
      if (!coolants.airThroughTool) {
        break;
      }
      m = coolants.airThroughTool.on;
      coolantOff = coolants.airThroughTool.off;
      break;
    case COOLANT_FLOOD_MIST:
      if (!coolants.floodMist) {
        break;
      }
      m = coolants.floodMist.on;
      coolantOff = coolants.floodMist.off;
      break;
    case COOLANT_MIST:
      if (!coolants.mist) {
        break;
      }
      m = coolants.mist.on;
      coolantOff = coolants.mist.off;
      break;
    case COOLANT_SUCTION:
      if (!coolants.suction) {
        break;
      }
      m = coolants.suction.on;
      coolantOff = coolants.suction.off;
      break;
    case COOLANT_FLOOD_THROUGH_TOOL:
      if (!coolants.floodThroughTool) {
        break;
      }
      m = coolants.floodThroughTool.on;
      coolantOff = coolants.floodThroughTool.off;
      break;
  }

  if (!m) {
    onUnsupportedCoolant(coolant);
    m = 9;
  }

  if (m) {
    if (Array.isArray(m)) {
      for (var i in m) {
        multipleCoolantBlocks.push(mFormat.format(m[i]));
      }
    } else {
      multipleCoolantBlocks.push(mFormat.format(m));
    }
    currentCoolantMode = coolant;
    return multipleCoolantBlocks; // return the single formatted coolant value
  }
  return undefined;
}

var mapCommand = {
  COMMAND_STOP: 0,
  COMMAND_OPTIONAL_STOP: 1,
  COMMAND_END: 2,
  COMMAND_SPINDLE_CLOCKWISE: 3,
  COMMAND_SPINDLE_COUNTERCLOCKWISE: 4,
  COMMAND_STOP_SPINDLE: 5,
  COMMAND_LOAD_TOOL: 6
};

function onCommand(command) {
  switch (command) {
    case COMMAND_START_SPINDLE:
      onCommand(tool.clockwise ? COMMAND_SPINDLE_CLOCKWISE : COMMAND_SPINDLE_COUNTERCLOCKWISE);
      return;
    case COMMAND_LOCK_MULTI_AXIS:
      return;
    case COMMAND_UNLOCK_MULTI_AXIS:
      return;
    case COMMAND_BREAK_CONTROL:
      return;
    case COMMAND_TOOL_MEASURE:
      return;
  }

  var stringId = getCommandStringId(command);
  var mcode = mapCommand[stringId];
  if (mcode != undefined) {
    writeBlock(mFormat.format(mcode));
  } else {
    onUnsupportedCommand(command);
  }
}

function onSectionEnd() {
  //writeBlock(gPlaneModal.format(17));

  if (((getCurrentSectionId() + 1) >= getNumberOfSections()) ||
    (tool.number != getNextSection().getTool().number)) {
    onCommand(COMMAND_BREAK_CONTROL);
  }

  forceAny();
}

/** Output block to do safe retract and/or move to home position. */
function writeRetract() {
  if (arguments.length == 0) {
    error(localize("No axis specified for writeRetract()."));
    return;
  }
  var words = []; // store all retracted axes in an array
  for (var i = 0; i < arguments.length; ++i) {
    let instances = 0; // checks for duplicate retract calls
    for (var j = 0; j < arguments.length; ++j) {
      if (arguments[i] == arguments[j]) {
        ++instances;
      }
    }
    if (instances > 1) { // error if there are multiple retract calls for the same axis
      error(localize("Cannot retract the same axis twice in one line"));
      return;
    }
    switch (arguments[i]) {
      case X:
        if (!machineConfiguration.hasHomePositionX()) {
          if (properties.useG28) {
            words.push("X" + xyzFormat.format(0));
          }
        } else {
          words.push("X" + xyzFormat.format(machineConfiguration.getHomePositionX()));
        }
        break;
      case Y:
        if (!machineConfiguration.hasHomePositionY()) {
          if (properties.useG28) {
            words.push("Y" + xyzFormat.format(0));
          }
        } else {
          words.push("Y" + xyzFormat.format(machineConfiguration.getHomePositionY()));
        }
        break;
      case Z:
        if (properties.useG28) {
          writeBlock(gFormat.format(28), gAbsIncModal.format(91), "Z" + xyzFormat.format(machineConfiguration.getRetractPlane()));
          writeBlock(gAbsIncModal.format(90));
          zOutput.reset();
        }
        retracted = properties.useG28; // specifies that the tool has been retracted to the safe plane
        break;
      default:
        error(localize("Bad axis specified for writeRetract()."));
        return;
    }
  }
  if (words.length > 0) {
    gMotionModal.reset();
    if (properties.useG28) {
      gAbsIncModal.reset();
      writeBlock(gFormat.format(28), gAbsIncModal.format(91), words); // retract
      writeBlock(gAbsIncModal.format(90));
    } else {
      writeBlock(gAbsIncModal.format(90), gFormat.format(53), gMotionModal.format(0), words);
    }
  }
}

function onClose() {
  writeln("");

  if (properties.useDustCollector) {
  writeBlock(mFormat.format(9)); // turns off dust collector
  } else {
  setCoolant(COOLANT_OFF);
  }

  writeRetract(Z);

  setWorkPlane(new Vector(0, 0, 0)); // reset working plane

  writeBlock(mFormat.format(tool.clockwise ? 3 : 4), sOutput.format(0));
  writeBlock(gFormat.format(4), "P" + milliFormat.format(10000));
  onImpliedCommand(COMMAND_STOP_SPINDLE);
  writeRetract(X, Y);

  onImpliedCommand(COMMAND_END);

  writeBlock(mFormat.format(5)); // stop program, spindle stop, coolant off

  bDialog ("ALL DONE!", "Programme End", 1, false);
  writeBlock("M0"); // flush out all operations in buffer to be preformed. No opt left unsent
  writeComment("All Ended");
  writeln ("; Tools motion box:");
  writeln ("; -----------------");
  writeln ("; axis: [min | max]");
  writeln ("; -----------------");
  writeln ("; on X: [min: "+motionBox.mBox[0][0]+" | max: "+motionBox.mBox[0][1]+"]");
  writeln ("; on Y: [min: "+motionBox.mBox[1][0]+" | max: "+motionBox.mBox[1][1]+"]");
  writeln ("; on Z: [min: "+motionBox.mBox[2][0]+" | max: "+motionBox.mBox[2][1]+"]");
  //motionBox.mBox();
}

function bCautious() {
  bDialog("SAFETY FIRST! Wear eye protection. Exercise extreme caution while changing tools.", "CAUTION!", 2, false);
  // writeBlock(mFormat.format(291) + " P\"SAFETY FIRST! Wear eye protection. Excercise extreme caution while changing tools.\" R\"CAUTION!\" S2");
  return;
}

function bBeep() {
  if (properties.beepOn) {
    writeBlock("M300");
  }
  return;
}

function bManualToolChangeRoutine () {
  //  By Bruce Royce for Jinni Tech JINNITECH
  if (isFirstSection()) {
      writeComment("LOGGING-> This is the 1st Tool - No change needed");
      writeComment("LOGGING-> First Tool should have been alreay loaded");
      bDialog("Tool: " + toolFormat.format(tool.number) + ", D:" + xyzFormat.format(tool.diameter), "First Tool Info!", 1, false);
  } else {
    writeComment("TITLE-> ---- TOOL CHANGE ROUTINE BEGINS ----");
    writeBlock("M5");
    writeBlock(gAbsIncModal.format(90));
    writeBlock("G60 S0");
    writeBlock("G59.3");
    writeBlock("G1 Z0 F200");
    bDialog("When Spindle stops clear the way to 'Tool Change Position'. Hit OK when ready", "Ready for Tool Change", 2, false);
    writeBlock("M400");
    writeBlock("G0 X0");
    writeBlock("M400");
    writeBlock("G0 Y0");
    bDialog("Tool: " + toolFormat.format(tool.number) + ", D:" + xyzFormat.format(tool.diameter), "Tool Change", 2, false);
    bDialog("Hands off the tool and spindel! Stay back!", "WARNING!", 0, false);
    writeBlock("G4 P3000");
    writeBlock("G0 R0 Y0");
    writeBlock("M400");
    writeBlock("G0 R0 X0");
    writeBlock("M400");
    writeBlock("G0 R0 Z0");
    if (properties.probeToolOnChange != "0") {
      if (properties.probeToolOnChange == "1") {
        bZProbeBlock(currentWorkOffset);
      } else {
        bCornerProbeBlock(currentWorkOffset);
      }
    }
    writeBlock(bWCS);
    writeComment("TITLE-> ---- TOOL CHANGE ROUTINE ENDS ----");
  }
  return;
}

function bWCS9 () {
  if (!properties.useWCS9AsToolChangeHome) {
    // set given values for tool change position
    writeComment("CHANGING-> Setting WCS9 to given values for tool change position");
    writeBlock("G10 L2 P9 X"+properties.toolChangeXPos+" Y"+properties.toolChangeYPos+" Z"+properties.toolChangeZPos);
  }
  return;
}

function bDialog (p,r,s,jog) {
  var jogT = "";
  if (jog != false) {
    jogT = " X1 Y1 Z1";
  }
  writeComment("DIALOGUEBOX-> On Screen message");
  if (s==0 || s==1) {
    jogT = " T5";
  }

  if (s>100) {
    if (s>120) s=120; // no more than 20 seconds message display
    jogT = " T"+(s-100);
    s=1; // with close message option
  }

  writeBlock(mFormat.format(291) + " P\""+ p +"\" R\""+ r +"\" S"+s + jogT);
  return;
}

function get3dProbeDirection() {
  let left2Right = 1;
  let south2Noth = 1;
  switch (properties.probe3DPlacement) {
    case "0":
    // bottom-left
      left2Right = 1;
      south2Noth = 1;
      break;
    case "1":
    // top-left
      left2Right = 1;
      south2Noth = -1;
      break;
    case "2":
      left2Right = -1;
      south2Noth = -1;
      break;
    case "3":
      left2Right = -1;
      south2Noth = 1;
    break;
  }
  let dir = [left2Right,south2Noth];
  return dir;
}

function get3dProbeMove(axis, type) {
  var thisValue = 10;
  var thisTractValue = 10;
  var flag = -1;
  var excess = 3; //milimiters
  var traXcess = 0;
  if (type != "probe") {
    if (type == "intetract") {
      flag = 1;
      traXcess = 5;
    }
  }

  let dir = get3dProbeDirection();
  switch (axis) {
    case "x":
        thisValue = (Number(properties.probe3DLength)+ excess) * dir[0];
        thisTractValue = (thisTractValue + traXcess) * dir[0];
        break;
    case "y":
        thisValue = (Number(properties.probe3DWidth) + excess) * dir[1];
        thisTractValue = (thisTractValue + traXcess) * dir[1];
        break;
    default:
        thisValue = (Number(properties.probe3DLength)+ excess) * dir[0];
        thisTractValue = (thisTractValue + traXcess) * dir[0];
  }

  if (type != "probe") {
    thisValue = thisTractValue;
  }
  thisValue *= flag;
  return thisValue;
}

function bCornerProbeBlock (currentWorkOffset) {
  writeComment("TITLE-> CORNER PROBE BEGINS --");
  var placement = Number(properties.probe3DPlacement);
  var toolDia = xyzFormat.format(tool.diameter);
  let dir = get3dProbeDirection();
  let probeMotionDir = [0,0];
  if (dir[0]<0) probeMotionDir[0] = 1;
  if (dir[1]<1) probeMotionDir[1] = 1;
  var offsetX = -1*dir[0]*(properties.probe3DRetract + toolDia/2);
  var offsetY = -1*dir[1]*(properties.probe3DRetract + toolDia/2);
  var offsetZ = properties.probe3DThickness + 3;
  bBeep();
  bDialog ("Mount 'CORNER PROBE'. Failure can break the tool. [Cancel] Stops All!", "WARNING! Corner probe", 3, true);
  writeBlock("G21");
  writeBlock("G91");
  writeBlock("M563 P999 S\"XYZ-Probe\"");
  writeBlock("T999");                     // switching to the probe tool we just defined
  //  ----------- Probing Z axis
  writeBlock("M585 Z60 E3 L0 F200 S1");
  writeBlock("G10 L20 P"+currentWorkOffset+" Z0");
  // ; >>> Retract
  writeBlock("G1 H1 Z3 F1500");           //      ; up 3m
  writeBlock("G1 H1 X"+ get3dProbeMove("x", "probe") +" F1500");         //    ; left
  writeBlock("M400");
  writeBlock("G1 Z-4 F1500");             //   ; down 4mm (in -1mm)
  // ; ----------- Probing X
  writeBlock("M585 X60 E3 L0 F300 S" + probeMotionDir[0]);
  writeBlock("G10 L20 P"+currentWorkOffset+" X0");            // Set X
  // ; >>> Retract
  writeBlock("G1 H1 X"+ get3dProbeMove("x", "retract") +" F1500");//    ; Left -10
  writeBlock("G1 H1 Z4 F1500"); //      ; up 4mm (out 3mm)
  writeBlock("M400"); //
  writeBlock("G1 Y"+ get3dProbeMove("y", "probe")+" F1500"); //       ; south 20mm
  writeBlock("M400");
  writeBlock("G1 H1 X" +get3dProbeMove("x", "intetract") + " F1500"); //     ; left 15mm (in 5mm)
  writeBlock("G1 Z-4 F1500"); //        ; down 4mm (in -1mm)
  writeBlock("M400");
  // ; ----------- PROBE Y
  writeBlock("M585 Y60 E3 L0 F300 S" + probeMotionDir[1]);
  writeBlock("G10 L20 P"+currentWorkOffset+" Y0");  //Set Y
  // ; >>>>  Retract to release the probe
  writeBlock("G1 H1 Y"+ get3dProbeMove("y", "retract")+" f2000");  // South 10 (Y is 10mm South)
  writeBlock("M400");
  writeBlock("G1 H1 Z4 f2000")    ; //up 4mm (Z is 3mm Up)
  writeBlock("M400");
  writeBlock("G1 H1 X"+ (get3dProbeMove("x", "intetract")*-1)+" f2000")  ; // left 15mm (X is 10mm Left)
  // ;; -- Getting Rid of the tool we don't want its interference
  writeBlock("M563 P999 D-1 H-1"); //          ; tool deleted
  writeBlock("T-1");                         // deselect tool
  writeBlock("G90");
  writeComment("CHANGING-> Setting WCS1 to the probed values");
  writeBlock("G10 L20 P"+currentWorkOffset+" X" +offsetX+ " Y" +offsetY+ " Z"+ offsetZ);  //   SET
  writeBlock("M500");                       // ; SAVED in WCS number 1
  bBeep();
  bDialog("Remove Probe", "WARNING!", 2, false);
  writeComment("TITLE-> CORNER PROBE ENDS --");
  return;
}

function bZProbeBlock (currentWorkOffset) {
  writeComment("TITLE-> Probing Z now - - - ")
  writeBlock(bWCS);
  writeBlock("G0 X" + bZProbe.safeInside);
  writeBlock("M400");
  writeBlock("G0 Y" + bZProbe.safeInside);
  bBeep();
  bDialog ("Mount "+ properties.probeZThickness +"mm 'Z-PROBE'. Failure can break the tool. [Cancel] stops All!", "WARNING! Z Probe", 3, true);
  writeBlock("G91");
  writeBlock("M563 P999 S\"XYZ-Probe\"");
  writeBlock("T999");
  writeBlock("M585 Z60 E3 L0 F300 S1");
  writeBlock("M563 P999 D-1 H-1");
  writeBlock("T-1");
  writeComment("CHANGING-> resetting WCS1 Z value to the probed to adjust for the nnew tool stickout");
  writeBlock("G10 L20 P"+currentWorkOffset+" Z" + properties.probeZThickness);
  writeBlock("M500");
  writeBlock("G1 Z" + properties.probeZRetract + " ; LOGGING-> Probe release")
  bBeep();
  writeBlock("G90");
  bDialog("Remove Z-Probe", "Remove Z Probe", 2, false);
  writeComment("TITLE-> Z Probe ENDS - - - ")
  return;
}

function bGetWorkOffset(workOffset) {
  if (workOffset == 0) {
    workOffset = Number(properties.useWhichWCS);
    if (workOffset > 59) {
      switch (workOffset) {
        case 59.1:
          workOffset = 7;
          break;
        case 59.2:
          workOffset = 8;
          break;
        case 59.3:
          workOffset = 9;
          break;
        default:
          workOffset = 1;
      }
    } else {
       workOffset = parseInt (workOffset - 53);
    }
    writeComment("No workOffset in Setup. WCS is now "+ workOffset + " gotten from post G"+ properties.useWhichWCS + " option");
  }
  return workOffset;
}

function bSetAndPrintCurrentWorkOffset (workOffset, currentWorkOffset) {
  if (workOffset > 0) {
    if (workOffset > 9) {
      error(localize("Work offset out of range."));
    } else {
      if (workOffset == 9 && properties.manualToolChange) {
        error(localize("WCS 9 is reserved for manual tool change. Either disable Manual Tool Change in the Post, or change the WCS 9 Offset to 1 to 8 (0 to control by Post-Processor) in the corresponding Setup"));
      } else {
        if (workOffset != currentWorkOffset) {
          var currentWcsName = "";
          if (workOffset+53 < 60) {
            currentWcsName = workOffset+53;
            writeBlock(gFormat.format(currentWcsName));
          } else {
            var p = workOffset - 6;
            currentWcsName = "G59."+p;
            writeBlock(currentWcsName);
          }
          bWCS = currentWcsName;
          currentWorkOffset = workOffset;
        }
      }
    }
  }
  return currentWorkOffset;
}

function setupBacklashCompensation() {
  // return;
  bCompensation.x1 = Number(properties.measuredBacklashXFor1mm);
  bCompensation.y1 = Number(properties.measuredBacklashYFor1mm);
  bCompensation.z1 = Number(properties.measuredBacklashZFor1mm);
  bCompensation.x10 = Number(properties.measuredBacklashXFor10mm);
  bCompensation.y10 = Number(properties.measuredBacklashYFor10mm);
  bCompensation.z10 = Number(properties.measuredBacklashZFor10mm);
  if (
    bCompensation.x1 > 1.5 ||
    bCompensation.x10 > 2.5 ||
    bCompensation.y1 > 1.5 ||
    bCompensation.y10 > 1.5 ||
    bCompensation.z1 > 1.5 ||
    bCompensation.z10 > 2.5
  ) {
    error("Backlash is too large, you'll be better of cutting with a wooden knife than this CNC machine");
  }
  // bCompensation.motionCounter = Number(properties.bCompensationCount);
  if (properties.applyBacklashCompensation) {
    writeln ("; ------------------------------------------------------------")
    writeln ("; Backlash compensation on motor direction changes are applied");
    writeln ("; Backlash values on X: " +bCompensation.x1 +"..."+ bCompensation.x10);
    writeln ("; Backlash values on Y: " +bCompensation.y1 +"..."+ bCompensation.y10);
    writeln ("; Backlash values on Z: " +bCompensation.z1 +"..."+ bCompensation.z10);
    writeln ("; - Check actual tool motion box after compensation at the end of this file")
    writeln ("; ------------------------------------------------------------")
  }
}

function axialBacklashCompensation(axis,_value) {
  if (properties.applyBacklashCompensation) {
    var _holder = _value;
    var axisLetter = ["x", "y", "z"];
    var isMoveReallyNeeded; // check to see if move really needed
    if (bCompensation.lastRequestedPosition[axis] == _value) {
      isMoveReallyNeeded = false;
    } else {
      isMoveReallyNeeded = true;
    }
    bCompensation.lastRequestedPosition[axis] = _value;
    if (bCompensation.isFirstTime(axis)) {
      bCompensation.oldPos[axis] = _holder;
    } else {
      if (isMoveReallyNeeded) {
          var diff = getBacklashCompensationValue (axis, _value, bCompensation.oldPos[axis])
          _value = _value + diff;
          bCompensation.oldPos[axis] = _value; // resetting the oldValue with a new one for the next use
        }
    }
  motionBox.setBox(axis, _value);
  }
  bToggleOutput(axis, isMoveReallyNeeded || bCompensation.isFirstTime(axis));
  return _value;
}


function bToggleOutput(axis, state) {
  if (state) {
    switch (axis) {
      case 0:
        xOutput.enable();
        break;
      case 1:
        yOutput.enable();
        break;
      case 2:
        zOutput.enable();
        break;
    }
  } else {
    switch (axis) {
      case 0:
        xOutput.disable();
        break;
      case 1:
        yOutput.disable();
        break;
      case 2:
        zOutput.disable();
        break;
    }
  }
}

function getBacklashCompensationValue(axis, newPos, oldPos) {
  if (newPos==oldPos) {
    // writeln("; No adjustment needed");
    return 0;
  }
  let compFlag = false;
  let compensationValue = [0, 0, 0]; // for 1mm, for 10mm, applicable value
  switch (axis) {
    case 0:
      compFlag = bCompensation.x;
      compensationValue[0] = bCompensation.x1;
      compensationValue[1] = bCompensation.x10;
      break;
    case 1:
      compFlag = bCompensation.y;
      compensationValue[0] = bCompensation.y1;
      compensationValue[1] = bCompensation.y10;
      break;
    case 2:
      compFlag = bCompensation.z;
      compensationValue[0] = bCompensation.z1;
      compensationValue[1] = bCompensation.z10;
      break;
  }
  if (compFlag) { // if compesation is available in this particular axis
    var thisDirection = (oldPos<newPos ? "up" : "down");
    if (thisDirection != bCompensation.lastDir[axis]) {
      if (bCompensation.lastDir[axis] == "none") {
        // first move? right? Set this as the previous for the next calculation and return without compensation
        bCompensation.lastDir[axis] = thisDirection;
        return 0;
      } else {
        // direction is actually Changed
        bCompensation.lastDir[axis] = thisDirection; // update old one now the test is over
        if (Math.abs(newPos - oldPos) > 1) {
          compensationValue[2] = Math.abs(compensationValue[1]);
        } else {
          compensationValue[2] = Math.abs(compensationValue[0]);
        } // comp value selection
      } // dir change detected
    } // direction mismatch with the old one
    return (thisDirection == "up" ? (compensationValue[2]) : (-1*compensationValue[2]));
  } // compensation is available ends
  else {return 0;} // if we're here it means the compesation was not available for the axis
} // function


function bflushAcCompErPerMotionCount() {
  bCompensation.motionCounter +=1;
  if (Number(properties.bCompensationCount) != 0 && bCompensation.motionCounter >= Number(properties.bCompensationCount)) {
    bCompensation.motionCounter = 0;
    writeComment("Intermediate Compensation Flush");
    bFlushAccumulatedCompensationError();
    return true;
  }
  return false;
}

function bFlushAccumulatedCompensationError() {
  bDialog("Flushing Accumulated Compensation", "WAIT!", 123, false);
  writeBlock("G1 H1 Z500");
  writeBlock("M400");
  writeBlock("G0 X0 Y0");
  writeBlock("M400");
  writeBlock("G1 Z0");
  if (properties.dwellInSeconds) {
    onDwell(2);
  } else {
    onDwell(2000);
  }
  writeBlock("G1 H1 Z500");
  writeBlock(
    "G0"
    +" X"+bCompensation.lastRequestedPosition[0]
    +" Y"+bCompensation.lastRequestedPosition[1]
    );
  writeBlock("M400");
  writeBlock("G1 Z"+bCompensation.lastRequestedPosition[2]);
  bCompensation.oldPos = bCompensation.lastRequestedPosition;
}
