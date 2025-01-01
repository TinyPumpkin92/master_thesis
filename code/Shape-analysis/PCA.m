function [points_mean, prin_comps, prin_vals] = PCA(data_points)
% Do PCA on points set.

% Compute mean of data
points_mean = mean(data_points);

% Create covariance matrix
diffs = bsxfun(@minus, data_points, points_mean);

% Use smallest obtainable covariance matrix
if size(data_points,1) > size(data_points,2)
    covariance_matrix = (diffs' * diffs) / size(data_points,1);
else
    covariance_matrix = (diffs * diffs') / size(data_points,1);
end

% Do eigen decomposition
[eigen_vecs, eigen_vals] = eig(covariance_matrix);

% Sort eigenvectors by descending eigenvalues
[prin_vals, indices] = sort(diag(eigen_vals), 'descend');
prin_comps = eigen_vecs(:, indices);

end
