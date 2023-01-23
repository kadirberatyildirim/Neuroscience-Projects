% Load the neuron activity data
neuron_activity = load('Chapter21_CenterOutTest.mat');

% Preprocess the data as needed
neuron_activity = remove_noise(neuron_activity);
neuron_activity = normalize(neuron_activity);

% Estimate the tuning curves for each neuron
tuning_curves = estimate_tuning_curves(neuron_activity);

% Compute the population vector at each time point
num_time_points = size(neuron_activity, 2);
population_vector = zeros(num_time_points, 1);
for t = 1:num_time_points
  population_vector(t) = sum(tuning_curves .* neuron_activity(:, t));
end

% Decode the stimulus presented to the animal
stimuli = load('stimuli.mat');
predictions = decode_stimulus(population_vector, stimuli);