% read_config_factors.m reads the file config_factors.txt containing the
% information about input parameters to the model selection algorithm
% (factors), their levels and settings.
%
% Copyright (c) 2015-2016, Imperial College London 
% All rights reserved.

function [factor_names, factor_settings] = read_config_factors(config_factors)


fileID = fopen(config_factors,'r');

%Read names of inputs (factors)
lines = textscan(fileID,'%s %*[^\n]');
factor_names = lines{1,1};

%scan from the beginning of the file to get factor settings

frewind(fileID);

formatSpec = '%*s %f %f %f';

settings = textscan(fileID, formatSpec,'CollectOutput',1);

factor_settings = settings{1,1};

fclose(fileID);


end