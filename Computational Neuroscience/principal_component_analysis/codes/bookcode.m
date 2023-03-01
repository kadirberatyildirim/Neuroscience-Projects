clc;clear;
%% Simulating Data
n = 500;
a(:,1) = normrnd(0,1,n,1);
a(:,2) = normrnd(0,1,n,1);
b(:,1) = normrnd(0,1,n,1);
%n = number of datapoints
%n random Gaussian values with mean 0, std. dev. 1
%Repeat for the 2nd dimension.
%n random Gaussian values with mean 0, std. dev. 1
%For b, the 2nd dimension is correlated with the 1st
b(:,2) = b(:,1)*0.5 + 0.5*normrnd(0,1,n,1);

%% 
var(a(:,1)) %Compute sample variance of 1st dim of "a"
c = a(:,1)-mean(a(:,1)); %Subtract mean from 1st dim of "a"
c'*c/(n-1) %Compute sample variance of 1st dim of "a"
%Note the apostrophe denoting transpose(c)
%% 
cov(a)
 %Compute the covariance matrix for "a"
c = a-repmat(mean(a),n,1); %Subtract the mean from "a"
c'*c/(n-1)
 %Compute the covariance matrix for "a"
 %% 
sigma = cov(b)
%Compute the covariance matrix of b
%Generate new zero-mean noise with the same covariance matrix
b2 = mvnrnd([0 0],sigma,n);
%% Principal Components
[V, D] = eig(sigma) %V = eigenvectors, D = eigenvalues for covariance matrix sigma
plot(b(:,1),b(:,2),'b.'); hold on
 %Plot correlated noise
plot(3*[-V(1,1) V(1,1)],3*[-V(1,2) V(1,2)],'k') %Plot axis in direction of 1st eigenvector
plot(3*[-V(2,1) V(2,1)],3*[-V(2,2) V(2,2)],'k') %Plot axis in direction of 2nd eigenvectorplot(b(:,1),b(:,2),'b.'); hold on
 %Plot correlated noise
plot(3*[-V(1,1) V(1,1)],3*[-V(1,2) V(1,2)],'k') %Plot axis in direction of 1st eigenvector
plot(3*[-V(2,1) V(2,1)],3*[-V(2,2) V(2,2)],'k') %Plot axis in direction of 2nd eigenvector

V2(:,1) = V(:,2);
V2(:,2) = V(:,1);
newB = b*V2; %Place the 1st principal component in the 1st row
%Place the 2nd principal component in the 2nd row
%Project data on PC coordinates

[coeff,score,latent] = pca(b); %Compute principal components of data in b

%% Spike Sorting
wf=session(2).chan48; %Load waveforms
plot(wf(:,1:200));
%Plot 200 waveforms.
%Princomp doesn't work on integers, so convert to double
[coeff,score,latent]=pca(double(wf'));
plot(score(:,1),score(:,2),'.','MarkerSize',1)

edges{1} = [-300:25:300];
edges{2} = [-250:25:250];
h = hist3(score(:,1:2),edges);
s = surface(h');
set(s,'XData',edges{1})
set(s,'YData',edges{2})
%Bins for the X-axis
%Bins for the Y-axis
%Compute a 2-D histogram
%Visualize the histogram
%Label the X-axis
%Label the Y-axisW