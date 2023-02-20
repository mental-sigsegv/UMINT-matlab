clear;
clc;
% close all;

points = [0,0; 77,68; 12,75; 32,17; 51,64; 20,19; 72,87; 80,37; 35,82;
2,15; 18,90; 33,50; 85,52; 97,27; 37,67; 20,82; 49,0; 62,14; 7,60;
100,100];

chromozonePermutePart = 2:19;

SWAP_RATE = 0.6;

% chromozonePermutePart = chromozonePermutePart(randperm(length(chromozonePermutePart)));
% TESTING_CH = [1, chromozonePermutePart, 20]
% chromozonePermutePart = swapgen(chromozonePermutePart, SWAP_RATE);
% TESTING_CH2 = [1, chromozonePermutePart, 20]

% return;

drawPoints(points);
drawNumbers(points);

MAX_GENERATIONS = 1;
POPULATION_SIZE = 10;
chromozome = zeros(POPULATION_SIZE, 20);

for i = 1:POPULATION_SIZE
    chromozome(i,:) = [1, chromozonePermutePart(randperm(length(chromozonePermutePart))), 20];
end

% chromozome
% T_POINTS = [0,0; 0,5; 5,5; 10,10;];
% fitnessPop(T_POINTS, [[1,2,3,4]; [1,4,2,4]])

return;

for iteration = 1:MAX_GENERATIONS
    
    ch1 = [1, chromozonePermutePart, 20];
    points = getNewpoints(points, ch1);
    drawLine(points);
    chromozonePermutePart = chromozonePermutePart(randperm(length(chromozonePermutePart)));
    pause(0.5);
end

function [array] = getNewpoints(points, chromozone)
    array = zeros(20, 2);

    for i = 1:length(chromozone)
        array(i, 1) = points(chromozone(i), 1);
        array(i, 2) = points(chromozone(i), 2);
    end  
end

function [] = drawLine(points)
    persistent line;
    if ~isempty(line)
        delete(line);
    end
    hold on;
    line = plot(points(:,1), points(:,2), 'r');
    hold off;
end

function [] = drawPoints(points)
    pointsX = points(:,1);
    pointsY = points(:,2);
    scatter(pointsX, pointsY, 50, "filled");
    
end

function [] = drawNumbers(points)
    pointsX = points(:,1);
    pointsY = points(:,2);

    for i = 1:size(points, 1)
        text(pointsX(i)+1.25, pointsY(i)+0.75, num2str(i));
    end
end


function [Fit] = fitnessPop(population, chromozene)
    [popSize, geneSize] = size(chromozene);
    for i = 1:popSize
        Fit(i) = 0;
        for j = 1:geneSize - 1
            Fit(i) = Fit(i) + getLenghtAB(population(chromozene(i,j),:), population(chromozene(i,j+1),:));    
        end
    end
end

function [length] = getLenghtAB(A, B)
    length = sqrt((B(1)-A(1))^2 + (B(2)-A(2))^2);
end