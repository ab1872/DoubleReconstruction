% Extracts temperature readings from the ground truth EP.

% Inputs:
% rays --- NV x 4 matrix of rays.
% gtEP --- the ground truth EPs


% Inputs: 
% rays --- NV x 4 matrix of rays. (Those generated from "GenerateCameras")
% angles --- NV x 1 matrix of ray angles. (Those generated from
% "GenerateCameras")
% gtEP --- M x 2 matrix of ground truth EP positions (M need not to be the
% same as the M of "EstimateEP").
% temperatures --- M x 1 temperatures of the ground truth EPs


% Outputs:
% readings --- N x 1 the temperature reading corresponding to each pose.

function readings = ExtractReadings(M, N, V, rays, angles, gtEP, temperatures)
    gains = Gain(angles); % convert local angle to gain.
    % We now have a selection of intersected EPs and weights.   
    readings = zeros(N, 1);

    for j=1:N
        acc = zeros(1, M);
        for k=1:V
            ww = zeros(1, M);
            [weight, sel] = IntersectEP(rays(k-1 + (j-1) * V + 1, :), gtEP);
            ww(sel) = weight; % weight to each EP.
            acc = acc + gains(k) * ww;
        end

        readings(j, 1) = acc * temperatures; % dot product
    end
end