% File name: mymosaic.m
% Author:
% Date created:

function [img_mosaic] = mymosaic(img_input)
% (INPUT) img_input: M ?N cell where M is the total number of frames in the 
% video and N is three if the number of input videos is 3
% (OUTPUT) img_mosaic: M ?1 cell vector representing the stitched image 
% mosaic for every frame

MAX_PTS = 100;

m = size(img_input, 1);
n = size(img_input, 2);

for i = 1:m
    im = cell(n, 1);
    cim = cell(n, 1);
    x = cell(n, 1);
    y = cell(n, 1);
    descs = cell(n, 1);
    match = cell(n - 1, 1);
    H = cell(n -1, 1);
    for j = 1:n
        im{j} = img_input{i, j};
        cim{j} = corner_detector(im{j});
        [x{j},y{j},~] = anms(cim{j}, MAX_PTS);
        descs{j} = feat_desc(rgb2gray(im{j}), x{j}, y{j});
        if j > 1
            match{j - 1} = feat_match(descs{j - 1}, descs{j});
            m = match{j-1};
            N = size(m(m~=-1),1);
            p1 = zeros(N,2);
            p2 = p1;
            idx = 1;
            x1 = x{j-1};
            x2 = x{j};
            y1 = y{j-1};
            y2 = y{j};
            
            for k =1:size(m,1)
                if(m(k) ~= -1)
                    p1(idx,1) = x1(k);
                    p1(idx,2) = y1(k);
                    idx = idx + 1;
                end
            end
            idx = m(m ~= -1);
            p2 = [x2(idx) y2(idx)];
            [H{j-1}, inlier_ind] = ransac_est_homography(p1(:,1),p1(:,2),p2(:,1),p2(:,2), 1);
            H{j - 1} = H{j-1} / H{j-1}(3,3);
        end
    end

    
end


tform = projective2d(H{j-1}');
[xlim, ylim] = outputLimits(tform, [1 size(im{j},2)], [1 size(im{j},1)]);
xmin = min([1; xlim']);
ymin = min([1; ylim']);
xmax = max([size(im{j},2); xlim']);
ymax = max([size(im{j},1); ylim']);
    
width = round(xmax - xmin);
height = round(ymax - ymin);
    
panorama = zeros([height width 3], 'like', im{j});

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
	'MaskSource', 'Input port');
    
panoramaView = imref2d([height width], [xmin xmax], [ymin ymax]);
    
pic = imwarp(im{j}, tform, 'OutputView', panoramaView);

% Generate a binary mask.
mask = imwarp(true(size(im{j},1),size(im{j},2)), tform, 'OutputView', panoramaView);

% Overlay the warpedImage onto the panorama.
mosaic = step(blender, panorama, pic, mask);
    
imshow(mosaic);
end