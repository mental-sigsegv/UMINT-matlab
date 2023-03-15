clear;
clc;
close all;
hold off;
MAX_INVEST = 10;
SPACE = ones(2, 5).*[0; MAX_INVEST];
POP_SIZE = 100;


MAX_GENERATIONS = 15000;
MAX_ITERATIONS = 5;
MUTATION_RATE = 0.6;
AMPS = 1.0 * ones(1, 5);
axis([-1 MAX_GENERATIONS+1 4e5 8e5]);
hold on;
plotValues = 1:MAX_GENERATIONS;

ALL_BEST = 0;
BEST_DECISION = 0;
ALL_BEST_GENE = 0;
for i = 1:MAX_ITERATIONS
    pop = genrpop(POP_SIZE, SPACE);
    HIGHEST_INCOME = 0;

for g = 1:MAX_GENERATIONS
%     fitnessValues = financeFitnessDeathPenalty(pop);  %r
    fitnessValues = financeFitnessProportional(pop);  %b
%     fitnessValues = financeFitnessGradational(pop);  %g


    [generationProfit, generationIndex] = min(fitnessValues);
    generationPopulation = pop(generationIndex, :);
    generationProfit = -generationProfit*1e6;
    plotValues(g) = generationProfit;

   
    popParents = selbest(pop, fitnessValues, [1 1 1 1 1 1 1 1]);
    %popChild = crossov(popParents, 2, 0);
    popChild = crosgrp(popParents, floor(POP_SIZE/14));
    popChildMutated = muta(popChild, MUTATION_RATE, AMPS, SPACE);

    popSelsus = selsus(pop, fitnessValues, floor(POP_SIZE/14));
    popSelsus = muta(popSelsus, fitnessValues, AMPS, SPACE);

    popRandom = selrand(pop, fitnessValues, floor(POP_SIZE/20));
    popRandom = muta(popRandom, fitnessValues, AMPS, SPACE);

    popSeltourn = seltourn(pop, fitnessValues, POP_SIZE-size(popParents)-size(popChildMutated)-size(popRandom)-size(popSelsus));
    popSeltourn(:) = mutx(popSeltourn, MUTATION_RATE, SPACE);

    pop(:) = [popParents; popChildMutated; popSelsus; popRandom; popSeltourn];
end    
    fprintf("Income of %2.d. iteration %6.2f\n", i, generationProfit);
    if generationProfit > ALL_BEST
        ALL_BEST = generationProfit;
        ALL_BEST_GENE = generationPopulation;
    end
    disp(generationPopulation);
    plot(plotValues, 'b');
end

fprintf("\nBest income from all iterations: %6.2f\nBest investment combination:\n", ALL_BEST);
disp(ALL_BEST_GENE*1e6);



function [Fit] = financeFitnessProportional(population)
    MAX_INVEST = 10;
    penatlyCoef = 2;
    [popSize, geneSize] = size(population);
    Fit = zeros(1, popSize);
    for p = 1:popSize
        penalty = 0;

        Fit(p) = -(0.04*population(p, 1)+0.07*population(p, 2)+0.11*population(p, 3)+0.06*population(p, 4)+0.05*population(p, 5));

        if sum(population(p, :)) > MAX_INVEST
            penalty = penalty + penatlyCoef*(sum(population(p, :)) - MAX_INVEST);
        end

        if population(p, 1) + population(p, 2) > 2.5
            penalty = penalty + penatlyCoef*(population(p, 1) + population(p, 2) - 2.5);
        end

        if -population(p, 4) + population(p, 5) > 0
            penalty = penalty + penatlyCoef*(-population(p, 4) + population(p, 5));
        end
         
        if (0.5 * (-population(p, 1)-population(p, 2)+population(p, 3)+population(p, 4)-population(p, 5))) > 0
            penalty = penalty + penatlyCoef*((0.5 * (-population(p, 1)-population(p, 2)+population(p, 3)+population(p, 4)-population(p, 5))));
        end

        Fit(p) = Fit(p) + penalty;
    end
end

function [Fit] = financeFitnessDeathPenalty(population)
    POKUTA = 0;
    MAX_INVEST = 10;
    [popSize, geneSize] = size(population);
    Fit = zeros(1, popSize);
    for p = 1:popSize
        if sum(population(p, :)) > MAX_INVEST
            Fit(p) = POKUTA;
        elseif population(p, 1) + population(p, 2) > 2.5
            Fit(p) = POKUTA;
        elseif -population(p, 4) +population(p, 5) > 0
            Fit(p) = POKUTA;
        elseif (0.5 * (-population(p, 1)-population(p, 2)+population(p, 3)+population(p, 4)-population(p, 5))) > 0
            Fit(p) = POKUTA;
        else
            Fit(p) = -(0.04*population(p, 1)+0.07*population(p, 2)+0.11*population(p, 3)+0.06*population(p, 4)+0.05*population(p, 5));
        end
    end
end


function [Fit] = financeFitnessGradational(population)
    MAX_INVEST = 10;
    
    penaltyBase = 25;
    [popSize, geneSize] = size(population);
    Fit = zeros(1, popSize);
    for p = 1:popSize
       numOfPenalties = 0;
       Fit(p) = -(0.04*population(p, 1)+0.07*population(p, 2)+0.11*population(p, 3)+0.06*population(p, 4)+0.05*population(p, 5));

       if sum(population(p, :)) > MAX_INVEST
            numOfPenalties = numOfPenalties + 1;
       end

       if (population(p, 1) + population(p, 2)) > 2.5
            numOfPenalties = numOfPenalties + 1;
       end

       if (-population(p, 4) + population(p, 5)) > 0
            numOfPenalties = numOfPenalties + 1;
       end

       if (0.5 * (-population(p, 1) - population(p, 2) + population(p, 3) + population(p, 4) - population(p, 5))) > 0
            numOfPenalties = numOfPenalties + 1;
       end

       if numOfPenalties > 0
           Fit(p) = Fit(p) + penaltyBase^numOfPenalties;
       end
    end
end
