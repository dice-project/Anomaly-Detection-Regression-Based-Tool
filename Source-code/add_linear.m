% add_linear.m is a part of the sequential model selection algorithm. It is
% used when algorithm chooses to add linear interactions to the current model trying to improve model's fit to the data.
%
% Copyright (c) 2015-2016, Imperial College London 
% All rights reserved.

function [DM_linear, Terms_matrix_new] = add_linear(Factor_matrix, Terms_matrix_prev)

[~, F] = size(Factor_matrix);

Terms_matrix = [];

% Create new Design and Terms matrices (with linear interactions)

for j=2:F
        
        % Find indices of variables in new terms
        
        Indices = nchoosek(1:F,j);
        [r,~] = size(Indices);
        
        Terms_matrix_new = zeros(r,F);
        
        k = 1;
        
        % Create terms matrix for the terms of j-th order
        
        for k=1:r
            
            Terms_matrix_new(k,Indices(k,:)) = 1;
            
        end
        
        % Append Terms matrix of j-th order to the Terms matrix of j-1-th
        % order
        
        Terms_matrix_inter = [Terms_matrix;
                               Terms_matrix_new];
                           
        Terms_matrix = Terms_matrix_inter;
        
         
end

                
% Find intersection, find unique rows in Terms_matrix and append them to the Terms_matrix_prev

[Intersection_T, ~, ~] = intersect(Terms_matrix_prev,Terms_matrix,'rows');

[~, ~, ib_Xor_T] = setxor(Intersection_T,Terms_matrix,'rows');

% Add unique columns of DM_new to DM_prev

Terms_matrix_new = [Terms_matrix_prev;
                    Terms_matrix(ib_Xor_T,:)];
                
                
% New design matrix
DM_linear = x2fx(Factor_matrix, Terms_matrix_new);               





end