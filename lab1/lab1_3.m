clear all
close all
clc
a=load("adsl_x.mat")
signal=a.x;
M = 32; % Długość prefiksu
N = 512; % Długość bloku
K = 4; % Liczba bloków
prefix = signal(1:M);
plot(xcorr(signal, prefix))
