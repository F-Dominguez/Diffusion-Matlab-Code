%*****************************************************
%* Find_Perm_Data                                    *
%* Data Ordering and formatting for plot generation. *
%* By Francisco Dominguez                            *
%*****************************************************

%In order to easily access any values of the entire data array 
%this script was created. With the use of this code we can ac-
%cess data with ease even from an array of N dimensions in the
%case that we have N different parameters of M societies. This 
%code is used in Graph3d and in Movievolution. It essentially 
%obtains the required data from the data array and the output 
%is synthetized into a simpler matrix. The code takes the va-
%lues input in 'conditions' as constant values and searches for
%that location in the data array. Whatever is not input in 
%'conditions' the code considers variable and so that entire 
%dimension in the data array is what becomes the output of the 
%code. 
%_____________________________________________________________

function [PconCols,PnCols,ThreshCols] = Find_Perm_Data(...
          conditions,Pconnect_Perm,Pn_Perm,Thresh_Perm)


CheckPcon = [];CheckPn = [];CheckThresh = [];

%Checks for the variable parameter.

for i = 1 : size(conditions,1)
    
    if strncmpi(conditions{i,1},'Pconnect',7)
        CheckPcon = strcat(CheckPcon,[' abs(Pconnect_Perm(' ...
            num2str(conditions{i,2}(1)) ',:)-' ...
            num2str(conditions{i,2}(2)) ')<1e-10 & ']);
    elseif strncmpi(conditions{i,1},'Pn',7)
        CheckPn = strcat(CheckPn,[' abs(Pn_Perm(' ...
            num2str(conditions{i,2}(1)) ',:)-' ...
            num2str(conditions{i,2}(2)) ')<1e-10 & ']);
    else
        CheckThresh = strcat(CheckThresh,[' abs(Thresh_Perm-' ...
            num2str(conditions{i,2}(1)) ')<1e-10 & ']);
    end
end

%Outputs Variable parameter information according to 
%fixed parameters input.

if isempty(CheckPcon)
    PconCols = 1:size(Pconnect_Perm,2);
else
    PconCols = eval(CheckPcon(1:end-2));
end
if isempty(CheckPn)
    PnCols = 1:size(Pn_Perm,2);
else
    PnCols = eval(CheckPn(1:end-2));
end
if isempty(CheckThresh)
    ThreshCols = 1:size(Thresh_Perm,2);
else
    ThreshCols = eval(CheckThresh(1:end-2));
end

