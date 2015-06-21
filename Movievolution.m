%*****************************************************
%* Movievolution                                     *
%* Graphing script for 3D graphs videos of Pconnect, *
%* Pn and Threshold versus Proportion of Adoption    * 
%* By Francisco Dominguez                            *
%*****************************************************

%Similar to Graph3d, this script uses Find_Perm_Data to generate 
%multiple graphs of the simulation data. This program then cre-
%ates a video in .avi format to show the evolution of the beha-
%viour of the model when one parameter is varied. Therefore in 
%this case two parameters remain variable. 
%Each frame in the video is a graph plotted in a similar way to 
%Graph3d. This script is particularly useful for analysis of the
%behaviour of the model. 
%As in Graph3d Pc represents a different Pconnect value for a
%different submatrix while Pn represents a Pn value for a dif-
%ferent subvector. It is worthwhile to notice that Matlab num-
%bers cells in a matrix ordered by column; in a 3x3 matrix the
%numbering will be #1 for the first cell, then below that cell 
%#2 and to the right of #1 will be #4. 
%_____________________________________________________________


%% 1-Society

numframes = 1+(Pn_Mat(1,1,3)-Pn_Mat(1,1,1))/Pn_Mat(1,1,2);
clear i;

fig1 = figure;
set(fig1,'render','painters')
for i = 1:numframes;
    Pn = Pn_Mat(1,1,1) + (i-1)*Pn_Mat(1,1,2);
    conditions = {'Pn'       [1 Pn]};
    Thresh_Perm = Thresh_Begin:Thresh_Intv:Thresh_End;
    [PconCols,PnCols,ThreshCols] = Find_Perm_Data(conditions,...
        Pconnect_Perm,Pn_Perm,Thresh_Perm);
    Result = Average(ThreshCols,PnCols,PconCols);
    ResResult = reshape(...
                Result,[size(Average,1) size(Average,3)]);
    
    X = Thresh_Begin:Thresh_Intv:Thresh_End;
    Y = Pconnect_Mat(1,1,1):Pconnect_Mat(1,1,2):...
                            Pconnect_Mat(1,1,3);
   
    [XX,YY] = meshgrid(Y,X);
    %(cool, winter, summer, spring, map, autumn(5),etc)
    colormap cool(7);    
    surf(XX,YY,ResResult);
    % zlim([0 1]);
    % ylim([0 10]);
    view([-127.5 30]);
    xlabel('P_c','fontweight','bold','FontSize',16);
    ylabel('\theta','fontweight','bold','FontSize',22);
    set(get(gca,'ZLabel'),'Rotation',0);
    zlabel('\Omega','fontweight','bold','FontSize',18);
    title({['P_n = (' num2str(Pn) '),   P_c = ( : ),   W = ('...
    num2str(Weight_Pop(1,1)) ') ']},'FontSize',16);
    pause(.03);
    A(i) = getframe(fig1);
    cla;
end
 
close(fig1);
movie2avi(A,'1_Society.avi','compression','Cinepak','fps',3)

%% 2 Societies

% Define Parameters

%'numframes' is the number of graphs (and therefore frames) 
%to be made for the video.
numframes = 1+(Pn_Mat(1,1,3)-Pn_Mat(1,1,1))/Pn_Mat(1,1,2);
clear i;

Pn2 = 0.80;
Pc2 = 0.001;
Pc3 = 0.001;
Pc4 = 0.01;

% Frame Generation

%In this example Pn1 is the parameter changing every frame while
%Pc1 is the variable being plotted along with Threshold and 
%Proportion.

fig1 = figure;
set(fig1,'render','painters')
for i = 1:numframes;
    Pn1 = Pn_Mat(1,1,1) + (i-1)*Pn_Mat(1,1,2);
    conditions = {    'Pconnect' [2 Pc2];
                      'Pconnect' [3 Pc3];
                      'Pconnect' [4 Pc4];
                      'Pn'       [1 Pn1];
                      'Pn'       [2 Pn2]};
    
    Thresh_Perm = Thresh_Begin:Thresh_Intv:Thresh_End;
    [PconCols,PnCols,ThreshCols] = Find_Perm_Data(conditions,...
        Pconnect_Perm,Pn_Perm,Thresh_Perm);
    Result = Average(ThreshCols,PnCols,PconCols);
    ResResult = reshape(...
                Result,[size(Average,1) size(Average,3)]);
    
    X = Thresh_Begin:Thresh_Intv:Thresh_End;
    Y = 0.001:0.001:0.02;
    
    [XX,YY] = meshgrid(Y,X);
    colormap cool;
    surf(XX,YY,ResResult);
    view([-127.5 30]);
    xlabel('Pconnect');
    ylabel('Threshold');
    zlabel('Proportion of Adoption');
    title(['Adoption for Pn = (' num2str(Pn1) ', ' num2str...
        (Pn2)'), Pconnect = ( : , ' num2str(Pc2) ', ' ...
        num2str(Pc3) ', 'num2str(Pc4) '), Weight = (' ...
        num2str(Weight_Pop(1,1)) ', 'num2str(Weight_Pop...
        (1,2)) ', ' num2str(Weight_Pop(2,1)) ', ' ...
        num2str(Weight_Pop(2,2)) ') ']);
    pause(.05);
    A(i) = getframe(fig1);
    cla;
end

% Movie making

close(fig1);
movie2avi(A,'testsss.avi','compression','Cinepak','fps',3)

%% 3-Societies 

%Define Parameters (3-D)

%'numframes' is the number of graphs (and therefore frames) 
%to be made for the video.
numframes = 1+(Pn_Mat(1,1,3)-Pn_Mat(1,1,1))/Pn_Mat(1,1,2);
clear i;

Pc2 = 0.005;
Pc3 = 0.001;
Pc4 = 0.005;
Pc5 = 0.01;
Pc6 = 0.001;
Pc7 = 0.001;
Pc8 = 0.001;
Pc9 = 0.01;

Pn1 = 0.75;
Pn3 = 0.90;

% Frame Generation (3-D)

% In this example Pn1 is the parameter changing every frame while 
% Pc1 is the variable being plotted along with Threshold and
% Proportion.

fig1 = figure;
set(fig1,'render','painters')
for i = 1:numframes;
    Pn2 = Pn_Mat(1,1,1) + (i-1)*Pn_Mat(1,1,2);
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
    [PconCols,PnCols,ThreshCols] = Find_Perm_Data(conditions,...
                         Pconnect_Perm,Pn_Perm,Thresh_Perm);
    Result = Average(ThreshCols,PnCols,PconCols);
    ResResult = reshape(...
                Result,[size(Average,1) size(Average,3)]);
    
    X = Thresh_Begin:Thresh_Intv:Thresh_End;
    Y = 0.001:0.0005:0.02;
    
    [XX,YY] = meshgrid(Y,X);
    colormap cool;
    surf(XX,YY,ResResult);
    view([-127.5 30]);
    xlabel('Pconnect');
    ylabel('Threshold');
    zlabel('Proportion of Adoption');
    title(['Pn = (' num2str(Pn1) ', ' num2str(Pn2)...
    ',' num2str(Pn3) '), Pc = ( :, ' num2str(Pc2)...
    ', ' num2str(Pc3) '; ' num2str(Pc4) ', ' num2str(Pc5)...
    ', ' num2str(Pc6) '; ' num2str(Pc7) ', ' num2str(Pc8)...
    ', ' num2str(Pc9) ')']);
    pause(.03);
    A(i) = getframe(fig1);
    cla;
end

% Movie making (3-D)

close(fig1);
movie2avi(A,'run2Pn1_0.75Pn3_0.90.avi','compression','Cinepak','fps',3)