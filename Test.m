% Tests accuracy away from recording trajectory
% Inputs: Ground Truth EPs, EPs, camera rays (position + direction).
% Outputs: errors --- each pose's error.

function errors = Test(gtM, M, N, V, rays, angles, gtEP, EP, T1, T2)
    % for each ray, extract readings on both the gtEP and EP.
    % error = difference of readings.

    readings1 = ExtractReadings(gtM, N, V, rays, angles, gtEP, T1);
    readings2 = ExtractReadings(M, N, V, rays, angles, EP, T2);
    errors = abs(readings1 - readings2);
    errors = 100 * errors ./ abs(readings1);
end

