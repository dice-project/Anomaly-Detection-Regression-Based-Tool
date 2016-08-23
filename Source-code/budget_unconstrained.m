% budget_constrained.m is a high-level routine executing the model
% selection algorithm when the budget (number of experiments a developer
% can run on the application to obtain observation points for the model
% fitting) is not limited (parameter Budget_constr in config_main.txt is 'No')
%
% Copyright (c) 2015-2016, Imperial College London 
% All rights reserved.


function [Rsq, coeffs_value, Terms_names, p_val] = budget_unconstrained(Init_set, Exp, F_total, R2, Rsq, p_val, p_val_thresh, Terms_indicator, Terms_matrix, y_predicted)

[N, F] = size(Init_set);

Terms_matrix_prev = Terms_matrix;

Factor_matrix_prev = Init_set;

n_levels = 2;

Exp_prev = Exp;

DM_prev = Init_set;


while F <= F_total


    if (((Rsq < R2) && all(p_val(2:end) > p_val_thresh)) || ((Rsq > 0.98) && any(p_val(2:end) < p_val_thresh)) || ((Rsq < R2) && any(p_val(2:end) < p_val_thresh)) || ((Rsq > R2) && all(p_val(2:end) > p_val_thresh))) && (Terms_indicator == 0)
        
        Case_fit = 1;
        
    elseif (((Rsq < R2) && all(p_val(2:end) > p_val_thresh)) || ((Rsq > 0.99) && any(p_val(2:end) < p_val_thresh)) || ((Rsq < R2) && any(p_val(2:end) < p_val_thresh)) || ((Rsq > R2) && all(p_val(2:end) > p_val_thresh))) && (Terms_indicator == 1) && (n_levels == 3)
        
        Case_fit = 2;     
        
    elseif (((Rsq < R2) && all(p_val(2:end) > p_val_thresh)) || ((Rsq > 0.98) && any(p_val(2:end) < p_val_thresh)) || ((Rsq < R2) && any(p_val(2:end) < p_val_thresh)) || ((Rsq > R2) && all(p_val(2:end) > p_val_thresh))) && (Terms_indicator == 1 || Terms_indicator == 2) 
        
        Case_fit = 3;
        
    elseif (((Rsq > R2 && Rsq < 0.98) && any(p_val(2:end) < p_val_thresh)) && (Terms_indicator == 0 || Terms_indicator == 1 || Terms_indicator == 2))
        
        Case_fit = 4;
                   
    end





    if Case_fit == 1
        
        % Add linear interactions (new design matrix with linear terms, but
        % no additional runs)
        [DM_linear, Terms_matrix_linear] = add_linear(Factor_matrix_prev, Terms_matrix_prev);
        
        % LASSO + DS + fitlm
        
        [Rsq, p_val, coeffs_value, Terms_names] = lasso_ds_fitlm(Factor_matrix_prev, DM_linear, Terms_matrix_linear, Exp_prev, R2);
        
        Terms_indicator = 1;
        
        Terms_matrix_prev = Terms_matrix_linear;
        
        DM_prev = DM_linear;
        
        
    
    elseif Case_fit == 2

        N = N + 1;
        
        % Add squared terms (augment design matrix) +1 run with the 3rd
        % level
        
        [DM_quad, Terms_matrix_quad] = add_quadratic(Factor_matrix_prev, Terms_matrix_prev);
        
        [Factor_matrix_new, DM_quad_new] = augment_dm_quad(DM_quad, Terms_matrix_quad, 1);
        
        % Run experiment to obtain an observation
    
           Exp = experiment(Factor_matrix_new(end,:),y_predicted);
           
           Exp_new = [Exp_prev;
                      Exp];
 
        
        % LASSO + DS + fitlm
        
        [Rsq, p_val, coeffs_value, Terms_names] = lasso_ds_fitlm(Factor_matrix_new, DM_quad_new, Terms_matrix_quad, Exp_new, R2);
        
        Terms_indicator = 2;
        
        DM_prev = DM_quad_new;
        
        Terms_matrix_prev = Terms_matrix_quad;
        
        Factor_matrix_prev = Factor_matrix_new;
        
        Exp_prev = Exp_new;
        
       
        
    elseif Case_fit == 3

        N = N + 1;
        
        % Add more runs (augment design matrix, run experiment), do not add new terms
        [Factor_matrix_new, DM_new] = augment_dm_any(DM_prev, Terms_matrix_prev, 1);
        
        Exp = experiment(Factor_matrix_new(end,:),y_predicted);
           
        Exp_new = [Exp_prev;
                   Exp];
        
        
        % LASSO + DS + fitlm
        
        [Rsq, p_val, coeffs_value, Terms_names] = lasso_ds_fitlm(Factor_matrix_new, DM_new, Terms_matrix_prev, Exp_new, R2);
        
        Terms_indicator = 2;
        
        DM_prev = DM_new;
        
        Factor_matrix_prev = Factor_matrix_new;
        
        Exp_prev = Exp_new;
               
        
    elseif Case_fit == 4

        N = N + 1;
        F = F + 1;
        
        if F > F_total
        
            break
            
        else
        
            % Add one more factor and one more run
        
            % Extend factor matrix, run one more experiment
            [Factor_matrix_new, DM_new, Terms_matrix_new] = add_factor(Factor_matrix_prev, Terms_matrix_prev);
        
            Exp = experiment(Factor_matrix_new(end,:),y_predicted);
        
            Exp_new = [Exp_prev;
                       Exp];
               

                   
            [Rsq, p_val, coeffs_value, Terms_names] = lasso_ds_fitlm(Factor_matrix_new, DM_new, Terms_matrix_new, Exp_new, R2);
                 
            Terms_indicator = 0;
        
            Exp_prev = Exp_new;
        
            Factor_matrix_prev = Factor_matrix_new;
        
            Terms_matrix_prev = Terms_matrix_new;
        
            DM_prev = DM_new; 
        
        end
            
   end


end

end