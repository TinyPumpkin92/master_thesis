function [shape] = compute3DShape(cloud, object_axes, direction, stdev, num_samples, precision, plt)
% Computes a 3D shape representation based on 3D radian samples of the isosurface
% of an object. Returns shape in format: [x1, ..., xn, y1, ..., yn,z1, ..., zn].

% Initialize sample points
sample_points = ones(3,num_samples);

% Sample unit sphere
theta = 2 * pi * 0.5 * (1 + sqrt(5)) * (1:num_samples);
theta = theta - (floor(theta ./ (2 * pi)) .* 2 * pi);
phi = acos(1 - 2 * ((1:num_samples) / num_samples));

pos_dist = norm(object_axes(:,1) - direction');
neg_dist = norm((-object_axes(:,1)) - direction');

if  pos_dist > neg_dist
    object_axes(:,1) = -object_axes(:,1);
end

% Compute rotation from axes set
R = object_axes * eye(3)'; % Due to orthonormality

x = cos(theta) .* sin(phi);
y = sin(theta) .* sin(phi);
z = cos(phi);

% Align unit sphere samples to object axes
alignment = (R * [x; y; z]);

x = alignment(1,:);
y = alignment(2,:);
z = alignment(3,:);

% Convert back to spherical coordinates
theta = atan(y ./ x);
phi = acos(z ./ sqrt(x.^2 + y.^2 + z.^2));

for i = 1:size(theta,2)
    if x(i) < 0
        theta(i) = theta(i) + pi;
    else
        if y(i) < 0
            theta(i) = theta(i) + 2*pi;
        end     
    end
end

if plt
    % Convert to cartesian coordinates on unit sphere
    x = cos(theta) .* sin(phi);
    y = sin(theta) .* sin(phi);
    z = cos(phi);

    % Plot grid on unit sphere
    figure;
    plot3(x,y,z,'.b');
    xlabel('X'); ylabel('Y'); zlabel('Z');
    axis equal;

end

% Find center of cloud
center = mean(cloud);

% Find smallest and largest norm
norms = sqrt((cloud(:,1) - center(1)).^2 + (cloud(:,2) - center(2)).^2 + (cloud(:,3) - center(3)).^2);
max_norm = max(norms);

% Initialize rho
rho = repelem(max_norm,size(theta,1), size(theta,2));

% Initialize sample points
x = center(1) + rho .* cos(theta) .* sin(phi);
y = center(2) + rho .* sin(theta) .* sin(phi);
z = center(3) + rho .* cos(phi);

% Adjust norm of all sample points
for i = 1:num_samples
    
    found = false;
    
    while ~found
        found = ismember(round([x(i),y(i),z(i)]), cloud,'rows');
        rho(i) = rho(i) - precision;
        
        x(i) = center(1) + rho(i) * cos(theta(i)) * sin(phi(i));
        y(i) = center(2) + rho(i) * sin(theta(i)) * sin(phi(i));
        z(i) = center(3) + rho(i) * cos(phi(i));
        
    end
    
end

% Convert to cartesian coordinates
sample_points(1,:) = (rho .* cos(theta) .* sin(phi)) / stdev(1);
sample_points(2,:) = (rho .* sin(theta) .* sin(phi)) / stdev(2);
sample_points(3,:) = (rho .* cos(phi)) / stdev(3);

if plt
    % Plot sample points
    figure;
    plot3(sample_points(1,:), sample_points(2,:),sample_points(3,:),'.b');
    axis equal; xlabel('X'); ylabel('Y'); zlabel('Z');
    axis equal;
end

% Reshape sample points to shape vector
shape = [sample_points(1,:), sample_points(2,:), sample_points(3,:)];

end
