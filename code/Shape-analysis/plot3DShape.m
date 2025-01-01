function [] = plot3DShape(shape, surface, num_points)
% Plots a 3D cell shape representation together with its isosurface.

figure;

% Split shape into separate coordinates
x = shape(1:num_points);
y = shape(num_points + 1:2 * num_points);
z = shape(2 * num_points + 1:end);

% Center isosurface
surface.vertices = bsxfun(@minus,surface.vertices,mean(surface.vertices));

% Plot isosurface
plt = patch(surface);
plt.FaceColor = 'red';
plt.EdgeColor = 'none';
alpha 0.25;
view(3);
camlight
lighting gouraud
hold on

% Plot shape points
scatter3(x,y,z,'filled','b');

% Set axes properties
axis equal; xlabel('X'); ylabel('Y'); zlabel('Z');

% Save figure and close
%savefig('~/figures/3DShape.fig');
savefig('3DShape.fig');
close;

end
