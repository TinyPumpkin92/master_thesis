function [save_path] = getComponentsInfo(segmentation, save_path)
% Compute information of 3D components from binary 3D segmentation.

% Find components in 3D
components = bwconncomp(segmentation == 1,26);

% Compute voxel indices for each component
voxels = table2cell(regionprops3(components,'VoxelList'));
voxel_indices = table2cell(regionprops3(components,'VoxelIdxList'));

% Compute binary cell image and principle axes lengths for each component
images = table2cell(regionprops3(components,'Image'));
axes_lengths = table2cell(regionprops3(components,'PrincipalAxisLength'));

% Compute volume and surface area for each component
volumes = table2cell(regionprops3(components,'Volume'));
surfaces = table2cell(regionprops3(components,'SurfaceArea'));

% Save components data and return filename
save(save_path, 'voxels', 'voxel_indices', 'images', 'axes_lengths', 'volumes', 'surfaces', '-v7.3');
end
