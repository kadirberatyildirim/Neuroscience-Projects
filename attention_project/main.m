clc;clear;clf;

%%%%% PARAMETERS %%%%%
num_trials = 80; % For each location
grid_size = 4; % One dimension of the grid, choose even nums
points = reshape(1:grid_size^2, [grid_size grid_size]);
bounds = 0:grid_size:grid_size^2-grid_size; % Defines grids
loc_counts = repmat(num_trials/grid_size, [grid_size/2 grid_size/2 grid_size^2]);
types = ["Valid100" "Valid300"; 
        "Invalid100" "Invalid300"]; % This is the structure of loc_counts

%%%%% Preadjustments %%%%%
% To make figure fullscreen, uncomment next line!
figure('units','normalized','outerposition',[0 0 1 1])

%%%%% Session %%%%%
for i=1:3
    % Choose a random point
    loc_remaining = reshape(sum(sum(loc_counts), 2), 1, []);
    weights = loc_remaining/sum(loc_remaining);
    point = randsample(reshape(points, 1, []), 1, true, weights);
    %{ 
    Calculate plot location, this is needed bc 'points' array's origin is
    top left while plot grid's origin is bottom left.
    %}
    [row, column] = find(points == point);
    plot_point = [grid_size*(column-1) bounds(end)-(grid_size*(row-1))];
    % Choose a random trial type
    

    % Plot
    clf;
    plot_controller("Cue", bounds, plot_point)
    pause(0.5)
    plot_controller("Target", bounds, plot_point)
    pause(0.5)
end

%%%%% HELPER FUNCTIONS %%%%%
