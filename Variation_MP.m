%*****************************************************
%* Variation_MP                                      *
%* Nested 'for' loop for every combination of values *
%* This is fed to Init_Pop which creates the Nvect   *  
%* and Adjacency Matrix, and to Evolve_MPopulation   *
%* which carries out the evolution.                  *
%* By Francisco Dominguez                            *
%*****************************************************

%This code is essentially a nested 'for' loop that executes the 
%functions 'Init_Pop' and 'Evolve_MP' for all possible combina- 
%tions of values input in Pn_Mat and Pconnect_Mat and then re-
%formatted into Pn_Perm and Pconnect_Perm.
%
%Pconnect_Len, Pn_Len and Thresh_Len are the number of values of 
%        Pconnect, Pn and Threshold that are desired to be simu-
%        lated by the program.
%WEight_Pop_Len: In the current version of the code, it is not
%        possible to vary the desired values of the weight for 
%        the utility functions related to threshold in each so-
%        ciety. This part is therefore not used but was included
%        for a future version of the program.
%Proportion: This value is the main result and object of study
%        in our simulations. It represent the proportion of non-
%        adopters (defined as the initial non adopting fraction 
%        of the population) that ended up adoptting the beha-
%        viour. Therefore it will be a value of 1 if everyone 
%        adopted at the end or 0 if no one did, with every va-
%        lue in between as a possible outcome.
%Regarding the counters, zz counts the total number of steps, 
%this is used in the function 'timebar' which is a modified ver-
%sion of the Matlab function waitbar to also incorporate time 
%remaining. The counter r is for the number of Repeat, c is for 
%Pconnect, s is for Pseed or Pn and t is for Threshold.
%
%For each combination of numbers, the Adjacency Matrix using 
%Pconnect and the Nvect (vector of states for each member of the
%society) is calculated using Init_Pop. Once those matrices are 
%obtained, the function Evolve_MPopulation carries the evolution 
%of the percolation through its final state and then the final
%Proportion is saved in the 4 dimensional array (For repeat, 
%connect, seed and threshold). Finally the average is calculated
%over all repetitions.
%
%The counters in this code are:
%
%zz: Counter for total steps.
%c:  Counter for Pconnect steps.
%s:  Counter for Pseed or Pn steps.
%t:  Counter for Threshold steps.
%_____________________________________________________________

function [Average,MSE,AllPerms] = Variation_MP(Thresh_Begin,...
Thresh_Intv,Thresh_End,Pconnect_Perm,Pn_Perm,Repeat,NumPop,...
PopSize,PopSame,PopSym,Weight_Pop)

%Length calculation.
Pconnect_Len = size(Pconnect_Perm,2);
Pn_Len = size(Pn_Perm,2);
Thresh_Len = (Thresh_End-Thresh_Begin)/Thresh_Intv +1;

% Following line reserved for following version incorporating
% weight variation.
% Weight_Pop_Len = numel(Weight_Pop);
Weight_Pop_Len =1;

%Preallocation for speed.
Proportion = zeros(Thresh_Len,Pn_Len,Pconnect_Len,Repeat,...
      Weight_Pop_Len);
AllPerms   = zeros(1 + size(Pconnect_Perm,1) + ...
      size(Pn_Perm,1),Thresh_Len*Pn_Len*Pconnect_Len);
Par_Connect = cell(NumPop,NumPop);

h = timebar(0,sprintf('%3.1f Percent Done',0));
zz=0;
for r = 1:Repeat
    c=1;
    for Pconnect = Pconnect_Perm
        [Adj_Mat]  =  Init_Pop(NumPop,PopSize,...
                      reshape(Pconnect,NumPop,...
                      []),PopSame,PopSym);
        %Total number of connections.
        Tot_Connect = sum(cell2mat(Adj_Mat),2);
        for Active_Pop = 1:NumPop
            for Connected_Pop = 1:NumPop
                 Par_Connect{Active_Pop, Connected_Pop} =...
                  sum(Adj_Mat{Active_Pop, Connected_Pop},2);
            end
        end
        s=1;
        for Pn = Pn_Perm
            %Network vector. It has 1's for non adopters, 0's 
            %for adopters.
            [NvectO]  =  Init_Pop(NumPop,PopSize,Pn);
            %Initial Number of non-adopters.
            IN = sum(cell2mat(NvectO));
            t = 1;
            for Threshold = Thresh_Begin:Thresh_Intv:Thresh_End
                Nvect = NvectO;
                [NAf] =  Evolve_MPopulation(Weight_Pop,NumPop,...
                         Adj_Mat,Nvect,Tot_Connect,...
                         Par_Connect,Threshold,PopSize);
                %Proportion of non-adopters that adopted the ...
                %behaviour.
                Proportion(t,s,c,r) = 1-(NAf/IN);
                t      = t + 1;
                zz = zz+1;
                steps = ...
                    (zz)/(Repeat*Thresh_Len*Pn_Len*Pconnect_Len);
                timebar(steps,h,...
                    sprintf('%3.1f Percent Done',steps*100));
            end
            s=s+1;
        end
        c=c+1;
    end
    
end
%Average of Proportion over r runs.
Average = mean(Proportion,4);
%MSE of each set of numbers.
MSE     = std(Proportion,1,4);
close(h);