clear all; close all;

%% Wymagania odnosnie filtracji cyfrowej
fpr = 2000;                             % czestotliwosc probkowania
f1 = 400;                              % czestotliwosc graniczna filtra dolno-przepustowego
f2 = 600;
N = 6;                                  % liczba biegunow prototypu analogowego
Rp = 3; Rs = 60;                        % oscylacje (R-ripples) w [dB] w pasmie PASS i STOP

%% Wymagania cyfrowe --> analogowe
f1_analog = 2 * fpr * tan(pi * f1 / fpr) / (2 * pi);
f2_analog = 2 * fpr * tan(pi * f2 / fpr) / (2 * pi);
w0 = 2 * pi * sqrt(f1_analog * f2_analog);
bw = 2 * pi * (f2_analog - f1_analog);

%% Projekt filtra analogowego
[z,p,gain] = ellipap(N, Rp, Rs);        % prototyp analogowy eliptyczny dolno-przepustowy
b = gain * poly(z); a = poly(p);        % zera & bieguny analogowe --> wspolczynniki [b,a]

% Przeskalowanie filtra do żądanej częstotliwości granicznej
[b, a] = lp2bp(b, a, w0, bw);
% Odpowiedź częstotliwościowa filtra analogowego
figure;
freqs(b, a);
title('Odpowiedź częstotliwościowa filtra analogowego');

% Dodaj rysunek z polozeniem zer & biegunow filtra analogowego
figure;
zplane(z, p);
title('Położenie zer i biegunów filtra analogowego');

% Oblicz sam i pokaz odpowiedz czestotliwosciowa filtra analogowego
[H, w] = freqs(b, a);
figure;
plot(w / (2 * pi), 20 * log10(abs(H)));
xlabel('Częstotliwość (Hz)');
ylabel('Magnituda (dB)');
title('Odpowiedź częstotliwościowa filtra analogowego');

%% Konwersja filtra analogowego na cyfrowy
[z, p, gain] = tf2zp(b, a);
[zz, pp, ggain] = bilinearMY(z, p, gain, fpr);   
b = ggain * poly(zz);
a = poly(pp);       
% Wyświetlenie zaprojektowanego filtra
% fvtool(b, a);

% Dodaj rysunek pokazujacy polozenie zer & biegunow filtra cyfrowego
figure;
zplane(b, a);
title('Położenie zer i biegunów filtra cyfrowego');

% Oblicz i pokaz odpowiedz czestotliwosciowa filtra cyfrowego
[H, f] = freqz(b, a, 2048, fpr);
figure;
plot(f, 20 * log10(abs(H)));
xlabel('Częstotliwość (Hz)');
ylabel('Magnituda (dB)');
title('Odpowiedź częstotliwościowa filtra cyfrowego');

% Sygnal wejsciowy x(n) - dwie sinusoidy: 20 and 500 Hz
Nx = 1000; % liczba probek sygnalu
dt = 1 / fpr; t = dt * (0:Nx-1); % chwile probkowania
%x = zeros(1,Nx); x(1) = 1; % sygnal delta Kroneckera (impuls jednostkowy)
x = sin(2 * pi * 20 * t + pi / 3) + sin(2 * pi * 500 * t + pi / 7); % suma dwoch sinusow

% Rekursywna filtracja cyfrowa IIR: x(n) --> [ b, a ] --> y(n)
% y = filter(b,a,x); % funkcja Matlaba
M = length(b); % liczba wspolczynnikow {b}
N = length(a); a = a(2:N); N = N - 1; % liczba wspolczynnikow {a}, usun a0=1
bx = zeros(1, M); % bufor bx na probki wejsciowe x(n)
by = zeros(1, N); % bufor by na probki wyjsciowe y(n)
y = zeros(1, Nx); % zainicjalizowanie wektora y

for n = 1:Nx % PETLA GLOWNA
    bx = [x(n) bx(1:M-1)]; % nowa probka x(n) na poczatek bufora bx
    y(n) = sum(bx .* b) - sum(by .* a); % filtracja = dwie srednie wazone, y(n)=?
    by = [y(n) by(1:N-1)]; % zapamietanie y(n) w buforze by
end

% RYSUNKI: porownanie wejscia i wyjscia filtra
figure;
subplot(211); plot(t, x); grid; % sygnal wejsciowy x(n)
subplot(212); plot(t, y); grid; % sygnal wyjsciowy y(n)
