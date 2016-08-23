% model_to_compare.m extracts from the model storage (cell array) a performance model
% to which application at current deployment will be compared after new
% model is trained.
%
% Copyright (c) 2015-2016, Imperial College London 
% All rights reserved.


function model = model_to_compare(model_storage,version_to_compare)

for i=1:length(model_storage)
    
    if isequal(model_storage{i,1}{3,1},version_to_compare)==1
    
    model = model_storage{i,1};
    
    end   
    
end


end