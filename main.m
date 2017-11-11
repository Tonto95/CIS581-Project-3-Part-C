vid1=VideoReader('Video1.mp4');
vid2=VideoReader('Video2.mp4');
vid3=VideoReader('Video3.mp4');
images = cell(1, 1);
i = 0;
while(hasFrame(vid3))
    readFrame(vid3);
    i = i + 1;
    frames1 = readFrame(vid1);
    frames2 = readFrame(vid2);
    frames3 = readFrame(vid3);
    images{i,1}=frames1;
    images{i,2}=frames2;
    images{i,3}=frames3;
end

% images{1, 1} = imread('test3.JPG');
% images{1, 2} = imread('test4.JPG');
% images{1, 3} = imread('test5.JPG');
% images{1,4} = imread('test_imgs_ordered/test8.JPG');
% images{1,5} = imread('test_imgs_ordered/test9.JPG');
img = mymosaic(images);
make_vid(images, 'output.avi');