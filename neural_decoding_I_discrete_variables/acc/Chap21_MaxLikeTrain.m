%Chapter 16 - Matlab for Neuroscientists
%9-3-08
%This code trains a maximum likelihood algorithm
%i.e. it records the mean and st. dev of the firing rate 
%for each neuron in each direction.
accuricies = [];
for i = 120:150

load Chapter21_CenterOutTest
numNeurons=length(unit);

% Train/Test Split
split_to = i;
instruction = instruction(1:split_to);
go = go(1:split_to);
direction = direction(1:split_to);

for n=1:numNeurons
    for i=1:8
        indDir=find(direction==i); %find trials in a given direction
        numTrials(i)=length(indDir);
        
        startInstr=instruction(indDir); %to center on instruction time
        trialEdges=sort([startInstr; startInstr+1]);
        spikeTimes=unit(n).times;
         if ~isempty(spikeTimes)
            %using "histc" to bin the spike times is faster than looping through trials
            temp=histc(spikeTimes,trialEdges);
            spikeCounts=temp(1:2:numTrials(i)*2);
            meanFR(n,i)=mean(spikeCounts);
            stdFR(n,i)=std(spikeCounts);
        else
            meanFR(n,i)=0;
            stdFR(n,i)=0;
        end
    end
end
save maxLikeData meanFR stdFR

accuricies = [accuricies; Chap21_MaxLikeTest(i)];

end

writematrix(accuricies, 'maxpoiss_acc.csv')

%Use poisson -- transfer lambda which is the avg of event happening