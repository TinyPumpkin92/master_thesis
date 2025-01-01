function [shape] = compute3DShape(isosurf, num_samples, plt)
% Computes a 3D shape representation based on 3D radian samples of the isosurface
% of an object. Returns shape in format: [x1, ..., xn, y1, ..., yn,z1, ..., zn].

% Initialize sample points
sample_points = ones(3,num_samples);

% Sample unit sphere 
theta = 2 * pi * 0.5 * (1 + sqrt(5)) * (1:num_samples);
theta = theta - floor(theta ./ (2 * pi)) .* 2 * pi;
phi = acos(1 - 2 * ((1:num_samples) / num_samples));

% Center isosurface around origin
vertices = isosurf.vertices;
vertices = bsxfun(@minus, vertices, mean(vertices));

% Convert isosurface coordinates to spherical coordinates
vertices_rho = zeros(size(vertices,1),1);

for i = 1:size(vertices,1)
    vertices_rho(i) = norm(vertices(i,:));
end

vertices_theta = atan(vertices(:,2) ./ vertices(:,1));

for i = 1:size(vertices,1)
    if vertices(i,1) < 0
        vertices_theta(i) = vertices_theta(i) + pi;
    else
        if vertices(i,2) < 0
            vertices_theta(i) = vertices_theta(i) + 2*pi;
        end
    end
end

vertices_phi = acos(vertices(:,3) ./ vertices_rho);

% Find containing face from isosurface for each grid point
faces = isosurf.faces;

% Interpolate vertices of faces to find containing face and obtain radii for grid points
rho = zeros(1,num_samples);

for i = 1:num_samples
    rhos = [0];
    for j = 1:size(faces,1)
    
        face = faces(j,:);

        a = [vertices_theta(face(1)), vertices_phi(face(1)), vertices_rho(face(1))];
        b = [vertices_theta(face(2)), vertices_phi(face(2)), vertices_rho(face(2))];
        c = [vertices_theta(face(3)), vertices_phi(face(3)), vertices_rho(face(3))];

        beta = abs(det([a(1)-c(1), theta(i)-c(1); a(2)-c(2), phi(i)-c(2)])) / abs(det([b(1)-a(1), c(1)-a(1); b(2)-a(2), c(2)-a(2)]));
        gamma = abs(det([b(1)-a(1), theta(i)-a(1); b(2)-a(2), phi(i)-a(2)])) / abs(det([b(1)-a(1), c(1)-a(1); b(2)-a(2), c(2)-a(2)]));
        alpha = 1-beta-gamma;

        if alpha >= 0 && alpha <= 1 && beta >= 0 && beta <= 1 && gamma >= 0 && gamma <= 1
            rhos = [rhos, alpha * a(3) + beta * b(3) + gamma * c(3)];
        end
    
    end 
    rho(i) = max(rhos);
end

if plt
    % Convert to cartesian coordinates on unit sphere
    sample_points(1,:) = cos(theta) .* sin(phi);
    sample_points(2,:) = sin(theta) .* sin(phi);
    sample_points(3,:) = cos(phi);

    % Plot grid on unit sphere
    figure;
    plot3(sample_points(1,:),sample_points(2,:),sample_points(3,:),'.b');
    axis equal;
end

% Convert to cartesian coordinates
sample_points(1,:) = rho .* cos(theta) .* sin(phi);
sample_points(2,:) = rho .* sin(theta) .* sin(phi);
sample_points(3,:) = rho .* cos(phi);

if plt
    % Plot sample points
    figure;
    plot3(sample_points(1,:),sample_points(2,:),sample_points(3,:),'.b');
    axis equal;
end

% Reshape sample points to shape vector
shape = [sample_points(1,:), sample_points(2,:), sample_points(3,:)];

end
