clear;
clc;
% close all;

graph_steps = 0.1;
search_delta = 0.25;
x = -6:graph_steps:6;
random_x = x(randi(length(x), 1));
%  random_x = 0;
%  random_x = 0.01;
%  random_x = -0.01;
%  random_x = -6;
%  random_x = 6;

draw_plot_0(x);
xlabel('x');
ylabel('f(x_i)');
find_minimum_0(random_x, search_delta);

function [] = find_minimum_0(x_current, d)
    hold on;
    scatter(x_current, f_0(x_current), "o", 'g', "+");
    
    while (-6 <= x_current) && (x_current <= 6)
        x_left = x_current - d;
        x_right = x_current + d;
        if (f_0(x_left) < f_0(x_current)) && (f_0(x_current) < f_0(x_right))
            x_current = x_left;
        elseif (f_0(x_left) > f_0(x_current)) && (f_0(x_current) > f_0(x_right))
            x_current = x_right;
        elseif (f_0(x_left) < f_0(x_current)) && (f_0(x_right) < f_0(x_current))
            if f_0(x_left) <= f_0(x_right)
                x_current = x_left;
            else 
                x_current = x_right;
            end
        else
            scatter(x_current, f_0(x_current), "r", "*");
            break
        end
        scatter(x_current, f_0(x_current), "g", "+");
    end
    fprintf("x: %.2f\ny: %.2f\n", x_current, f_0(x_current));
    hold off;
end

% ----------------- %
% DEFINED FUNCTIONS %
% ----------------- %

function [] = draw_plot_0(x)
    plot(x, f_0(x), 'b');
end

function [y] = f_0(x)
    y=0.2*x.^4+0.2*x.^3-4*x.^2+10;
end