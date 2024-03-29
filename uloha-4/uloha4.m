clear;clc;close all;

load("databody");

axis([0 1 0 1 0 1]);

plot3(0, 0, 0);

hold on;

plot3(data1(:,1), data1(:,2), data1(:,3), "x", "color", '#ffa500');
plot3(data2(:,1), data2(:,2), data2(:,3), "x", "color",  'black');
plot3(data3(:,1), data3(:,2), data3(:,3), "x", "color",  'blue');
plot3(data4(:,1), data4(:,2), data4(:,3), "x", "color",  'magenta');
plot3(data5(:,1), data5(:,2), data5(:,3), "x", "color",  'green');

fprintf("1. orange\n2. black\n3. blue\n4. magenta\n5. green\n");

title("Data body");
xlabel("x");
ylabel("y");
zlabel("z");

hold on

% vstupne data NS
X = [data1; data2; data3; data4; data5];
X = transpose(X);

% vystupne data
P = [ones(1, 50), zeros(1, 50), zeros(1, 50), zeros(1, 50), zeros(1, 50);
     zeros(1, 50), ones(1, 50), zeros(1, 50), zeros(1, 50), zeros(1, 50);
     zeros(1, 50), zeros(1, 50), ones(1, 50), zeros(1, 50), zeros(1, 50);
     zeros(1, 50), zeros(1, 50), zeros(1, 50), ones(1, 50), zeros(1, 50);
     zeros(1, 50), zeros(1, 50), zeros(1, 50), zeros(1, 50), ones(1, 50)];

% vytvorenie struktury NS na klasifikaciu
net = patternnet(15);

% trenovanie
net.divideFcn='dividerand';

net.divideParam.trainRatio=0.8;
net.divideParam.valRatio=0;
net.divideParam.testRatio=0.2;

net.trainParam.goal = 0.000001;
net.trainParam.epochs = 500;
net.trainParam.min_grad=1e-10;

net = train(net,X,P);

y = net(X);

classes = vec2ind(y);

X2=rand(3,5)

% simulacia vystupu NS
y2 = net(X2);
% priradenie vstupov do tried
classes2 = vec2ind(y2);

colors = ["#ffa500", "black", "blue", "magenta", "green"];

for i = 1:length(X2(1,:))
    color = colors(classes2(i));
    plot3(X2(1,i), X2(2,i), X2(3,i), 's', 'MarkerSize', 10, 'MarkerEdgeColor', color , 'LineWidth',1);
    text(X2(1,i)+0.05, X2(2,i), X2(3,i), int2str(i), 'FontSize', 12, 'Color', 'black', 'HorizontalAlignment', 'center');
end
fprintf('Vzorka piatich bodov ma nasledovne priradene skupiny: ');
disp(classes2);