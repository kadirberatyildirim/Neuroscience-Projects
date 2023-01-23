function [p prefDir param]=Chap17_RasterPlot(neuronNum)
%Chapter 17 - Matlab for Neuroscientists 2e
%Tuning Curve
%Nov 15, 2013
load('Chap17_Data')

%choose a default neuron if none specified
if ~exist('neuronNum')
    neuronNum=129;
end

%bin firing rates for each direction
spikeCount=zeros(8,1);
for i=1:8
    indDir=find(direction==i); %find trials in a given direction
    numTrials(i)=length(indDir);
    
    for j =1:numTrials(i)
        %pick one of the following:
        centerTime=go(indDir(j)); %to center on start of movement time
        %centerTime=instruction(indDir(j)); %to center on instruction time

        allTimes=unit(neuronNum).times-centerTime; %center spike times
        spikeCount(i)=spikeCount(i)+sum(allTimes>-1&allTimes<1); %pick 2 seconds around center time
    end  
    %divide by the number of trials & bin size (2 s) for a mean firing rate
    spikeCount(i)=spikeCount(i)/numTrials(i)/2;
end

%fit a tuning curve to "spikeCount"
ang = [0:45:315]';
mystring = 'p(1)+p(2)*cos(theta/180*pi-p(3))';
myfun = inline(mystring,'p','theta');
[param, error] = nlinfit(ang,spikeCount,myfun,[1 1 0]);
fit = myfun(param,[0:359]);

%plot raw data, tuning curve
figure
plot(ang,spikeCount)
xlabel('Angle')
ylabel('Avg Firing Rate')
chanNum=unit(neuronNum).chanNum;
unitNum=unit(neuronNum).unitNum;
title(['Chan ' num2str(chanNum) '-' num2str(unitNum)])
hold on
plot([0:359],fit,'r-.')
legend('Actual','Fit')

%easiest to pick preferred direction (in degrees) from fit data
[p prefDir]=max(fit);
p;
prefDir
