% normalise_settings.m reads the variable factor_settings containing the
% information about the levels for each of the factors and counts them.
% This information is then used in the main algorithm to form design
% matrices (used in the model selection algorithm)
%
% Copyright (c) 2015-2016, Imperial College London 
% All rights reserved.

function count_levels = normalise_settings(factor_settings)

for i=1:length(factor_settings)

count_levels(i) = sum(~isnan(factor_settings(i,:)));

end


end