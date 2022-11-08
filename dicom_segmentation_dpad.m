close all; clear all; 
clc

outputPath = ['./Output/Dicom DPAD Output/'];
name = '';

% read the dicom file
a = dicomread('Input/A0020_SAG_SPINE');
info = dicominfo('Input/A0020_SAG_SPINE');
figure('Visible', 'on');
imshow(a),title("Original");
saveas(gcf,[outputPath name 'Original.jpg']); close;

% crop the image
a = imcrop(a, [225 200 850 400]);

% double the precision of the image
img = im2double(a);
[nr,nc,~] = size(img);
imgSize = numel(img);
figure('Visible', 'off'); 
imshow(img),title("Original Cropped");
saveas(gcf,[outputPath name 'OriginalCropped.jpg']); close;

% convert image to grayscale
img = rgb2gray(img);
img = imadjust(img);
figure('Visible', 'off');
imshow(img),title("Preprocessing 1");
saveas(gcf,[outputPath name 'Preprocess1.jpg']); close;

%complementing the image... gave worse results hence not being used
%img = imcomplement(img);
%figure('Visible', 'off'); imshow(img); 
%saveas(gcf,[outputPath name '_1Pre2.jpg']); close;

%-DPAD 
stepsize = 0.01;
nosteps = 200; % 10
wnSize = 17; % 5
img = dpad(img, stepsize, nosteps,'cnoise',5,'big',wnSize,'aja');

figure('Visible', 'off')
imshow(img),title("Preprocessing 2"); 
saveas(gcf,[outputPath name 'Preprocess2.jpg']); close;

img = img(5:end-4,5:end-4);
img = imresize(img,[nr,nc]);
img = normalise(img);
img = imbinarize(img,graythresh(img));
img = double(img >= 0.5);
img = imclearborder(img);
img= imfill(img,'holes');
figure('Visible', 'off');
imshow(img),title("Final Output");
saveas(gcf,[outputPath name 'FinalOutput' '.jpg']); close;
figure('Visible', 'on');
imshow(labeloverlay(a,img)),title("Final Output Overlay"); 
saveas(gcf,[outputPath name 'FinalOutputOverlay.jpg']); close;


            

