function [delta_block_coarse, delta_block_fine] = computeRegistration(ZOOM, precomp, nmbr)

% delta_block_coarse, delta_block_fine - output parameters from debugging

% Initialize optimizer
disp('Registration started.');
[optimizer, metric] = imregconfig('multimodal');

optimizer.InitialRadius = 0.001;
optimizer.MaximumIterations = 500;

optimizer.Epsilon = 1e-5;
optimizer.GrowthFactor = 1.01;

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
           
% Initialize delta block informations
delta_block_size = 1024;
delta_block_coarse = zeros(delta_block_size, delta_block_size, size(image_files,2));
delta_block_fine = delta_block_coarse;

% Place landmarks
initial_transforms = cell(size(image_files,2),1);
initial_transforms{1} = affine2d;

fixed = imread(image_files{1});
fixed = rgb2gray(fixed);

if precomp
    load('all_points.mat', 'all_points', 'center');
    fixed_points = all_points{1};
else
   h = figure;
   imshow(fixed,[]);
   
   center = round(size(fixed) / 2);
   
   xlim([1,size(fixed,2)]);
   ylim([1,size(fixed,1)]);
    
   fixed_points = zeros(2,2);
   p = ginput(1);

    % Zoom in if necessary and choose a landmark
    if ZOOM
        xlim(p(1)+[-256,256]);
        ylim(p(2)+[-256,256]);
        fixed_points(1,:) = ginput(1);
    else
        fixed_points(1,:) = p;
    end

    xlim([1,size(fixed,2)]);
    ylim([1,size(fixed,1)]);

    p = ginput(1);

    % Zoom in if necessary and choose a landmark
    if ZOOM
        xlim(p(1)+[-256,256]);
        ylim(p(2)+[-256,256]);
        fixed_points(2,:) = ginput(1);
    else
        fixed_points(2,:) = p;
    end
   
end

% Extract and save delta block
delta_block_coarse(:,:,1) = fixed(center(1) + (1:delta_block_size), ...
                                  center(2) + (1:delta_block_size));

delta_block_fine(:,:,1) = delta_block_coarse(:,:,1);

for i = 2:size(image_files,2)

    % Place landmarks
    moving = imread(image_files{i});
    moving = rgb2gray(moving);
    
    if precomp
        points = all_points{i};
    else
        imshow(moving,[]);

        points = zeros(2,2);
        p = ginput(1);

        % Zoom in if necessary and choose a landmark
        if ZOOM
            xlim(p(1)+[-256,256]);
            ylim(p(2)+[-256,256]);
            points(1,:) = ginput(1);
        else
            points(1,:) = p;
        end

        xlim([1,size(moving,2)]);
        ylim([1,size(moving,1)]);

        p = ginput(1);

        % Zoom in if necessary and choose a landmark
        if ZOOM
            xlim(p(1)+[-256,256]);
            ylim(p(2)+[-256,256]);
            points(2,:) = ginput(1);
        else
            points(1,:) = p;
        end
    end
    
    % Compute transformation for coarse registration
    tform = fitgeotrans(points,fixed_points,'NonreflectiveSimilarity');
    initial_transforms{i} = tform;
    warpedMoving = imwarp(moving,tform,'OutputView',imref2d(size(fixed)));
    %fixed_points = points;

    % Extract and save delta block
    delta_block_coarse(:,:,i) = warpedMoving(center(1) + (1:delta_block_size), ...
                                             center(2) + (1:delta_block_size));
                                         
    if i == 1
        delta_block_fine(:,:,i) = delta_block_coarse(:,:,i);
    end

end

close(h);

disp('Coarse registration finished.');

% Initialize transformations
transforms = cell(size(image_files,2),1);
transforms{1} = affine2d;
T = transforms{1}.T;

% Fine-tune coarse registration
for i = 2:size(image_files,2)

    moving_section = delta_block_coarse(:,:,i);
    fixed_section = delta_block_coarse(:,:,i-1);

    % Compute and save transformation
    t = imregtform(moving_section, fixed_section, 'rigid', optimizer, metric);
    transforms{i} = affine2d(t.T*T);
    T = t.T*T;

    % Extract and save delta block
    delta_block_fine(:,:,i) = imwarp(delta_block_coarse(:,:,i), affine2d(T), ...
                              'OutputView',imref2d([delta_block_size,delta_block_size]));

end

disp('Fine-tuning of registration finished.');

% Save landmarks and transformations
save(sprintf('~/data/registration_data_%d.mat',nmbr),'initial_transforms','transforms', 'center','-v7.3');
disp('Registration data saved to disk.');

end
