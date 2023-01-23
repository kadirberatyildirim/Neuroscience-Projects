clc; clear; clf;

h = figure('units','normalized','outerposition',[0 0 1 1]) %Creating a figure with a handle h
set(h,'color',[0 0 0]) % Makes the figure window black

%%%%% Starting Screen %%%%%
start_text = "Press enter to continue trials";
pause_figure(start_text)

%%%%%  %%%%%
dists = 40; % Distances to the right from the center
for dist = dists
    pause_text = "You will be starting phase with distance " + string(dist) + ". Focus on the center.";
    pause_figure(pause_text)
    s = trial(h, dist);
end

% Save trial data
writematrix(s, string(datetime()) + "_session_data.csv")

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