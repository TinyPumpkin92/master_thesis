function [shape] = compute2DShape(contour, num_points)
% Computes the shape representation of a 2D contour. Returns shape in
% format: [x1, ..., xn, y1, ..., yn].

% Compute length and accumulative lengths of contour
total_contour_length = 0;
point_lengths = zeros(1, size(contour,2));

for i = 2:size(contour,2)
    total_contour_length = total_contour_length + norm(contour(:,i) - contour(:,i-1));
    point_lengths(i) = total_contour_length;
end

% Compute step size for contour sample point construction
step_size = total_contour_length / num_points;

% Initialize 2D shape representation
shape = zeros(2, num_points);

% Compute shape representation with num_points sample points
for i = 1:num_points
    
    % Get closest contour points on each side of the sample point
    before = find(point_lengths < i * step_size,1,'last');
    after = find(point_lengths > i * step_size,1,'first');
    
    % Compute the direction vector for the sample point and how much we
    % need to move along it
    move_length = (i * step_size) - point_lengths(before);
    
    if isempty(after)
        for j = 1:size(contour,2)
            if norm(contour(:,j) - contour(:,before)) > move_length
                after = j;
                break;
            end
        end
    end
    
    direction = contour(:,after) - contour(:,before);
    
    % Compute sample point as contour point before sample point plus
    % move_length times direction
    shape(:,i) = (contour(:,before) + (move_length * direction));
    
end

shape = [shape(1,:), shape(2,:)];

end

