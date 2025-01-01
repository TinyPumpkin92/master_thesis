function[] = performRegistration(nmbr)

load(sprintf('~/data/registration_data_%d.mat',nmbr), 'initial_transforms','transforms', 'center');
% Initialize filenames and subblock
image_files = {'1.tif','2.tif','3.tif','4.tif','5.tif', ...
               '6.tif','7.tif','8.tif','9.tif','10.tif', ...
               '11.tif','12.tif','13.tif','14.tif','15.tif', ...
               '16.tif','17.tif','18.tif','19.tif','20.tif', ...
               '21.tif','22.tif','23.tif','24.tif','25.tif', ...
               '26.tif','27.tif','28.tif','29.tif','30.tif', ...
               '31.tif','32.tif','33.tif','34.tif','35.tif', ...
               '36.tif','37.tif','38.tif','39.tif','40.tif', ...
               '41.tif','42.tif','43.tif','44.tif','45.tif', ...
               '46.tif','47.tif','48.tif','49.tif','50.tif'}; % Place all filenames here

fixed = imread(image_files{1});
fixed = rgb2gray(fixed);

last = fixed;

for i = 1:size(image_files,2)
    
    image = imread(image_files{i});
    image = rgb2gray(image);
    
    % Compute new transformations for the second transformation
    toOrigin = [1, 0, 0; 0, 1, 0; -center(1), -center(2), 1];
    fromOrigin = [1, 0, 0; 0, 1, 0; center(1), center(2), 1];

    image = imwarp(image,initial_transforms{i},'OutputView',imref2d(size(fixed)));
    image = imwarp(image, affine2d(toOrigin * (transforms{i}.T) * fromOrigin), 'OutputView',imref2d(size(fixed)));
    
    imwrite(image, sprintf('~/data/20171010PyramidCellsRegistered_%d/%d.tif',nmbr,i));
    
end

saveSubblock(nmbr);

end
