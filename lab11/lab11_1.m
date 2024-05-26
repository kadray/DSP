% Wczytanie próbki dźwiękowej
[x, fs] = audioread('DontWorryBeHappy.wav');  % zmienione z wavread na audioread dla zgodności
x = double(x);

% Konwersja do mono, jeśli sygnał jest stereo
if size(x, 2) == 2
    x = mean(x, 2);
end

a = 0.9545;  % parametr a kodera

% KODER
d = x - a * [0; x(1:end-1)];  % różnicowy sygnał predykcji

% Kwantyzacja
dq = lab11_kwant(d);  % kwantyzator

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

soundsc(y, fs)
% Obliczanie błędu rekonstrukcji
mse_original = mean((x - y).^2);
disp(['Średni kwadrat błędu (oryginalny sygnał vs zrekonstruowany): ', num2str(mse_original)]);

% Funkcja kwantyzacji
function dq = lab11_kwant(d)
    % Kwantyzacja sygnału d do 16 stanów (4 bity)
    d_min = min(d);
    d_max = max(d);
    step = (d_max - d_min) / 15;  % krok kwantyzacji dla 16 poziomów
    dq = round((d - d_min) / step) * step + d_min;
end
