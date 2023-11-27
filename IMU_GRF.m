import org.opensim.modeling.*

path='C:\OpenSim 4.4\Geometry';
ModelVisualizer.addDirToGeometrySearchPaths(path);

% Load the model and initialize
model = Model("Scaled_Model.osim");
model.initSystem();

%% Get Mass
references = osimList2MatlabCell(model,'Body');  % Get a cell array of references to all the bodies in a model
num = length(references);
segment = zeros(num,1);
mass = zeros(num,1);
for i = 1:num
    segment = references{i};     
    mass(i) = segment.getMass();
end

%% IK
Results_Dir_IK = "squat_jump\IK";
% Get trc data to determine time range
markerData = MarkerData("squat_jump\IK\test_data_markers.trc");
ikTool = InverseKinematicsTool("squat_jump\IK\Setup_IK.xml");

% Tell Tool to use the loaded model
ikTool.setModel(model);

% Get initial and intial time 
IK_initial_time = markerData.getStartFrameTime();
IK_final_time = markerData.getLastFrameTime();

% Setup the ikTool for this trial
ikTool.setMarkerDataFileName("squat_jump\IK\test_data_markers.trc");
ikTool.setStartTime(IK_initial_time);
ikTool.setEndTime(3);
ikTool.setResultsDir(Results_Dir_IK);
ikTool.setOutputMotionFileName("squat_jump\IK\Result_IK.mot");

% Save the settings in a setup file
outfile = 'squat_jump\IK\Setup_IK.xml';
ikTool.print(outfile);

% Run IK
ikTool.run();

%% Analyze
analyzeTool = AnalyzeTool("squat_jump\Analyze\Setup_Analyze_kinematics.xml");
ANA = analyzeTool.run();

%% Get Acc
% read the simulation results
ANA_filename = "squat_jump\Analyze\jumper-scaled_BodyKinematics_acc_global.sto";
ANA_table = TimeSeriesTable(ANA_filename);
% ANA_table_m = osimTableToStruct(ANA_table);

nRows = ANA_table.getNumRows();
nCols = ANA_table.getNumColumns();

% Preallocate a MATLAB matrix
matData = NaN(nRows, nCols);

% Retrieve data from the OpenSim table and populate the MATLAB matrix
for i = 0:nCols-1
    % Get the data for each column and store it in the MATLAB matrix
    columnData = ANA_table.getDependentColumnAtIndex(i).getAsVector();
    matData(:, i+1) = columnData.toMat();
end