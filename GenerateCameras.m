% Outputs: 
% ray -- NV x 2 list of positions 
% -- NV x 2 list of normals
% angles -- NV x 2 list 

function [ray, angles] = GenerateCameras(Radius, N, V, theta)
    camRange = 50; %camera sweep half range in degrees.
    offset = 0;
    radius = Radius; % radius of the circle (10 meters)
    %N = 10; % N poses

    camAng = deg2rad(linspace(-camRange + 90, camRange + 90, N))'; %camera angles.
    positions = radius * [cos(camAng), sin(camAng)] + [0, offset];
    normals = [-cos(camAng), -sin(camAng)];

    ray = zeros(N*V, 4);
    angles = linspace(-theta, theta, V)';
    for p = 1:N
        newnormals = GenerateRays(normals(p,:), theta, V);
        L1 = (p-1)*V+1;
        L2 = p*V;
        ray(L1:L2, :) = [repmat(positions(p,:), V, 1), newnormals(:, 1:2)];
    end
end