%*********************************************************
%*Graph2D                                           *
%*Template for generating 2D plot.                       *
%* By Francisco Dominguez                                *
%*********************************************************

%This is basically a template for plotting 2D plots of data
%from the simulation. It must be edited based on individual
%plot requirements.
%_____________________________________________________________

%%One Society_2-D Plot

Pc = 0.012;
Pn = 0.7;
conditions = {    'Pconnect' [1 Pc];
                  'Pn' [1 Pn]};
Thresh_Perm = Thresh_Begin:Thresh_Intv:Thresh_End;
[PconCols,PnCols,ThreshCols] = Find_Perm_Data(conditions,...
    Pconnect_Perm,Pn_Perm,Thresh_Perm);
Result = Average(ThreshCols,PnCols,PconCols);
Error = MSE(ThreshCols,PnCols,PconCols);

figure (1);
h = errorbar(Thresh_Begin:Thresh_Intv:Thresh_End,Result,Error);
% h = plot(Thresh_Begin:Thresh_Intv:Thresh_End,Result);
set(h,'color',[0, 0.5078, 0])                  %// data
set(h,'LineWidth',1.4,{'LineStyle'},{'-'});    %'--'; ':'; '-.'
set(h,{'Marker'},{'o'});                       %'none';'o';'x'
set(gca, 'FontSize',14)
grid on;
xlim([44 58]);
ylim([-0.1 1.1]);
xlabel('\theta','fontweight','bold','FontSize',18);
ylabel('\Omega      ','fontweight','bold','FontSize',16);
set(get(gca,'YLabel'),'Rotation',0);
title({['P_n = (' num2str(Pn) '),   P_c = (' num2str(Pc) '),...
    W = (' num2str(Weight_Pop(1,1)) ') ']},'FontSize',16);
print -djpeg  Pn0.7Pc0.012error.jpg -r250;
saveas(gcf,'Pn0.7Pc0.012error.fig');

%% Multiple 2-D Plots

Pn = 0.7;
z = 1;
Result = zeros(1+(Thresh_End - Thresh_Begin)/Thresh_Intv,...
         (Pconnect_Mat(1,1,3)-Pconnect_Mat(1,1,1))/...
         Pconnect_Mat(1,1,2));
for i= Pconnect_Mat(1,1,1):Pconnect_Mat(1,1,2):...
                           Pconnect_Mat(1,1,3);

conditions = {    'Pconnect' [1 i];
                  'Pn' [1 Pn]};
Thresh_Perm = Thresh_Begin:Thresh_Intv:Thresh_End;
[PconCols,PnCols,ThreshCols] = Find_Perm_Data(conditions,...
    Pconnect_Perm,Pn_Perm,Thresh_Perm);
Result(:,z) = Average(ThreshCols,PnCols,PconCols);
Error(:,z) = MSE(ThreshCols,PnCols,PconCols);
z = z + 1;
end

k1 = 0.01;
k2 = 0.012;
k3 = 0.014;

x1 = 1 + (k1 - Pconnect_Mat(1,1,1))/Pconnect_Mat(1,1,2);
x2 = 1 + (k2 - Pconnect_Mat(1,1,1))/Pconnect_Mat(1,1,2);
x3 = 1 + (k3 - Pconnect_Mat(1,1,1))/Pconnect_Mat(1,1,2);

figure (1);
h = plot(Thresh_Begin:Thresh_Intv:Thresh_End,Result(:,x1),...
         Thresh_Begin:Thresh_Intv:Thresh_End,Result(:,x2),...
         Thresh_Begin:Thresh_Intv:Thresh_End,Result(:,x3));
set(h,'LineWidth',1.4,{'LineStyle'},{'-'});  % '--' ; ':' ; '-.'
set(h,{'Marker'},{'o'});                     % 'none';'o';'x'
set(gca, 'FontSize',14)
axis tight;
grid on;
xlim([36 66]);
ylim([-0.1 1.1]);
legend('P_c = 0.01','P_c = 0.012','P_c = 0.014');
xlabel('\theta','fontweight','bold','FontSize',18);
ylabel('\Omega      ','fontweight','bold','FontSize',16);
set(get(gca,'YLabel'),'Rotation',0);
title({['P_n = (' num2str(Pn) '),    W = ('...
    num2str(Weight_Pop(1,1)) ') ']},'FontSize',16);
print -djpeg  Pn0.7triplePc.jpg -r250;
saveas(gcf,'Pn0.7triplePc.fig');

%% Critical Threshold


Pc = Pconnect_Begin;
Pn = Pn_Begin;
Weight_Pop = 1;

n =2;
x = Critical(2, 1 : n :end);
y = Critical(1, 1 : n :end);

h = plot( x ,y,'MarkerSize', 4);
set(h,'LineWidth',1.4,{'LineStyle'},{'-'});   % '--' ; ':' ; '-.'
set(h,{'Marker'},{'o'});                      % 'none';'o';'x'
set(h,{'Color'},{'b'});                       % 'r';'g';'b'
set(gca, 'FontSize',14)
pbaspect([1.8 1 1]);           

axis tight;
grid on;
xlabel('m','fontweight','bold','FontSize',18);
ylabel('\theta_c      ','fontweight','bold','FontSize',16);
set(get(gca,'YLabel'),'Rotation',0);
title({['P_n = (' num2str(Pn) '),   P_c = (' num2str(Pc) '),...
   W = (' num2str(Weight_Pop) ') ']},'FontSize',16);

%Obtain a Fit.

coeffs = polyfit(x, y, 1);

% Get fitted values

b = 1 + (Pop_End - Pop_Begin) / (Pop_Intv*n);
fittedX = linspace(min(x), max(x), b);
fittedY = polyval(coeffs, fittedX);
R = corrcoef([y' fittedY'])

% Plot the fitted line

hold on;
plot(fittedX, fittedY, 'r-', 'LineWidth', 2);

print -djpeg  Critical.jpg -r250;
saveas(gcf,'Critical.fig');