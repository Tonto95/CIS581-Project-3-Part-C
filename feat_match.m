% File name: feat_match.m
% Author: Ahmed Zahra, Anthony Owusu
% Date created:

function [match] = feat_match(descs1, descs2)
% (INPUT) descs1: 64?N1 matrix representing the corner descriptors of the
% first frame
% (INPUT) descs2: 64?N2 matrix representing the corner descriptors of the
% second frame
% (OUTPUT) match: N1 ? 1 vector where match1 points to the index of the
% descriptor in descs2 that matches with the feature i in descriptor descs1.
% If the match is not found, match1 = ?1

RATIO_VALUE = 0.75; 

%Iterate through all points to find the euclidian distance
n = size(descs2, 2);
match = ones(n, 1)*-1;
for i = 1:size(descs2, 2)
    st_min = inf;
    st_index = 0;
    nd_min = inf;
    nd_index = 0;
    for j = 1:size(descs1, 2)
        d1 = descs1(:, i);
        d2 = descs2(:, j);
        diff = norm(d1 - d2);
        % compare with current min
        if (diff < st_min)
            nd_min = st_min;
            nd_index = st_index;
            st_min = diff;
            st_index = j;
            continue;
        end
        if (diff < nd_min && diff >= st_min)
            nd_min = diff;
            nd_index = j;
            continue;
        end
    end
    ratio = st_min/nd_min;
    if (ratio < RATIO_VALUE)
        match(i) = st_index;
    end
end
end