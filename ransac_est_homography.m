% File name: ransac_est_homography.m
% Author:
% Date created:

function [H, inlier_ind] = ransac_est_homography(x1, y1, x2, y2, thresh)
% (INPUT) x1, y1, x2, y2: N ? 1 vectors representing the corresponding 
% feature coordinates in the first image and the second image. The point 
% x1i, y1i in the first image are matched to x2i, y2i in the second image
% (INPUT) thresh: The threshold on distance to determine if the transformed 
% points agree
% (OUTPUT) H: 3?3 matrix representing the homography computed at the end of 
% RANSAC
% (OUTPUT) inlier_ind: N ?1 vector representing if the correspondence 
% is an inlier or not. Denote inlier using 1 and 0 for outlier

% Set the RANSAC constants
nRANSAC = 1000;
e = thresh; % Pixels
% min_inliers = 10;

bestH = zeros(3);

N = size(x1,1);

count = 0;

for i=1:nRANSAC
    rand_indices = zeros(4,1);
    
    % Generate 4 random indices
    for j=1:4
        rand_idx = randi([1 N]);
        while (ismember(rand_idx, rand_indices))
            rand_idx = randi([1 N]);
        end
        rand_indices(j) = rand_idx;
    end
    
    % Select 4 random points accordning to the calculated indices
    x1_i = x1(rand_indices);
    y1_i = y1(rand_indices);
    x2_i = x2(rand_indices);
    y2_i = y2(rand_indices);
    
    % Estimate the homography matrix for the selected points
    H = est_homography(x2_i, y2_i, x1_i, y1_i);
    
    currentCount = 0;
    H = H / H(3,3);
    % Loop through all the points and determine the number of points tha
    % are satisfied by the calculated homography matrix
    for j =1:N
        lhs = H * [x1(j); y1(j); 1];
        lhs = lhs / lhs(3);
        
        % Calculate the distance between the estimated and the actual point
        e_i = sqrt((lhs(1) - x2(j))^2 + (lhs(2) - y2(j))^2);
        
        if (e_i < e)
            currentCount = currentCount + 1;
        end
    end
    
    % Check the number of inliers is greater the max 
    if currentCount > count
        bestH = H;
        count = currentCount;
    end
end

inlier_ind = zeros(N,1);
H = bestH;

for i=1:N
    lhs = H * [x1(i); y1(i); 1];
    H = H / H(3,3);
    lhs = lhs / lhs(3);
        
    % Calculate the distance between the estimated and the actual point
	e_i = sqrt((lhs(1) - x2(i))^2 + (lhs(2) - y2(i))^2);
        
    if (e_i < e)
        inlier_ind(i) = 1;
    end
end

x1_i = x1(inlier_ind == 1);
y1_i = y1(inlier_ind == 1);
x2_i = x2(inlier_ind == 1);
y2_i = y2(inlier_ind == 1);

% Use all the inliers to calculate the homography
H = est_homography(x1_i, y1_i, x2_i, y2_i);
end