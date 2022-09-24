# reg2latex

## Description
The function `reg2latex` creates a `.tex` file from a linear model in Matlab. The function allows for multiple model inputs and to format your own regression output. If you use other methods to estimate regressions in Matlab (e.g.:  [Econometrics Toolbox](https://www.spatial-econometrics.com), then you can parse a `struct` into `reg2latex` and obtain a regression output.

## Set-up
Clone the repository and add it to your Matlab path. Make sure to add the folder `helper` to your path.

The file `main_regression_file.m` contains the three examples from the `README.md` file and produces the corresponding `.tex` files. The file `main_text.text` just loads the tables files via `\input`.

## Table of content 
    - Example 1
    - Example 2
    - Example 3
    - Required packages in Latex
    
## Example 1
Run `fitlm` and obtain to obtain a linear regression.
```
% Load default sample data from mathworks
load carsmall
X = [Weight,Horsepower,Acceleration];
% Fit a linear regression model using fitlm.
mdl = fitlm(X,MPG);

% Function takes a linear Model as input and outputs a seperate .tex file
tabPosition = 'H';
tabCaption = 'My table names goes here'; 
tabLabel = 'tab:myLabel';
tabNote = 'This a long note explaining what I did in each model.';

% Call reg2latex and createx tex output for a single regression output
modelName = '& Baseline Model 1';
reg2latex({mdl},'myTable1.tex', tabPosition, tabCaption, tabLabel, modelName, tabNote);
```
The obtained screenshot from the output in Latex is

![tab1](/screenshots/ScreenshotTab1.png "Tab1")

Note that I added a bit of vertical spacing the displayed table here with `\renewcommand{\arraystretch}{1.5}`


## Example 2
Adding more regression models into one output table. Suppose you run multiple models and want to store the results column wise.
```
mdl1 = fitlm([Weight,Horsepower],MPG);
mdl2 = fitlm(Weight,MPG);

% Call reg2latex and createx tex output if I would have used two models
modelName = '& \textbf{Baseline Model} 1 & Another model 2';
tabCaption = 'Please make my first model bold'; 
reg2latex({mdl, mdl1},'myTable2.tex', tabPosition, tabCaption, tabLabel, modelName, tabNote);

% Call reg2latex and create tex output for all the models
modelName = '& Baseline Model 1 & Another model 2 & Another fancy model 3';
reg2latex({mdl2, mdl, mdl1},'myTable3.tex', tabPosition, tabCaption, tabLabel, modelName, tabNote);
```
![tab2](/screenshots/ScreenshotTab2.png "Tab2")
![tab3](/screenshots/ScreenshotTab3.png "Tab3")

## Example 3
Suppose you have results from a custom regression output in a struct. Make sure that the fields are named as in the mdl object. Here as an example consider using the ols function from the [Econometrics Toolbox](https://www.spatial-econometrics.com)
```
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

modelName = '& Baseline Model 1 & Test';
reg2latex({mdl, myMdl},'myCustomTable.tex', tabPosition, tabCaption, tabLabel, modelName, tabNote, addInfo)
```
![tab4](/screenshots/ScreenshotTab4.png "Tab4")

## Required packages in Latex
Place the following packages in your preamble
```
\usepackage{booktabs}
\usepackage{multirow}
\usepackage{float} % Need if position of table needs float
\usepackage[flushleft]{threeparttable}
```
