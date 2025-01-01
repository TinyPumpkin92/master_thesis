function [image_mean, image_variance] = pixelStats(image)
% Computes pixel statistics for threshold determination.

% Smooth subblock section
gaussian = fspecial('gaussian', [3 3], 1);
image = conv2(image, gaussian, 'same');

% Calculate sifting measures
neighborhood_size = 11; % Must be an odd number
image_mean = conv2(image, ones(neighborhood_size)/(neighborhood_size^2), 'same');
image_variance = sqrt(conv2(image.^2 ,ones(neighborhood_size)/(neighborhood_size^2), 'same') - image_mean.^2);

figure;
histogram(image_mean(:),256);
axis on;
savefig('~/figures/image_mean.fig');
close;

figure;
histogram(image_variance(:),100);
axis on;
savefig('~/figures/image_variance.fig');
close;

end