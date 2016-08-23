% add_factor.m is a part of the sequential model selection algorithm. It is
% used when algorithm chooses the action to add a new factor to the
% currently fitted model (instead of trying to improve the fit further).
%
% Copyright (c) 2015-2016, Imperial College London 
% All rights reserved.

function [Factor_matrix_new, DM_new, Terms_matrix_new] = add_factor(Factor_matrix, Terms_matrix_prev)

[N,Ff] = size(Factor_matrix);

Factor_matrix_add = [Factor_matrix -1*ones(N,1)];

New_term = zeros(1,Ff+1);

New_term(1,end) = 1;


[N_terms,~] = size(Terms_matrix_prev);

zeros_before_term = Ff+1;

zeros_after_term = N_terms - Ff - 1;


Terms_matrix_add = [[Terms_matrix_prev(1:Ff+1,:) zeros(zeros_before_term,1)];
                New_term;
                [Terms_matrix_prev(Ff+2:end,:) zeros(zeros_after_term,1)]];

[~, DM_cand] = candgen(Ff+1, Terms_matrix_add);

DM_add = x2fx(Factor_matrix_add,Terms_matrix_add);

add_row = candexch(DM_cand, 1,'start',DM_add);

DM_new = [DM_add; 
          DM_cand(add_row,:)];
      
Terms_matrix_new = Terms_matrix_add;
           
Factor_matrix_new = DM_new(:,2:Ff+2);





end