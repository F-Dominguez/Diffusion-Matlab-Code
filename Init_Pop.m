%************************************************************
%* Init_Pop                                                      
%*                                                               
%* Generation of General Adjacency Matrix and Population Vector. 
%* By Francisco Dominguez                                        
%************************************************************

%This function generates the Adjacency Matrix if the Pval in 
%question is Pconnect or the Nvect (vector of population con-
%taining 0 for new behaviour or 1 for original behaviour) if 
%the Pval is the Pn. 
%
%The matrix PopSym dictates wether a submatrix of the adjacency
%matrix (AdjM) is symmetrical or not. In this program, the AdjM
%for each society and the AdjM for the relationship between so-
%cieties are all included in the same general AdjM. The same is
%done for the Nvect which encompasses the Nvect of each indivi-
%dual society. Therefore, each component of the general AdjM 
%dictates the relation of individual societies or between two 
%particular societies.
%PopSym determines if those relations are symmetrical. If so 
%then the matrix is generated using a random sparse symmetrical
%matrix command instead of just sparse symmetric matrix. Note 
%that if symmetric matrix is desired, then it must be a square 
%matrix i.e. PopSize(i) = PopSize(j). In other words PopSym dic-
%tates if we have symmetric adjacency matrices for societies; 
%AdjM_11 is symmetric.
%
%The vector PopSame, on the other hand dictates whether or not 
%interaction within societies are symmetrical between them; for
%example if we need the Adjacency matrix of society i inter-
%acting with j to be equal to society j interacting with i; 
%AdjM_13 = AdjM_31. Anything other than 'Same' will  make them 
%be generated differently. Note that if Same is desired, then 
%the Pconnect values must be equal too.
%_____________________________________________________________

%OutVar: This output will be either AdjM or Nvect, depending on
%         the input Pval.
%Pval  : Can be Pn or Pconnect, if Pn then OutVar will be Nvect,
%        if Pconnect then OutVar will be AdjM.
function [OutVar] = Init_Pop(NumPop,PopSize,Pval,PopSame,PopSym)

%In the following case the program is considering Pconnect.
if nargin > 3
    OutVar     = cell(NumPop);
    k          = 1;
    for i = 1:NumPop
        for j = 1:NumPop
            %If Same is reported on the vector PopSame and 
            %the inserted values are equal.
            if i > j && strncmpi('Same',PopSame{k},4) && ...
                    Pval(i,j) == Pval(j,i)
                %Then the Adjacency matrix is the same.
                OutVar{i,j} = OutVar{j,i}';
                k         = k + 1;
            else
                if i > j
                    k = k + 1;
                end
                %If the entry for the (i.j) adjacency com-
                %ponent in the PopSym matrix starts with Sym 
                %and the population size of those 2 societies 
                %is equal then use symmetric.
                if strncmpi('Sym',PopSym{i,j},3) &&...
                    PopSize(i) == PopSize(j)
                    OutVar{i,j} = ...
                        spones(sprandsym(PopSize(i),Pval(i,j)));
                else
                    OutVar{i,j} = spones(sprand...
                        (PopSize(i),PopSize(j),Pval(i,j)));
                end
            end
        end
    end
%In the following case the program is considering Pn.  
else
    OutVar = cell(NumPop,1);
    for i = 1:NumPop
        OutVar{i} = rand(PopSize(i),1)<Pval(i);
    end
end