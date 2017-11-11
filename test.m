% Test script
clear all
close all

max_pts = 100;

im1 = imread('test3.JPG');
im2 = imread('test4.JPG');

cim1 = corner_detector(im1);
cim2 = corner_detector(im2);

[x1,y1,~] = anms(cim1, max_pts); 
[x2,y2,~] = anms(cim2, max_pts); 

descs1 = feat_desc(rgb2gray(im1), x1, y1);
descs2 = feat_desc(rgb2gray(im2), x2, y2);

imshow(im1);
hold on
plot(x1,y1, 'rx');
match = feat_match(descs1, descs2);

N = size(match(match~=-1),1);
p1 = zeros(N,2);
p2 = p1;
idx = 1;

for i =1:size(match,1)
    if(match(i) ~= -1)
        p1(idx,1) = x1(i);
        p1(idx,2) = y1(i);
        idx = idx + 1;
    end
end

idx = match(match ~= -1);
p2 = [x2(idx) y2(idx)];

[H, inlier_ind] = ransac_est_homography(p1(:,1),p1(:,2),p2(:,1),p2(:,2), 1);