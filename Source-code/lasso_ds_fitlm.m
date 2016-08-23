% lasso_ds_fitlm.m implements model selection algorithm (for more information see deliverable D4.3). 
%
% Copyright (c) 2015-2016, Imperial College London 
% All rights reserved.


function [Rsq, p_val, coeffs_value, Terms_names] = lasso_ds_fitlm(Factor_matrix, DM_prev, Terms_matrix_prev, Exp_prev, FIT)


% Transform DM_prev into orthonormal matrix (DS accepts orthonormal matrix as
% input)

[m,n] = size(DM_prev);


% Dantzig selector algorithm was developed for orthogonal (and orthonormal)
% matrices. Normalised designed matrices used in the model selection are
% not orthogonal, therefore need to be transformed first.
if m == n
    
X_DS = DM_prev;
X_norm_DS = X_DS./sqrt(m);
[X_orth_DS, ~] = qr(X_norm_DS);
    
else

X_DS = DM_prev;
X_norm_DS = X_DS./sqrt(m);
Xt = X_norm_DS';
[X_orth_DS, ~] = qr(Xt,0);
X_orth_DS = X_orth_DS';

end

% Initial guess ( x = A\B)
in_guess = X_DS\Exp_prev;  

% Transform observations (if matrix A is transformed, then, in order to
% keep coefficients in x scaled correctly, observations in vector B should
% also be transformed).

Data_transf = X_orth_DS*in_guess;

% Run LASSO to obtain set of Lambdas for DS 
[~, fitinfo] = lasso(X_DS,Exp_prev,'CV',m);

Lambda = fitinfo.Lambda;



% Run Dantzig selector for each Lambda from LASSO to obtain set of
% solutions (each solution is a vector of model terms)

for i=1:length(Lambda)

betas_DS(:,i)  = l1dantzig_pd_mod(in_guess, X_orth_DS, [], Data_transf, Lambda(i), 1e-5, 30);

end


%Then fitlm with non-zero effects (or N_experiments-1 largest effects, if N of non-zero
%effects is larger than N_experiments-1)


for i=1:length(Lambda)
    
    Non_zero_DS_ind = find(betas_DS(:,i) > 1e-04 | betas_DS(:,i) < -1e-04);
    
    Non_zero_DS = betas_DS(Non_zero_DS_ind,i);
    
    if length(Non_zero_DS) >= m
    
    
    [~,I] = sort(Non_zero_DS,'descend');
    
    betas_DS_N_1_largest_ind = I(1:m-1);
    
    betas_DS_sort_back_ind = sort(betas_DS_N_1_largest_ind);
    
    NON_ZERO_IND{i} = betas_DS_sort_back_ind;
    
    % Find fit
    lm_DS{i} = fitlm(Factor_matrix, Exp_prev, Terms_matrix_prev(betas_DS_sort_back_ind,:));
    
    else
        
        lm_DS{i} = fitlm(Factor_matrix, Exp_prev, Terms_matrix_prev(Non_zero_DS_ind,:));
        
        NON_ZERO_IND{i} = Non_zero_DS_ind;
        
    end
    
    
end

% Find set of fits

for i=1:length(Lambda)
    
    FIT_DS(i) = lm_DS{1,i}.Rsquared.Adjusted;    
    
end


Rsq_ind = find(FIT_DS >= FIT,1, 'last');

if isempty(Rsq_ind) == false
    
    Rsq = FIT_DS(Rsq_ind);
    
else
    
    [Rsq, Rsq_ind] = max(FIT_DS);
    
end


p_val = lm_DS{1,Rsq_ind}.Coefficients.pValue;
    
    
Non_zero_ind = NON_ZERO_IND{1,Rsq_ind};

Terms_names = lm_DS{1,Rsq_ind}.CoefficientNames';

coeffs_value = lm_DS{1,Rsq_ind}.Coefficients.Estimate;




end