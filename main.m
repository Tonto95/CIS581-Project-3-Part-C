images = cell(1, 2);

images{1,1} = imread('test3.JPG');
images{1,2} = imread('test4.JPG');
images{1,3} = imread('test5.JPG');
mymosaic(images);