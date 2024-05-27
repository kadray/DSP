close all; clear all;

%% Dane
[x, fs] = audioread('DontWorryBeHappy.wav');
x = double(x);
x = x(:, 1); % przetwarzamy lewy kanal
%x = x(1:1024);

%% Okno analizy i syntezy
%N = 32; 
N = 128;
n = 0:N-1;
window = sin(pi * (n + 0.5) / N);  % okno analizy i syntezy
%% Q - współczynnik skalujący
%Q = 100000; %% Błąd 3.4e-06
Q=60;
figure;
plot(n, window);
hold all;
grid;
title("Okno analizy i syntezy");
xlabel("Próbki"); ylabel("Amplituda");

%% Macierz analizy Modified DCT
A = zeros(N/2, N); 
for k = 1:N/2 
    A(k, :) = sqrt(4/N) * cos(2 * pi / N * (k - 1 + 0.5) * (n + 0.5 + N / 4));
end

%% Macierz syntezy 
S = A'; % transponowana macierz analizy


% Wypełnienie y i referencyjnego zerami o długości sygnału
y = zeros(1, length(x));
dref = y;
for i = 1:N/2:length(x) - N
    % Pobranie próbki o długości okna
    sample = x(i:i+N-1);
    % Okienkowanie; mnożenie z oknem
    windowed = sample' .* window;
    % Analiza; mnożenie z macierzą analizy
    analyzed = A * windowed';
    % Kwantyzacja
    quantized = round(analyzed * Q);
    % Synteza; mnożenie z macierzą syntezy
    synthesized = S * quantized;
    % Okienkowanie ponowne
    dewindowed = window .* synthesized';
    % Zapisywanie do sygnału
    y(i:i+N-1) = y(i:i+N-1) + dewindowed;
    
    % Referencja bez kwantyzacji
    synthesized = S * analyzed;
    dewindowed = window .* synthesized';
    dref(i:i+N-1) = dref(i:i+N-1) + dewindowed;
end

% Zmniejszanie amplitudy. Pomaga ukryć szumy
y = y / Q;

%% Błąd
disp("Dla Q = "+ Q)
disp("Maksymalny błąd: "+ max(abs(x - y')))
disp("Średni błąd: "+ mean(abs(x - y')))

%% Wykresy
n = 1:length(x);

figure;
hold all;
plot(n, x);
plot(n, y);
title('Sygnał oryginalny vs po odkodowaniu z MDCT');
legend('Referencyjny', 'Zrekonstruowany');

%% Słuchanie
soundsc(y(1:300000), fs);
