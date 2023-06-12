clear;
clc;
close all;
hold off;
INVEST = 10;  % working with 10 and scaling number up
SPACE = ones(2, 5).*[0; INVEST];
POP_SIZE = 100;
GENERATIONS = 7500;
ITERATIONS = 5;
MUT_RATE = 0.6;
AMPS = 1.0 * ones(1, 5);
axis([-1 7500 4e5 10e5]);
hold on;
graphPoints = 1:GENERATIONS;
ALL_BEST = 0;
BEST_DECISION = 0;
ALL_BEST_GENE = 0;
for i = 1:ITERATIONS
    pop = genrpop(POP_SIZE, SPACE);
    HIGHEST_INCOME = 0;
for g = 1:GENERATIONS
    fitnessValues = fitnessMrtva(pop);
%     fitnessValues = fitnessUmerna(pop);
%     fitnessValues = fitnessStupnovita(pop);

    [generationProfit, generationIndex] = min(fitnessValues);
    generationPopulation = pop(generationIndex, :);
    generationProfit = -generationProfit*1e6;
    graphPoints(g) = generationProfit;
    popParents = selbest(pop, fitnessValues, [1 1 1 1 1 1]);
    popChild = crosgrp(popParents, floor(15));
    popChildMutated = muta(popChild, MUT_RATE, AMPS, SPACE);
    popSelsus = selsus(pop, fitnessValues, floor(12));
    popSelsus = muta(popSelsus, fitnessValues, AMPS, SPACE);
    popRandom = selrand(pop, fitnessValues, floor(6));
    popRandom = muta(popRandom, fitnessValues, AMPS, SPACE);
    popSeltourn = seltourn(pop, fitnessValues, POP_SIZE-size(popParents)-size(popChildMutated)-size(popRandom)-size(popSelsus));
    popSeltourn(:) = mutx(popSeltourn, MUT_RATE, SPACE);
    pop(:) = [popParents; popChildMutated; popSelsus; popRandom; popSeltourn];
end    
    fprintf("Profit of %2.d. iteration %6.2f\n", i, generationProfit);
    if generationProfit > ALL_BEST
        ALL_BEST = generationProfit;
        ALL_BEST_GENE = generationPopulation;
    end
    disp(generationPopulation);
    plot(graphPoints, 'r');
end

fprintf("\nBest profit from all iterations: %6.2f\nBest INVEST combination:\n", ALL_BEST);
disp(ALL_BEST_GENE*1e6);

function [Fit] = fitnessUmerna(population)
    INVEST = 10;
    [popSize, geneSize] = size(population);
    Fit = zeros(1, popSize);
    for p = 1:popSize
        penalty = 0;
        Fit(p) = -(0.04*population(p, 1)+0.07*population(p, 2)+0.11*population(p, 3)+0.06*population(p, 4)+0.05*population(p, 5));
        if sum(population(p, :)) > INVEST
            penalty = penalty +2*(sum(population(p, :)) - INVEST);
        end
        if population(p, 1) + population(p, 2) > 2.5
            penalty = penalty +2*(population(p, 1) + population(p, 2) - 2.5);
        end
        if -population(p, 4) + population(p, 5) > 0
            penalty = penalty +2*(-population(p, 4) + population(p, 5));
        end
        if (0.5 * (-population(p, 1)-population(p, 2)+population(p, 3)+population(p, 4)-population(p, 5))) > 0
            penalty = penalty +2*((0.5 * (-population(p, 1)-population(p, 2)+population(p, 3)+population(p, 4)-population(p, 5))));
        end
        Fit(p) = Fit(p) + penalty;
    end
end

function [Fit] = fitnessMrtva(population)
    penalty = 0;
    INVEST = 10;
    [popSize, geneSize] = size(population);
    Fit = zeros(1, popSize);
    for p = 1:popSize
        if sum(population(p, :)) > INVEST
            Fit(p) = penalty;
        elseif population(p, 1) + population(p, 2) > 2.5
            Fit(p) = penalty;
        elseif -population(p, 4) +population(p, 5) > 0
            Fit(p) = penalty;
        elseif (0.5 * (-population(p, 1)-population(p, 2)+population(p, 3)+population(p, 4)-population(p, 5))) > 0
            Fit(p) = penalty;
        else
            Fit(p) = -(0.04*population(p, 1)+0.07*population(p, 2)+0.11*population(p, 3)+0.06*population(p, 4)+0.05*population(p, 5));
        end
    end
end


function [Fit] = fitnessStupnovita(population)
    INVEST = 10;
    penaltyBase = 27;
    [popSize, geneSize] = size(population);
    Fit = zeros(1, popSize);
    for p = 1:popSize
       penalties = 0;
       Fit(p) = -(0.04*population(p, 1)+0.07*population(p, 2)+0.11*population(p, 3)+0.06*population(p, 4)+0.05*population(p, 5));
       if sum(population(p, :)) > INVEST
            penalties = penalties + 1;
       end
       if (population(p, 1) + population(p, 2)) > 2.5
            penalties = penalties + 1;
       end
       if (-population(p, 4) + population(p, 5)) > 0
            penalties = penalties + 1;
       end

       if (0.5 * (-population(p, 1) - population(p, 2) + population(p, 3) + population(p, 4) - population(p, 5))) > 0
            penalties = penalties + 1;
       end

       if penalties > 0
           Fit(p) = Fit(p) + penaltyBase^penalties;
       end
    end
end
