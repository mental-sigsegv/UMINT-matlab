clc;
clear;
close all;

max_iteration = 5;
max_numgen = 500;
population = 100;
n = 10;
Space = ones(2,n).*[-500;500];

for interation = 1:max_iteration
    pop = genrpop(population, Space);

    for gen = 1:max_numgen
        fitness = schwefel(population)
        parents = selbest(pop, fitness, [2 2 2 1 1 1]);
        kid = crosgrp(parents, floor(population/5));
    end



end