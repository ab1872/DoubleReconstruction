clear;
clf;

N = 5; % poses
V = 10; % rays per pose
theta = 10; % +- degrees
Radius = 10;


% Generate cameras
[rays, angles] = GenerateCameras(Radius, N, V, theta);
% Generate Ground Truth Eps
pattern1 = [
2, 2, 1, 1;
2, 2, 1, 1;
2, 2, 1, 1;
2, 2, 1, 1;
]';

[gtEP, gttemperature] = GenerateEP(pattern1, 3, 1);

subplot(2,2,1);
scatter(gtEP(:,1),gtEP(:,2),25,gttemperature,'filled');
colorbar
title("Ground truth temperature distribution");
hold on
quiver(rays(:,1),rays(:,2),rays(:,3),rays(:,4));
axis equal

% Extract temperature readings
readings = ExtractReadings(length(gtEP), N, V, rays, angles, gtEP, gttemperature);
disp(readings');
% Generate Estimator EPs

pattern2 = ones(4,4);
[EP, ~] = GenerateEP(pattern2, 3, 0.1);

subplot(2,2,2);
scatter(EP(:,1),EP(:,2));
hold on
quiver(rays(:,1),rays(:,2),rays(:,3),rays(:,4));
title("Estimator EP locations");
axis equal


%Estimate EPs
prior = EstimateEPLO(length(EP), N, V, rays, angles, readings, EP);
prior = prior + rand(length(EP),1)/6;
temperatures = EstimateEPTVD(length(EP), N, V, rays, angles, readings, EP, prior, .2, 0);
subplot(2,2,3);

scatter(EP(:,1),EP(:,2),25,temperatures,'filled');
colorbar
title("Calculated EPs");
axis equal

subplot(2,2,4);

[R1, A1] = GenerateCameras(8,2*N, V, theta);
[R2, A2] = GenerateCameras(12,3*N, V, theta);

newrays = [R1; rays; R2];
NL = length(newrays);
newangles = [A1; angles; A2];
errors = Test(length(gtEP), length(EP), N + 2*N + 3*N, V, newrays, newangles, gtEP, EP, gttemperature, temperatures);
disp(length(errors) + " " + length(newrays(1:V:NL)));
scatter(newrays(1:V:NL,1),newrays(1:V:NL,2),25, errors,'filled');
title("Reprojection (%) errors");
hold on
colorbar
axis equal
scatter(gtEP(:,1),gtEP(:,2));
clim([0,50]);
