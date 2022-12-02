% For each camera, generate a ray
% Inputs: 1x2 normal, beam half width, resolution V, 
% Outputs: Kx(2+1) arrays of normals (+ local degrees)

function newnormals = GenerateRays(onenormal, theta, V)
    degrees = linspace(-theta, theta, V);
    perp = [onenormal(2), -onenormal(1)];

    newnormals = zeros(V, 3);
    for i=1:length(degrees)
        ang = deg2rad(degrees(i));
        newnormals(i,:) = [(onenormal * cos(ang) + perp * sin(ang)), degrees(i)];
    end
end