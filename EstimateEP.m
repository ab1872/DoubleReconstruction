% Estimate the EP temperatures (Overdetermined System Method)

% Inputs: 
% rays --- NV x 4 matrix of rays. (Those generated from "GenerateCameras")
% angle --- NV x 1 matrix of ray angles. (Those generated from
% "GenerateCameras")
% readings --- N x 1 matrix of camera readings.
% EP --- M x 2 matrix of EP positions

% Outputs:
% Temperatures --- M x 1 vector of estimated temperatures

function [temperatures] = EstimateEP(M, N, V, rays, angles, readings, EP)

    gains = Gain(angles); % convert local angle to gain.
    
    % We now have a selection of intersected EPs and weights.

    % Populate A

    A = zeros(N, M+1);

    for j=1:N
        acc = zeros(1, M);
        for k=1:V
            ww = zeros(1, M);
            [weight, sel] = IntersectEP(rays(k-1 + (j-1) * V + 1, :), EP);
            ww(sel) = weight; % weight to each EP.
            acc = acc + gains(k) * ww;
        end

        A(j, :) = [-readings(j), acc];
    end

    % Solve for X.

    [~, ~, V] = svd(A);
    temperatures = V(:, M+1);
    % Normalize.

    temperatures = temperatures / temperatures(1);
    temperatures = temperatures(2:(M+1));
end