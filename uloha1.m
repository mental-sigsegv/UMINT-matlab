clear;
clc;
close all;

max_iterations = 5;
max_generations = 500;
population = 100;
dimensions = 10;
rate = 0.4;
alfa = 1.15;
amps = 10.0 * ones(1, dimensions);
space = ones(2, dimensions).*[-500; 500];
graph_values = 1:max_generations;

figure(1);
xlabel('generation');
ylabel('f(x_i)');
title_str = sprintf('evolution graph (%d dimensions)', dimensions);
title(title_str);

axis([-1 max_generations+1 -(dimensions+1)*420 -500]);
% axis([max_generations-0.001 max_generations -(dimensions)*418.99 -(dimensions)*418.97]); % zoom in

grid on;
hold on;

for iteration = 1:max_iterations
    pop = genrpop(population, space);
    color = rand(1, 3);

    for generation = 1:max_generations
        fitness_values = schwefel(pop);
        pop_parents = selbest(pop, fitness_values, [2 2 1 1 1 1]*floor(population/50));
        %pop_child = crossov(pop_parents, 2, 0);
        pop_child = crosgrp(pop_parents, floor(population/5));
        pop_child_mutated = muta(pop_child, rate, amps, space);
    
        pop_selsus = selsus(pop, fitness_values, floor(population/10));

        pop_random = selrand(pop, fitness_values, floor(population/10));
    
        pop_seltourn = seltourn(pop, fitness_values, population-size(pop_parents)-size(pop_child_mutated)-size(pop_random)-size(pop_selsus));
        pop_seltourn(:) = mutx(pop_seltourn, rate, space);
    
        pop(:) = [pop_parents; pop_child_mutated; pop_selsus; pop_random; pop_seltourn];
        [min_val, min_idx] = min(fitness_values);
        graph_values(generation) = min_val;
    end % generations
    plot(graph_values, 'r');
    fprintf("%d. iteration: %4.4f\n\tPopulation:", iteration, graph_values(max_generations-1));
    disp(pop(min_idx,:));
end % iterations

hold off;




