%*************************************************
%* Percolation simulation in heterogeneous media *
%* Final Version Programmed April 4, 2012        *
%* By Francisco Dominguez                        *
%*************************************************

tic; close all; clc

%% Define Parameters

% n:            Dimension of Adjacency matrix.
% Thresh_Begin: Initial value of Threshold.
% Thresh_Intv:  Increment of Threshold for variation.
% Thresh_End:   Final Value of Threshold.
% Repeat:       Number of times percolation experiment is re- 
%               peated to obtain the average of the proportion 
%				of adoption.
% Pseed :       Probability of initial activity, or initial 
%               adoption of new behaviour. Pn = 1-Pseed.
% Pconnect:  Probability of connectedness for the Adjacency 
%            Matrix; this is the probability that connections 
%            between members will arise.
% NumPop:    Number of societies.
% PopSize:   Vector stating the size of all societies.
% PopSame:   Vector stating if we need the submatrices (of the 
%       Adjacency matrix) representing interaction between  
%       societies to be equal; for example if we need the Adja-
%       cency matrix of society i interacting with j to be equal
%       to society j interacting with i. Anything other than 
%       'Same' will make them be generated differently, i.e. 
%       will get us non symmetric relations between 
%       populations.
% PopSym:    Matrix stating if the submatrices of the Adjacency 
%       matrix are generated symmetrically or not. Anything  
%       other than Sym will yield non symmetric random matrices,
%       i.e. we won't have a symmetric relation inside 
%       societies.
% Weight_Pop: Vector introducing weight to the utility function 
%       of individuals in a particular society. This is to vary 
%       the importance of adoption of a certain society in a
%       given individual. This is also a way to make a relative
%       variation of threshold amongst the societies.
%
% It is possible for this code to simulate percolation for any 
% number of societies. One must define a Pn vector with dimen- 
% sion equal to this number. Also one must define a Pconnect 
% matrix with values for every interacting society; NumPop^2.   
% Pn_Mat and Pconnect_Mat are 3xNumPop matrices. First row de-
% fines the initial values of Pn or Pconnect respectively, se-
% cond row gives the increment for simulation and third row 
% gives the final value for simulation. The code takes all po-
% ssible permutations of values introduced in this matrices.
%  This last step is achieved in the function Variation_Perm.
%_____________________________________________________________

% One Society

Thresh_Begin = 6;
Thresh_Intv = 1;
Thresh_End = 6;
Repeat = 500;                        

Pn_Mat = cat(3,.70,.001,.99);
Pconnect_Mat = cat(3,.002,.00005,.002);

NumPop = 1;
PopSize = [10000];
PopSame = {'Same'};
PopSym = {'Diff'};
Weight_Pop = [1];

%_____________________________________________________________
%% Two Societies

Thresh_Begin = 0;
Thresh_Intv = 1;
Thresh_End = 100;
Repeat = 3;                        

Pn_Mat = cat(3,[0.70 0.80],...
               [0.05 0.10],...
               [0.95 0.90]);
Pconnect_Mat = ...
cat(3,[0.000 0.001;0.001 0.010],...
      [0.005 0.001;0.001 0.010],...
      [0.300 0.001;0.001 0.010]);
NumPop     = 2;
PopSize    = [10000 10000];
PopSame    = {'Same','Same'};
PopSym     = {'Diff','Diff';'Diff','Diff'};
Weight_Pop = [1 -1;-1 1];

%_____________________________________________________________
% Three Societies

Thresh_Begin = 20;
Thresh_Intv = 1;
Thresh_End = 90;
Repeat =10;                        

Pn_Mat = cat(3,[0.84 0.85 0.90],...
               [0.02 0.05 0.05],...
               [0.94 0.85 0.90]);
Pconnect_Mat = ...
cat(3,...
[0.000 0.005 0.001;0.005 0.005 0.001;0.001 0.001 0.005],...
[0.002 0.001 0.001;0.001 0.005 0.001;0.001 0.001 0.005],...
[0.090 0.005 0.001;0.005 0.005 0.001;0.001 0.001 0.005]);
NumPop     = 3;
PopSize    = [10000 10000 10000];
PopSame    = {'Same','Same','Same'};
PopSym     = {'Diff','Diff','Diff';...
              'Diff','Diff','Diff';...
              'Diff','Diff','Diff'};
Weight_Pop = [1 1 1;1 1 1;1 1 1];

%_____________________________________________________________
%% Simulation

[Pconnect_Perm] = Variation_Perm(Pconnect_Mat);
[Pn_Perm]       = Variation_Perm(Pn_Mat);
[Average,MSE]   = Variation_MP(Thresh_Begin,Thresh_Intv,...
Thresh_End,Pconnect_Perm,Pn_Perm,Repeat,NumPop,PopSize,...
PopSame,PopSym,Weight_Pop);

elapsedtime = toc;

%_____________________________________________________________
%% GUI

% To execute the Graphical User Interface, either uncomment the 
% following line or execute it in the command prompt. This will 
% load the data into the interface and allow for dynamical ob-
% servation of the results.

% test1(Pconnect_Perm,Pn_Perm,Thresh_Begin:Thresh_End,...
Average,MSE,NumPop)
