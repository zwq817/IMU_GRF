function [Plot_all, Plot_main, Error_all, ErrorPer_all, error, error_per] = GRF_Plot(ANA_table_m, GRFExp_table, GRFCal_total, GRFExp_total, GRFCal_total_sim)    
    %% All Segments
    % Resampled
    commonTime = 0:1/120:3;
    time1 = ANA_table_m.time;
    time2 = GRFExp_table(:, 1);
    GRFCal_resampled = interp1(time1, GRFCal_total, commonTime, 'spline');
    GRFExp_resampled = interp1(time2, GRFExp_total, commonTime, 'spline');
    
    Plot_all = figure();
    plot(commonTime, GRFCal_resampled, '-', 'LineWidth', 1.5);
    hold on;
    plot(commonTime, GRFExp_resampled, '--', 'LineWidth', 1.5);
    xlabel('Time (seconds)');
    ylabel('Force (N)');
    legend('Calculated Data', 'Experimental Data');
    title('Comparison of Ground Reaction Forces of All Segments');
    error_sum = 0;
    error_per_sum = 0;
    % Error
    err = zeros(length(GRFExp_resampled), 1);
    err_per = zeros(length(GRFExp_resampled), 1);
    for e = 1:length(GRFExp_resampled)
        err(e) = GRFCal_resampled(e) - GRFExp_resampled(e);
        err_per(e) = (err(e) / GRFExp_resampled(e)) * 100;
        error_sum = error_sum + err(e);
        error_per_sum = error_per_sum + err_per(e);
    end
    error = error_sum / length(GRFExp_resampled);
    error_per = error_per_sum / length(GRFExp_resampled);

    Error_all = figure();
    plot(commonTime, err, '-', 'LineWidth', 1.5);
    xlabel('Time (seconds)');
    ylabel('Force (N)');
    title('Error of Ground Reaction Forces of All Segments');

    ErrorPer_all = figure();
    plot(commonTime, err_per, '-', 'LineWidth', 1.5);
    xlabel('Time (seconds)');
    ylabel('Percentage (%)');
    title('Error Percentage of Ground Reaction Forces of All Segments');

    

    %% Trunk, Thigh, Shank
    % Resampled
    GRFCal_resampled_sim = interp1(time1, GRFCal_total_sim, commonTime, 'spline');
    
    Plot_main = figure();
    plot(commonTime, GRFCal_resampled_sim, '-', 'LineWidth', 1.5);
    hold on;
    plot(commonTime, GRFExp_resampled, '--', 'LineWidth', 1.5);
    xlabel('Time (seconds)');
    ylabel('Force (N)');
    legend('Calculated Data', 'Experimental Data');
    title('Comparison of Ground Reaction Forces of Trunk, Thigh, Shank');