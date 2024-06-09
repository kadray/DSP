clear all
close all
clc
%% 3
% generacja obrazów bazowych
IM1 = zeros(128, 128);
IM1(2, 10) = 1;
im1 = idct2(IM1);

IM2 = zeros(128, 128);
IM2(7, 28) = 1;
im2 = idct2(IM2);

IM3 = zeros(128, 128);
IM3(70, 120) = 1;
im3 = idct2(IM3);

IM4 = zeros(128, 128);
IM4(111, 20) = 1;
im4 = idct2(IM4);

figure;
subplot(2,4,1);
imshow(IM1);
title("IM1");
subplot(2,4,2);
imshow(rescale(im1));
title("im1");

subplot(2,4,3);
imshow(IM2);
title("IM2");
subplot(2,4,4);
imshow(rescale(im2));
title("im2");

subplot(2,4,5);
imshow(IM3);
title("IM3");
subplot(2,4,6);
imshow(rescale(im3));
title("im3");

subplot(2,4,7);
imshow(IM4);
title("IM4");
subplot(2,4,8);
imshow(rescale(im4));
title("im4");

% generujemy nowy obrazek 128x128
% suma obrazów bazowych
im = im1 + im2 + im3 + im4;

% wyznacz dct2
IM = dct2(im);

figure;
subplot(1,4,1);
imshow(rescale(im));
title("Obraz sumaryczny");

% analiza obrazu sumarycznego
subplot(1,4,2);
imshow(IM); title('DCT2 obrazu sumarycznego');

% szukamy wspolrzednych 3-5 pikselow aby je potem moc wyzerowac
for i = 1:length(IM)
    for j = 1:length(IM)
        if(abs(IM(i,j))>0.99)
            fprintf('Zapalony piksel w: %d %d', i, j);
            fprintf('\n');
        end
    end
end

% zostawiamy tylko jeden zapalony wspolczynnik
% wyłaczanie pikseli
IM(2, 10) = 0;          % IM 1
IM(7, 28) = 0;          % IM 2
% IM(70, 120) = 0;      % IM 3
IM(111, 20) = 0;        % IM 4

im = idct2(IM);
subplot(1,4,3);
imshow(rescale(im)); 
title('DCT2 obrazu sum. - wyzerowane wsp.');

im = im - im3;
subplot(1,4,4);
imagesc(im); 
set(gca,'DataAspectRatio',[1 1 1]);
colorbar;
title('Roznica im wyzerowanego i jego niewyzerowanej skladowej');