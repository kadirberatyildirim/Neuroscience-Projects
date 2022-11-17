clc; clear; clf;

scores = ["Trial" "brightness-"+string(0:10:90)]; % List that will store all trial results

h = figure('units','normalized','outerposition',[0 0 1 1]) %Creating a figure with a handle h
set(h,'color',[0 0 0]) % Makes the figure window black

%%%%% Starting Screen %%%%%
start_text = "Press enter to continue trials";
pause_figure(start_text)

%%%%% Para/fovial experiment with shades of gray %%%%%
dists = 0:40:200; % Distances to the right from the center
for dist = dists
    pause_text = "You will be starting phase with distance " + string(dist) + ". Focus on the center.";
    pause_figure(pause_text)
    s = trial(h, dist, [1 2 3], 0); % [1 2 3] is the gray color
    scores = [scores; "Gray-"+string(dist) transpose(s)];
end

%%%%% RGB experiment %%%%%
colours = ["R" "G" "B"];
for i = 1:3 % In order, R, G and B trials are done this way
    for j = 3:4
        pause_text = "You will be starting trial with color " + colours(i) + " and with distance " + string(dists(j)) + ". Focus on the center.";
        pause_figure(pause_text)
        s = trial(h, dists(j), i, 0);
        scores = [scores; colours(i)+"-"+string(dists(j)) transpose(s)];
    end
end

%%%%% Relative experiment %%%%%
for i = 2:3
    pause_text = "You will be starting relative trial with distance " + string(dist) + ". Focus on the center and decide if right dot is dimmer or brighter than the left dot.";
    pause_figure(pause_text)
    s = trial(h, dists(i), [1 2 3], dists(i));
    scores = [scores; colours(i)+"-"+string(dists(j)) transpose(s)];
end

% Save trial data
writematrix(scores, string(datetime()) + "_session_data.csv")

%% Helpers
function pause_figure(txt)
    clf;
    image(uint8(zeros(400,400,3)))
    text(50, 200, txt, 'Color', 'r');
    % When enter pressed, this while will end
    inp = get_input;
    while inp ~= 13
        inp = get_input;
    end
end

function inp = get_input
    k = waitforbuttonpress;
    inp = double(get(gcf,'CurrentCharacter'));
end