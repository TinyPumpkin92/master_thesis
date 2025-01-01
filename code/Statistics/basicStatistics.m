function [shape] = basicStatistics(load_path, cell_type)
% Computes basic statistics for pyramidal cells. Input cell_type should be
% a logical vector indicating which cells in the data that are pyramidal and
% which are not.

infos = load(load_path, 'volumes', 'surfaces');

volumes = infos.volumes .* cell_type;
surfaces = infos.surfaces .* cell_type;

mean_volume = mean(volumes(volumes ~= 0));
mean_surface = mean(surfaces(surfaces ~= 0));

var_volumen = mean((bsxfun(@minus, volumes(volumes ~= 0), mean_volume)).^2);
var_surface = mean((bsxfun(@minus, surfaces(surfaces ~= 0), mean_surface)).^2);

end
