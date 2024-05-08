clear all
close all
clc
% Parametry sygnału
fpilot = 19000; % Częstotliwość 19 kHz
fs = 44100; % Częstotliwość próbkowania
t = 0:1/fs:1; % Wektor czasu od 0 do 1 sekundy z częstotliwością próbkowania Fs

df = 10; % Zmiana częstotliwości ±10 Hz
fm = 0.1; % Częstotliwość zmiany częstotliwości (10 sekund)

phase_offset = pi/4; % Przesunięcie fazowe o pi/4 radianów (możesz zmienić na dowolną wartość)

%% punkty 1 i 2
p = sin(2*pi*fpilot*t + phase_offset);
p = awgn(p, 0, 'measured'); 

% %% punkt 3
% delta_f = df * sin(2*pi*fm*t);
% p = sin(2*pi*(fpilot + delta_f).*t + phase_offset);

% Petla PLL z filtrem typu IIR do odtworzenia częstotliwości i fazy pilota [7]
% i na tej podstawie sygnałów nośnych: symboli c1, stereo c38 i danych RDS c57
freq = 2*pi*fpilot/fs;
theta = zeros(1,length(p)+1);
alpha = 1e-2;
beta = alpha^2/4;
for n = 1 : length(p)
    perr = -p(n)*sin(theta(n));
    theta(n+1) = theta(n) + freq + alpha*perr;
    freq = freq + beta*perr;
end
    
% Obliczenie składowych sygnału
c1 = cos((1/19)*theta(1:end-1));
c19 = cos(theta(1:end-1));
c38 = cos(2*theta(1:end-1));
c57 = cos(3*theta(1:end-1));

% Sumowanie sygnałów
signal_sum = c1 + c19 + c38 + c57;
fft_signal = fft(signal_sum);

% Plot in frequency domain
Fs = fs; % Sampling frequency
N = length(signal_sum); % Length of signal
f = linspace(0, Fs, N); % Frequency vector
f_khz = f / 1000; % Convert frequencies to kHz

figure;
plot(f_khz, abs(fft_signal));
title('FFT of Sum of Frequencies');
xlabel('Frequency (kHz)');
ylabel('Magnitude');
