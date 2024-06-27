clear all
close all
clc

N = 2000;
fpr = 2000;
dt = 1/fpr;
t = dt*(0:N-1);
f = linspace(-N, fpr, N);
w=2*pi*f;

% 1. Rectangular Window
T1 = 0.1;
rr_t = @(t, T) (abs(t) <= T);
x1 = rr_t(t, T1);
X1 = fftshift((2*sin(w.*T1))./w);
fft_X1 = fftshift(fft(x1))/N;

% 2. Signum Signal
x2 = sign(t);
X2 = (2./(1j*w));
fft_X2 = fftshift(fft(x2))/N;

% 3. Gaussian Function
a3 = 1; % example value for a
x3 = exp(-a3 * t.^2);
X3 = (sqrt(pi/a3)*exp(-w.^2/4*a3));
fft_X3 = fftshift(fft(x3))/N;

% 4. Unilateral Exponential
a4 = 1; % example value for a
x4 = exp(-a4 * t) .* (t >= 0);
X4 = (1./(a4+1j*w));
fft_X4 = fftshift(fft(x4))/N;

% 5. Damped Sine
a = 5; % example value for a
A=10;
omega5 = 2 * pi * 5; % example frequency
x5 = A * exp(-a * t) .* sin(omega5 * t) .* (t >= 0);
X5 = ((A*omega5)./((a+1j*w).^2+omega5^2));
fft_X5=fftshift(fft(x5))/N;

% 6. Damped Cosine
a=5;
A=10;
omega6 = 2 * pi; 
x6 = A * exp(-a * t) .* cos(omega6 * t) .* (t >= 0);
X6 = (A*(a+1j*w)./((a+1j*w).^2+omega6^2));
fft_X6=fftshift(fft(x6))/N;

% 7. Cosine Fragment
omega7 = 2 * pi;
T7=0.5; 
x7 = cos(omega7 * t) .* rr_t(t, T7);
X7 = (sin((w + omega7)*T7)./(w + omega7) + sin((w - omega7)*T7)./(w - omega7));
fft_X7=fftshift(fft(x7))/N;


x_list={x1 x2 x3 x4 x5 x6 x7};
X_list={X1 X2 X3 X4 X5 X6 X7};
fft_list={fft_X1 fft_X2 fft_X3 fft_X4 fft_X5 fft_X6 fft_X7};
disp(length(w))
for k=1:7
    figure;
    subplot(3, 1, 1); plot(t, x_list{k});
    subplot(3, 1, 2); plot(w, abs(X_list{k}), w, abs(fft_list{k}));
    xlabel('Frequency (Hz)'); ylabel('Amplitude');
    subplot(3, 1, 3); plot(w, 20*log10(abs(X_list{k})), w, 20*log10(abs(fft_list{k})));
    xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
end