function textFullRow = createColTextModel(p,varargin)
   
    expectedVariable = {'NumObservations', 'Rsquared-Ordinary', 'Rsquared-Adjusted', 'LogLikelihood'};
    
    t = inputParser;
    addRequired(t, 'p');
    
    % Allows later to access the Rsquared struct and call the field names because varargin now contains the       
    addParameter(t,'variable',...
                 @(x) any(validatestring(x,expectedVariable)));         
    textFullRow = '';
    
    % Get number of models from input
    numModel = size(p.Results.mdl,2);
    
    for iModel=1:numModel
        
        % Access single model
        mdl = p.Results.mdl{iModel};
        
        % Get field names and find the values corresponding to the variable
        % of interest
        fieldnamesMdl = fieldnames(mdl)';
        if contains(varargin,'Rsquared')
            idxVariable = find(contains(fieldnamesMdl,'Rsquared'));
        else
            idxVariable = find(contains(fieldnamesMdl,varargin{1}));
        end
        
        % Last column does not need a & in Latex
        if iModel == numModel
            
            % Access field value in the same way as for structs
            if contains(varargin{1},'Rsquared') 
               tempText = checkRsquared(mdl,fieldnamesMdl, idxVariable, varargin);
            else
                tempText= string(mdl.(fieldnamesMdl{idxVariable}));
            end
            
            
        % If it is not the last model then add column separator for Latex    
        else
            
            % Access field value in the same way as for structs
            if contains(varargin{1},'Rsquared')
                tempText = checkRsquared(mdl,fieldnamesMdl, idxVariable, varargin);
            else
                tempText= string(mdl.(fieldnamesMdl{idxVariable}));
            end
            
            % Append column separator to text
            tempText = append(tempText,' & ');
            
        end
        
        % Create full row
        textFullRow = char(append(textFullRow, tempText));
    end

end