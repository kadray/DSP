close all
clear all
clc
% Parametry
fs = 100000; % Częstotliwość próbkowania
fpilot = 19000; % Częstotliwość pilota
theta = 0; % Początkowy kąt fazowy
alpha = 1e-2; % Parametr pętli PLL
beta = alpha^2/4; % Parametr pętli PLL

% Generowanie sygnału pilota
t = (0:1/fs:1); % Wektor czasu
p = sin(2*pi*fpilot*t); % Sygnał pilota

% Szum biały gaussowski
SNR = [0, 5, 10, 20]; % Poziomy sygnału szumu w dB
for i = 1:length(SNR)
    p_noisy = awgn(p, SNR(i)); % Dodanie szumu do sygnału pilota

    % Implementacja cyfrowej pętli PLL
    theta = 0; % Reset kąta fazowego
    for n = 1 : length(p_noisy)
        perr = -p_noisy(n)*sin(theta);
        theta = theta + (2*pi*fpilot/fs) + alpha*perr;
        fpilot = fpilot + beta*perr;
    end

    % Wyznaczenie czasu zbieżności
    convergence_time = find(abs(diff(p_noisy)) < 0.01, 1); % Przyjmujemy, że zbieżność następuje, gdy różnica między kolejnymi próbkami spadnie poniżej pewnego progu

    % Wyświetlenie rezultatów
    fprintf('Poziom sygnału szumu: %d dB\n', SNR(i));
    fprintf('Czas zbieżności: %d próbek\n', convergence_time);
    
    % Wykres sygnału w dziedzinie czasu
    figure;
    subplot(2,1,1);
    plot(t, p_noisy);
    title('Sygnał z dodanym szumem w dziedzinie czasu');
    xlabel('Czas [s]');
    ylabel('Amplituda');
    grid on;

    % Wykres sygnału w dziedzinie częstotliwości
    NFFT = 2^nextpow2(length(p_noisy)); % Długość FFT
    f = (-fs/2:fs/NFFT:fs/2-fs/NFFT); % Wektor częstotliwości
    P = fftshift(fft(p_noisy, NFFT)); % Dyskretna transformata Fouriera
    subplot(2,1,2);
    plot(f, abs(P));
    title('Spektrum sygnału z dodanym szumem');
    xlabel('Częstotliwość [Hz]');
    ylabel('Amplituda');
    xlim([-fs/2, fs/2]);
    grid on;

    fprintf('\n');
end
