% File name: anms.m
% Author: Ahmed Zahra, Anthony Owusu
% Date created:

function [y, x, rmax] = anms(cimg, max_pts)
% (INPUT) cimg: H ?W matrix representing the corner-metric matrix.
% (INPUT) max_pts: The desired number of corners
% (OUTPUT) x: N?1 matrix representing the column coordinates of the corners
% (OUTPUT) y: N?1 matrix representing the row coordinates of the corners
% (OUTPUT) rmax: Supression radius used to obtain max_pts corners

c_robust = 0.9;

N = size(cimg.Metric,1);

% Create an array the size of the number of points
points = cimg.Location;
points_min_radius = zeros(N,1);

metric = cimg.Metric;

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
y = points(1:max_pts,2);
x = points(1:max_pts,1);

% Find the max supression radius
rmax = pts_min_r_sorted(max_pts); % ??