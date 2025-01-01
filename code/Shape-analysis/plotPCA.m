function[] = plotPCA(data, k)

% Perform pirinciple components analysis of data
[data_mean, prin_comps, prin_vals] = PCA(data);

figure;
% Number of principle components
x = 1:size(prin_vals,1);
% Cumulative variance
y = cumsum(prin_vals)/sum(prin_vals);
% Plot explained variance
plot(x,y,'r');
axis([1 min(size(data)) 0 1.1]); xlabel('Number of principle components');
ylabel('Explained variance');

% Create matrix of mean shapes
mean_mat = repmat(data_mean,97,1);

% Define shape to use for visualization of principle components
neuron = 25;

% For first k principle components
for i = 1:k
    
    figure;
    p_k = prin_comps(:,i);
    
    for j = 1:3
        
        % Plot ith principle component - j * std of ith principle component
        recons = mean_mat - j * sqrt(prin_vals(i)) * p_k * (p_k' * (data - mean_mat));
        vertices = [recons(neuron,1:100)',recons(neuron,101:200)',recons(neuron,201:end)'];
        faces = boundary(vertices,0.25);
        
        subplot(3,3,1+(j-1)*3);
        hold on
        p = patch('Vertices',vertices,'Faces',faces);
        p.FaceColor = 'red';
        p.EdgeColor = 'none';
        daspect([1 1 1]);
        alpha 1;
        view(3); 
        axis equal;
        camlight;
        lighting gouraud;
        xlabel('X'); ylabel('Y'); zlabel('Z');
        title(sprintf('- %d standard deviation',j));
        
        % Plot mean shape
        vertices = [data_mean(1:100)',data_mean(101:200)',data_mean(201:end)'];
        faces = boundary(vertices,0.25);

        subplot(3,3,2+(j-1)*3);
        hold on
        p = patch('Vertices',vertices,'Faces',faces);
        p.FaceColor = 'red';
        p.EdgeColor = 'none';
        daspect([1 1 1]);
        alpha 1;
        view(3); 
        axis equal;
        camlight;
        lighting gouraud;
        xlabel('X'); ylabel('Y'); zlabel('Z');
        title('Mean');
        
        % Plot ith principle component + j * std of ith principle component
        recons = mean_mat + j * sqrt(prin_vals(i)) * p_k * (p_k' * (data - mean_mat));
        vertices = [recons(neuron,1:100)',recons(neuron,101:200)',recons(neuron,201:end)'];
        faces = boundary(vertices,0.25);
        
        subplot(3,3,3+(j-1)*3);
        hold on
        p = patch('Vertices',vertices,'Faces',faces);
        p.FaceColor = 'red';
        p.EdgeColor = 'none';
        daspect([1 1 1]);
        alpha 1;
        view(3); 
        axis equal;
        camlight;
        lighting gouraud;
        xlabel('X'); ylabel('Y'); zlabel('Z');
        title(sprintf('+ %d standard deviation',j));
        
    end
    
end

end