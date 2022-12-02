% Estimate the EP temperatures (Linear Optimization Method)

% Inputs: 
% rays --- NV x 4 matrix of rays. (Those generated from "GenerateCameras")
% angle --- NV x 1 matrix of ray angles. (Those generated from
% "GenerateCameras")
% readings --- N x 1 matrix of camera readings.
% EP --- M x 2 matrix of EP positions

% Outputs:
% Temperatures --- M x 1 vector of estimated temperatures

function [temperatures] = EstimateEPLO(M, N, V, rays, angles, readings, EP)
    disp("EPs: " + M);
    disp("Poses: " + N);
    gains = Gain(angles); % convert local angle to gain.
    
    % We now have a selection of intersected EPs and weights.

    % Populate Aeq

    Aeq = zeros(N, M);

    for j=1:N
        acc = zeros(1, M);
        for k=1:V
            ww = zeros(1, M);
            [weight, sel] = IntersectEP(rays(k-1 + (j-1) * V + 1, :), EP);
            ww(sel) = weight; % weight to each EP.
            acc = acc + gains(k) * ww;
        end

        Aeq(j, :) = acc;
    end

    % Build f.
    % f is a bathtub.

    % Solve for X.

    % x = linprog(f,A,b,Aeq,beq) includes equality constraints Aeq*x = beq. 

    beq = readings;
    A = -eye(M);
    b = zeros(M, 1);

    f = linspace(0,1,length(EP));
    f = 4 * f.^2 - 4 * f + 1; % y = 4x^2 + -4x + 1 bathtub

    temperatures = linprog(f, A, b, Aeq, beq);
end