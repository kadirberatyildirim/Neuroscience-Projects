function plot_controller(type, bounds, point)
    clf;
    % Plot the background grids
    %plot_grids(bounds)
    %hold on
    if type == "Cue"
        % Plot the random box
        %f = fill([point(1) point(1) point(1)+length(bounds) point(1)+length(bounds)], ...
            %[point(2) point(2)+length(bounds) point(2)+length(bounds) point(2)], 'b');
        %alpha(f,0.2)
        % Or plot the scatter cue

        s = scatter(point(1), point(2), ...
            250, "x", "blue");
    elseif type == "Target"
        s = scatter(point(1), point(2), ...
            100, "red", 'filled');
    end
    xlim([0 16])
    ylim([0 16])
    axis off
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

