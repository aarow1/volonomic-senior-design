close all
clear all
clc
%% Generate red seams
I = imread('greens.jpg');
imshow(I);
hold on
title('Original image');
[Ir, T] = carvRed(I,1,1);
figure
hold on
title('Image with red seams');
imshow(Ir);

%% Remove seams
nr = 6;     % # of rows to remove
nc = 3;     % # of columns to remove
[Ic, T] = carv(I,nr,nc);
figure
imgtitle = sprintf('Image with %1.0f rows and %1.0f columns removed', nr, nc);
hold on
title(imgtitle);
imshow(Ic);
