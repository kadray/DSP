% Parametry sygnału
fpilot = 19000; % Częstotliwość 19 kHz
fs = 44100; % Częstotliwość próbkowania
t = 0:1/fs:1; % Wektor czasu od 0 do 1 sekundy z częstotliwością próbkowania Fs

df = 10; % Zmiana częstotliwości ±10 Hz
fm = 0.1; % Częstotliwość zmiany częstotliwości (10 sekund)

phase_offset = pi/4; % Przesunięcie fazowe o pi/4 radianów (możesz zmienić na dowolną wartość)

% Generowanie sygnału sinusoidalnego z przesunięciem fazowym
p = sin(2*pi*fpilot*t + phase_offset);
delta_f = df * sin(2*pi*fm*t);
p = sin(2*pi*(fpilot + delta_f).*t + phase_offset);
%p = awgn( p, 10, 'measured'); 
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
disp(perr)
c57(:,1) = cos(theta(1:end-1)); % nosna 57 kHz
fft_signal = fft(c57);

% Oblicz wektor częstotliwości
frequencies = linspace(0, fs, length(c57));

% Narysuj widmo częstotliwości
plot(frequencies(1:end/2), abs(fft_signal(1:end/2))*2/length(c57));
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda');
title('Widmo częstotliwości sygnału');