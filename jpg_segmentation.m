b = imread('Input/img-1.jpg');
imshow(b),title("Original");
saveas(gcf,[outputPath name 'Original.jpg']); close;
inputPath = './Input/';
outputPath = ['./Output/JPG Output/'];
name = '';
% converting coloured jpg to grayscale
b=rgb2gray(b);
% cropping the jpg
b = imcrop(b, [225 200 850 400]);
imshow(b),title("Original Cropped");
saveas(gcf,[outputPath name 'OriginalCropped.jpg']); close;

% put two thresholds to check the differences in result
[~,threshold1] = edge(b,'prewitt');
[~,threshold2] = edge(b,'sobel');

% edge detection
fudgeFactor = 0.5;
BWs1 = edge(b,'prewitt',threshold1 * fudgeFactor);
BWs2 = edge(b,'sobel',threshold2 * fudgeFactor);


se90 = strel('line',3,90);
se0 = strel('line',3,0);

% dilation
BWsdil1 = imdilate(BWs1,[se90 se0]);
BWsdil2 = imdilate(BWs2,[se90 se0]);
BWdfill1 = imfill(BWsdil1,'holes');
BWdfill2 = imfill(BWsdil2,'holes');

BWnobord1 = imclearborder(BWdfill1,4);
BWnobord2 = imclearborder(BWdfill2,4);

% erosion
seD = strel('diamond',1);
BWfinal1 = imerode(BWnobord1,seD);
BWfinal1 = imerode(BWfinal1,seD);
BWfinal2 = imerode(BWnobord2,seD);
BWfinal2 = imerode(BWfinal2,seD);
imshow(BWfinal1),title("Prewitt");
saveas(gcf,[outputPath name 'Prewitt.jpg']); close;
imshow(BWfinal2),title("Sobel");
saveas(gcf,[outputPath name 'Sobel.jpg']); close;
imshow(labeloverlay(b,BWfinal1)),title("Prewitt Overlay");
saveas(gcf,[outputPath name 'OverlayPrewitt.jpg']); close;
imshow(labeloverlay(b,BWfinal2)),title("Sobel Overlay");
saveas(gcf,[outputPath name 'OverlaySobel.jpg']); close;

% create outline
BWoutline1 = bwperim(BWfinal1);
BWoutline2 = bwperim(BWfinal2);
Segout1 = b; 
Segout2 = b; 
Segout1(BWoutline1) = 255; 
Segout2(BWoutline2) = 255; 
imshow(Segout1),title("Prewitt Border");
saveas(gcf,[outputPath name 'BorderPrewitt.jpg']); close;
imshow(Segout1),title("Sobel Border");
saveas(gcf,[outputPath name 'BorderSobel.jpg']); close;

