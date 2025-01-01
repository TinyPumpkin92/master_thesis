function [] = componentStats(segmentation, file_name, rate)
% Sift components from 3D segmentation so that components has surface/volume
% ratio above rate.

% Load components data
load(file_name, 'volumes', 'surfaces');

% Convert volumes and surfaces to matrices
volumes = cell2mat(volumes);
surfaces = cell2mat(surfaces);

% Plot ratios
figure;
scatter(volumes, surfaces,'r', 'filled');
hold on
plot([0,max(volumes)],[0,rate*max(volumes)],'k-');
legend('3D components', strcat('f(volumen)=',num2str(rate),'*volumen'));
xlabel('Volume');
ylabel('Surface Area');
axis equal;
savefig('~/figures/volume_surface_ratio.fig');
close;

figure;
nbins = ceil(max(volumes) / 100);
histogram(volumes,nbins);
hold on
title('Histogram of volumes');
axis equal;
savefig('~/figures/volume_hist.fig');
close;

end
