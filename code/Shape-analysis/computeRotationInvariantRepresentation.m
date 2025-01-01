function [shape] = computeRotationInvariantRepresentation(surface, l, num_radii)
% Computes a 3D shape representation / description of a surface using spherical
% harmonics.

% Define sphere radii
sphere_radii = (1/num_radii):(1/num_radii):1;
rounding_factor = log10(num_radii);

% Initialize descriptor (number of radii x l frequencies)
shape = zeros(length(sphere_radii),2*l+1);

% Center and scale coordinates of isosurface
surface_points = bsxfun(@minus, surface.vertices, mean(surface.vertices));
surface_points = bsxfun(@rdivide, surface_points, var(surface_points));

% Convert to spherical coordinates
r = sqrt(surface_points(:,1).^2 + surface_points(:,2).^2 + surface_points(:,3).^2);
theta = atan(surface_points(:,2) ./ surface_points(:,1));
theta = theta + pi * (surface_points(:,1) < 0) + 2 * pi * (surface_points(:,1) >= 0 & surface_points(:,2) < 0);
phi = acos(surface_points(:,3) ./ r);

% Round radii to 2 decimal digits
r = round(r*(10^rounding_factor)) / (10^rounding_factor);

% Compute delta theta and delta phi
delta_theta = zeros(size(theta));
delta_phi = zeros(size(phi));

for i = 1:size(delta_theta,1)
    
    if i == size(delta_theta,1)
        delta_theta(i) = theta(1) - theta(i);
        delta_phi(i) = phi(1) - phi(i);
    else
        delta_theta(i) = theta(i+1) - theta(i);
        delta_phi(i) = phi(i+1) - phi(i);
    end
end

for i = 1:length(sphere_radii)

    % Find surface points intersecting sphere
    f = sphere_radii(i)*(r == sphere_radii(i))';

    % For each frequency
    Plm_pos = legendre(l,cos(phi));
    
    for m = -l:l

        % Compute Ylm
        if m < 0
            Clm = (-1)^abs(m) * (factorial(l - abs(m))/factorial(l + abs(m))); %Relation coefficient
            Ylm = sqrt(((2*l+1)*factorial(l-m))/(4*pi*factorial(l+m))) * exp((sqrt(-1)*m*theta')) .* (Clm * Plm_pos(abs(m)+1,:));
        else
            Ylm = sqrt(((2*l+1)*factorial(l-m))/(4*pi*factorial(l+m))) * exp((sqrt(-1)*m*theta')) .* Plm_pos(m+1,:);
        end
        
        % Compute alm
        alm = (1/4*pi*f.^2) .* (conj(Ylm) .* f .* sin(phi') .* delta_theta' .* delta_phi');

        % Compute norm of frequency component
        shape(i,m+l+1) = norm(alm .* Ylm);

    end

end

% shape = sum(shape);

end

