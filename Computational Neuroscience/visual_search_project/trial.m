function [user_time, user_input] = trial(type, size)
    %{
    -> There must be equal number of with and without target trials.
    -> Use only correct trials for analysis.
    -> Be as quick as possible for answering.
    -> 160 trials (1 sec each).
    -> Must be at least 20 correct trials per level.
    %}
    
    %%%%% TRIAL STARTS HERE %%%%%
    %%%%% GRAPH CONTROL %%%%%
    plot_controller(type, size)
    
    % Time user input
    [user_time, user_input] = input_handler;
end

%%%%% USER INPUT HANDLER %%%%%
function [time, answer] = input_handler
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
