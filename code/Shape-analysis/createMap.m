function [map] = createMap(filename, num_samples)

% Load components info
load(filename, 'images', 'voxels');

% Compute isosurfaces
isosurfaces = cell(size(images));

for i = 1:size(images,1)
    isosurfaces{i} = computeSurface(images{i});
end

% Compute 3d shapes for all components
representations = zeros(size(images,1),3*num_samples);

for i = 1:size(images,1)
    representations(i,:) = compute3DShape(isosurfaces{i}, num_samples, false);
end

% Compute positions of 3d shapes
positions = zeros(size(voxels,2),1);

for i = 1:size(voxels,1)
    positions(i) = mean(voxels{i});
end

% Compute map as respresentations with positions
map = cell(2,1);
map{1} = representations;
map{2} = positions;

% Save map
savepath = '~/results/map_data.mat';
save(savepath, 'map', '-v7.3');

end
