clear all; close all; clc;
% Wczytanie próbki dźwiękowej
[x, fs] = audioread('DontWorryBeHappy.wav');  % zmienione z wavread na audioread dla zgodności
x = double(x);

a = 0.9545;  % parametr a kodera

% KODER
d = x - a * [[0, 0]; x(1:end-1, :)]; % różnicowy sygnał predykcji

% Kwantyzacja
dq = lab11_quantize(d, 7);  % kwantyzator
dq=d

% DEKODER
y = zeros(size(dq));  % inicjalizacja zrekonstruowanego sygnału
y(1) = dq(1);  % pierwszy element dekodera
for n = 2:length(dq)
    y(n) = dq(n) + a * y(n-1);
end

% Porównanie sygnałów
figure(1);
n = 1:length(x);
plot(n, x, 'b', n, y, 'r');
legend('Oryginalny sygnał', 'Zrekonstruowany sygnał');
title('Porównanie sygnału oryginalnego i zrekonstruowanego');

soundsc(y, fs);
% Obliczanie błędu rekonstrukcji
mse_original = mean((x - y).^2);
disp(['Średni kwadrat błędu (oryginalny sygnał vs zrekonstruowany): ', num2str(mse_original)]);

function y = lab11_quantize(x, b)  % (sygnał, liczba bitów)
    left_channel = x(:, 1);   % rozdzielamy na kanal lewy i prawy
    right_channel = x(:, 2);
    min_left = min(left_channel);    % znajduje min i max w każdym
    max_left = max(left_channel);
    min_right = min(right_channel);
    max_right = max(right_channel);
    
    % minimum, maksimum, zakres (odległość punktów od siebie)
    range_left = max_left - min_left; 
    range_right = max_right - min_right;
    
    % liczba bitów, liczba przedziałów kwantowania
    Nq = 2^b; 
    % szerokość przedziału kwantowania
    dx = range_left / Nq; % dzielę na równe progi
    quantized_left = dx * round(left_channel / dx); % zaokrąglam do najbliższego progu
    
    dx = range_right / Nq;
    quantized_right = dx * round(right_channel / dx);
    
    % funkcja zwraca sygnał stereo - złożenie horyzontalne
    y = horzcat(quantized_left, quantized_right);  % składa sygnał z dwóch kanałów
end
