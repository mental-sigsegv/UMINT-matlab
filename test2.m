% Define the coordinates of the vertices of the square
x = [0 1 1 0 ];
y = [0 0 1 1 ];
z = [0 0 0 0 ];

% Plot the square using plot3
plot3(1, 1, 1, 's', 'MarkerSize', 15, 'MarkerEdgeColor', 'r', 'LineWidth',2);

% Set the axis limits and labels
xlim([-1 2]);
ylim([-1 2]);
zlim([-1 2]);
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;