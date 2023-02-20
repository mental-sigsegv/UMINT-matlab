clear;
clc;
close all;

MAX_ITERATIONS = 50;
MAX_GENERATIONS = 300;
POPULATION_SIZE = 100;
NUM_OF_GENES = 10;
MUTATION_RATE = 0.4;
AMPS = 10.0 * ones(1, NUM_OF_GENES);
SPACE = ones(2, NUM_OF_GENES).*[-500; 500];

valuesPerGenerations = 1:MAX_GENERATIONS;

figure(1);
xlabel('generation');
ylabel('f(x_i)');
title_str = sprintf('evolution graph (%d NUM_OF_GENES)', NUM_OF_GENES);
title(title_str);

axis([-1 MAX_GENERATIONS+1 -(NUM_OF_GENES+1)*420 -500]);

% axis([MAX_GENERATIONS-0.001 MAX_GENERATIONS -(NUM_OF_GENES)*418.99 -(NUM_OF_GENES)*418.97]); % zoom in

grid on;
hold on;

for iteration = 1:MAX_ITERATIONS
    pop = genrpop(POPULATION_SIZE, SPACE);
    % color = rand(1, 3);  % for random colors

    for generation = 1:MAX_GENERATIONS
        fitnessValues = schwefel(pop);
        popParents = selbest(pop, fitnessValues, [2 2 2 1 1 1]*floor(POPULATION_SIZE/50));
        %popChild = crossov(popParents, 2, 0);
        popChild = crosgrp(popParents, floor(POPULATION_SIZE/5));
        popChildMutated = muta(popChild, MUTATION_RATE, AMPS, SPACE);
    
        popSelsus = selsus(pop, fitnessValues, floor(POPULATION_SIZE/10));

        popRandom = selrand(pop, fitnessValues, floor(POPULATION_SIZE/10));

        popSeltourn = seltourn(pop, fitnessValues, POPULATION_SIZE-size(popParents)-size(popChildMutated)-size(popRandom)-size(popSelsus));
        popSeltourn(:) = mutx(popSeltourn, MUTATION_RATE, SPACE);
    
        pop(:) = [popParents; popChildMutated; popSelsus; popRandom; popSeltourn];
        [minValue, minIndex] = min(fitnessValues);
        valuesPerGenerations(generation) = minValue;
    end % generations
    plot(valuesPerGenerations, 'b');
    fprintf("%d. iteration: %4.4f\n\tPOPULATION_SIZE:", iteration, valuesPerGenerations(MAX_GENERATIONS-1));
    disp(pop(minIndex,:));
end % iterations

hold off;