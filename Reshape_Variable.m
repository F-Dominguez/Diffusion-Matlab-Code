%*********************************************************
%* Reshape_Variable                                      *
%* Data Reshaping for 2d plots.                          *
%* By Francisco Dominguez                                *
%*********************************************************

%This script was made to quickly access data for 2D plotting. 
%Later Find_Perm_Data was made to be more general but this 
%script is included for completeness and for the fact that 
%for 2D plots it is still more efficient.
%If the data array is too big, getting data in a form that 
%Matlab understands for plotting 2D graphs can be cumbersome.
%This script was made to aid in that task.
%The code will take and entry data matrix (Average or MSE for
%example) then a number or vector determining the constant 
%dimension or dimensions, and finally a number or vector 
%determining the constant entry in those dimensions. 
%
%As an example:
%
% AvgThresh = Reshape_Variable(Average,2,1);
% MSEThresh = Reshape_Variable(MSE,2,1);
% Graph_Thresh(Thresh_Begin,Thresh_Intv,Thresh_End,...
%              AvgThresh,MSEThresh);
%
%In here, the code will take the second dimension of the Average
%and MSE arrays and of that dimension the first entry and it 
%will report the result in a vector form. The code will not work 
%properly if the desired output is of a higher dimension than 1, 
%i.e. it only works well to output vectors, therefore one must 
%be careful to determine the correct number of constants.
%
%Another example: 
%
% AvgThresh = Reshape_Variable(Average,[2 1],[1 3]);
% MSEThresh = Reshape_Variable(MSE[2 1],[1 3]);
% Graph_Thresh(Thresh_Begin,Thresh_Intv,Thresh_End,...
%              AvgThresh,MSEThresh);
%_____________________________________________________________


function [z] = Reshape_Variable(x,Const_Dim,entry_num)

Dimen = size(x);

[Const_Dim,IX] = unique(Const_Dim);
NumConsts = length(Const_Dim);
entry_num = entry_num(IX);

if NumConsts == 1
    if Const_Dim == 1
        y = x(entry_num,:,:);
        rows = Dimen(2);
    elseif Const_Dim == 2
        y = x(:,entry_num,:);
        rows = Dimen(1);
    else
        y = x(:,:,entry_num);
        rows = Dimen(1);
    end
    z = reshape(y,rows,[]);
else
    [~,IX] = sort(Const_Dim,'descend');
    for i = 1:NumConsts
        if Const_Dim(IX(i)) == 1
            x = x(entry_num(IX(i)),:,:);
        elseif Const_Dim(IX(i)) == 2
            x = x(:,entry_num(IX(i)),:);
        else
            x = x(:,:,entry_num(IX(i)));
        end
    end
    z=x(:);
end
