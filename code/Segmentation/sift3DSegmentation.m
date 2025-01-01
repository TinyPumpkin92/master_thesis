function [segmentation] = sift3DSegmentation(segmentation, file_name)
% Sift components from 3D segmentation so that components has surface/volume
% ratio above rate.

% Load components data
load(file_name, 'volumes', 'surfaces', 'voxel_indices');

% Convert volumes and surfaces to matrices
volumes = cell2mat(volumes);
surfaces = cell2mat(surfaces);

% Find components to be removed
no_comps = [];

for i = 1:size(volumes,1)
    
    % Surface-volume ratios
    sur_vol_sphere = surfaces(i)^(3/2) / volumes(i);
    sur_vol_pyramid = surfaces(i) / volumes(i);
    
    % Threshold for surface-volume ratio
    if (sur_vol_sphere < 9 && sur_vol_sphere > 12 && sur_vol_pyramid > 1.2) 
        no_comps = [no_comps; i];
    end
end

% Remove components from segmentation
for i = 1:size(no_comps,1)
    segmentation(voxel_indices{no_comps(i)}) = 0;
end
 
end
