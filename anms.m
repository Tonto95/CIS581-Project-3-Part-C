% File name: anms.m
% Author: Ahmed Zahra, Anthony Owusu
% Date created:

function [y, x, rmax] = anms(cimg, max_pts)
% (INPUT) cimg: HxW matrix representing the corner-metric matrix.
% (INPUT) max_pts: The desired number of corners
% (OUTPUT) x: Nx1 matrix representing the column coordinates of the corners
% (OUTPUT) y: Nx1 matrix representing the row coordinates of the corners
% (OUTPUT) rmax: Supression radius used to obtain max_pts corners

N = size(cimg(cimg ~= 0),1);
points = zeros(N,2);
metric = zeros(N,1);
idx = 1;
for i=1:size(cimg,1)
    for j = 1:size(cimg,2)
        
        if (cimg(i,j) ~= 0)
            points(idx, 1) = i;
            points(idx, 2) = j;
            metric(idx) = cimg(i,j);
            idx = idx + 1;
        end
        
    end
end

c_robust = 0.9;

% Create an array the size of the number of points
points_min_radius = zeros(N,1);

% Initialize the minimum radius as infinite
r_min = Inf;

% Calculate radius
get_r = @(x1,x2) sqrt((x1(1,1) - x2(1,1))^2 + (x1(1,2) - x2(1,2))^2);

for i=1:N
    for j=1:N
        % Skip the iteration if we are comparing the same point
        if (i == j)
            continue
        end
        
        % Check if the magnitude the current point is larger
        if (metric(i) <= metric(j)*c_robust)
            % Calculate the radius and check if it is less than the current
            % minimum
            curr_r = get_r(points(i,:), points(j,:));
            
            % Update the minimum radius if the current radius is smaller
            if (curr_r < r_min)
                r_min = curr_r;
            end
        end
    end
    
    % Set the min radius of the current point
    points_min_radius(i,:) = r_min;
    
    r_min = inf;
end

% Sort the array of radiuses in descending order
[pts_min_r_sorted, order] = sort(points_min_radius, 'descend');

% Sort the array of points accordingly
points = points(order,:);
y = points(1:max_pts,1);
x = points(1:max_pts,2);

% Find the max supression radius
rmax = pts_min_r_sorted(max_pts); % ??