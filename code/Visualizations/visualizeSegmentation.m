function [] = visualizeSegmentation(filepath)
% Plots a 3D cell shape representation together with its isosurface.

%load '~/data/test_info.mat' images voxels;
load filepath images voxels;

figure;

% Set axes properties
axis equal; xlabel('X'); ylabel('Y'); zlabel('Z');

hold on

% For each component in segmentation
for i = 1:size(images,1);

% Compute isosurface
surface = computeSurface(images{i});

% Translate surface to origo
surface.vertices = bsxfun(@minus,surface.vertices,mean(surface.vertices));

% Place surface in global coordinate system by centering around original
% mass center
surface.vertices = bsxfun(@plus,surface.vertices,mean(voxels{i}));

% Plot isosurface
plt = patch(surface);

% Set colour and transparency
plt.FaceColor = 'red';
plt.EdgeColor = 'none';
alpha 0.25;

% Set view and lighting
view(3);
camlight
lighting gouraud

% Plot mass center of surface
masscenter = mean(voxels{i});
plot3(masscenter(1),masscenter(2),masscenter(3),'kx','MarkerSize',10,'LineWidth',20);

end

% Save figure and close
savefig('~/figures/seg_visualization.fig');
close;

end
