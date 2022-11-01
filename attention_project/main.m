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
data = ["Trial" "Subject_Time" "Subject_Answer" "Cue_Pos" "Target_Pos"];
pause_btw_events = 1; % In seconds

%%%%% Preadjustments %%%%%
% To make figure fullscreen, uncomment next line!
figure('units','normalized','outerposition',[0 0 1 1])
% A text before starting trial
g = text (0.3, 0.5, "Press enter to start trials");
% When enter pressed, this while will end
inp = get_input;
while inp ~= 13
    inp = get_input;
end

%%%%% Session %%%%%
for i=1:total_trials
    % Choose a random location on grid
    loc = choose_loc(loc_counts, points, 0, 0);
    % Save that location's trial matrix
    curr_loc_matrix = loc_counts(:,:,loc);
    % Choose a random trial type
    trial_weights = reshape(curr_loc_matrix,1,[])/sum(sum(curr_loc_matrix));
    curr_trial = randsample(reshape(types, 1, []), 1, true, trial_weights);
    % Find plot point
    cue_point = find_plot_point(loc, points, bounds, grid_size);
    % Split trial type string for deciding target times and location
    type = split(curr_trial, "-");
    %{
    % Empty plot before the event, so that events are not shown too fast
    clf;
    scatter(8,8,450,'+','black')
    pause(pause_btw_events)
    %}
    % Plot
    switch type(1)
        case "Valid"
            plot_controller("Cue", bounds, cue_point)
            pause(str2double(type(2))/10^3)
            clf;
            plot_controller("Target", bounds, cue_point)
        case "Invalid"
            plot_controller("Cue", bounds, cue_point)
            pause(str2double(type(2))/10^3)
            new_loc = choose_loc(loc_counts, points, 0, loc);
            target_point = find_plot_point(new_loc, points, bounds, grid_size);
            clf;
            plot_controller("Target", bounds, target_point)
    end
    
    % Time subject
    [user_time, user_answer] = input_handler;

    % Reduce chosen trials count by 1
    trial_index = find(types==curr_trial);
    curr_loc_matrix(trial_index) = curr_loc_matrix(trial_index) - 1;
    % Overwrite 3D counts matrix with the new matrix of the trial
    loc_counts(:,:,loc) = curr_loc_matrix;

    % Store Data
    cue_entry = string(cue_point(1)) + "," + string(cue_point(2));
    if type(1) == "Valid"
        data = [data; curr_trial user_time user_answer cue_entry cue_entry];
    elseif type(1) == "Invalid"
        targ_entry = string(target_point(1)) + "," + string(target_point(2));
        data = [data; curr_trial user_time user_answer cue_entry targ_entry];
    end

    % Remaining trials can be shown by uncommenting next line
    %disp("Remaining trials: " + string(sum(reshape(sum(sum(loc_counts), 2), 1, []))))
end

% Save trial data
writematrix(data, string(datetime()) + "_session_data.csv")

%%%%% HELPER FUNCTIONS %%%%%
function [time, answer] = input_handler
    tic

    % space: 32, enter: 13
    k = waitforbuttonpress;
    answer = double(get(gcf,'CurrentCharacter'));
    
    time = toc;

    switch answer
        case 13
            answer = "Valid";
        case 32
            answer = "Invalid";
        otherwise
            answer = "Unknown_Input";
    end
end
% Input for enter skipping -> returns ASCII char of input
function inp = get_input
    k = waitforbuttonpress;
    inp = double(get(gcf,'CurrentCharacter'));
end

function loc = choose_loc(loc_counts, points, nonintersecting, old_loc)
    loc_remaining = reshape(sum(sum(loc_counts), 2), 1, []);
    loc_weights = loc_remaining/sum(loc_remaining);
    if ~(nonintersecting)
        loc = randsample(reshape(points, 1, []), 1, true, loc_weights);
    elseif nonintersecting
        while 1
            loc = randsample(reshape(points, 1, []), 1, true, loc_weights);
            if loc ~= old_loc
                break
            end
        end
    end
end

function plot_point = find_plot_point(loc, points, bounds, grid_size)
    %{ 
    Calculate plot location, this is needed bc 'points' array's origin is
    top left while plot grid's origin is bottom left.
    %}
    [row, column] = find(points == loc);
    plot_point = [grid_size*(column-1) bounds(end)-(grid_size*(row-1))];
end