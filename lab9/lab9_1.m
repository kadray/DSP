clear;
close all;

% Parametry sygnału
fs = 8000;  % Częstotliwość próbkowania [Hz]
t = 1;      % Czas trwania [s]

% Częstotliwości i amplitudy harmonicznych
f1 = 34.2;  % Częstotliwość pierwszej harmonicznej [Hz]
A1 = -0.5;  % Amplituda pierwszej harmonicznej
f2 = 115.5; % Częstotliwość drugiej harmonicznej [Hz]
A2 = 1;     % Amplituda drugiej harmonicznej

% Tworzenie osi czasu
time = 0:1/fs:(t-1/fs);

% Generowanie sygnałów harmonicznych
harmonic1 = A1 * sin(2 * pi * f1 * time);
harmonic2 = A2 * sin(2 * pi * f2 * time);
SNR = [10, 20, 40];
dref = harmonic1 + harmonic2;
d = awgn( dref, SNR(1), 'measured' ); % WE: sygnał odniesienia dla sygnału x
x = [ d(1) d(1:end-1) ]; % WE: sygnał filtrowany, teraz opóźniony d
M = 1; % długość filtru
mi = 1;% współczynnik szybkości adaptacji

y = []; e = []; % sygnały wyjściowe z filtra
bx = zeros(M,1); % bufor na próbki wejściowe x
h = zeros(M,1); % początkowe (puste) wagi filtru

for n = 1 : length(x)
    bx = [ x(n); bx(1:M-1) ]; % pobierz nową próbkę x[n] do bufora
    y(n) = h' * bx; % oblicz y[n] = sum( x .* bx) – filtr FIR
    e(n) = d(n) - y(n); % oblicz e[n]
    h = h + mi * e(n) * bx; % LMS
    % h = h + mi * e(n) * bx /(bx'*bx); % NLMS
end
snr(d, h)
figure()
plot(time, d)