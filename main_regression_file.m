%% Example 1
% Load default sample data from mathworks
load carsmall
X = [Weight,Horsepower,Acceleration];
%Fit a linear regression model using fitlm.
mdl = fitlm(X,MPG);

% Function takes a linear Model as input and outputs a seperate .tex file
tabPosition = 'H';
tabCaption = 'My table names goes here'; 
tabLabel = 'tab:myLabel';
tabNote = 'This a long note explaining what I did in each model.';

% Call mdl2latex and createx tex output for a single regression output
modelName = '& Baseline Model 1';
reg2latex({mdl},'filename','myTable1.tex', 'tabPosition',tabPosition, 'tabCaption',tabCaption, 'tabLabel',tabLabel, 'modelName', modelName, 'tabNote',tabNote);

%% Example 2
% Adding more regression models into one output table. Suppose you run multiple models and want to store the results column
% wise.
mdl1 = fitlm([Weight,Horsepower],MPG);
mdl2 = fitlm(Weight,MPG);

% Call mdl2latex and createx tex output if I would have used two models
modelName = '& \textbf{Baseline Model} 1 & Another model 2';
tabCaption = 'Please make my first model bold'; 
reg2latex({mdl, mdl1},'filename','myTable2.tex', 'tabPosition',tabPosition, 'tabCaption',tabCaption, 'tabLabel',tabLabel, 'modelName', modelName, 'tabNote',tabNote);

% Call mdl2latex and createx tex output for all my models
modelName = '& \textbf{Baseline Model} 1 & Another model 2 & Another fancy model 3';
reg2latex({mdl2, mdl, mdl1},'filename','myTable3.tex', 'tabPosition',tabPosition, 'tabCaption',tabCaption, 'tabLabel',tabLabel, 'modelName', modelName, 'tabNote',tabNote);

%% Example 3
% Suppose you have results from a custom regression output in a struct then mdl2latex works as well.
% Consider using the ols function from the Spacial Econometric Toolbox from LeSage (Link:)
olsStruct = ols(Acceleration, [Weight]);
pValue = 2 * min(tcdf(olsStruct.tstat, olsStruct.nobs-1), 1-tcdf(olsStruct.tstat, olsStruct.nobs-1));

% Note that the structure of your input has to follow this format
myTable = table(olsStruct.beta, olsStruct.bstd, olsStruct.tstat, pValue,...
                'VariableNames', {'Estimate', 'SE', 'tStat', 'pValue'}, 'RowNames', {'weight'});
myMdl = struct;
myMdl.CoefficientNames = myTable.Properties.RowNames';
myMdl.Coefficients = myTable;
myMdl.NumCoefficients = olsStruct.nvar;

% Add fields to be added after coefficients in the same convention als in mdl
addInfo.addFieldName = {'N', 'Rsquared', 'FirmFE'}; 

addInfo.model1.(addInfo.addFieldName{1}) = olsStruct.nobs;
addInfo.model1.(addInfo.addFieldName{2}) = olsStruct.rsqr;
addInfo.model1.(addInfo.addFieldName{3}) = 'Yes';

addInfo.model2.(addInfo.addFieldName{1}) = mdl.NumObservations;
addInfo.model2.(addInfo.addFieldName{2}) = mdl.Rsquared.Ordinary;
addInfo.model2.(addInfo.addFieldName{3}) = 'No';

modelName = '& \textbf{Baseline Model} 1 & Test';
reg2latex({mdl, myMdl},'filename','myCustomTable.tex', 'tabPosition', tabPosition, 'tabCaption', tabCaption, 'tabLabel',tabLabel, 'modelName', modelName, 'tabNote',tabNote);
