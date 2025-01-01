function [segmentation] = thresholdSegmentation(image)
% Segments a 2D image of pyramidal cells based on thresholds.

% Smooth subblock section
gaussian = fspecial('gaussian', [5 5], 1);
image = conv2(image, gaussian, 'same');

% Calculate threshold measures
neighborhood_size = 11; % Must be an odd number
image_mean = conv2(image, ones(neighborhood_size)/(neighborhood_size^2), 'same');
image_variance = sqrt(conv2(image.^2 ,ones(neighborhood_size)/(neighborhood_size^2), 'same') - image_mean.^2);

% Perform thresholding
segmentation = image_mean < 92 & ...
               image_mean > 78 & ...
               image_variance < 7;

% Close gaps in borders
segmentation = imclose(segmentation, strel('disk', neighborhood_size));

% Close holes from cell cores
segmentation = imfill(segmentation,'holes');

end

% image < 100 & ...
% image > 70 & ...
