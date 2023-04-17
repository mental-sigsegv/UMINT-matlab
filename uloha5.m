clear;clc;close all;

load("datafun");

n=length(y);
n2=fix(n/2);

% vytvorenie štruktúry NS 
net=fitnet([15 15]);

net.divideFcn='divideint';

net.divideParam.trainRatio=0.8;
net.divideParam.valRatio=0.2;
net.divideParam.testRatio=0.2;

% Nastavenie parametrov trénovania
net.trainParam.goal = 1e-4;
net.trainParam.show = 5;        
net.trainParam.epochs = 500;

% Trénovanie NS
net=train(net,x,y);

% Simulácia výstupu NS
outnetsim = sim(net,x);

% Vykreslenie priebehov
figure;
plot(x,y,'b',x,outnetsim,'-or');
hold on;

x2 = [1 2 3 4 5 6 7 8];
outnetsim2 = sim(net, x2);
scatter(x2, outnetsim2, 'b');

ERRsse = sse(net,y(indx_train),net(x(indx_train)));
fprintf("Train SSE: ");
disp(ERRsse);

ERRmse = mse(net,y(indx_train),net(x(indx_train)));
fprintf("Train MSE: ");
disp(ERRmse);
ERRmae = mae(net,y(indx_train),net(x(indx_train)));
fprintf("Train MAE: ");
disp(ERRmae);

ERRsse = sse(net,y(indx_test),net(x(indx_test)));
fprintf("Test SSE: ");
disp(ERRsse);

ERRmse = mse(net,y(indx_test),net(x(indx_test)));
fprintf("Test MSE: ");
disp(ERRmse);

ERRmae = mae(net,y(indx_test),net(x(indx_test)));
fprintf("Test MAE: ");
disp(ERRmae);
