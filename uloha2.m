clear;
clc;
close all;

POINTS = [0,0; 77,68; 12,75; 32,17; 51,64; 20,19; 72,87; 80,37; 35,82;
2,15; 18,90; 33,50; 85,52; 97,27; 37,67; 20,82; 49,0; 62,14; 7,60;
100,100];

chromosomePP = 2:19;  % chromosome permutation part

SWAP_RATE = 0.15;
MAX_ITERATIONS = 10;
MAX_GENERATIONS = 300;
POPULATION_SIZE = 150;

fitnessPerGeneration = zeros(MAX_ITERATIONS, MAX_GENERATIONS);
bestPath = 2:19;
bestFitness = fitnessPop(POINTS, chromosomePP(1,:));

figure(1);
xlabel('generation');
ylabel('path length');
title('evolution graph of length values');
axis([-1 MAX_GENERATIONS+1 300 1000]);

for iteration = 1:MAX_ITERATIONS
    valuesPerGenerations = 1:MAX_GENERATIONS;
    chromosome = zeros(POPULATION_SIZE, 18);

    % fill chromosome population with random chromosomes
    for i = 1:POPULATION_SIZE
        chromosome(i,:) = [chromosomePP(randperm(length(chromosomePP)))];
    end

    % generations
    for generation = 1:MAX_GENERATIONS
        
        fitnessValues = fitnessPop(POINTS, chromosome);
        minValue = min(fitnessValues);
        valuesPerGenerations(generation) = minValue;
        popTheBest = selbest(chromosome, fitnessValues, 1);
        
        % save best fitness and population
        if fitnessPop(POINTS, popTheBest) < bestFitness
            bestFitness = fitnessPop(POINTS, popTheBest);
            bestPath = popTheBest;
        end

        popBest = selbest(chromosome, fitnessValues, [3 3 3 2 2 1 1 1 1]);
        popBestChanged = swapgen(selbest(chromosome, fitnessValues, ones(1, 10) * 2), SWAP_RATE);
        popBestChanged = swapgen(crosord(popBestChanged, 0), SWAP_RATE);
        
        popRand = swapgen(selrand(chromosome, fitnessValues, ones(1, 10)), SWAP_RATE);
        popRandChanged = invord(crosord(popRand, 0), SWAP_RATE);
        
        popTourn = invord(seltourn(chromosome, fitnessValues, POPULATION_SIZE-size(popBest)-size(popBestChanged)-size(popRandChanged)), SWAP_RATE);
        
        chromosome = [popBest; popBestChanged; popRandChanged; popTourn];
    
    end
    figure(1)
    hold on;
    color = rand(1, 3);  % for random colors
    plot(valuesPerGenerations, 'Color', color);
    fprintf("Iteration %2d.: \n\tvalue: %.2f\n", iteration, fitnessPop(POINTS, popTheBest));
end

% draw path
figure(2);
drawPoints(POINTS);
drawNumbersNextToPoints(POINTS);
title('path');
xlabel('x');
ylabel('y');
bestPath = [1, bestPath, 20];
fprintf("\nLenght of the shortest path: %.2f\n\tPath of line\n\t%s\n", bestFitness, num2str(bestPath));
drawPath(POINTS, bestPath);

% ----------------- %
% DEFINED FUNCTIONS %
% ----------------- %

% draw points
function [] = drawPoints(points)
    pointsX = points(:,1);
    pointsY = points(:,2);
    scatter(pointsX, pointsY, 50, "filled");
end

% draw path as line based on points and chromosome order
function [] = drawPath(points, chromosome)
    % define start and end
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

% plot numbers
function [] = drawNumbersNextToPoints(points)
    pointsX = points(:,1);
    pointsY = points(:,2);

    for i = 1:size(points, 1)
        text(pointsX(i)+1.25, pointsY(i)+0.75, num2str(i));
    end
end

% calculate fitness value of population based on chromosone set
function [Fit] = fitnessPop(population, chromosome)
    [popSize, geneSize] = size(chromosome);
    Fit = zeros(1, popSize);
    for i = 1:popSize
        Fit(i) = 0;
        for j = 1:geneSize - 1
            Fit(i) = Fit(i) + lengthPoints(population(chromosome(i,j),:), population(chromosome(i,j+1),:));    
        end
        Fit(i) = Fit(i) + lengthPoints([0,0], population(chromosome(i,1),:));
        Fit(i) = Fit(i) + lengthPoints(population(chromosome(i,18),:), [100, 100]);
    end
end

% calculate distance between 2 points
function [length] = lengthPoints(pointA, pointB)
    length = sqrt((pointB(1)-pointA(1))^2 + (pointB(2)-pointA(2))^2);
end