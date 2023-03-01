clc; clear;

load("Chap17_SpikeSorting.mat"); % Load session

wf1 = session(1).wf;
wf2 = session(2).wf;
stamps1 = session(1).stamps;
stamps2 = session(2).stamps;

[coeff, score, latent] = pca(double(wf1)); % LATENT contains eigenvectors

%% Plot Varience Explained
z = [0];
a = latent/sum(latent);
for i = 1:47
    temp = z(i) + a(i);
    z = [z temp];
end
figure()
plot(z, 'k--')
hold on
scatter(1:48, z, 'black')
xlabel('Dimensions Taken')
ylabel('Percentage of Variation Explained')

% Alternatively, we could use pcacov, which performs pca on covariance
% matrix, so we would need to give covariance matrix to it
%[x, y, z] = pcacov(cov(double(wf1)));

%% Histogram of PCA space
edges{1} = [-300:10:300];
edges{2} = [-250:10:250];
figure()
h = hist3(score(:,1:2),edges);
s = surface(h');
set(s,'XData',edges{1})
set(s,'YData',edges{2})
xlabel('PCA Axis 1')
ylabel('PCA Axis 2')
zlabel('Counts')

%% Find and Plot templates
centre1 = [12.5 75]; radius1 = 65; centre1_points = [];
centre2 = [87.5 -67.5]; radius2 = 37.5; centre2_points = [];

imp = score(:,1:2);
for i = 1:length(imp)
    if norm(imp(i,:) - centre1) < radius1 % with norm, we calculate euclidean distance
        centre1_points = [centre1_points; score(i,:)];
    elseif norm(imp(i,:) - centre2) < radius2
        centre2_points = [centre2_points; score(i,:)];
    end
end

points = centre1_points * transpose(coeff);
points2 = centre2_points * transpose(coeff);
figure()
plot(mean(points,1))
hold on
plot(mean(points2,1))
grid on
xlabel('Channel Number')
ylabel('Mean Voltage (mV)')

% Plot of all (or some) waveforms and their template
tmp = centre1_points';
figure()
plot(tmp(:,1:200), 'k')
hold on
plot(mean(points,1), 'b')
grid on
xlabel('Channel Number')
ylabel('Mean Voltage (mV)')

%% RMSE
centre1_rmse = rmse(double(centre1_points), mean(points,1), 2);
wf1_rmse = rmse(double(wf1), mean(points,1), 2);

%% Day 2 Projection
proj_wf2 = double(wf2)*coeff;

% Histogram
edges{1} = [-300:10:300];
edges{2} = [-250:10:250];
figure()
h = hist3(proj_wf2(:,1:2),edges);
s = surface(h');
set(s,'XData',edges{1})
set(s,'YData',edges{2})
xlabel('PCA Axis 1')
ylabel('PCA Axis 2')
zlabel('Counts')

centre1_points_2 = []; centre2_points_2 = [];

imp = score2(:,1:2);
for i = 1:length(imp)
    if norm(imp(i,:) - centre1) < radius1 % with norm, we calculate euclidean distance
        centre1_points_2 = [centre1_points_2; score2(i,:)];
    elseif norm(imp(i,:) - centre2) < radius2
        centre2_points_2 = [centre2_points_2; score2(i,:)];
    end
end

points_2 = centre1_points_2 * transpose(coeff);
points2_2 = centre2_points_2 * transpose(coeff);
figure()
plot(mean(points_2,1), 'b--')
hold on
plot(mean(points2_2,1), 'r--')

% Day 2 own pca
[coeff2, score2, latent2] = pca(double(wf2));

centre1_points_2_2 = []; centre2_points_2_2 = [];
centre1_2 = [60 10]; radius1_2 = 30;
centre2_2 = [-160 30]; radius2_2 = 30;

imp = score2(:,1:2);
for i = 1:length(imp)
    if norm(imp(i,:) - centre1_2) < radius1_2 % with norm, we calculate euclidean distance
        centre1_points_2_2 = [centre1_points_2_2; score2(i,:)];
    elseif norm(imp(i,:) - centre2_2) < radius2_2
        centre2_points_2_2 = [centre2_points_2_2; score2(i,:)];
    end
end

points_2_2 = centre1_points_2_2 * transpose(coeff2);
points2_2_2 = centre2_points_2_2 * transpose(coeff2);
plot(mean(points_2_2,1), 'b')
plot(mean(points2_2_2,1), 'r')
grid on
xlabel('Channel Number')
ylabel('Mean Voltage (mV)')