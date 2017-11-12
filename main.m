% vid1=VideoReader('vid1.MOV');
% vid2=VideoReader('vid3.MOV');
% vid3=VideoReader('vid4.MOV');
% vid1=VideoReader('myvid1.MOV');
% vid2=VideoReader('myvid2.MOV');
% vid3=VideoReader('myvid3.MOV');
% % % 
% images = cell(1, 1);
% i = 0;
% while(hasFrame(vid1) && hasFrame(vid2) && hasFrame(vid3))
%     i = i + 1;
%     frames1 = readFrame(vid1);
%     frames2 = readFrame(vid2);
%     frames3 = readFrame(vid3);
%     images{i,1}=frames1;
%     images{i,2}=frames2;
%     images{i,3}=frames3;
% end

% images{1, 1} = imread('test3.JPG');
% images{1, 2} = imread('test4.JPG');
% images{1, 3} = imread('test5.JPG');
% images{1,4} = imread('test_imgs_ordered/test8.JPG');
% images{1,5} = imread('test_imgs_ordered/test9.JPG');
% m = {images{1,1},images{1,2},images{1,3}};
img = mymosaic(images);
while(hasFrame(vid3))
    i = i + 1;
    img{i} = readFrame(vid3); 
end
% imshow(img{1});
make_vid(img, 'output2.avi');