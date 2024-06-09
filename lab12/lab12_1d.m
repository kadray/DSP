clear all
close all
clc
%% 4. 
img = imread('im2.png');    % wczytaj obraz
img = double(img);

figure;
subplot(1,4,1);
imshow(img);
title("Oryginalny obraz");

% dct2
img_dct2 = dct2(img);

subplot(1,4,2);
imshow(img_dct2);
title("Matlabowe dct");

% my dct 2D
IMG = zeros(128, 128);
for i = 1 : 128
    row = img(i, :);
    ROW = dct(row);
    IMG(i, :) = ROW;
end

subplot(1,4,3);
imshow(IMG);
title("Pół mojego dct");

for i = 1 : 128
    col = IMG(:, i);
    COL = dct(col);
    IMG(:, i) = COL;
end

subplot(1,4,4);
imshow(IMG);
title("Moje dct");
