function [trials, user_times, user_inputs] = trial(size)
    %{
    -> There must be equal number of with and without target trials.
    -> Use only correct trials for analysis.
    -> Be as quick as possible for answering.
    -> 160 trials (1 sec each).
    -> Must be at least 20 correct trials per level.
    %}
    
    %%%%% PARAMETERS %%%%%
    types = ["Pop-out" "Conjunction" "No-target"];
    trial_counts = [40 40 80];
    trials = [];
    
    % User parameters
    user_times = [];
    user_inputs = [];
    
    %%%%% TRIAL STARTS HERE %%%%%
    for i=1:160
        % Clear and focus user with center X
        plot_controller("Focus", size)
    
        %%%%% CHOOSING AND COUNTING TRIALS %%%%%
        % Choose a random trial from found trials and add to trials
        curr_trial = randsample(types, 1, true, trial_counts/sum(trial_counts));
        % Save trial
        trials = [trials curr_trial]
        % Reduce chosen trial number by 1
        trial_counts(find(types == curr_trial)) = trial_counts(find(types == curr_trial)) - 1;
    
        %%%%% GRAPH CONTROL %%%%%
        plot_controller(curr_trial, size)
        
        % Time user input
        [inp_time, inp] = time_input;
        % Save inputs
        user_inputs = [user_inputs inp]
        user_times(end+1,:) = inp_time
    end
end

%%%%% TIMER FOR USER INPUT %%%%%
function [time, answer] = time_input
    tic

    % space: 32, enter: 13
    k = waitforbuttonpress;
    inp = double(get(gcf,'CurrentCharacter'));
    
    time = toc;

    switch inp
        case 13
            answer = "Target";
        case 32
            answer = "No-target";
        otherwise
            answer = "Invalid Input";
    end
end
