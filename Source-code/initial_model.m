% initial_model.m forms initial subset (2 factors) from the matrix of factors,
% creates a design, runs experiments and fits the linear regression model
% only for main factors.
%
% Copyright (c) 2015-2016, Imperial College London 
% All rights reserved.

function [Rsq_init, p_val, Terms_indicator, Terms_names, Terms_matrix, coeffs_value, Init_set, Exp] = initial_model(y_predicted)

Init_set = ff2n(2);
Init_set(Init_set == 0) = -1;

[n_rows,~] = size(Init_set);

% Run 'experiments' (this part will be replaced after integration)

Exp = zeros(n_rows,1);

for i=1:n_rows
    
    Exp(i,1) = experiment(Init_set(i,:),y_predicted);
    
end

% Fit the model for main factors

lm_init = fitlm(Init_set,Exp,'linear');

% Report fit and other metrics of interest

Rsq_init = lm_init.Rsquared.Adjusted;
p_val = lm_init.Coefficients.pValue(2:end);

coeffs_value = lm_init.Coefficients.Estimate(2:end);

Terms_indicator = 0; % This variable = 0 if only main effect is added to the model from the new factor,
                     % 1 - if linear interactions were added to the model (in addition to main effects),
                     % 2 - if squared terms were added (in addition to main
                     % and linear interactions)
                     
Terms_names = lm_init.Formula.TermNames; % This variable is needed to report ultimately selected terms.
                                         % Needs to be modified (only
                                         % significant terms left) before
                                         % final model is reported/exported

Terms_matrix = [0 0;
                1 0;
                0 1];
                          

end