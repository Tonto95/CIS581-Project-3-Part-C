% File name: corner_detector.m
% Author: Ahmed Zahra, Anthony Owusu
% Date created:

function [cimg] = corner_detector(img)
% (INPUT) img: HxW matrix representing the gray scale input frame
% (OUTPUT) cimg: HxW matrix representing the corner-metric matrix for the image

% Convert img from rgb 2 grayscale
img_gray = rgb2gray(img);

% Find the corner points
cimg = detectHarrisFeatures(img_gray);

% Create HxW matrix 
[H,W] = size(img_gray);
mat = zeros(H,W);

locations = round(cimg.Location);
strengths = cimg.Metric;

for i=1:size(locations,1)
    mat(locations(i,1), locations(i,2)) = strengths(i);
end

cimg = mat;

% cimg = cornermetric(img_gray, 'Harris');


end