function [annotations] = annotate()
% Annotates 3D components by size.

% Get height ratio
load(sprintf('~/data/comp_data_%d.mat',nmbr),'volumes');
annotations = zeros(size(volumes));

% Annotate components
for i = 1:size(annotations,1)
    
    if volume < 9000 % Theoretical volume is 9000??
        annotations(i) = 1;
    end

end

end
