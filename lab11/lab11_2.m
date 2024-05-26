% Wczytaj dowolny plik .wav
[x, fs] = audioread("DontWorryBeHappy.wav");

% Parametry
N = 128; % Długość okna

% Okno analizy i syntezy
n = 0:N-1;
h = sin(pi * (n + 0.5) / N)';

% Macierz analizy
A = zeros(N/2, N);
for k = 0:(N/2-1)
    for m = 0:(N-1)
        A(k+1, m+1) = sqrt(4/N) * cos(2*pi/N * (m+0.5) * (m+0.5 + N/4));
    end
end

% Macierz syntezy
S = A';

% Transformacja i rekonstrukcja
x_len = length(x);
y = zeros(size(x));

% Przechodzenie przez sygnał w oknach
for i = 1:N/2:x_len-N
    x_segment = x(i:i+N-1);
    X = A * (x_segment .* h);
    y_segment = (S * X) .* h;
    
    % Dopasowanie długości segmentów
    y_segment = y_segment(1:min(length(y_segment), N));
    y(i:i+N-1) = y(i:i+N-1) + y_segment;
end

% Porównanie sygnałów
figure;
subplot(2,1,1);
plot(x);
title('Oryginalny sygnał');
subplot(2,1,2);
plot(y);
title('Zrekonstruowany sygnał');

% Odtwarzanie dźwięku
sound(x, fs);
pause(length(x)/fs + 2);
sound(y, fs);
