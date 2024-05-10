clear all
close all
clc

dref = audioread("mowa_1.wav");
d = audioread("mowa_3.wav");
x = audioread("mowa_2.wav");
time=length(x);
M = 8; % długość filtru
mi = 0.2;% współczynnik szybkości adaptacji
y = []; e = []; % sygnały wyjściowe z filtra
bx = zeros(M,1); % bufor na próbki wejściowe x
h = zeros(M,1); % początkowe (puste) wagi filtru

for n = 1 : length(x)
    bx = [ x(n); bx(1:M-1) ]; % pobierz nową próbkę x[n] do bufora
    y(n) = h' * bx; % oblicz y[n] = sum( x .* bx) – filtr FIR
    e(n) = d(n) - y(n); % oblicz e[n]
    h = h + mi * e(n) * bx; % LMS
    %h = h + mi * e(n) * bx /(bx'*bx); % NLMS
end

figure()
plot(d, "r") %% Sa + G(Sb)
hold on
plot(dref, "b") %% czyste Sa dla porównania
hold on
plot(e, "g") %% przefiltrowane Sa

soundsc(e)