function [] = plotIsosurface(s,transparent)
    figure;
    hold on
    p = patch(s);
    p.FaceColor = 'red';
    p.EdgeColor = 'none';
    daspect([1 1 1]);
    if transparent
        alpha 0.5;
    else
        alpha 1;
    end
    view(3); 
    axis equal;
    camlight;
    lighting gouraud;
    xlabel('X'); ylabel('Y'); zlabel('Z');
end