function[] = plotSHA(data, num_points, f)

% Sample unit sphere
theta = 2 * pi * 0.5 * (1 + sqrt(5)) * (1:num_points);
theta = theta - (floor(theta ./ (2 * pi)) .* 2 * pi);
phi = acos(1 - 2 * ((1:num_points) / num_points));



end