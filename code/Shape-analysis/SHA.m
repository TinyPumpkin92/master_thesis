function [] = SHA(data, num_freq)

% Initialize decompositions
decomposition = cell(num_freq);

% Extract x, y, z
x = data(1:100);
y = data(101:200);
z = data(201:end);

% Convert to spherical coordinates
r = sqrt(x.^2 + y.^2 + z.^2);
theta = atan(y ./ x);
theta = theta + pi * (x < 0) + 2 * pi * (x >= 0 & y < 0);
phi = acos(z ./ r);

% Compute delta theta and delta phi
delta_theta = zeros(size(theta));
delta_phi = zeros(size(phi));

for i = 1:size(delta_theta,1)
    
    if i == size(delta_theta,1)
        delta_theta(i) = theta(1) - theta(i);
        delta_phi(i) = phi(1) - phi(i);
    else
        delta_theta(i) = theta(i+1) - theta(i);
        delta_phi(i) = phi(i+1) - phi(i);
    end
end

% For each frequency
for l = 1:num_freq

alm_set = zeros(100,2*l+1);
Plm_pos = legendre(l,cos(phi));
    
    for m = -l:l

        % Compute Ylm
        if m < 0
            Clm = (-1)^abs(m) * (factorial(l - abs(m))/factorial(l + abs(m))); %Relation coefficient
            Ylm = sqrt(((2*l+1)*factorial(l-m))/(4*pi*factorial(l+m))) * exp((sqrt(-1)*m*theta')) .* (Clm * Plm_pos(abs(m)+1,:));
        else
            Ylm = sqrt(((2*l+1)*factorial(l-m))/(4*pi*factorial(l+m))) * exp((sqrt(-1)*m*theta')) .* Plm_pos(m+1,:);
        end
        
        % Compute alm
        alm_set = (1/4*pi) .* (conj(Ylm) .* sin(phi') .* delta_theta' .* delta_phi');

        % Save alm to decomposition
        alm_set(m+l+1,:) = alm;

    end

decomposition{l} = alm_set;

end

end
