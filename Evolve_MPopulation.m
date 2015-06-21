%***********************************************************
%* Evolve_MPopulation                                      *
%* Core of the program, the percolation is simulated here. *
%* By Francisco Dominguez                                  *
%***********************************************************

%This is the core of the Percolation or cascade simulation. It 
%applies at each step, the rule that if a member has more or 
%equal than Threshold neighbors with the new behaviour (which 
%is represented by 0) then it adopts that behaviour from the 
%original one (represented by 1). The programs stops if at any 
%given cycle, no new individuals adopted the new behaviour, in 
%which case all of them adopted it or there was a cluster that 
%wasn't connected enough to the rest of the network.
%
%Active_Pop: Refers to the current population being evolved. The 
%   Active_Pop refers to 'rows' in the Adjacency matrix's sub 
%   matrix configuration. This means that if we have Active_Pop  
%   = 1 in a 3 society configuration, we are taking into account 
%   the submatrices referring to the interaction of society 1 
%   with itself, with society 2 and society 3.
%
%Connected_Pop: Refers to 'columns' in the Adjacency matrix's 
%   sub matrix configuration.
%
%With both of these numbers the program does the product of Ad-
%jacency matrix and Vector of Population by parts to then report 
%the vector of population at the next step.
%
%The weight parameter is considered here. Although the threshold 
%is the same throughout the societies, each assigns a weight on 
%their links (relations) with each other society, and therefore 
%we can manipulate how important relations are between interac-
%ting societies. If we set the weight to 0, no feedback will 
%occur when behaviours change in the interacting societies. 
%We can also set it as negative and therefore, it will have the 
%effect of making the adoption of the new behaviour undesirable 
%for a certain population if another population is adopting it.
%_____________________________________________________________

function [NAf] =  Evolve_MPopulation(Weight_Pop,NumPop,...
    Adj_Mat,Nvect,Tot_Connect,Threshold,PopSize)
%In the following code, Active_pop refers to 'rows' in the AdjM,
%while Connected_Pop is used to denote 'columns' in the AdjM. 
%These rows and columns are not of scalars but of submatrices,
%referring to particular societies. Therefore 13 is the interac-
%tion if society 1 with society 3, and therefore an entire matrix
%itself.

dNA = 1;
Connect2one = cell(1,NumPop);
Connect2zero = cell(1,NumPop);
while dNA
   for Active_Pop = 1:NumPop
       for Connected_Pop = 1:NumPop
           if Weight_Pop == ones(NumPop)
                 if Connected_Pop == 1
                     %Vector stating the amount of connec-
                     %tions to 1's. This is basically a part
                     %of the utility function for members of 
                     %Active_Pop.
                     Connect2one{Active_Pop} = ...
                       Adj_Mat{Active_Pop, Connected_Pop}*...
                       Nvect{Connected_Pop};
                 else
                     %Vector stating the amount of connec-
                     %tions to 1's.
                     Connect2one{Active_Pop} = ...
                       Connect2one{Active_Pop} + ...
                       Adj_Mat{Active_Pop, Connected_Pop}*...
                       Nvect{Connected_Pop};
                 end
           else
               switch Weight_Pop(Active_Pop, Connected_Pop)
                 case 0,
                    if Connected_Pop == 1
                       Connect2zero{Active_Pop} = ...
                        zeros(PopSize(Connected_Pop),1);
                     end
                 case 1,
                    if Connected_Pop == 1
                       Connect2zero{Active_Pop} = ...
                        Par_Connect{Active_Pop,Connected_Pop}...
                        - (Adj_Mat{Active_Pop,Connected_Pop}*...
                        Nvect{Connected_Pop});
                    else
                       Connect2zero{Active_Pop} = ...
                        Connect2zero{Active_Pop} + ...
                        Par_Connect{Active_Pop,Connected_Pop}...
                        - (Adj_Mat{Active_Pop,Connected_Pop}*...
                        Nvect{Connected_Pop});
                    end
                 otherwise,
                    if Connected_Pop == 1
                       Connect2zero{Active_Pop} = ...
                        Weight_Pop(Active_Pop,Connected_Pop)*(...
                        Par_Connect{Active_Pop,Connected_Pop}...
                        - (Adj_Mat{Active_Pop,Connected_Pop}*...
                        Nvect{Connected_Pop}));
                    else
                       Connect2zero{Active_Pop} = ...
                        Connect2zero{Active_Pop} + ...
                        Weight_Pop(Active_Pop,Connected_Pop)*(...
                        Par_Connect{Active_Pop,Connected_Pop}...
                        - (Adj_Mat{Active_Pop,Connected_Pop}*...
                        Nvect{Connected_Pop}));
                    end
               end
           end
       end
   end
   if Weight_Pop == ones(NumPop)
       %If number of connections to 0's is less than m,then
       %the behaviour stays the same.
       Amask = ((Tot_Connect-cell2mat(Connect2one'))<Threshold);
       %Initial Number of nonadopters at each step.
       NAi = sum(cell2mat(Nvect));
       %Percolation step.
       Nvect = mat2cell(cell2mat(Nvect).*Amask,PopSize);
       %Final Number of nonadopters at each step.
       NAf = sum(cell2mat(Nvect));
       %Number of adopters gained.
       dNA = NAi-NAf;
   else
       Amask = ((cell2mat(Connect2zero'))<Threshold);
       NAi = sum(cell2mat(Nvect));
       Nvect = mat2cell(cell2mat(Nvect).*Amask,PopSize);
       NAf = sum(cell2mat(Nvect));
       dNA = NAi-NAf;
   end
end
