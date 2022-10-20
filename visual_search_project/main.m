clc;clear;clf;

%%%%% SESSION PARAMETERS %%%%%
sizes = [4 8 12 16];
sess_data = [];

for i=1:length(sizes)
    clf;
    % To make figure fullscreen, uncomment next line!
    figure('units','normalized','outerposition',[0 0 1 1])
    % A text before starting trial
    g = text (0.5, 0.5, "Press enter to start trial level: " + string(i));
    % When enter pressed, this while will end
    inp = get_input;
    while inp ~= 13
        inp = get_input;
    end
    
    [trial_order, trial_times, trial_inputs] = trial(sizes(i));
    % Concatenate trial data
    trial_data = [transpose(trial_order) trial_times transpose(trial_inputs)];
    trial_data = [trial_data transpose(repmat("Size "+string(sizes(i)), 1, size(trial_data, 1)))];
    % Concatenate trial data to session data
    sess_data = [sess_data; trial_data];
end

% Save trial data
writematrix(sess_data, "session_data.csv")

function inp = get_input
    k = waitforbuttonpress;
    inp = double(get(gcf,'CurrentCharacter'));
end