%*************************************************
%* Variation_Perm                                *
%*                                               *
%* Calculation and reformatting of all possible  *
%* permutations asked in the program.            *
%* By Francisco Dominguez                        *
%*************************************************

%This code transforms the Pconnect_Mat and Pn_Mat into a useful 
%form that encompasses all possible permutations of values of 
%Pconnect or Pn for the program to execute the simulation.
%
%Mat_Intv : The input matrix in question; it can be Pconnect_Mat 
%       or Pn_Mat.
%Intv_Nums: Calculates the total number of steps for each para-
%       meter, i.e. the total number of steps that the program 
%       will do for a particular parameter of a population, for
%       example Pconnect11, Pconnect12 etc.
%Num_Cols : Is the total number of steps for all parameters, en-
%       compassing all possible Pconnect or Pn depending on the 
%       input matrix.
%ForVar   : This is the output of the function, It will be 
%       Pconnect_Perm or Pn_Perm depending on the input matrix.
%_____________________________________________________________

function [ForVar] = Variation_Perm(Mat_Intv)

%Calculation of number of increments.
Intv_Nums = (round((Mat_Intv(:,:,3)-Mat_Intv(:,:,1))./...
Mat_Intv(:,:,2))+1)';

%Total number of increments.
Num_Cols = prod(prod(Intv_Nums));

%Preallocation for speed.
ForVar = zeros(numel(Mat_Intv)/3,Num_Cols);

%Obtaining the permutations in form of a matrix.
for i = 1:size(Mat_Intv,1)
    for j = 1:size(Mat_Intv,2)
        RowNum        = j + (i-1) * size(Mat_Intv,1);
        Ent_Block_Len = prod(Intv_Nums(RowNum:end));
        Block_Num_Len  = Ent_Block_Len/Intv_Nums(j,i);
        Block = zeros(1,Ent_Block_Len);
        for z = 1:Ent_Block_Len/Block_Num_Len
            Block_Part_val = Mat_Intv(i,j,1) + (z-1)*...
            Mat_Intv(i,j,2);
            Block((1+(z-1)*Block_Num_Len):Block_Num_Len*z) = ...
                repmat(Block_Part_val,1,Block_Num_Len);
        end
        ForVar(RowNum,:) = ...
        repmat(Block,1,Num_Cols/Ent_Block_Len);
    end
end