% augment_dm_any.m is a part of the sequential model selection algorithm.
% It is used to find a combination of factor settings that would result in
% obtaining the observation (after running an application with these
% settings) carrying maximum information (the best for using in model
% fitting). Currently the default is to obtain one combination of settings
% (i.e. to run one experment at each step of the model selection process) - nrows = 1, 
% but nrows can be increased by the developer (general rule: the more data points available
% for model fitting - the better, but more 'expensive').
%
% Copyright (c) 2015-2016, Imperial College London 
% All rights reserved.

function [Factor_matrix_new, DM_new] = augment_dm_any(DM_prev, Terms_matrix_prev, nrows)

[~,F] = size(Terms_matrix_prev);

[~, DM_cand] = candgen(F, Terms_matrix_prev);

add_row = candexch(DM_cand, nrows,'start',DM_prev);

DM_new = [DM_prev; 
          DM_cand(add_row,:)];
           
Factor_matrix_new = DM_new(:,2:F+1);


end