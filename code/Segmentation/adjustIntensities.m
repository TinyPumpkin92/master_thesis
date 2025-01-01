function [subblock] = adjustIntensities(subblock,target_intensity)
% Adjust image intensities in sections of 3D image subblock to match an
% average intensity of target_intensity.

for i = 1:size(subblock,3)
    
    % Get all non-black pixels
    idx = find(subblock(:,:,i));
    
    % Compute average intensity of section i
    avr = sum(sum(subblock(idx))) / numel(subblock(idx));
    
    % Compute difference to target intensity
    avr_diff = round(target_intensity - avr);
    
    % Add intensity difference to every pixel in section i
    subblock(idx) = subblock(idx) + avr_diff;
    
end

end