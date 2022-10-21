clc;clear;clf;

% To make figure fullscreen, uncomment next line!
figure('units','normalized','outerposition',[0 0 1 1])

for i=1:3
    clf;
    plot_controller("Cue")
    pause(0.5)
end