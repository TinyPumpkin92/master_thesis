function [comp_contour] = computeContour(image)
% Computes the contour from binary image. Image do not need to be padded
% beforehand.

% Compute component boundaries
comp_contour = cell(size(image,3));

% Convert image to double
image = double(image);

for i = 1:size(image,3)
    
    % Pad contour image (to avoid splitting contour in two parts)
    pad_section = zeros(size(image(:,:,i)) + 2);
    pad_section(2:end-1,2:end-1) = image(:,:,i);
    
    % Compute contour (at value 0.5 to avoid digitization artifacts)
    contour = contourc(pad_section,[0.5, 0.5]);
    comp_contour{i} = contour(:,2:end);
    
end

end
