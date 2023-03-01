clear

popacc = readmatrix('popvec_acc.csv');
maxnorm = readmatrix('maxnorm_acc.csv');
maxpoiss = readmatrix('maxpoiss_acc.csv');

x = 120:150;

plot(x, popacc, 'o--red')
hold on
plot(x, maxnorm, 'o--blue')
plot(x, maxpoiss, 'o--black')
xlabel('Training Size')
ylabel('Accuracy')
legend('Pop Vec', 'MLE (Normal)', 'MLE (Poisson)')