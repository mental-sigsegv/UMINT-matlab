clear;
clc;
close all;

MAX_ITERATIONS = 5;
GENERATIONS = 300;
POP_SIZE = 100;
GENES = 10;
MUT_RATE = 0.4;
AMPS = 10.0 * ones(1, GENES);
SPACE = ones(2, GENES).*[-500; 500];

graphPoints = 1:GENERATIONS;

figure(1);
xlabel('generation');
ylabel('f(x_i)');
title("evolution graph");

axis([0 300 -4500 -500]);

grid on;
hold on;

for iteration = 1:MAX_ITERATIONS
    pop = genrpop(POP_SIZE, SPACE);

    for generation = 1:GENERATIONS
        fitnessValues = schwefel(pop);
        popParents = selbest(pop, fitnessValues, [4 4 4 2 2 2]);
        popChild = crosgrp(popParents, floor(20));
        popChildMutated = muta(popChild, MUT_RATE, AMPS, SPACE);
        popSelsus = selsus(pop, fitnessValues, floor(10));
        popRandom = selrand(pop, fitnessValues, floor(10));
        popSeltourn = seltourn(pop, fitnessValues, POP_SIZE-size(popParents)-size(popChildMutated)-size(popRandom)-size(popSelsus));
        popSeltourn = mutx(popSeltourn, MUT_RATE, SPACE);
    
        pop = [popParents; popChildMutated; popSelsus; popRandom; popSeltourn];
        [minValue, minIndex] = min(fitnessValues);
        graphPoints(generation) = minValue;
    end
    plot(graphPoints);
    fprintf("%2d. Iteration: %4.4f\n\tPopulation:", iteration, graphPoints(GENERATIONS-1));
    disp(pop(minIndex,:));
end

hold off;