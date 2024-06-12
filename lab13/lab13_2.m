clear all; close all;

L=double((imread('L188Undistorted.png')));
P=double((imread('P188Undistorted.png')));

% L = double(rgb2gray(imread('kaczka1.jpg')));
% P = double(rgb2gray(imread('kaczka2.jpg')));
figure
subplot(121); imshow(L,[]);
subplot(122); imshow(P,[]);

wektory=motionEstES(P,L,32,64); %rozmiar bloku, zakres poszukiwania
figure
imshow(L,[]);
hold on;
quiver(wektory(2,:),wektory(1,:),wektory(4,:),wektory(3,:),'m');