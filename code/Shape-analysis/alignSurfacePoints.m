function [alignment, prin_comps, stdev] = alignSurfacePoints(data, plt)
% Align 2D or 3D data points, so that observations are comparable.

% Set dimension
if size(data,2) == 3
    dim3 = true;
else
    dim3 = false;
end

% Extract x and y and possibly z
x = data(:,1);
y = data(:,2);

if dim3
    z = data(:,3);
end

% Define target axes for rotation and potentially extract z
if dim3
    target_axes = eye(3);
else
    target_axes = eye(2);
end

stdev = [std(x - mean(x)), std(y - mean(y)), std(y - mean(y))];

% Center shape at origin and scale by its std
x = (x - mean(x)) / std(x - mean(x));
y = (y - mean(y)) / std(y - mean(y));

if dim3

    % Center shape at origin and scale by its std
    z = (z - mean(z)) / std(z - mean(z));

    % Get principle axes of shape centered at origo and scaled by its std
    [~, prin_comps, ~] = PCA([x, y, z]);

    % Compute rotation from axes sets
    R = target_axes * prin_comps'; % Due to orthonormality

    % Rotate points to align to coordinate system axes
    alignment = (R * [x'; y'; z'])';

else

    % Get principle axes of shape
    [~, prin_comps, ~] = PCA([x, y]);

    % Compute rotation from axes sets
    R = target_axes * prin_comps'; % Due to orthonormality

    % Rotate points to align to fixed axes
    alignment = (R * [x'; y'])';

end

% Plot aligned shapes
if plt
    figure;
    hold on
    if dim3
        plot3(alignment(:,1), alignment(:,2), alignment(:,3),'.');
        quiver3([0,0,0],[0,0,0], [0,0,0], prin_comps(1,:), prin_comps(2,:), prin_comps(3,:));
        scatter3(0,0,0,'bo','filled');
    else
        plot(alignment(:,1), alignment(:,2));
        quiver([0,0,0],[0,0,0], prin_comps(1,:), prin_comps(2,:));
        scatter(0,0,'bo','filled');
    end
    axis equal;
    hold off
end

end
