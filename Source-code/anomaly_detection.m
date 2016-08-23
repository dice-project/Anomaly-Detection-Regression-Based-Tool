% anomaly_detection.m compares performance models of two
% applicaton versions in order to detect possible significant changes in
% performance (anomaly or improvement, depending on the direction of
% change).
%
% Copyright (c) 2015-2016, Imperial College London 
% All rights reserved.

function anomaly_detection(model_old,model_new,version, factor_names)

%create file for writing report into
formatSpec = 'report%d.txt';

report = sprintf(formatSpec,version);

fileID = fopen(report,'w');

%close all
x = -1:0.1:1;

%Model n-1
terms_old = model_old{1,1};
coeffs_old = model_old{2,1};

%Model n
terms_new = model_new{1,1};
coeffs_new = model_new{2,1};


%find unique elements in both model_old and model_new
[UNIQUE, ind_mod_old, ind_mod_new] = setxor(terms_old, terms_new, 'stable');

if isempty(UNIQUE)==true
    
    %disp('Models have identical terms')
    UNIQUE_old = [];
    UNIQUE_new = [];
    
elseif isempty(ind_mod_new)==true
    
    UNIQUE_old = terms_old(ind_mod_old);
    UNIQUE_new = [];
    %disp(['Model term(s)' UNIQUE_old  'disappeared from the model'])
    
elseif isempty(ind_mod_old)==true
    
    UNIQUE_new = terms_new(ind_mod_new);
    UNIQUE_old = [];
    %disp(['Model term(s)' UNIQUE_new  'appeared in the model'])
    
else
    
    UNIQUE_old = terms_old(ind_mod_old);
    UNIQUE_new = terms_new(ind_mod_new);
    
    %disp(['Model term(s)' UNIQUE_old  'disappeared from the model, model term(s)' UNIQUE_new  'appeared in the model']) 
   
end


% Compare projections of model terms for significant difference (that
% includes comparing unique model terms with 0)

[COINCIDE, ind_coinc_old, ind_coinc_new] = intersect(terms_old, terms_new, 'stable');

% Compare coinciding model terms for significant difference
hypothesis_c = [];

if isempty(COINCIDE)==false    

for i=2:length(ind_coinc_old) 
        
      % Generate curves (samples) for projections y = f(model_term_i)
      if (length(strfind(terms_old{ind_coinc_old(i),1},'x')) == 1) && (isempty(strfind(terms_old{ind_coinc_old(i),1},'^2')) == true) %projections for main factors
          
          projection_old(i,:) = coeffs_old(ind_coinc_old(i))*x;
          projection_new(i,:) = coeffs_new(ind_coinc_new(i))*x;
          
      elseif length(strfind(terms_old{ind_coinc_old(i),1},'x')) > 1 %projections for interactions
          
          projection_old(i,:) = coeffs_old(ind_coinc_old(i))*x; 
          projection_new(i,:) = coeffs_new(ind_coinc_new(i))*x;
          
      elseif (length(strfind(terms_old{ind_coinc_old(i),1},'x')) == 1) && (isempty(strfind(terms_old{ind_coinc_old(i),1},'^2')) == false)
          
          projection_old(i,:) = coeffs_old(ind_coinc_old(i))*x.^2;
          projection_new(i,:) = coeffs_new(ind_coinc_new(i))*x.^2;
                
      %there also should be condition for interactions of the form x^2:x
      
      end
      
      % Test for significant difference between new and old model terms
      [hypothesis_c(i), ~] = vartest2(projection_old(i,:), projection_new(i,:));
              
end

      %Report anomalies if found
      
      if isempty(find(hypothesis_c==1)) == false
          
          message_anomaly = 'The problem is in %s'; % Phrase message correctly
          
          anomalies_identified_c = model_old{1,1}(ind_coinc_old(hypothesis_c==1),1);
          
          for i=1:length(anomalies_identified_c)
              
              index = sscanf(anomalies_identified_c{i},'%*c%d');
          
          fprintf(fileID, message_anomaly, factor_names{index,1}); 

          % Add if it's improvement or degradation (direction of change)
          
          end
          
      end     

end


%Compare unique model terms to zero: for old model terms that disappeared
%from the model (to discern if their disappearance made the difference)

hypothesis_o = [];

if (isempty(UNIQUE)==false) && (isempty(ind_mod_old)==false)


for i=1:length(ind_mod_old) 
        
      % Generate curves (samples) for projections y = f(model_term_i)
      if (length(strfind(terms_old{ind_mod_old(i),1},'x')) == 1) && (isempty(strfind(terms_old{ind_mod_old(i),1},'^2')) == true) %projections for main factors
          
          projection_old(i,:) = coeffs_old(ind_mod_old(i))*x;
          projection_new(i,:) = zeros(1,length(x));
          
      elseif length(strfind(terms_old{ind_mod_old(i),1},'x')) > 1 %projections for interactions
          
          projection_old(i,:) = coeffs_old(ind_mod_old(i))*x;
          projection_new(i,:) = zeros(1,length(x));
          
      elseif (length(strfind(terms_old{ind_mod_old(i),1},'x')) == 1) && (isempty(strfind(terms_old{ind_mod_old(i),1},'^2')) == false)
          
          projection_old(i,:) = coeffs_old(ind_mod_old(i))*x.^2;
          projection_new(i,:) = zeros(1,length(x));
                
      %there also should be condition for interactions of the form x^2:x
      
      end
      
      % Test for significant difference between old model terms and zero
      [hypothesis_o(i), ~] = vartest2(projection_old(i,:),zeros(1,length(projection_old(i,:))));
            
end

%Report anomalies if found
      
      if isempty(find(hypothesis_o==1)) == false
          
          message_anomaly = 'Disappearance of %s caused anomalous behaviour'; % Phrase message correctly
          
          anomalies_identified_o = model_old{1,1}(ind_mod_old(hypothesis_o==1),1);
          
          for i=1:length(anomalies_identified_o)
              
              index = sscanf(anomalies_identified_o{i},'%*c%d');
          
          fprintf(fileID, message_anomaly, factor_names{index,1}); 

          % Add if it's improvement or degradation (direction of change)
          
          end
                    
      end

end


%Compare unique model terms to zero: for new model terms that appeared
%in the model n compared to n-1 model (to discern if their appearance made the difference)

hypothesis_n = [];

if (isempty(UNIQUE)==false) && (isempty(ind_mod_new)==false)
    
    for i=1:length(ind_mod_new) 
        
      % Generate curves (samples) for projections y = f(model_term_i)
      if (length(strfind(terms_new{ind_mod_new(i),1},'x')) == 1) && (isempty(strfind(terms_new{ind_mod_new(i),1},'^2')) == true) %projections for main factors
          
          projection_old(i,:) = zeros(1,length(x));
          projection_new(i,:) = coeffs_new(ind_mod_new(i))*x;
          
      elseif length(strfind(terms_new{ind_mod_new(i),1},'x')) > 1 %projections for interactions
          
          projection_old(i,:) = zeros(1,length(x)); 
          projection_new(i,:) = coeffs_new(ind_mod_new(i))*x;
          
      elseif (length(strfind(terms_new{ind_mod_new(i),1},'x')) == 1) && (isempty(strfind(terms_new{ind_mod_new(i),1},'^2')) == false)
          
          projection_old(i,:) = zeros(1,length(x));
          projection_new(i,:) = coeffs_new(ind_mod_new(i))*x.^2;
          
      
      %there also should be condition for interactions of the form x^2:x
      
      end
      
      % Test for significant difference between new model terms and zero
      [hypothesis_n(i), ~] = vartest2(zeros(1,length(projection_new(i,:))),projection_new(i,:));
            
    end
       
    %Report anomalies if found
      
      if isempty(find(hypothesis_n==1)) == false
          
          message_anomaly = 'Appearance of %s caused anomalous behaviour'; % Phrase message correctly
          
          anomalies_identified_n = model_new{1,1}(ind_mod_new(hypothesis_n==1),1);
          
          for i=1:length(anomalies_identified_n)
              
              index = sscanf(anomalies_identified_n{i},'%*c%d');
          
          fprintf(fileID, message_anomaly, factor_names{index,1}); 

          % Add if it's improvement or degradation (direction of change)
          
          end
                   
      end    

end

   %If no anomalies were detected, report their absence
   
   if (isempty(find(hypothesis_c==1)) == true) && (isempty(find(hypothesis_o==1)) == true) && (isempty(find(hypothesis_n==1)) == true)
       
       fprintf(fileID,'%s\n','No anomalies detected');
       
   end

   
    %Close the report file
    fclose(fileID);


end