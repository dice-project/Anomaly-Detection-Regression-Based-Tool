% add_quadratic.m is a part of the sequential model selection algorithm. It is
% used when algorithm chooses to add quadratic interactions to the current
% model (if the factor has more than 2 levels), trying to improve model's fit to the data.
%
% Copyright (c) 2015-2016, Imperial College London 
% All rights reserved.

function   [DM_new, Terms_matrix_new] = add_quadratic(Factor_matrix, Terms_matrix_prev)


[~,F] = size(Factor_matrix);

Array_1 = 1:F;
Array_2 = F+1:2*F;

% Add squared main effects to the Terms matrix

Terms_quad_main = diag(2*ones(1,F));

Terms_matrix_quad = [Terms_matrix_prev;
                     Terms_quad_main];

Terms_matrix = zeros(1,F);

% Create new Design and Terms matrices (with quadratic interactions)

for j=2:2*F

        % Find indices of variables in new terms
        
        Indices = nchoosek([Array_1 Array_2],j);
        
        % Filter out columns in DM (and rows in terms matrix) where a linear term is
        % multiplied by its squared term.
        
        [filter,~] = size(Indices);
        
        g=1;
        f=1;
        z=1;
        repetitions=[];
        
        for g=1:filter
        
        for f=1:F
        
           if any(Indices(g,:)==Array_1(f)) && any(Indices(g,:)==Array_2(f))
        
               repetitions(z) = g;
               z = z + 1;  
               
           end
                  
        end
                  
        end
        
        [Indices_filtered,~,~] = setxor(Indices, Indices(repetitions,:),'rows','stable');
        
        % Write terms into the Terms_matrix
                
        [r,d] = size(Indices_filtered);
        
        Terms_matrix_new = zeros(r,F);
        
        k = 1;
        
        % Create terms matrix for the terms of j-th order
        
        for k=1:r
            
            for b=1:d
                
                if Indices_filtered(k,b) > F
                    
                   pos = find(Array_2==Indices_filtered(k,b)); 
            
                   Terms_matrix_new(k,pos) = 2;
                   
                else
                    
                   Terms_matrix_new(k,Indices_filtered(k,b)) = 1;
                    
                end
            
            end
            
        end
        
        % Append Terms matrix of j-th order to the Terms matrix of j-1-th
        % order
        
        Terms_matrix_inter = [Terms_matrix;
                              Terms_matrix_new];
                           
        Terms_matrix = Terms_matrix_inter;
        
         
end


                
% Find intersection, find unique rows in Terms_matrix and append them to the Terms_matrix_prev (similar to Design matrix above)

[Intersection_T, ~, ~] = intersect(Terms_matrix_quad,Terms_matrix,'rows');

[~, ~, ib_Xor_T] = setxor(Intersection_T,Terms_matrix,'rows');

% Add unique columns of DM_new to DM_prev

Terms_matrix_new = [Terms_matrix_quad;
                    Terms_matrix(ib_Xor_T,:)];
                
                
DM_new = x2fx(Factor_matrix,Terms_matrix_new);

end