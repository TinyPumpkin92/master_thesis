function[] = rotationTest(image, num_freq, num_radii)% Set parameters

% Compute origin surface
surface = computeSurface(image);
descriptor = sum(computeRotationInvariantRepresentation(surface,num_freq,num_radii));

% Rotation om x-aksen
angles = 0:pi/8:2*pi;
differences = zeros(size(angles));

for  i = 1:size(angles,2)
    testsurface = surface;
    testsurface.vertices = ([1,0,0;0,cos(angles(i)),-sin(angles(i));0,sin(angles(i)),cos(angles(i))] * testsurface.vertices')';
    testdescriptor = sum(computeRotationInvariantRepresentation(testsurface,num_freq,num_radii));
    differences(i) = norm(descriptor - testdescriptor);
end

figure;
plot(angles,differences, 'b');
axis equal; axis([0, 2*pi, -1, 1]);
xlabel('Rotation angle');
ylabel('Norm of difference vector');
title('Rotation about x-axis');

% Rotation om y-aksen
for  i = 1:size(angles,2)
    testsurface = surface;
    testsurface.vertices = ([cos(angles(i)) 0, sin(angles(i)); 0,1,0; -sin(angles(i)),0,cos(angles(i))] * testsurface.vertices')';
    testdescriptor = sum(computeRotationInvariantRepresentation(testsurface,num_freq,num_radii));
    differences(i) = norm(descriptor - testdescriptor);
end

figure;
plot(angles,differences,'r');
axis equal; axis([0, 2*pi, -1, 1]);
xlabel('Rotation angle');
ylabel('Norm of difference vector');
title('Rotation about y-axis');

% Rotation om z-aksen
for  i = 1:size(angles,2)
   testsurface = surface;
    testsurface.vertices = ([cos(angles(i)),-sin(angles(i)),0;sin(angles(i)),cos(angles(i)),0;0,0,1] * testsurface.vertices')';
    testdescriptor = sum(computeRotationInvariantRepresentation(testsurface,num_freq,num_radii));
    differences(i) = norm(descriptor - testdescriptor); 
end

figure;
plot(angles,differences,'g');
axis equal; axis([0, 2*pi, -1, 1]);
xlabel('Rotation angle');
ylabel('Norm of difference vector');
title('Rotation about z-axis');

end
