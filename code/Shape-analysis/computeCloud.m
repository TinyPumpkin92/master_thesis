function [cloud] = computeCloud(image, plt)
% Creates points cloud from 3D image.

x = [];
y = [];
z = [];

% Find all coordinates of object voxels in the image
for j = 1:size(image,3)
    
    [y_j, x_j] = find(image(:,:,j));
    x = [x; x_j];
    y = [y; y_j];
    z = [z; j * ones(length(x_j),1)];
    
end

cloud = [x, y, z];

% Plot example points cloud
if plt
    
    figure;
    plot3(cloud(:,1),cloud(:,2),cloud(:,3),'.','MarkerSize',10);
    
end

end
