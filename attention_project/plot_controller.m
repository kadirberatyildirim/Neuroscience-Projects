function plot_controller(type)
    bounds = 0:4:12; % Defines grids
    % Choose a random grid
    point = [randsample(bounds,1) randsample(bounds,1)];
    % Plot the background grids
    plot_grids(bounds)
    hold on
    if type == "Cue"
        % Plot the random box
        f = fill([point(1) point(1) point(1)+4 point(1)+4], ...
            [point(2) point(2)+4 point(2)+4 point(2)], 'b')
        alpha(f,0.2)
    elseif type == "Target"
        
    end
end

% Every plot will contain grids
function plot_grids(bounds)
    for j=1:4
        for i=1:4
            rectangle('Position', [bounds(i) bounds(j) 4 4])
        end
    end
end