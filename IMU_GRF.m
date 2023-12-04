clear; close all; clc
import org.opensim.modeling.*

path='C:\OpenSim 4.4\Geometry';
ModelVisualizer.addDirToGeometrySearchPaths(path);

% Load the model and initialize
model = Model('Scaled_Model.osim');
model.initSystem();
IKPath = "squat_jump\IK";

SetupIK = IKPath + "\Setup_IK.xml";
SetupAnalyze = strrep(IKPath, "IK", "Analyze") + "\Setup_Analyze_kinematics.xml";
ANA_filename = preprocess(model, IKPath, SetupIK, SetupAnalyze);

GRF_File = strrep(IKPath, "IK", "\jump_forces.xlsx");
[ANA_table_m, GRFExp_table, GRFCal_total, GRFExp_total, GRFCal_total_sim] = getGRF(model, ANA_filename, GRF_File) ;
[Plot_all, Plot_main, Error_all, ErrorPer_all, error, error_per] = GRF_Plot(ANA_table_m, GRFExp_table, GRFCal_total, GRFExp_total, GRFCal_total_sim);