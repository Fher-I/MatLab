%% TEMP GRADIENT
%This function plots temperature gradient per minute and calculates 
%the maximum temperature gradient. The sample rate must be 1Hz. The
%gradient is calculated as kelvin/minute.
%Author: Fernando Idrovo
%Revision 1: Dec 11, 2020
%% REQUIREMENTS
%temp_gradient(filename,units,column)
%filename: tested extensions .txt, .dat, .xlsx, .mat 
%The filename must be in the same directory as this script. 
%Units: for celcius enter 'c', for Farenheith enter 'f', default Kelvin 
%column: if file contains multiple columns of data indicate the column to evaluate
%%
function temp_gradient(filename,units,column)
if nargin<3 || isempty(column)
    column=1; 
end
[path,name,ext] = fileparts(filename);
if strcmp(ext,'.mat')
    dataStruct = load(filename);
    fieldNames = fieldnames(dataStruct);
    variableName =fieldNames{1};
    temp = dataStruct.(variableName);
    tempTable = array2table(temp);
    L = height(tempTable);
else
    tempTable = readtable(filename);
    L = height(tempTable);
end
col = column;

unit = lower(units);


%create a tempData array in kelvin
if strcmp(unit,'c')
   tempData = tempTable{:,col} + 273.15;
elseif strcmp(unit,'f')
       tempData = ((tempTable{:,col})-32)*5/9 + 273.15;
else
    tempData = tempTable{:,col};
end

%calculate rate of change

for x = 1:L
    if x<(L-60)
        rateOfChange(x) =tempData(x+60)-tempData(x);
    end
end

%plot results 

[maxValue, idx] = max(rateOfChange);
maxStr = string(maxValue);
colNames = tempTable.Properties.VariableNames;
plot(rateOfChange)
hold on
yline(maxValue,'r');
hold off;
str = string(colNames(col));
lgd=legend(str,'Maximum Value');
title(lgd,'Temperature Gradient Per Minute')
text(idx,maxValue,maxStr)



end