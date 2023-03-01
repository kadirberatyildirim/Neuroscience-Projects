clc;clear;clf;

%%%%% SESSION PARAMETERS %%%%%
levels = [4 8 12 16];
level_counter = [160 160 160 160];
sess_data = ["Trial" "Size" "User_Time" "User_Input"];
session_pauser = 100;

%%%% TRIAL PARAMETERS %%%%%
types = ["Pop-out" "Conjunction" "No-target"];
trial_counts = repmat([40 40 80], [length(levels) 1]);
trials = [];

%%%%% STARTING SCREEN %%%%%
clf;
% To make figure fullscreen, uncomment next line!
figure('units','normalized','outerposition',[0 0 1 1])
% A text before starting trial
g = text (0.3, 0.5, "Press enter to start trials");
% When enter pressed, this while will end
inp = get_input;
while inp ~= 13
    inp = get_input;
end

for i=1:640
    %%%%% STARTING TRIALS %%%%%
    % Choose a level randomly
    curr_level = randsample(levels, 1, true, level_counter/sum(level_counter));
    curr_level_index = find(levels == curr_level);
    % Reduce chosen trial number by 1
    level_counter(curr_level_index) = level_counter(curr_level_index) - 1;
    
    % Get remaining trial counts for that level
    curr_level_counts = trial_counts(curr_level_index, :);
    % Choose a random trial
    curr_trial = randsample(types, 1, true, curr_level_counts/sum(curr_level_counts));
    % Reduce chosen trial number by 1
    curr_level_counts(find(types == curr_trial)) = curr_level_counts(find(types == curr_trial)) - 1;
    trial_counts(curr_level_index, :) = curr_level_counts;

    % Clear and focus user with center X
    plot_controller("Focus", curr_level)

    % Run trial
    [trial_time, trial_input] = trial(curr_trial, curr_level);
    % Save data
    sess_data = [sess_data; curr_trial curr_level trial_time trial_input];
    
    % A break every 100 trials
    if mod(i, session_pauser) == 0
        clf;
        g = text (0.3, 0.5, string(640 - i) + " trials remaining, enter to continue");
        % When enter pressed, this while will end
        inp = get_input;
        while inp ~= 13
            inp = get_input;
        end
    end
end

% Save trial data
writematrix(sess_data, "session_data.csv")

function inp = get_input
    k = waitforbuttonpress;
    inp = double(get(gcf,'CurrentCharacter'));
end