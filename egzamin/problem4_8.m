clear all
close all
clc

N=2000;
fpr=2000;
dt=1/fpr;
t=dt*(0:N-1);
w=2*pi./t;

% 1. Rectangular Window
T=0.1;
rr_t = @(t, T) (abs(t) <= T);
x1=rr_t(t, T);
X1=(2*sin(w.*T))./w;
fft_X1=fft(x1);
figure;
subplot(3, 1, 1); plot(t, x1);
subplot(3, 1, 2); plot(w, X1, w, fft_X1)
subplot(3, 1, 3); plot(w, 20*log10(X1), w, 20*log10(fft_X1))

% 2. Signum Signal
x2 = sign(t);
X2=2./(1j*w);
fft_X2=fft(x2);
figure;
subplot(3, 1, 1); plot(t, x2);
subplot(3, 1, 2); plot(w, X2, w, fft_X2)
subplot(3, 1, 3); plot(w, 20*log10(X2), w, 20*log10(fft_X2))

% 3. Gaussian Function
a = 1; % example value for a
x3 = exp(-a * t.^2);
X3 = sqrt(pi/a)*exp(-w.^2/4*a);
fft_X3=fft(x3);
figure;
subplot(3, 1, 1); plot(t, x3);
subplot(3, 1, 2); plot(w, X3, w, fft_X3)
subplot(3, 1, 3); plot(w, 20*log10(X3), w, 20*log10(fft_X3))

% 4. Unilateral Exponential
a = 1; % example value for a
x4 = exp(-a * t) .* (t >= 0);
X4 = 1./(a+1j*w);
fft_X4=fft(x4);
figure;
subplot(3, 1, 1); plot(t, x4);
subplot(3, 1, 2); plot(w, X4, w, fft_X4)
subplot(3, 1, 3); plot(w, 20*log10(X4), w, 20*log10(fft_X4))

% 5. Damped Sine
a = 5; % example value for a
A=10;
omega0 = 2 * pi * 5; % example frequency
x5 = A * exp(-a * t) .* sin(omega0 * t) .* (t >= 0);
X5 = (A*omega0)./((a+1j*w).^2+omega0^2);
fft_X5=fft(x5);
figure;
subplot(3, 1, 1); plot(t, x5);
subplot(3, 1, 2); plot(w, X5, w, fft_X5)
subplot(3, 1, 3); plot(w, 20*log10(X5), w, 20*log10(fft_X5))


% 6. Damped Cosine
a=5;
A=10;
omega0 = 2 * pi * 50; 
x6 = A * exp(-a * t) .* cos(omega0 * t) .* (t >= 0);
X6 = A*(a+1j*w)./((a+1j*w).^2+omega0^2);
fft_X6=fft(x6);
figure;
subplot(3, 1, 1); plot(t, x6);
subplot(3, 1, 2); plot(w, X6, w, fft_X6)
subplot(3, 1, 3); plot(w, 20*log10(X6), w, 20*log10(fft_X6))


% 7. Cosine Fragment
x7 = cos(omega0 * t) .* rr_t(t, T);
X7 = sin((w + omega0)*T)./(w + omega0) + sin((w - omega0)*T)./(w - omega0);
fft_X7=fft(x7);
figure;
subplot(3, 1, 1); plot(t, x7);
subplot(3, 1, 2); plot(w, X7, w, fft_X7)
subplot(3, 1, 3); plot(w, 20*log10(X7), w, 20*log10(fft_X7))
