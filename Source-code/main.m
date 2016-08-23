% main.m:
% 1) Reads content of configuration files config_main.txt,
% config_factors.txt to obtain input data;
% 2) Reads cell array saved in modelstorage.mat to load the latest previous model of the application performance;
% 3) Creates initial application model;
% 4) Calls other functions (via routines budget_constrained or budget_unconstrained) to obtain ultimate model;
% 5) Saves/exports the model into the cell array in modelstorage.mat (this step is implemented but commented out, see user manual for more info);
% 6) Calls anomaly_detection function to obtain information about possible
% anomalies introduced with the new deployment;
% 7) Generates report (currently short messages printed into report*.txt file, where * denotes the version of the application);
%
% Copyright (c) 2015-2016, Imperial College London 
% All rights reserved.


% Oryxtime.mat contains 32 observations (full factorial 2-level design for
% 5 factors) of the batch processing time obtained via running an
% open-source Machine Learning application Oryx 2. Factors and their settings used to obtain these 32 data points
% are provided in the file config_factors.txt. In the current implementation (the tool is not
% integrated into DICE framework (i.e. no application under development to
% run) and no communication with the monitoring platform), choosing a value from this dataset simulates
% running and experiment over application under test and then collecting monitoring data. For more information see user manual.


load('Oryxtime.mat');
load('modelstorage.mat')


% Obtain input data from configuration files
config_main = 'config_main.txt';

all_content = read_config_main(config_main);

Metric = all_content{1,1};
Budget_constr = all_content{1,2};
N_budget = all_content{1,3};
Mode = all_content{1,4};
R2 = all_content{1,5};
p_val_thresh = all_content{1,6};
version_to_compare = all_content{1,7};

% Load application model created at the deployment n-1 (in general, it can
% be any previous version. The version number is stored for every model and
% can be provided as a parameter for model retrieval in config_main).

Model_n_1 = model_to_compare(model_storage,version_to_compare);

% Obtain factor names and settings (for now - from config file, but when
% integrated with CI tool, can be supplied by it)
[factor_names, factor_settings] = read_config_factors('config_factors.txt');

%Total number of factors
F_total = length(factor_names);

%Count factor levels. This count will be used to create normalised levels:
%e.g. if count_levels for given factor = 2, then sequential model selection
%algorithm will assign [-1; 1] levels to this factor. If count_levels = 3,
%then [-1;0;1] and so on.
count_levels = normalise_settings(factor_settings);



% FIRST STEP
% Create initial model (please refer to the deliverable D4.3 for more
% information)

[Rsq_init, p_val, Terms_indicator, Terms_names, Terms_matrix, coeffs_value, Init_set, Exp] = initial_model(Oryx_time);
                                         
% MAIN ALGORITHM
% Sequential model selection

if strcmpi(Budget_constr,'no') == true
    
    [Rsq, coeffs_value, Terms_names, p_val_new] = budget_unconstrained(Init_set, Exp, F_total, R2, Rsq_init, p_val, p_val_thresh, Terms_indicator, Terms_matrix, Oryx_time);
    
elseif strcmpi(Budget_constr,'yes') == true
    
    [Rsq, coeffs_value, Terms_names, p_val_new] = budget_constrained(Init_set, Exp, N_budget, F_total, R2, Rsq_init, p_val, p_val_thresh, Terms_indicator, Terms_matrix, Oryx_time);
    
end

% Clean up model (remove all 'noise' terms). 

k=1;

for i=1:length(p_val_new)
    
    if p_val_new(i) <= p_val_thresh
        
        coeffs_new(k) = coeffs_value(i);
        pval_new(k) = p_val_new(i);
        k=k+1;
        
    end
    
end

% Export model into the 'repository'

%Append new model to the end of the cell array model_storage
model_storage{end+1,1}{1,1} = Terms_names;
model_storage{end,1}{2,1} = coeffs_new;
% Current version
model_storage{end,1}{3,1} = length(model_storage);

version = length(model_storage);

%save('modelstorage.mat','model_storage');

%ANOMALY DETECTION

% Function compares two models: one of the previous models requested by the developer 
% (via providing version number through config_main.txt
% to the most recent trained model. However, the more general
% functionality of comparing two previous versions to each other can also be implemented 
% (developer would need to supply another version of a model from the model_storage
% and it will be used as an input to anomaly_detection).
anomaly_detection(Model_n_1, model_storage{end,1},version,factor_names);


