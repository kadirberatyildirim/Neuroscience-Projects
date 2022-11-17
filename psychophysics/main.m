clc; clear; clf;

trials = ['Fovial' 'Parafovial' 'RGB' 'Relative'];

pause_figure("Press enter to continue trials")

s = trial






%% Helpers
function pause_figure(txt)
    clf;
    text (0.3, 0.5, txt);
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