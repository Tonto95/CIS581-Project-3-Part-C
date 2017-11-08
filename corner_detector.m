% File name: corner_detector.m
% Author: Ahmed Zahra, Anthony Owusu
% Date created:

function [cimg] = corner_detector(img)
% (INPUT) img: H?W matrix representing the gray scale input frame
% (OUTPUT) cimg: H?W matrix representing the corner-metric matrix for the image

% Convert img from rgb 2 grayscale
img_gray = rgb2gray(img);

% Find the corner points
cimg = detectHarrisFeatures(img_gray);

end