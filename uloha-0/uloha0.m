clear;
clc;
close all;

graphStep = 0.1;
searchDelta = 0.1;
x = -6:graphStep:6;
startingPoint = x(randi(length(x), 1));

drawPlot(x);

xlabel('x');
ylabel('f(x_i)');

findMinimum(startingPoint, searchDelta);

function [] = findMinimum(x, d)
    hold on;
    scatter(x, mathFunction(x), 'g', "+");
    
    while (-6 <= x) && (x <= 6)
        x_left = x - d;
        x_right = x + d;
        if (mathFunction(x_left) < mathFunction(x)) && (mathFunction(x) < mathFunction(x_right))
            x = x_left;
        elseif (mathFunction(x_left) > mathFunction(x)) && (mathFunction(x) > mathFunction(x_right))
            x = x_right;
        elseif (mathFunction(x_left) < mathFunction(x)) && (mathFunction(x_right) < mathFunction(x))
            if mathFunction(x_left) <= mathFunction(x_right)
                x = x_left;
            else 
                x = x_right;
            end
        else
            scatter(x, mathFunction(x), "r", "*");
            break
        end
        scatter(x, mathFunction(x), "g", "+");
    end
    fprintf("vysledky\nx suradnica: %.2f\ny suradnica: %.2f\n", x, mathFunction(x));
    hold off;
end

function [] = drawPlot(x)
    plot(x, mathFunction(x), 'b');
end

function [y] = mathFunction(x)
    y=0.2*x.^4+0.2*x.^3-4*x.^2+10;
end