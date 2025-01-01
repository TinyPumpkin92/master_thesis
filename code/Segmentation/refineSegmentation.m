function [segmentation] = refineSegmentation(segmentation, strelsize)
% Perform 3D mathematical morphology on segmentation.

% Remove noise and smoothen components
sphere = strel('sphere', strelsize);
segmentation = imopen(segmentation,sphere);

end
