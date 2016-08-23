% experiment.m simulates two steps that will be implemented during the
% integration with other DICE tools:

% 1) Running application with the given combination of settings (e.g. configuration
% settings, virtual resources allocated and so on). This functionality will
% be carried out by the DICE CI tool (most likely deployment and testing
% tools);

% 2) Obtaining and parsing the data collected by the monitoring platform
% (D-Mon) during the application run.

% r_x - combination of settings and their values that should be passed to the CI tool
% y_predicted (will be deprecated after the integration) - imports the set of observations stored in the Oryxtime.mat, 
%                                                          from which one relevant 'experiment result' will be picked up 
%                                                          to be used in fitting the model
%
% Copyright (c) 2015-2016, Imperial College London 
% All rights reserved.

function y = experiment(r_x, y_predicted)

Candset = ff2n(5);
Candset(Candset==0) = -1;

[m,n] = size(Candset);

if length(r_x) < n
    
    r_x = [r_x -1*ones(1,n-length(r_x))];
    
end

for i=1:m
    
    if isequal(r_x,Candset(i,:)) == true
        
        y = y_predicted(i);
        
    end
    
    
end


end