clear all 
close all
clc

fs = 3.2e6;         % częstotliwość próbkowania
N  = 32e6;          % liczba próbek (IQ)
fc = 0.50e6;        % częstotliwość środkowa stacji MF

bwSERV = 80e3;      % szerokość pasma usługi FM (szerokość pasma ~= częstotliwość próbkowania!)
bwAUDIO = 16e3;     % szerokość pasma audio FM (szerokość pasma == 1/2 * częstotliwość próbkowania!)

f = fopen('samples_100MHz_fs3200kHz.raw');
s = fread(f, 2*N, 'uint8');
fclose(f);

s = s-127;

% IQ --> zespolone
wideband_signal = s(1:2:end) + sqrt(-1)*s(2:2:end); clear s;

% Wyciągnij nośną wybranej usługi, a następnie przesuń wybraną usługę do pasma podstawowego
wideband_signal_shifted = wideband_signal .* exp(-sqrt(-1)*2*pi*fc/fs*[0:N-1]');

% Wyznacz filtr dolnoprzepustowy typu Butterwortha LP rzędu 4 o częstotliwości granicznej 80 kHz
[b, a] = butter(4, 80e3/(fs/2));

% Odfiltruj usługę z sygnału o szerokim paśmie
wideband_signal_filtered = filter(b, a, wideband_signal_shifted);

% Próbkowanie do szerokości pasma usługi - bwSERV = nowa częstotliwość próbkowania
x = wideband_signal_filtered(1:fs/(bwSERV*2):end);

% Demodulacja FM
dx = x(2:end).*conj(x(1:end-1));
y = atan2(imag(dx), real(dx));

% Dodaj filtr antyaliasingowy
[b_aa, a_aa] = butter(4, 16e3/(bwSERV/2));
ya = filter(b_aa, a_aa, y);

% Decymacja do szerokości pasma audio bwAUDIO
ym = downsample(ya, bwSERV/bwAUDIO);

% De-emfaza (brak kodu w wersji udostępnionej)

% Odsłuchaj ostateczny wynik
ym = ym-mean(ym);
ym = ym/(1.001*max(abs(ym)));
% soundsc(ym, bwAUDIO*2);

% Charakterystyka czasowo-częstotliwościowa i widmo gęstości mocy oryginalnego sygnału
figure;
subplot(2, 1, 1);
spectrogram(wideband_signal, hamming(1024), 512, 1024, fs, 'yaxis');
title('Charakterystyka czasowo-częstotliwościowa oryginalnego sygnału');
subplot(2, 1, 2);
psd(spectrum.welch('Hamming', 1024), wideband_signal, 'Fs', fs);
title('Widmo gęstości mocy oryginalnego sygnału');

% Charakterystyka czasowo-częstotliwościowa i widmo gęstości mocy sygnału przefiltrowanego
figure;
subplot(2, 1, 1);
spectrogram(wideband_signal_filtered, hamming(1024), 512, 1024, fs, 'yaxis');
title('Charakterystyka czasowo-częstotliwościowa sygnału przefiltrowanego');
subplot(2, 1, 2);
psd(spectrum.welch('Hamming', 1024), wideband_signal_filtered, 'Fs', fs);
title('Widmo gęstości mocy sygnału przefiltrowanego');

% Charakterystyka czasowo-częstotliwościowa i widmo gęstości mocy sygnału po demodulacji
figure;
subplot(2, 1, 1);
spectrogram(y, hamming(1024), 512, 1024, fs/bwSERV, 'yaxis');
title('Charakterystyka czasowo-częstotliwościowa sygnału po demodulacji');
subplot(2, 1, 2);
psd(spectrum.welch('Hamming', 1024), y, 'Fs', fs/bwSERV);
title('Widmo gęstości mocy sygnału po demodulacji');
disp(y)
% Charakterystyka czasowo-częstotliwościowa i widmo gęstości mocy sygnału po filtracji antyaliasingowej
figure;
subplot(2, 1, 1);
spectrogram(ya, hamming(1024), 512, 1024, fs/bwAUDIO, 'yaxis');
title('Charakterystyka czasowo-częstotliwościowa sygnału po filtracji antyaliasingowej');
subplot(2, 1, 2);
psd(spectrum.welch('Hamming', 1024), ya, 'Fs', fs/bwAUDIO);
title('Widmo gęstości mocy sygnału po filtracji antyaliasingowej');

% Wykorzystanie funkcji periodogram do wyznaczenia widma gęstości mocy
[Pxx, F] = periodogram(wideband_signal, hamming(length(wideband_signal)), length(wideband_signal), fs);

% Znalezienie "górek" na widmie gęstości mocy
threshold = 0.1 * max(Pxx); % Próg dla "górek"
peak_indices = find(Pxx > threshold);

% Wyświetlenie "górek" na wykresie
figure;
plot(F, 10*log10(Pxx));
hold on;
plot(F(peak_indices), 10*log10(Pxx(peak_indices)), 'r*');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [dB]');
title('Widmo gęstości mocy sygnału wideband');
grid on;

% Wyświetlenie częstotliwości stacji radiowych
disp('Częstotliwości stacji radiowych:');
disp(F(peak_indices));


