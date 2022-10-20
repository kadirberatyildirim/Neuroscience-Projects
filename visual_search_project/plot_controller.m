function plot_controller(type, size)
    clf;
    if type == "Pop-out"
        circles = rand(2,size/2-1)*5;
        crosses = rand(2,size/2)*5;
        one_true_ring = rand(2,1)*5;
        
        s1 = scatter(circles(1,:), circles(2,:), 200, "green", ...
                    "linewidth", 2);
        hold on
        s2 = scatter(crosses(1,:), crosses(2,:), 200, "green", ...
                    "linewidth", 2);
        s2.Marker = 'x';
        hold on
        s3 = scatter(one_true_ring(1,:), one_true_ring(2,:), 200, "red", ...
                    "linewidth", 2);
        axis off;
    elseif type == "Conjunction"
        circles = rand(2,size/2-1)*5;
        one_true_ring = rand(2,1)*5;
        red_crosses = rand(2,floor(size/4))*5;
        green_crosses = rand(2,ceil(size/4))*5;
        
        s1 = scatter(circles(1,:), circles(2,:), 200, "green", ...
                    "linewidth", 2);
        hold on
        s2 = scatter(red_crosses(1,:), red_crosses(2,:), 200, "red", ...
                    "linewidth", 2);
        s2.Marker = 'x';
        hold on
        s3 = scatter(green_crosses(1,:), green_crosses(2,:), 200, "green", ...
                    "linewidth", 2);
        s3.Marker = 'x';
        hold on
        s4 = scatter(one_true_ring(1,:), one_true_ring(2,:), 200, "red", ...
                    "linewidth", 2);
        axis off;
    elseif type == "No-target"
        circles = rand(2,size/2)*5;
        red_crosses = rand(2,ceil(size/4))*5;
        green_crosses = rand(2,floor(size/4))*5;
        
        s1 = scatter(circles(1,:), circles(2,:), 200, "green", ...
                    "linewidth", 2);
        hold on
        s2 = scatter(green_crosses(1,:), green_crosses(2,:), 200, "green", ...
                    "linewidth", 2);
        s2.Marker = 'x';
        hold on
        s3 = scatter(red_crosses(1,:), red_crosses(2,:), 200, "red", ...
                    "linewidth", 2);
        s3.Marker = 'x';
        axis off;
    elseif type == "Focus"
        s = scatter(2.5, 2.5, 200, "black", "linewidth", 2);
        s.Marker = 'x';
        axis off;
        pause(0.5) % Sleep half second to make person look on the dot
    end
end