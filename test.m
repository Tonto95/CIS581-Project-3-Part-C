% Test script
clear all
close all

max_pts = 100;

im1 = imread('test1.JPG');
im2 = imread('test2.JPG');

cim1 = corner_detector(im1);
cim2 = corner_detector(im2);

[x1,y1,~] = anms(cim1, max_pts); 
[x2,y2,~] = anms(cim2, max_pts); 

descs1 = feat_desc(rgb2gray(im1), x1, y1);
descs2 = feat_desc(rgb2gray(im2), x2, y2);

match = feat_match(descs1, descs2);