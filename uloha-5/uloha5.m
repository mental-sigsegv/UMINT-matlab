clear;clc;close all;

load("datafun");

% vytvorenie štruktúry NS 
net=fitnet([20 20]);
% net=fitnet(5);
% net=fitnet([5 5 5 5 5 5]);
% net=fitnet([5 10 5])

net.divideFcn='divideint';
net.divideParam.trainRatio=0.8;
net.divideParam.valRatio=0.2;
net.divideParam.testRatio=0.2;

net.trainParam.goal = 1e-4;
net.trainParam.show = 5;        
net.trainParam.epochs = 500;

net=train(net,x,y);

outnetsim = sim(net,x);

% Vykreslenie priebehov
figure;
plot(x,y,'b',x,outnetsim,'-or');
hold on;

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
