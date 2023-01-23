%Chapter 17 - Matlab for Neuroscientists 2e
%Example Book Code
%Nov 15, 2013

load('Chap17_Data')

%282
t1=spike(1).times;
t2=spike(2).times;

figure %Create a new figure
hold on %Allow multiple plots on the same graph
for i=1:length(t1) %Loop through each spike time
    line([t1(i) t1(i)], [0 1]) %Create a tick mark at x 5 t1(i) with a height of 1
end
ylim([0 5]) %Reformat y-axis for legibility
xlabel('Time (sec)'); ylabel('Trial #')

%%
for i=1:length(t2)
    line([t2(i) t2(i)], [1 2])
end
%Figure 17.1

%283
raster=zeros(47,401); %Initialize raster matrix
edges=[-1:.005:1]; %Define bin edges
for j=1:47 %Loop over all trials
            %Count how times fall in each bin
    raster(j,:)=histc(spike(j).times,edges);
end
figure %Create figure for plotting
imagesc(~raster ) %'B' inverts 0s and 1s
colormap('gray') %Zero plotted as black, one as white

figure %not in chapter
%284
edges = [-1:0.1:1]; %Define the edges of the histogram
peth = zeros(21,1); %Initialize the PETH with zeros
for j=1:47 %Loop over all trials
    %Add current trial's spike times
    peth =peth+histc(spike(j).times,edges);
end
bar(edges,peth); %Plot PETH as a bar graph
xlim([-1.1 1]) %Set limits of X-axis
xlabel('Time (sec)') %Label x-axis
ylabel('# of spikes') %Label y-axis
%Figure 17.2

figure %not in chapter
%285
x = 1:20; %Create a vector with 20 elements
y = x; %Make y the same as x
z = randn(1,20); %Create a vector of random numbers with same dimensions as x
y = y + z ; %Add z to y, introducing random variation
plot(x,y, '.' ) %Plot the data as a scatter plot
xlabel('Luminance')
ylabel('Firing rate')
%Figure 17.4

%286
p=polyfit(x,y,1) %Fits data to a linear 1st degree polynomial

hold on %Allows 2 plots of the same graph
yFit = x*p(1)+p(2); %Calculates fitted regression line
plot(x,yFit) %Plots regression

predictor=[x' ones(20,1)]; %Bundle predictor variables together into a matrix
p=regress(y',predictor) %Perform regression
yFit=predictor*p; %Calculate fit values

x = 0 : 0.1 : 30; %Create a vector from 0 to 10 in steps of 0.1
y = cos (x); %Take the cosine of x, put it into y
z = randn(1,301); %Create random numbers, put it into 301 columns
y = y+ z; %Add the noise in z to y
figure %Create a new figure
plot (x,y) %Plot it

%%
%287
mystring = 'p(1)+p(2)*cos(theta-p(3))'; %Cosine function in string form

myfun = inline(mystring, 'p', 'theta' ); %Converts string to a function

p= nlinfit(x, y, myfun, [1 1 0] ); %Least squares curve fit to inline function “myfun”

%p = nlinfit(x, y, @myfun, [1 1 0] ); %Least squares curve fit to function “myfun.m”

hold on %Allows 2 plots of the same graph
yFit = myfun(p,x); %Calculates fitted regression line
plot(x,yFit,'k') %Plots regression
%Figure 17.5

predictor=[ones(301,1) sin(x)' cos(x)']; %Bundle predictor variables
p=regress(y',predictor) %Linear regression
yFit=predictor*p; %Calculate fit values
theta=atan2(p(2),p(3)); %Find preferred direction from fit weights

%%
%Project

%Similar to Figure 17.6
neuronNum=129;
Chap17_RasterPlot(neuronNum)

%Similar to Figure 17.7
Chap17_PETH(neuronNum)

%Fit a tuning curve
Chap17_TuningCurve(neuronNum)