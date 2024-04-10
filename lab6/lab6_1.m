close all
clear all
clc

load("butter.mat")

fs = 16000;
fmin = 1189;
fmax = 1229;
wmin = 2*pi*fmin;
wmax = 2*pi*fmax;

[b,a] = zp2tf(z,p,k);


[z_cyf, p_cyf , k_cyf] = bilinear(z, p,k, fs);
[a_cyf,b_cyf] = zp2tf(z_cyf,p_cyf,k_cyf);
N = 2000; % liczba punktów w charakterystyce
[H, w] = freqz(a_cyf, b_cyf, N, fs);

% Wykres charakterystyki amplitudowo-częstotliwościowej
figure;
plot(w, abs(H));
axis([1150 1300 -1 3])
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda');
title('Charakterystyka amplitudowo-częstotliwościowa filtru cyfrowego');
grid on;
% Dodanie linii pionowych dla częstotliwości granicznych
hold on;
line([fmin, fmin], ylim, 'Color', 'r', 'LineStyle', '--');
line([fmax, fmax], ylim, 'Color', 'r', 'LineStyle', '--');
hold off; 


% Obliczenie charakterystyki amplitudowo-częstotliwościowej dla filtru analogowego
[Hz,wz] = freqs(b, a, w);

% Wykres charakterystyki amplitudowo-częstotliwościowej filtru analogowego
figure;
plot(wz/(2*pi), abs(Hz));
axis([1150 1300 -1 3])
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda');
title('Charakterystyka amplitudowo-częstotliwościowa filtru analogowego');
grid on;
line([fmin, fmin], ylim, 'Color', 'r', 'LineStyle', '--');
line([fmax, fmax], ylim, 'Color', 'r', 'LineStyle', '--');
hold off; 


duration = 1; % czas trwania w sekundach
t = 0:1/fs:duration-1/fs; % wektor czasu

% Częstotliwości harmoniczne w hercach
f1 = 1209;
f2 = 1272;

% Generowanie sygnałów harmonicznych
signal1 = sin(2*pi*f1*t);
signal2 = sin(2*pi*f2*t);

% Sumowanie sygnałów
digital_signal = signal1 + signal2;


% Przefiltrowanie sygnału cyfrowego
filtered_signal = zeros(size(digital_signal)); % Inicjalizacja sygnału przefiltrowanego

% Konwolucja sygnału z odpowiedzią impulsową filtra
for n = 1:length(filtered_signal)
    for k = 1:length(a_cyf)
        if n-k+1 > 0
            filtered_signal(n) = filtered_signal(n) + a_cyf(k)*digital_signal(n-k+1);
        end
    end
    for k = 2:length(b_cyf)
        if n-k+1 > 0
            filtered_signal(n) = filtered_signal(n) - b_cyf(k)*filtered_signal(n-k+1);
        end
    end
end

% Wyświetlenie sygnału przefiltrowanego i oryginalnego
figure;
subplot(2,1,1);
plot(t, digital_signal);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnał cyfrowy złożony z dwóch harmonicznych (oryginalny)');
subplot(2,1,2);
plot(t, filtered_signal);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnał cyfrowy po filtracji ( własny filtr )');


% Przefiltrowanie sygnału cyfrowego
filtered_signal = filter(a_cyf, b_cyf, digital_signal);

% Wyświetlenie sygnału przefiltrowanego i oryginalnego
figure;
subplot(2,1,1);
plot(t, digital_signal);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnał cyfrowy złożony z dwóch harmonicznych (oryginalny)');
subplot(2,1,2);
plot(t, filtered_signal);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnał cyfrowy po filtracji');
