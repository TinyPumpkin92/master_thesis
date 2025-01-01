% Create ground truth for manually registered image
subblock = zeros(3000, 3000, 5);

im = imread('../markings/test_image_1_redMarked.png');
im = rgb2hsv(im);

gt = im(:,:,3) > 0.9;
subblock(:,:,1) = gt;
imwrite(gt, '../gt/test_image_1_gt.png');

im = imread('../markings/test_image_2_redMarked.png');
im = rgb2hsv(im);

gt = im(:,:,3) > 0.9;
subblock(:,:,2) = gt;
imwrite(gt, '../gt/test_image_2_gt.png');

im = imread('../markings/test_image_3_redMarked.png');
im = rgb2hsv(im);

gt = im(:,:,3) > 0.9;
subblock(:,:,3) = gt;
imwrite(gt, '../gt/test_image_3_gt.png');

im = imread('../markings/test_image_4_redMarked.png');
im = rgb2hsv(im);

gt = im(:,:,3) > 0.9;
subblock(:,:,4) = gt;
imwrite(gt, '../gt/test_image_4_gt.png');

im = imread('../markings/test_image_5_redMarked.png');
im = rgb2hsv(im);

gt = im(:,:,3) > 0.9;
subblock(:,:,5) = gt;
imwrite(gt, '../gt/test_image_5_gt.png');

save('../gt/gt_3d_subblock.mat','subblock');
