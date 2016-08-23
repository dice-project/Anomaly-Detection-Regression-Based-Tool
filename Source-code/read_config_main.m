% read_config_main.m reads config_main.txt file to obtain input parameters
% to the tool.
%
% Copyright (c) 2015-2016, Imperial College London 
% All rights reserved.


function all_content = read_config_main(config_main)

%[Metric, Budget_constr, Budget, Mode, R2, p_value] = read_config_main(config_main)

fileID = fopen(config_main,'r');

formatSpec = 'Metric=%s Budget_constr=%s Budget=%d Mode=%s R2=%f p_value=%f version_to_compare=%f';

all_content = textscan(fileID,formatSpec,'Delimiter', '\n');

fclose(fileID);


end

