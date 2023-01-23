%Chapter 16 - Matlab for Neuroscientists
%9-2-08
%This code trains a population vector algorithm
%i.e. it fits each neuron's firing rate to a tuning curve
load Chapter21_CenterOutTest

numNeurons=length(unit);

% Train/Test Split
split_to = 150;
instruction = instruction(1:split_to);
go = go(1:split_to);
direction = direction(1:split_to);

spikeCounts = [];
for n=1:numNeurons
    %bin firing rates for each direction
    spikeCount=zeros(8,1);
    for i=1:8
        indDir=find(direction==i); %find trials in a given direction
        numTrials(i)=length(indDir);
        
        startInstr=instruction(indDir); %to center on instruction time
        trialEdges=sort([startInstr; startInstr+1]);
        spikeTimes=unit(n).times;
        if ~isempty(spikeTimes)
            %using "histc" to bin the spike times is faster than looping through trials
            temp=histc(spikeTimes,trialEdges);
            spikeCount(i)=sum(temp(1:2:numTrials(i)*2));
        else
            spikeCount(i)=0;
        end
        %divide by the number of trials for a mean firing rate
        spikeCount(i)=spikeCount(i)/numTrials(i);
    end

    spikeCounts = [spikeCounts; spikeCount'];
    %fit a tuning curve to "spikeCount"
    ang=[0:pi/4:2*pi-pi/4]';
    mystring = 'p(1)+p(2)*cos(theta-p(3))';
    myfun = inline(mystring,'p','theta');
    param(n,:) = nlinfit(ang,spikeCount,myfun,[1 1 0])';
    ang2=[0:.001:2*pi];
    fit = myfun(param(n,:),ang2);
    
    %easiest to pick preferred direction (in degrees) from fit data
    [p prefDirInd]=max(fit);
    prefDir(n)=ang2(prefDirInd);
end
save popVectorData param prefDir

%{
h = heatmap(spikeCounts(5:35,:))
h.Colormap = summer
h.XData = [0 45 90 135 180 225 270 315]
h.YData = 5:35
xlabel('Movement Angle (Degrees)')
ylabel('Neuron Index')
title('Average Firing Rate of Different Neurons wrt Movement Angle')
grid off
%}
