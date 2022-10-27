function plot_controller(type, bounds, point)
    clf;
    % Plot the background grids
    plot_grids(bounds)
    hold on
    if type == "Cue"
        % Plot the random box
        f = fill([point(1) point(1) point(1)+length(bounds) point(1)+length(bounds)], ...
            [point(2) point(2)+length(bounds) point(2)+length(bounds) point(2)], 'b');
        alpha(f,0.2)
    elseif type == "Target"
        % Find middle point of the grid and put a target point
        s = scatter((2*point(1)+length(bounds))/2, (2*point(2)+length(bounds))/2, ...
            800, "red", 'filled');
    end
    hold off
end

% Every plot will contain grids
function plot_grids(bounds)
    for j=1:length(bounds)
        for i=1:length(bounds)
            rectangle('Position', ...
                [bounds(i) bounds(j) length(bounds) length(bounds)])
        end
    end
end