function [direction] = estimateDirection(surface, alignment, ax, plt)
% Find normalized direction of a pyramidal neuron using the isosurface, its
% alignment and set of axes. The direction is: apex minus center of mass.

% Find x-coordinates for alignment vertices
x = alignment.vertices(:,1);

% Sort x-coordinates in ascending order
[x_vals, idxs] = sort(x);
y_vals = alignment.vertices(idxs,2);

% Find size of x-coordinate range
range_size = x_vals(end) - x_vals(1);

% Find size of y-coordinate range for both ends
upper_range = max(y_vals(x_vals > x_vals(end) - range_size/2)) - min(y_vals(x_vals > x_vals(end) - range_size/2));
lower_range = max(y_vals(x_vals <= x_vals(1) + range_size/2)) - min(y_vals(x_vals <= x_vals(1) + range_size/2));

% Define apex vertex
if upper_range > lower_range
    idx = idxs(1);
else
    idx = idxs(end);
end

% Define direction of neuron
apex = surface.vertices(idx,:);
center = mean(surface.vertices);
direction = apex - center;

% Normalize direction of neuron
direction = direction / norm(direction);

if plt
    
    figure;
    hold on;
    
    p = patch(surface);
    p.FaceColor = 'blue';
    p.EdgeColor = 'none';
    
    camlight;
    lighting gouraud;
    daspect([1 1 1]);
    alpha 0.25;
    view(3);
    
    axis equal;
    xlabel('X'); ylabel('Y'); zlabel('Z');
    
    quiver3(center(1),center(2),center(3), ...
            15*direction(1),15*direction(2),15*direction(3));
        
    quiver3(center(1),center(2),center(3), ...
            15*ax(1,1),15*ax(2,1),15*ax(3,1));
        
    plot3(center(1),center(2),center(3),'kx','MarkerSize',10,'Linewidth', 2);
    plot3(apex(1),apex(2),apex(3),'k.','MarkerSize',25);
    
    legend('Neuron surface','Estimated direction of neuron', ...
           'First principle axis of neuron','Center of mass','Estimated apex');
        
    hold off;
    
end

end
