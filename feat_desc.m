% File name: feat_desc.m
% Author: Ahmed Zahra, Anthony Owusu
% Date created:

function [descs] = feat_desc(img, x, y)
% (INPUT) img: H xW matrix representing the gray scale input image frame
% (INPUT) x: Nx1 matrix representing the column coordinates of the corners
% (INPUT) y: Nx1 matrix representing the row coordinates of the corners
% (OUTPUT) descs: 64xN matrix, with column i being the 64-dimensional descriptor (8?8
% linearized grid) computed at the location (xi, yi) in img

N = size(x,1);

descs = zeros(64,N);

img_padded = padarray(img, [20,20], 0, 'both');

points = [y x];

for i=1:N
    p = round(points(i,:));
    
    % Get the 40x40 block around the point
    block = img_padded(p(2):p(2)+40,p(1):p(1)+40);
    
    % Apply gaussian bluring on the block
    block = imgaussfilt(block);
    
    count = 1;
    for j=1:5:40
        for k=1:5:40
            descs(count,i) = block(j,k);
            count = count + 1;
        end
    end
    
    descs(:,i) = (descs(:,i) - mean(descs(:,i)))/std(descs(:,i));
end

end