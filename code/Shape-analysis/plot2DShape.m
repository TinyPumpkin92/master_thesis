function [] = plot2DShape(shape, contour, num_points)
% Plots a 2D cell shape representation together with its contour.

figure;

% Plot contour
plot(contour(1,:),contour(2,:), 'r');
hold on

% Plot sample points
scatter(shape(1),shape(num_points + 1), 'g', 'filled', 'MarkerEdgeColor', [0, 0, 0], 'LineWidth', 2);
scatter(shape(2),shape(num_points + 2), 'g', 'filled');
scatter(shape(3:num_points),shape(num_points + 3:end), 'b', 'filled');

% Set axes
axis equal;
axis([(min(shape(1:num_points)) - 5), (max(shape(1:num_points)) + 5), ...
      (min(shape(num_points + 1:end)) - 5), (max(shape(num_points + 1:end)) + 5)]);
set(gca,'Ydir','reverse');

% Save figure and close
savefig('~/figures/2DShape.fig');
close;

end
