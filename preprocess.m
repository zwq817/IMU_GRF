function ANA_filename = preprocess(input_model, IKPath, SetupIK, SetupAnalyze)
    import org.opensim.modeling.*
    
    path='C:\OpenSim 4.4\Geometry';
    ModelVisualizer.addDirToGeometrySearchPaths(path);
    
    % Load the model and initialize
    model = Model(input_model);
    model.initSystem();

    %% IK
    Results_Dir_IK = IKPath;
    % Get trc data to determine time range
    markerData = MarkerData(IKPath + "\test_data_markers.trc");
    ikTool = InverseKinematicsTool(SetupIK);
    
    % Tell Tool to use the loaded model
    ikTool.setModel(model);
    
    % Get initial and intial time 
    IK_initial_time = markerData.getStartFrameTime();
    IK_final_time = markerData.getLastFrameTime();
    
    % Setup the ikTool for this trial
    ikTool.setMarkerDataFileName(IKPath + "\test_data_markers.trc");
    ikTool.setStartTime(IK_initial_time);
    ikTool.setEndTime(3);
    ikTool.setResultsDir(Results_Dir_IK);
    ikTool.setOutputMotionFileName(IKPath + "\Result_IK.mot");
    
    % Save the settings in a setup file
    outfile = IKPath + "\Setup_IK.xml";
    ikTool.print(outfile);
    
    % Run IK
    ikTool.run();
    
    %% Analyze
    analyzeTool = AnalyzeTool(SetupAnalyze);
    analyzeTool.run();
    ANA_filename = strrep(IKPath, "IK", "Analyze") + "\jumper-scaled_BodyKinematics_acc_global.sto";
