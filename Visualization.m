%*****************************************************
%* Visualization                                     *
%* Visual aid for diffusion progress in networks     *
%* Lattice networks and Random networks              * 
%* By Francisco Dominguez                            *
%*****************************************************

%This program does the diffusion process in 2 different sce-
%narios. The first scenario is for Lattice Networks where the
%threshold is 4 throughout the population. Relations are with
%first neighbors only.
%
%The second does the same for an arbitrary adjacency matrix.
%In both cases it captures snapshots of the diffusion and then
%produces a video of the contagion.
%_____________________________________________________________

%% Lattice

L = 1000;
p = 0.95;
m = 3;

dNA = 1;
A = int8(rand(L)<p);
B = (zeros(L,L));
i = 1;
index = 0;

while dNA
    Aright = circshift(A, [0, 1]);
    Aleft = circshift(A, [0, -1]);
    Adown = circshift(A, [1, 0]);
    Aup = circshift(A, [-1, 0]);
    Amask = int8((Aright + Aleft + Adown + Aup) >= m);
    NAi=sum(sum(A)); 
    imagesc((1-A)), title({ 'Frame Number: ' num2str(i) }),...
        colormap(gray), axis square;
    set(gca, 'FontSize',12)
    pause(0.04)
    B=B+double(A);
    A=A.*Amask;
    NAf=sum(sum(A));
    dNA=NAi-NAf;
    Speed(i)=dNA;
    if (i >= index)
     filename = strcat('Animation2D_', num2str(index), '.jpg');
     print (filename , '-djpeg', '-r250')
     index = index + 30;
    end
    i=i+1;
end

%% Adjacency Matrix

clear all
clc

while (i <= 70)
    
    L = 100;
    Pob = L^2;
    Pn = 0.90;
    Pc = 0.00058;
    Threshold = 3;

    dNA = 1;
    i = 1;
    Connect2zero=zeros(Pob,1);
    A = double(rand(L)<Pn);
    Nvect = reshape(A,Pob,1);
    Adj_Mat=spones(sprand(Pob,Pob,Pc));
    Par_Connect=sum(Adj_Mat,2);
    index = 0;
   

    while dNA
        Connect2zero = Par_Connect - Adj_Mat * Nvect;
        Amask = (Connect2zero'<Threshold);
        NAi = sum(Nvect);
        Nvect = Nvect.*Amask';
        NAf = sum(Nvect);
        A=reshape(Nvect,[L L]);
        imagesc((1-A)), title({ 'Step Number: ' num2str(i) }),...
            colormap(gray),axis square
        set(gca, 'FontSize',15)
        pause(0.1)
        dNA=NAi-NAf;
        Speed(i)=dNA;
        if (i >= index) 
        filename = strcat('Animation2D_',...
                          num2str(index), '.jpg');
        print (filename , '-djpeg', '-r250')
        index = index + 2;
        end
        i=i+1;
    end
end
