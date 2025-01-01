function [shape] = compute3DShapeNaive(cloud, num_samples_theta, num_samples_phi)
% Computes a 3D shape representation based on 3D radian samples of cell
% images. Returns num_samples_theta * num_samples_phi sample points.  Returns
% shape in format: [x1, ..., xn, y1, ..., yn,z1, ..., zn].

% Initialize sample meshes
[theta, phi] = meshgrid(1:10:360,1:10:360);

% Initialize query meshes
[q_theta, q_phi] = meshgrid(1:(360/num_samples_theta):360, 1:(360/num_samples_phi):360);

% Initialize volume data
radii = zeros(size(theta));

% Find midpoint of cloud
cloud_center = mean(cloud);

% Find max radius
points = bsxfun(@minus, cloud, cloud_center);
cloud_radii = sqrt(points(:,1).^2 + points(:,2).^2 + points(:,3).^2);
max_radius = max(cloud_radii);

% Compute volume data
for i = 1:size(theta,1)
    for j = 1:size(theta,2)

        % Get sample radii
        samples_radii = (1:1:ceil(max_radius))';

        % Initialize sample coordinates
        coordinates = zeros(size(samples_radii,1), 3);

        % Compute (cartesian) sample coordinates
        coordinates(:,1) = cloud_center(1) + samples_radii .* repelem(cosd(theta(i,j))*sind(phi(i,j)), size(samples_radii,1))';
        coordinates(:,2) = cloud_center(2) + samples_radii .* repelem(sind(theta(i,j))*sind(phi(i,j)), size(samples_radii,1))';
        coordinates(:,3) = cloud_center(3) + samples_radii .* repelem(cosd(phi(i,j)), size(samples_radii,1))';
        
        % Add to center and round
        coordinates = round(coordinates);

        % Find max radius contained in cloud
        contained = ismember(coordinates,cloud,'rows');

        % Interpolate radius to find approximate surface point
        biggest_radius_idx = find(contained,1,'last');
        
        if isempty(biggest_radius_idx)
            radii(i,j) = 0.5;
        else
            radii(i,j) = samples_radii(biggest_radius_idx) + 0.5;
        end

    end
end

% Interpolate volume data (get volume data for query meshes)
q_radii = interp2(theta, phi, radii, q_theta, q_phi);

% Convert from spherical coordinates to cartesian coordinates
q_points = zeros(3,numel(q_radii));

for i = 1:size(q_theta,1)
    for j = 1:size(q_theta,2)

        q_points(1,i*(j-1)+j) = q_radii(i,j) * cosd(q_theta(i,j)) * sind(q_phi(i,j));
        q_points(2,i*(j-1)+j) = q_radii(i,j) * sind(q_theta(i,j)) * sind(q_phi(i,j));
        q_points(3,i*(j-1)+j) = q_radii(i,j) * cosd(q_phi(i,j));

    end
end

% Reshape query points matrix to shape vector
shape = [q_points(1,:), q_points(2,:), q_points(3,:)];

end
