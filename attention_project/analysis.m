
filename = "KBY_nogrid_1input_10-Nov-2022 13:22:47_session_data.csv";
data = readtable(filename);

% Valid/Invalid 
%{
valids = data(1:640, :);
valids = valids(:,7);
valids = table2array(valids);
invalids = data(640:1280, :);
invalids = invalids(:,7);
invalids = table2array(invalids);
[h,p] = ttest2(valids, invalids)
%}

