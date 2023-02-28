clear;
clc;
close all;
hold off;
MAX_INVEST = 2.5e6;
SPACE = ones(2, 5).*[0; MAX_INVEST];
POP_SIZE = 150;


MAX_GENERATIONS = 500;
MAX_ITERATIONS = 10;
MUTATION_RATE = 0.75;
AMPS = 10.0 * ones(1, 5);
axis([-1 MAX_GENERATIONS+1 4e5 8e5]);
hold on;
plotValues = 1:MAX_GENERATIONS;

ALL_BEST = 0;
for i = 1:MAX_ITERATIONS
    pop = genrpop(POP_SIZE, SPACE);
    HIGHEST_INCOME = 0;
for g = 1:MAX_GENERATIONS
    fitnessValues = financeFitnessDeathPenalty(pop);
    fitnessValues = financeFitnessGradational(pop);


    [minValue, minIndex] = min(fitnessValues);
    plotValues(g) = -min(fitnessValues);

    if -minValue >HIGHEST_INCOME
        HIGHEST_INCOME = -minValue;
        BEST_DECISION = pop(minIndex, :);
    end

    popParents = selbest(pop, fitnessValues, [2 2 2 1 1 1]*floor(POP_SIZE/50));
    %popChild = crossov(popParents, 2, 0);
    popChild = crosgrp(popParents, floor(POP_SIZE/5));
    popChildMutated = muta(popChild, MUTATION_RATE, AMPS, SPACE);

    popSelsus = selsus(pop, fitnessValues, floor(POP_SIZE/5));
    popSelsus = muta(popSelsus, fitnessValues, AMPS, SPACE);

    popRandom = selrand(pop, fitnessValues, floor(POP_SIZE/10));
    popRandom = muta(popRandom, fitnessValues, AMPS, SPACE);

    popSeltourn = seltourn(pop, fitnessValues, POP_SIZE-size(popParents)-size(popChildMutated)-size(popRandom)-size(popSelsus));
    popSeltourn(:) = mutx(popSeltourn, MUTATION_RATE, SPACE);

    pop(:) = [popParents; popChildMutated; popSelsus; popRandom; popSeltourn];
end    
    fprintf("Income of %2.d. iteration %6.2f\n", i, HIGHEST_INCOME);
    if HIGHEST_INCOME > ALL_BEST
        ALL_BEST = HIGHEST_INCOME;
        ALL_BEST_GENE = BEST_DECISION;
    end
    disp(BEST_DECISION);
    
    plot(plotValues);
end

fprintf("Best from all iterations %6.2f\nBest investment combination:", ALL_BEST);
disp(ALL_BEST_GENE)



function [Fit] = financeFitnessGradational(population)
    MAX_INVEST = 1e7;
    penatlyCoef = 1;
    [popSize, geneSize] = size(population);
    Fit = zeros(1, popSize);
    for p = 1:popSize
        chromosome = num2cell(population(p, :));
        [x1, x2, x3, x4, x5] = chromosome{:};
        chromosome = [x1, x2, x3, x4, x5];

        Fit(p) = -(0.04*x1+0.07*x2+0.11*x3+0.06*x4+0.05*x5);

        if sum(chromosome) > MAX_INVEST
            Fit(p) = Fit(p) + penatlyCoef*(sum(chromosome) + MAX_INVEST);
        end

        if x1 + x2 > 2.5e6
            Fit(p) = Fit(p) + penatlyCoef*((x1 + x2) - 2.5e6);
        end

        if -x4 + x5 > 0
            Fit(p) = Fit(p) + penatlyCoef*(-x4 + x5);
        end
         
        if (0.5 * (-x1-x2+x3+x4-x5)) > 0
            Fit(p) = Fit(p) + penatlyCoef*(0.5 * (-x1-x2+x3+x4-x5));
        end
    end
end

function [Fit] = financeFitnessDeathPenalty(population)
    POKUTA = 0;
    MAX_INVEST = 1e7;
    [popSize, geneSize] = size(population);
    Fit = zeros(1, popSize);
    for p = 1:popSize
        if sum(population(p)) > MAX_INVEST
            Fit(p) = POKUTA;
        elseif population(p, 1) + population(p, 2) > 2.5e6
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
