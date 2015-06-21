%*****************************************************
%* Graph3d                                           *
%* Graphing script for single 3D graphs of Pconnect, *
%* Pn and Threshold versus Proportion of Adoption    * 
%* By Francisco Dominguez                            *
%*****************************************************

%This Script is to facilitate the plotting of 3d graphs using 
%the results of the simulation. One selects all but one value 
%of Pconnect and Pn to be constant and plots the Threshold and
%Proportion of Adoption with this variable Pconnect or Pn. In
%the case of two societies one must select the value amongst 4 
%Pconnects and two Pns. 
%This program uses Find_Perm_Data to obtain all the permutations
%of the desired values to plot and to arrange them in a format 
%that Matlab will use.
%In this program the Pc represents a different Pconnect value 
%for a different submatrix while Pn represents a Pn value for a 
%different subvector. It is worthwhile to notice that Matlab 
%numbers cells in a matrix ordered by column; in a 3x3 matrix the
%numbering will be #1 for the first cell, then below that cell 
%#2 and to the right of #1 will be #4. 
%_____________________________________________________________


%% Data Loading

% clear all
% load('C:\Users\...\Percolation\Results\Run_1.mat')

%_____________________________________________________________
%% 1 Society

Pn = 0.95;
conditions = {'Pn'       [1 Pn]};

Thresh_Perm = Thresh_Begin:Thresh_Intv:Thresh_End;
[PconCols,PnCols,ThreshCols] = ...
                    Find_Perm_Data(conditions,Pconnect_Perm,...
                    Pn_Perm,Thresh_Perm);
Result = Average(ThreshCols,PnCols,PconCols);
ResResult = reshape(Result,[size(Result,1) size(Result,3)]);

X = Thresh_Begin:Thresh_Intv:Thresh_End;
Y = Pconnect_Mat(1,1,1):Pconnect_Mat(1,1,2):Pconnect_Mat(1,1,3);

[XX,YY] = meshgrid(Y,X);
%(cool, winter, summer, spring, map, autumn(5),etc)
colormap cool(7);    
surf(XX,YY,ResResult);
set(gca, 'FontSize',12)
xlim([Pconnect_Mat(1,1,1) Pconnect_Mat(1,1,3)]);
ylim([Thresh_Begin Thresh_End]);
zlim([0 1]);
% view([-127.5 30]);
xlabel('P_c','fontweight','bold','FontSize',16);
ylabel('\theta','fontweight','bold','FontSize',22);
set(get(gca,'ZLabel'),'Rotation',0);
zlabel('\Omega   ','fontweight','bold','FontSize',18);
title({['P_n = (' num2str(Pn) '),   P_c = ( : ),   W = ('...
    num2str(Weight_Pop(1,1)) ') ']},'FontSize',18);
print -djpeg  1-socPn0.95.jpg -r250;
saveas(gcf,'1-socPn0.75.fig');

%_____________________________________________________________
%% 2 Societies

% Define Parameters

Pc2 = 0.001;
Pc3 = 0.001;
Pc4 = 0.010;

Pn1 = 0.80;
Pn2 = 0.90;

% Formatting

conditions = {    'Pconnect' [2 Pc2];
                  'Pconnect' [3 Pc3];
                  'Pconnect' [4 Pc4];
                  'Pn' [1 Pn1];
                  'Pn' [2 Pn2]};

Thresh_Perm = Thresh_Begin:Thresh_Intv:Thresh_End;
[PconCols,PnCols,ThreshCols] = ...
                    Find_Perm_Data(conditions,Pconnect_Perm,...
                    Pn_Perm,Thresh_Perm);
Result = Average(ThreshCols,PnCols,PconCols);
ResResult = reshape(Result,[size(Result,1) size(Result,3)]);

% Plotting 

X = Thresh_Begin:Thresh_Intv:Thresh_End;
Y = Pconnect_Mat(1,1,1):Pconnect_Mat(1,1,2):Pconnect_Mat(1,1,3);

[XX,YY] = meshgrid(Y,X);
%(cool, winter, summer, spring, map, autumn(5),etc)
colormap cool(3);    
surf(XX,YY,ResResult);
xlim([Pconnect_Mat(1,1,1) Pconnect_Mat(1,1,3)]);
ylim([Thresh_Begin Thresh_End]);
zlim([0 1]);
view([-127.5 30]);
xlabel('P_c','fontweight','bold','FontSize',16);
ylabel('\theta','fontweight','bold','FontSize',22);
set(get(gca,'ZLabel'),'Rotation',0);
zlabel('\Omega    ','fontweight','bold','FontSize',18);
title({['P_n = (' num2str(Pn1) ', ' num2str(Pn2) '), W = ('...
   num2str(Weight_Pop(1,1)) ',' num2str(Weight_Pop(1,2)) ','...
   num2str(Weight_Pop(2,1)) ',' num2str(Weight_Pop(2,2)) ')'],...
   ['P_c = ( :, ' num2str(Pc2) ', ' num2str(Pc3) ', '...
   num2str(Pc4) ')']},'FontSize',16);
print -djpeg  W1Pn(.80,.90).jpg -r250
saveas(gcf,'W1Pn(.80,.90).fig');

%_____________________________________________________________
%% 3 Societies

%Define Parameters

Pc2 = 0.005;
Pc3 = 0.001;
Pc4 = 0.005;
Pc5 = 0.005;
Pc6 = 0.001;
Pc7 = 0.001;
Pc8 = 0.001;
Pc9 = 0.005;

Pn1 = 0.90;
Pn2 = 0.85;
Pn3 = 0.90;

% Formatting

conditions = {    'Pconnect' [2 Pc2];
                  'Pconnect' [3 Pc3];
                  'Pconnect' [4 Pc4];
                  'Pconnect' [5 Pc5];
                  'Pconnect' [6 Pc6];
                  'Pconnect' [7 Pc7];
                  'Pconnect' [8 Pc8];
                  'Pconnect' [9 Pc9];
                  'Pn' [1 Pn1];
                  'Pn' [2 Pn2];
                  'Pn' [3 Pn3]};

Thresh_Perm = Thresh_Begin:Thresh_Intv:Thresh_End;
[PconCols,PnCols,ThreshCols] = ...
                    Find_Perm_Data(conditions,Pconnect_Perm,...
                    Pn_Perm,Thresh_Perm);
Result = Average(ThreshCols,PnCols,PconCols);
ResResult = reshape(Result,[size(Average,1) size(Average,3)]);

% Plotting 

X = Thresh_Begin:Thresh_Intv:Thresh_End;
Y = 0.000:0.001:0.09;

[XX,YY] = meshgrid(Y,X);
%(winter, summer, spring, parula(5), map, autumn(5),etc)
colormap cool;   
surf(XX,YY,ResResult);
view([-127.5 30]);
xlabel('P_c','fontweight','bold','FontSize',16);
ylabel('\theta','fontweight','bold','FontSize',22);
set(get(gca,'ZLabel'),'Rotation',0);
zlabel('\Omega','fontweight','bold','FontSize',18);
title({['P_n = (' num2str(Pn1) ', ' num2str(Pn2)...
    ',' num2str(Pn3) ')'], ['P_c = ( :, ' num2str(Pc2)...
    ', ' num2str(Pc3) '; ' num2str(Pc4) ', ' num2str(Pc5)...
    ', ' num2str(Pc6) '; ' num2str(Pc7) ', ' num2str(Pc8)...
    ', ' num2str(Pc9) ')']},'FontSize',18);
print -djpeg  run2_3Pn(.90,.85,.90).jpg -r250 ;


figure (2);
contour(XX,YY,ResResult);