% Inputs:
% ray --- 1x4 vector of ray position and direction.
% EP ---- Mx2 matrix of points.

% Outputs:
% weight --- weights to each respective EP
% sel ------ selects which EP are close above a certain threshold

function [weight, sel] = IntersectEP(ray, EP)
    thresh = 2;

    sel = zeros(length(EP));
    weight = zeros(length(EP));
    selc = 1;

    raypos = ray(1:2);
    raydir = ray(3:4);

    for i = 1:length(EP)
        rel = EP(i,:) - raypos;
        dist = abs(rel(1) * raydir(2) - rel(2) * raydir(1));
        if dist < thresh
            weight(selc) = (thresh-dist)^2;
            sel(selc) = i;
            selc = selc+1;
        end
    end
    
    weight = weight(1:(selc-1));
    sel = sel(1:(selc-1));
end
