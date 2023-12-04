function [ANA_table_m, GRFExp_table, GRFCal_total, GRFExp_total, GRFCal_total_sim] = getGRF(input_model, ACC_File, GRF_File)    
    import org.opensim.modeling.*
    
    path='C:\OpenSim 4.4\Geometry';
    ModelVisualizer.addDirToGeometrySearchPaths(path);
    
    % Load the model and initialize
    model = Model(input_model);
    model.initSystem();

    %% Get Acc
    % read the simulation results
    ANA_filename = ACC_File;
    ANA_table = TimeSeriesTable(ANA_filename);
    ANA_table_m = osimTableToStruct(ANA_table);
    
    %% Experimental
    
    GRFExp_filename = GRF_File;
    GRFExp_table = readmatrix(GRFExp_filename);
    
    frame_exp = length(GRFExp_table);
    GRFExp_r = zeros(frame_exp, 1);
    GRFExp_l = zeros(frame_exp, 1);
    GRFExp_total = zeros(frame_exp, 1);
    
    for t_grf = 1:frame_exp
        GRFExp_r(t_grf) = GRFExp_table(t_grf, 3);
        GRFExp_l(t_grf) = GRFExp_table(t_grf, 9);
        GRFExp_total(t_grf) = GRFExp_r(t_grf) + GRFExp_l(t_grf);
    end
    
    %% Calculated (All Segment
    references = osimList2MatlabCell(model,'Body');  % Get a cell array of references to all the bodies in a model
    g = 9.81;
    nbody = length(references);
    frame = length(ANA_table_m.time);
    mass = zeros(nbody,1);
    AccData = zeros(frame, nbody);
    grf = zeros(frame, 1);
    GRFCal_total = zeros(frame, 1);
    for t = 1:frame
        for n = 1:nbody
            segment = references{n};     
           % Get Mass
            mass(n) = segment.getMass();
           % Get acc
            segmentName = char(segment);
            fieldName = [segmentName '_Y'];
            AccData(:, n) = ANA_table_m.(fieldName);
           % Get GRF
            grf(t, n) = mass(n) .* (AccData(t, n) + g);
            GRFCal_total(t) = GRFCal_total(t) + grf(t, n);
        end
    end
    
    %% Calculated (Trunk, Thigh, Shank (pelvis, femur, tibia, torso % 1, 2, 3, 7, 8, 12
    sim_references = {references{1}; references{2}; references{3}; references{7}; references{8}; references{12}};
    nbody_sim = length(sim_references);
    mass_sim = zeros(nbody_sim,1);
    AccData_sim = zeros(frame, nbody_sim);
    grf_sim = zeros(frame, 1);
    GRFCal_total_sim = zeros(frame, 1);
    for t_sim = 1:frame
        for n_sim = 1:nbody_sim
            segment_sim = sim_references{n_sim};     
           % Get Mass
            mass_sim(n_sim) = segment_sim.getMass();
           % Get acc
            segmentName = char(segment_sim);
            fieldName = [segmentName '_Y'];
            AccData_sim(:, n_sim) = ANA_table_m.(fieldName);
           % Get GRF
            grf_sim(t_sim, n_sim) = mass_sim(n_sim) .* (AccData_sim(t_sim, n_sim) + g);
            GRFCal_total_sim(t_sim) = GRFCal_total_sim(t_sim) + grf_sim(t_sim, n_sim);
        end
    end