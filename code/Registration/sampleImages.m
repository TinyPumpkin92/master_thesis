function[] = sampleImages(image_files, ZOOM)

h = figure;
all_points = cell(size(image_files,2),1);

for i = 1:size(image_files,2)
    
    image = imread(image_files{i});
    image = rgb2gray(image);
    imshow(image,[]);

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
    
    all_points{i} = points;
end

close(h);
save('all_points.mat','all_points', '-v7.3');

end
