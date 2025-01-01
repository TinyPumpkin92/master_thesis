function [comp_surface] = computeSurface(image)
% Computes the surface from binary image. Image do not need to be padded
% beforehand.

% Convert image to double
image = double(image);

% Pad image
pad_image = zeros(size(image) + 2);
pad_image(2:end-1,2:end-1, 2:end-1) = image;

% Compute component surface
comp_surface = isosurface(pad_image, 0.5);

end
