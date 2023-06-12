clear;
clc;
close all;

POINTS = [0,0; 77,68; 12,75; 32,17; 51,64; 20,19; 72,87; 80,37; 35,82;
2,15; 18,90; 33,50; 85,52; 97,27; 37,67; 20,82; 49,0; 62,14; 7,60;
100,100];
middlePart = 2:19;
SWAP_RATE = 0.15;
ITERATIONS = 10;
GENERATIONS = 300;
POP_SIZE = 150;
fitnessPerGeneration = zeros(ITERATIONS, GENERATIONS);
bestPath = 2:19;
bestFitness = fitness(POINTS, middlePart(1,:));
figure(1);
xlabel('generation');
ylabel('path length');
title('evolution graph');
axis([-1 300 250 1100]);

for iteration = 1:ITERATIONS
    valuesPerGenerations = 1:GENERATIONS;
    chromosome = zeros(POP_SIZE, 18);

    for i = 1:POP_SIZE
        chromosome(i,:) = [middlePart(randperm(length(middlePart)))];
    end

    for generation = 1:GENERATIONS
        
        fitnessValues = fitness(POINTS, chromosome);
        minValue = min(fitnessValues);
        valuesPerGenerations(generation) = minValue;
        popTheBest = selbest(chromosome, fitnessValues, 1);

        if fitness(POINTS, popTheBest) < bestFitness
            bestFitness = fitness(POINTS, popTheBest);
            bestPath = popTheBest;
        end

        popBest = selbest(chromosome, fitnessValues, [3 3 3 2 2 1 1 1 1]);
        popBestChanged = swapgen(selbest(chromosome, fitnessValues, ones(1, 10) * 2), SWAP_RATE);
        popBestChanged = swapgen(crosord(popBestChanged, 0), SWAP_RATE);
        popRand = swapgen(selrand(chromosome, fitnessValues, ones(1, 10)), SWAP_RATE);
        popRandChanged = invord(crosord(popRand, 0), SWAP_RATE);
        popTourn = invord(seltourn(chromosome, fitnessValues, POP_SIZE-size(popBest)-size(popBestChanged)-size(popRandChanged)), SWAP_RATE);
        chromosome = [popBest; popBestChanged; popRandChanged; popTourn];
    
    end
    figure(1)
    hold on;
    plot(valuesPerGenerations);
    fprintf("Iteration %2d.: \n\tvalue: %.2f\n", iteration, fitness(POINTS, popTheBest));
end

figure(2);
drawPoints(POINTS);
drawNumbers(POINTS);
title('path');
xlabel('x');
ylabel('y');
bestPath = [1, bestPath, 20];
fprintf("\nLenght of the shortest path: %.2f\n\tPath of line\n\t%s\n", bestFitness, num2str(bestPath));
drawPath(POINTS, bestPath);

function [] = drawPoints(points)
    pointsX = points(:,1);
    pointsY = points(:,2);
    scatter(pointsX, pointsY, 50, "filled");
end

function [] = drawPath(points, chromosome)
    pointsX(1) = 0;
    pointsX(20) = 100;
    pointsY(1) = 0;
    pointsY(20) = 100;

    for i = 2:length(chromosome)+1
        pointsX(i) = points(chromosome(i-1),1);
        pointsY(i) = points(chromosome(i-1),2);
    end

    hold on;
    plot(pointsX, pointsY, 'r');
    hold off;
end

function [] = drawNumbers(points)
    pointsX = points(:,1);
    pointsY = points(:,2);

    for i = 1:size(points, 1)
        text(pointsX(i)+1.25, pointsY(i)+0.75, num2str(i));
    end
end

function [Fit] = fitness(population, chromosome)
    [popSize, geneSize] = size(chromosome);
    Fit = zeros(1, popSize);
    for i = 1:popSize
        Fit(i) = 0;
        for j = 1:geneSize - 1
            Fit(i) = Fit(i) + pythagoras(population(chromosome(i,j),:), population(chromosome(i,j+1),:));    
        end
        Fit(i) = Fit(i) + pythagoras([0,0], population(chromosome(i,1),:));
        Fit(i) = Fit(i) + pythagoras(population(chromosome(i,18),:), [100, 100]);
    end
end

function [length] = pythagoras(A, B)
    length = sqrt((B(1)-A(1))^2 + (B(2)-A(2))^2);
end