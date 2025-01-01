function [] = segmentNeurons(nmbr)

close all; tic;

% Load data and ground truth
load(sprintf('~/data/subblock_%d.mat',nmbr), 'subblock');
disp('Loaded subblock.');

% Adjust intensities
subblock = adjustIntensities(subblock,104);
disp('Adjusted intensities.');

% Do segmentation
segmentation = zeros(size(subblock));

for i = 1:size(subblock,3)
    segmentation(:,:,i) = thresholdSegmentation(subblock(:,:,i));
end
disp('Segmented subblock.');

% Refine segmentation
segmentation = refineSegmentation(segmentation,5);
disp('Refined segmentation.');

% Get 3D components, save info to file
filename = getComponentsInfo(segmentation, sprintf('~/data/comp_data_%d.mat',nmbr));

% Sift segmentation
segmentation = sift3DSegmentation(segmentation, filename);
disp('Filtered segmentation.');

% Save remaining 3D components to file (overwrite previous)
filename = getComponentsInfo(segmentation, sprintf('~/data/comp_data_%d.mat',nmbr));

% Save components data and return filename
save(sprintf('~/data/segmentation_%d.mat',nmbr), 'segmentation', '-v7.3');
disp('Saved segmentation and components data.');

time_used = toc;
fprintf('%s%d\n','Time used for segmentation: ', time_used);

%{
if stats

    gt = load('~/data/gt_3d_subblock.mat');
    gt = gt.subblock;
    disp('Loaded groundtruth.');

    % Compute confusion matrix for segmentation
    conf_matrix = computeConfusionMatrix3D(segmentation, gt);

    % Compute statistics on correctness
    pos_det_rate = conf_matrix(1,1) / (sum(conf_matrix(:,1)));
    neg_det_rate = conf_matrix(2,2) / (sum(conf_matrix(:,2)));
    tot_det_rate = (conf_matrix(1,1) + conf_matrix(2,2)) / (sum(sum(conf_matrix)));

    % Output statistics
    disp(strcat('True positive rate: ',num2str(pos_det_rate)));
    disp(strcat('True negative rate: ',num2str(neg_det_rate)));
    disp(strcat('Total true detection rate: ',num2str(tot_det_rate)));

    % Save statistics
    save('~/results/segmentation_stats.mat', 'conf_matrix', 'pos_det_rate', 'neg_det_rate', 'tot_det_rate', '-v7.3');
    disp('Saved statistics.');

end
%}

end
