% File name: mymosaic.m
% Author:
% Date created:

function [img_mosaic] = mymosaic(img_input)
% (INPUT) img_input: MxN cell where M is the total number of frames in the
% video and N is three if the number of input videos is 3
% (OUTPUT) img_mosaic: Mx1 cell vector representing the stitched image
% mosaic for every frame

MAX_PTS = 300;

m = size(img_input, 1);
n = size(img_input, 2);
img_mosaic = cell(m, 1);

mid = ceil(n/2);

H = cell(n -1, 1);
for i = 1:size(img_input,1)
    im = cell(n, 1);
    cim = cell(n, 1);
    x = cell(n, 1);
    y = cell(n, 1);
    descs = cell(n, 1);
    match = cell(n - 1, 1);
    for j = 1:n
        im{j} = img_input{i, j};
        if(i == 1)
            cim{j} = corner_detector(im{j});
            [x{j},y{j},~] = anms(cim{j}, MAX_PTS);
            descs{j} = feat_desc(rgb2gray(im{j}), x{j}, y{j});
        end
        if j > 1 && i == 1
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
            if (j == mid)
                [H{j-1}, inlier_ind] = ransac_est_homography(p2(:,1),p2(:,2),p1(:,1),p1(:,2), 0.8);
            else
                [H{j-1}, inlier_ind] = ransac_est_homography(p1(:,1),p1(:,2),p2(:,1),p2(:,2), 0.8);
            end
            H{j - 1} = H{j-1} / H{j-1}(3,3);
        end
    end
    if (i == 1)
        
        % Store the size of a single image
        xlim = [];
        ylim = [];
        tform = cell(1,1);

        % Create a cell to store the transform between image 1 and image i


        % Fill out the cell array with the transforms and determine the extents of
        % the panorama
        for l=1:size(im,1)
            imageSize = size(im{l});
            if l > mid
                tform{l} = projective2d(H{l-1}');
                [xlim(l,:), ylim(l,:)] = outputLimits(tform{l}, [1 imageSize(2)], [1 imageSize(1)]);
            elseif l == mid
                tform{mid} = projective2d(eye(3));
                [xlim(mid,:), ylim(mid,:)] = outputLimits(tform{mid}, [1 imageSize(2)], [1 imageSize(1)]);
            else
                tform{l} = projective2d(H{l}');
                [xlim(l,:), ylim(l,:)] = outputLimits(tform{l}, [1 imageSize(2)], [1 imageSize(1)]);
            end

        end
        xmin = min([1; xlim(:)]);
        ymin = min([1; ylim(:)]);
        xmax = max([imageSize(2); xlim(:)]);
        ymax = max([imageSize(1); ylim(:)]);

        width = round(xmax - xmin);
        height = round(ymax - ymin);
    end
    % Initialize the final panorama as an array of zeros
    panorama = zeros([height width 3], 'like', im{1});
    
    blender = vision.AlphaBlender('Operation', 'Binary mask', ...
        'MaskSource', 'Input port');
    
    panoramaView = imref2d([height width], [xmin xmax], [ymin ymax]);
    
    for p=1:size(im,1)
        pic = imwarp(im{p}, tform{p}, 'OutputView', panoramaView);
        
        % Generate a binary mask.
        mask = imwarp(true(size(im{p},1),size(im{p},2)), tform{p}, 'OutputView', panoramaView);
        
        % Overlay the warpedImage onto the panorama.
        panorama = step(blender, panorama, pic, mask);
    end
     img_mosaic{i} = panorama;
     %imshow(panorama);

end