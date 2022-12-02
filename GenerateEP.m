%Generates a pattern of EPs.

%Inputs
% pattern ---- a matrix showing the pattern + with temperature.
% width --- scale of the pattern (width)
% noise ---- noise amplitude

%Outputs:
% EP ---- M x 2 array of EP positions
% temperature --- M x 1 arrays of corresponding ground truth temperatures.


function [EP, temperature] = GenerateEP(pattern, width, noise)
    ss = size(pattern);
    height = ss(1) / ss(2) * width;

    exes = linspace(-width, width, ss(2));
    wyes = linspace(-height, height, ss(1));

    EP = zeros(ss(1) * ss(2), 2);
    temperature = zeros(ss(1) * ss(2), 1);
    i = 1;

    for xx=1:ss(2)
        for yy=1:ss(1)
            if(pattern(yy,xx) > 0)
                EP(i,:) = [exes(xx) + noise * (rand() - 1), wyes(yy) + noise * (rand() - 1)];
                temperature(i,1) = pattern(yy,xx);
                i = i + 1;
            end
        end
    end

    EP = EP(1:(i-1), :);
    temperature = temperature(1:(i-1), :);
end

