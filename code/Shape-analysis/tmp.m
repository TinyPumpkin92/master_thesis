figure;
hold on
k = boundary([shape(1:200)',shape(201:400)',shape(401:end)']);
trisurf(k,shape(1:200),shape(201:400),shape(401:end),'Facecolor','red','FaceAlpha',0.2);
plot3(mass_center(1),mass_center(2),mass_center(3),'kx','MarkerSize',10,'LineWidth',20);
axis equal;
hold off


figure;
hold on
k = boundary(sample_points');
trisurf(k,sample_points(1,:),sample_points(2,:),sample_points(3,:),'Facecolor','blue','FaceAlpha',0.2,'EdgeColor','none');
scatter3(sample_points(1,:),sample_points(2,:),sample_points(3,:),'filled');
axis equal;


figure;
[x,y,z]=sphere;
hSurface=surf(x,y,z);
hold on
set(hSurface,'FaceColor',[1 0 0], ...
  'FaceAlpha',0.2,'FaceLighting','gouraud','EdgeColor','none');
scatter3(sample_points(1,:),sample_points(2,:),sample_points(3,:),'filled');
axis equal;


X = [5 + randn(100,2)*0.5+ones(100,2);
-5 + randn(100,2)*0.5-ones(100,2)];



for j = 1:size(data_points,1)

        p = data_points(j,:);
        c = clusters(assignments(j),:);
        points = data_points(assignments == assignments(j),:);
        ldm(j) = exp((-1/2)*sum(((p - c) ./ std(points)).^2)); % Mangler brøken med 1/sigma*sqrt(2pi)

end
