clc;clear;clf;

%%%%% PARAMETERS %%%%%
num_trials = 80; % For each location
grid_size = 4; % One dimension of the grid, choose even nums
points = reshape(1:grid_size^2, [grid_size grid_size]);
bounds = 0:grid_size:grid_size^2-grid_size; % Defines grids
loc_counts = repmat(num_trials/grid_size, [grid_size/2 grid_size/2 grid_size^2]);
types = ["Valid-100" "Valid-300"; 
        "Invalid-100" "Invalid-300"]; % This is the structure of loc_counts
total_trials = num_trials*grid_size^2;

%%%%% Preadjustments %%%%%
% To make figure fullscreen, uncomment next line!
figure('units','normalized','outerposition',[0 0 1 1])

%%%%% Session %%%%%
for i=1:total_trials
    % Choose a random location on grid
    loc_remaining = reshape(sum(sum(loc_counts), 2), 1, []);
    loc_weights = loc_remaining/sum(loc_remaining);
    loc = randsample(reshape(points, 1, []), 1, true, loc_weights);
    % Save that location's trial matrix
    curr_loc_matrix = loc_counts(:,:,loc);
    % Choose a random trial type
    trial_weights = reshape(curr_loc_matrix,1,[])/sum(sum(curr_loc_matrix));
    curr_trial = randsample(reshape(types, 1, []), 1, true, trial_weights);
    % Reduce chosen trials count by 1
    trial_index = find(types==curr_trial);
    curr_loc_matrix(trial_index) = curr_loc_matrix(trial_index) - 1;
    % Overwrite 3D counts matrix with the new matrix of the trial
    loc_counts(:,:,loc) = curr_loc_matrix;
    
    %{ 
    Calculate plot location, this is needed bc 'points' array's origin is
    top left while plot grid's origin is bottom left.
    %}
    [row, column] = find(points == loc);
    cue_point = [grid_size*(column-1) bounds(end)-(grid_size*(row-1))];
    % Split trial type string for deciding target times and location
    type = split(curr_trial, "-");
    
    % Plot
    clf;
    switch type(1)
        case "Valid"
            plot_controller("Cue", bounds, cue_point)
            pause(str2double(type(2))/10^3)
            clf;
            plot_controller("Target", bounds, cue_point)
            input_handler;
        case "Invalid"
            plot_controller("Cue", bounds, cue_point)
            pause(str2double(type(2))/10^3)
            clf;
            plot_controller("Target", bounds, cue_point)
            input_handler;
    end

    % Remaining trials can be shown by uncommenting next line
    disp("Remaining trials: " + string(sum(reshape(sum(sum(loc_counts), 2), 1, []))))
end

%%%%% HELPER FUNCTIONS %%%%%
function [time, answer] = input_handler
    tic

    % space: 32, enter: 13
    k = waitforbuttonpress;
    answer = double(get(gcf,'CurrentCharacter'));
    
    time = toc;
end