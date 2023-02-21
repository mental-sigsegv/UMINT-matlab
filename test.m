clear;
clc;
points = [0,0; 77,68; 12,75; 32,17; 51,64; 20,19; 72,87; 80,37; 35,82;
2,15; 18,90; 33,50; 85,52; 97,27; 37,67; 20,82; 49,0; 62,14; 7,60;
100,100];
chromosome = [0, 9, 3, 5, 17, 2, 11, 6, 1, 4, 15, 7, 8, 13, 16, 18, 10, 14, 12, 19];

drawPoints(points);
drawNumbers(points);
drawLineCH(points, chromosome(2:19));
fitnessPop(points, chromosome(2:19))

function [] = drawNumbers(points)
    pointsX = points(:,1);
    pointsY = points(:,2);

    for i = 1:size(points, 1)
        text(pointsX(i)+1.25, pointsY(i)+0.75, num2str(i));
    end
end

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
        pointsX(i) = points(chromosome(i-1)+1,1);
        pointsY(i) = points(chromosome(i-1)+1,2);
    end

    hold on;
    line = plot(pointsX, pointsY, 'r');
    hold off;
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