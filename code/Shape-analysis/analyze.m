function [] = analyze(nmbr)

% Load components info
load(sprintf('~/data/comp_data_%d.mat',nmbr), 'images');
disp('Loaded neuron images.');

% Compute isosurfaces
isosurfaces = cell(size(images));
a_isosurfaces = cell(size(images));
principal_axes = cell(size(images));

for i = 1:size(images,1)
    isosurfaces{i} = computeSurface(images{i});
    
end
disp('Computed isosurfaces.');

for i = 1:size(isosurfaces,1)
    surface = isosurfaces{i};
    [surface_points, object_axes] = alignSurfacePoints(surface.vertices, false);
    principal_axes{i} = object_axes;
    surface.vertices = surface_points;
    a_isosurfaces{i} = surface;
end
disp('Aligned isosurfaces.');

% Save isosurfaces
save(sprintf('~/data/surfaces_%d.mat',nmbr), 'isosurfaces', 'a_isosurfaces', 'principal_axes', '-v7.3');
disp('Saved isosurfaces.');

% Compute Pincus and Theriot representations
representations = cell(size(images));

for i = 1:size(representations,1)
    cloud = computeCloud(images{i},false);
    representations{i} = compute3DShape(cloud, principal_axes{i}, 100, 0.1, false);
    if mod(i,20) == 0
        fprintf('%d finished...\n',i);
    end
end
disp('Computed shape representations.');

%{
% Compute spherical representations
sphere_representations = cell(size(isosurfaces));

max_freq = 12;
radii = 50;

for i = 1:size(isosurfaces,1)
    sphere_representations{i} = computeRotationInvariantRepresentation(isosurfaces{i}, max_freq, radii);
end
disp('Computed spherical shape representations.');
%}

load(sprintf('~/data/representations_big_%d.mat',nmbr), 'sphere_representations');

% Save spherical representations
save(sprintf('~/data/representations_big_%d.mat',nmbr), 'representations', 'sphere_representations', '-v7.3');
disp('Saved shape representations and spherical shape representations.');

%{
% Compute spherical descriptors
descriptors = cell(size(sphere_representations));

for i = 1:size(sphere_representations,1)
    descriptors{i} = sum(sphere_representations{i});
end
disp('Computed spherical descriptors.');

% Save spherical representations
save(sprintf('~/data/descriptors_%d.mat', nmbr), 'descriptors', '-v7.3');
disp('Saved spherical descriptors.');
%}

end
