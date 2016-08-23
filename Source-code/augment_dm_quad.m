% augment_dm_quad.m is a part of the sequential model selection algorithm.
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

function [Factor_matrix_new, DM_quad_new] = augment_dm_quad(DM_quad, Terms_matrix_quad, nrows)

[~,F] = size(Terms_matrix_quad);

[~, DM_cand] = candgen(F, Terms_matrix_quad);

[ind_row,~] = find(~(DM_cand(:,2:F+1)));

ind_quad = unique(ind_row);

DM_cand_new = DM_cand(ind_quad,:);

add_row = candexch(DM_cand_new, nrows,'start',DM_quad);

DM_quad_new = [DM_quad; 
               DM_cand_new(add_row,:)];
           
Factor_matrix_new = DM_quad_new(:,2:F+1);


end