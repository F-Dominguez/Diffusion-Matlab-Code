%*********************************************************
%* Critical_Test                                         *
%* Templates to perform critical Threshold tests.        *
%* By Francisco Dominguez                                *
%*********************************************************

%This is only a template for a very specific kind of task. We 
%want to find the first value of Threshold that gives us a 
%Proportion of adoption greater than X%. This can be then 
%plotted as a function of population size, Pconnect or Pn. 
%Both of the following templates were used as a basis when this
%kind of graph was being studied.
%_____________________________________________________________

%% Template 1

loop_rows = find(Pconnect_Perm(1,:)==.01007);
g = zeros(1,length(loop_rows));
for i = 1:length(loop_rows)
    f = find(Average(:,loop_rows(i))>2e-5,1,'last');
    if ~isempty(f)
        g(i) = Thresh_Begin + Thresh_Intv*(f-1);
    end
end
plot(Pconnect_Perm(4,loop_rows),g)

%% Template 2

g = zeros(1,size(Average,3));
for i = 1 :size(Average,3)
    f = find(Average(:,i)>4e-3,1,'last');
    if ~isempty(f)
        g(i) = f;
    end
end