clear;clc;close all;

load("databody");
% vykreslenie dat
h = figure;
axis([0 1 0 1 0 1]);
plot3(data1(:,1), data1(:,2), data1(:,3), "x", data2(:,1), data2(:,2), data2(:,3), "x", data3(:,1), data3(:,2), data3(:,3), "x", data4(:,1), data4(:,2), data4(:,3), "x", data5(:,1), data5(:,2), data5(:,3), "x");
hold on;
plot3(0.5, 0.5, 0.5, 'b-', 'LineWidth', 2);
title("Data body");
xlabel("x");
ylabel("y");
zlabel("z");

hold on

% vstupne data NS
X = [data1; data2; data3; data4; data5];
X = transpose(X);

P = [ones(1, 50), zeros(1, 50), zeros(1, 50), zeros(1, 50), zeros(1, 50);
     zeros(1, 50), ones(1, 50), zeros(1, 50), zeros(1, 50), zeros(1, 50);
     zeros(1, 50), zeros(1, 50), ones(1, 50), zeros(1, 50), zeros(1, 50);
     zeros(1, 50), zeros(1, 50), zeros(1, 50), ones(1, 50), zeros(1, 50);
     zeros(1, 50), zeros(1, 50), zeros(1, 50), zeros(1, 50), ones(1, 50)]

net = patternnet(15);

net.divideParam.trainRatio=0.8;
net.divideParam.valRatio=0;
net.divideParam.testRatio=0.2;

net.trainParam.goal = 0.000001;
net.trainParam.epochs = 500;
net.trainParam.min_grad=1e-10;

net = train(net,X,P);


y = net(X);

classes = vec2ind(y);

% test
X2=[0.3 0.4 0.7 0.8 0.5;0.6 0.7 0.2 0.3 0.5; 0.1 0.2 0.3 0.4 0.8];

% simulacia vystupu NS
y2 = net(X2);
% priradenie vstupov do tried
classes2 = vec2ind(y2);
fprintf('Vzorka piatich bodov ma nasledovne priradene skupiny: ');
disp(classes2);