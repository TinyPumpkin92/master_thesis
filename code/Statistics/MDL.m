function [best_k, errors, regularizations, err_reg] = MDL(data_points)
% Do MDL on points set using k-means clustering algorithm. Returns optimal
% number of clusters.

% Initialize number of clusters
max_clusters = 8;
num_clusters = 1:max_clusters;

% Initialize errors and regularizations
errors = zeros(1,max_clusters);
regularizations = zeros(1,max_clusters);

for i = num_clusters

    % Get clusters and assignments
    [assignments, clusters] = kmeans(data_points, i);

    % Compute total error
    n_clusters = zeros(size(data_points));

    for j = 1:size(data_points,1)
        n_clusters(j,:) = clusters(assignments(j),:);
    end

    errors(i) = sum(sqrt(sum((data_points - n_clusters).^2,2)));

    % Compute regularization
    regularizations(i) = ((1 + i*2*size(data_points,2)) / 2) * log(size(data_points,1)) + 3^i;

    ldm = 0;
        
    for k = 1:i
        
        points = data_points(assignments == k,:);
        mu = clusters(k,:);
        
        cov_mat = cov(points);
        cond_num = cond(cov_mat);
        
        for l = 1:size(points,1)
            if cond_num > 2.5
                
                eigenvals = eig(2*pi*cov_mat);
                pdet = prod(eigenvals(eigenvals ~= 0));
                
                ldm = ldm + log(1/sqrt(pdet)) + log(exp((-1/2) * (points(l,:) - mu) ...
                                              * pinv(cov_mat) * (points(l,:) - mu)'));
                
            else
                
                ldm = ldm + log(1/sqrt((2*pi)^(size(data_points,2))*det(cov_mat))) ...
                          + log(exp((-1/2) * (points(l,:) - mu) / cov_mat * (points(l,:) - mu)'));
                
            end
        end

    end
    
    regularizations(i) = regularizations(i) - ldm;

end

regularizations = real(regularizations);
err_reg = errors + regularizations;

% Plot errors, regularizations and err_reg
figure;
hold on
plot(num_clusters, errors, 'b');
plot(num_clusters, regularizations, 'r');
plot(num_clusters, err_reg, 'g');
legend('Total model error','Model regularization','Total model error plus regularization');
xlabel('K');
hold off

% Return and print best number of clusters
[~, best_k] = min(err_reg);

end
