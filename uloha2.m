clear;
clc;
% close all;

points = [0,0; 77,68; 12,75; 32,17; 51,64; 20,19; 72,87; 80,37; 35,82;
2,15; 18,90; 33,50; 85,52; 97,27; 37,67; 20,82; 49,0; 62,14; 7,60;
100,100];

chromosomePermutePart = 2:19;

SWAP_RATE = 0.15;


drawPoints(points);
drawNumbers(points);

MAX_ITERATIONS = 10;
MAX_GENERATIONS = 300;
POPULATION_SIZE = 150;

fitnessPerGeneration = zeros(MAX_ITERATIONS, MAX_GENERATIONS);
fitnessBestPath = 1:18;

chromosomeMiddleParts = zeros(POPULATION_SIZE, 18);

for i = 1:POPULATION_SIZE
    chromosomeMiddleParts(i,:) = [chromosomePermutePart(randperm(length(chromosomePermutePart)))];
end

fitnessBest = fitnessPop(points, chromosomePermutePart(1,:));

for iteration = 1:MAX_ITERATIONS
    chromosomeMiddleParts = zeros(POPULATION_SIZE, 18);
    for i = 1:POPULATION_SIZE
        chromosomeMiddleParts(i,:) = [chromosomePermutePart(randperm(length(chromosomePermutePart)))];
    end
    for generation = 1:MAX_GENERATIONS
        fitness = fitnessPop(points, chromosomeMiddleParts);
        theBest = selbest(chromosomeMiddleParts, fitness, 1);
        if fitnessPop(points, theBest) < fitnessBest
            fitnessBest = fitnessPop(points, theBest);
            fitnessBestPath = theBest;
        end
%         drawLineCH(points, theBest);
    %      pause(0.1);
        a = selbest(chromosomeMiddleParts, fitness, [3 3 3 2 2 1 1 1 1]);
        b = swapgen(selbest(chromosomeMiddleParts, fitness, ones(1, 10) * 2), SWAP_RATE);
        b(:) = swapgen(crosord(b, 0), SWAP_RATE);
        
        c = swapgen(selrand(chromosomeMiddleParts, fitness, ones(1, 10)), SWAP_RATE);
        c(:) = swapgen(crosord(c, 0), SWAP_RATE);
        e = a(1:5,:);
        for i = 1:5
            e(i,:) = [a(i,1:9), a(i,10:18)];
        end
        e(:) = crosord(e, 0);
        d = swapgen(seltourn(chromosomeMiddleParts, fitness, POPULATION_SIZE-size(a)-size(b)-size(c)-size(e)), SWAP_RATE);
        
        chromosomeMiddleParts(:) = [a; b; c; d; e];

%         drawLineCH(points, theBest);
%         pause(0.01);
    end
    fprintf("Iteration %2d.: \n\tvalue: %.2f\n", iteration, fitnessPop(points, theBest));
end

fitnessBestPath = [1, fitnessBestPath, 20];
fitnessBestPathString = num2str(fitnessBestPath);
fprintf("\nLenght of the shortest path: %.2f\n\tPath of line\n\t%s\n", fitnessBest, fitnessBestPathString);


drawLineCH(points, fitnessBestPath);

function [] = drawPoints(points)
    pointsX = points(:,1);
    pointsY = points(:,2);
    scatter(pointsX, pointsY, 50, "filled");
end


function [] = drawLineCH(points, chromosome)

    persistent line;
        if ~isempty(line)
            delete(line);
        end

    pointsX = 1:20;
    pointsY = 1:20;
    
    pointsX(1) = 0;
    pointsX(20) = 100;
    pointsY(1) = 0;
    pointsY(20) = 100;


    for i = 2:length(chromosome)+1
        pointsX(i) = points(chromosome(i-1),1);
        pointsY(i) = points(chromosome(i-1),2);
    end

    hold on;
    line = plot(pointsX, pointsY, 'r');
    hold off;
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
        Fit(i) = Fit(i) + getLenghtAB([0,0], population(chromozene(i,1),:));
        Fit(i) = Fit(i) + getLenghtAB(population(chromozene(i,18),:), [100, 100]);
    end
end

function [length] = getLenghtAB(A, B)
    length = sqrt((B(1)-A(1))^2 + (B(2)-A(2))^2);
end