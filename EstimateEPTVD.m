% Estimate the EP temperatures (TVD Method)

% Inputs: 
% rays --- NV x 4 matrix of rays. (Those generated from "GenerateCameras")
% angle --- NV x 1 matrix of ray angles. (Those generated from
% "GenerateCameras")
% readings --- N x 1 matrix of camera readings.
% EP --- M x 2 matrix of EP positions
% prior --- M x 1 vector of prior temperatures
% lambda --- regularization parameter

% Outputs:
% Temperatures --- M x 1 vector of estimated temperatures

function [temperatures] = EstimateEPTVD(M, N, V, rays, angles, readings, EP, prior, lambda, tau)
    disp("EPs: " + M);
    disp("Poses: " + N);
    gains = Gain(angles); % convert local angle to gain.
    
    % Populate Aeq

    Aeq = zeros(N, M);
    x = optimvar('x',M,1);
    beq = readings;

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

    % Build objective function
    obj = norm(Aeq * x - beq);

    % Build regularization term.
    
    % for each Point
    for i=1:M
    	ne = GetNeighbors(M, EP, prior, i, 4, tau);
    	% for each Selected Neighbor
    	for k=1:length(ne)
    	    j = ne(k);
            if j ~=i
    	        obj = obj + norm(x(i) - x(j)) / norm(EP(i,:) - EP(j,:));
        	end
        end
    end
    disp(obj);
    %obj = simplify(obj);

    % Solve for x.
    
    prob = optimproblem('Objective', obj);
    x0.x = prior;
    
    [sol, fval, exitflag, output] = solve(prob, x0);

    temperatures = sol.x
end
