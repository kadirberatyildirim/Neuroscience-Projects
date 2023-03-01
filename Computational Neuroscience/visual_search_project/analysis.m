
% Remove header
%sess_data(1,:) = [];

% Check how many of each trial has beed done by subject
disp("Total pop-out trials: " + string(length(find(sess_data(:,1) == "Pop-out"))))
disp("Total conjunction trials: " + string(length(find(sess_data(:,1) == "Conjunction"))))
disp("Total no-target trials: " + string(length(find(sess_data(:,1) == "No-target"))))

% Separate trials and take only the correct ones
pops = sess_data(find(sess_data(:,1) == "Pop-out"),:);
true_pops = pops(find(pops(:,4) == "Target"),:);
conj = sess_data(find(sess_data(:,1) == "Conjunction"),:);
true_conj = conj(find(conj(:,4) == "Target"),:);
no = sess_data(find(sess_data(:,1) == "No-target"),:);
true_no = no(find(no(:,4) == "No-target"),:);

% Calculate means
pop_means = []; conj_means = []; no_means = [];
for i=1:4
    p = true_pops(find(true_pops(:,2) == string(i*4)),:);
    pop_means(end+1,:) = mean(str2double(p(:,3)));
    c = true_conj(find(true_conj(:,2) == string(i*4)),:);
    conj_means(end+1,:) = mean(str2double(c(:,3)));
    n = true_no(find(true_no(:,2) == string(i*4)),:);
    no_means(end+1,:) = mean(str2double(n(:,3)));
end

% Calculate Pearson Correlation
set_sizes = [4 8 12 16];
[r, p] = corrcoef(pop_means, set_sizes);
disp("Pearson correlation between Pop-out and set sizes: " + string(r(2)))
disp("P value regarding this correlation: " + string(p(2)))
[r, p] = corrcoef(conj_means, set_sizes);
disp("Pearson correlation between Conjunction and set sizes: " + string(r(2)))
disp("P value regarding this correlation: " + string(p(2)))
[r, p] = corrcoef(no_means, set_sizes);
disp("Pearson correlation between No-target and set sizes: " + string(r(2)))
disp("P value regarding this correlation: " + string(p(2)))

t = polyfit(set_sizes, pop_means, 1);
disp("Slope of mean times for Pop-out trials: " + string(t(1)))
t = polyfit(set_sizes, conj_means, 1);
disp("Slope of mean times for Conjunction trials: " + string(t(1)))
t = polyfit(set_sizes, no_means, 1);
disp("Slope of mean times for No-target trials: " + string(t(1)))

% Plots
sp1 = subplot(2,1,1);
plot(set_sizes, pop_means)
hold on
plot(set_sizes, conj_means)
%ylim([0.5 0.6])
legend("Pop-out", "Conjunction")
xlabel("Set size")
ylabel("RT")

sp2 = subplot(2,1,2);
target_means = (pop_means + conj_means)/2;
plot(set_sizes, no_means)
hold on
plot(set_sizes, target_means)
%ylim([0.5 0.8])
legend("No-target", "Target")
xlabel("Set size")
ylabel("RT")


