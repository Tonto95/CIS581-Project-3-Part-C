images = cell(1, 2);

images{1,1} = imread('test_imgs_ordered/test5.JPG');
images{1,2} = imread('test_imgs_ordered/test6.JPG');
images{1,3} = imread('test_imgs_ordered/test7.JPG');
% images{1,4} = imread('test_imgs_ordered/test8.JPG');
% images{1,5} = imread('test_imgs_ordered/test9.JPG');
mymosaic(images);