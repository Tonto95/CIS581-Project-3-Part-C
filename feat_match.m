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

[idx,d] = knnsearch(descs1, descs2);
end