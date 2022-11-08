close all; clear all; 
clc
outputPath = ['./Output/Dicom Output/'];
name = '';

% read the dicom file
a = dicomread('Input/A0020_SAG_SPINE');
info = dicominfo('Input/A0020_SAG_SPINE');
imshow(a),title('Original Image')
saveas(gcf,[outputPath name 'Original.jpg']); close;

% crop the image
a = imcrop(a, [225 200 850 400]);
imshow(a),title("Original Cropped");
saveas(gcf,[outputPath name 'OriginalCropped.jpg']); close;
se = strel('line',1,1);
erodedimg = imerode(a,se);

% create a threshold for bw image
img_thresh = a;
img_thresh(a<100) = 0;
img_thresh(a>100) = 255;

% dilation
se = strel('disk',1);
dilatedimg = imdilate(img_thresh, se);

imshow(dilatedimg),title('Dilated Image')

dilatedimg = rgb2gray(dilatedimg);

b = edge(dilatedimg);

dilatedimg2 = imdilate(b,se);

figure()
imshow(dilatedimg),title('Dilated Image')
saveas(gcf,[outputPath name 'Dilated.jpg']); close;
imshow(img_thresh),title('Thresholded Image')
saveas(gcf,[outputPath name 'Threshold.jpg']); close;
imshow(dilatedimg2),title('Thresholded Image with Edge')
saveas(gcf,[outputPath name 'EdgeThreshold.jpg']); close;
