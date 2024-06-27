clear all
close all
clc

N = 2000;
fpr = 2000;
dt = 1/fpr;
t = dt*(0:N-1);
f = linspace(-fpr/2, fpr/2, N);
w = 2*pi*f;

%% 1. Okno prostokątne
T1 = 0.4;
rr_t = @(t, T) (abs(t) <= T);
x1 = rr_t(t, T1);
X1 = (2*sin(w*T1))./w;

%% 2. Signum
x2 = sign(t);
X2 = (2./(1j*w));

%% 3. Funkcja Gaussa
a3 = 1; 
x3 = exp(-a3 * t.^2);
X3 = (sqrt(pi/a3)*exp(-w.^2/(4*a3)));

%% 4. Jednostronna eksponenta
a4 = 10; 
x4 = exp(-a4 * t) .* (t >= 0);
X4 = (1./(a4+1j*w));

%% 5. Tłumiony sinus
a = 5; 
A5=10;
omega5 = 2 * pi *10; 
x5 = A5 * exp(-a * t) .* sin(omega5 * t) .* (t >= 0);
X5 = ((A5*omega5)./((a+1j*w).^2+omega5^2));

%% 6. Tłumiony kosinus
a=5;
A6=10;
omega6 = 2 * pi*10; 
x6 = A6 * exp(-a * t) .* cos(omega6 * t) .* (t >= 0);
X6 = (A6*(a+1j*w)./((a+1j*w).^2+omega6^2));

%% 7. Fragment kosinusa
omega7 = 2 * pi*10;
T7=0.5; 
x7 = cos(omega7 * t) .* rr_t(t, T7);
X7 = (sin((w + omega7)*T7)./(w + omega7) + sin((w - omega7)*T7)./(w - omega7));

x_list={x1 x2 x3 x4 x5 x6 x7};
X_list={X1 X2 X3 X4 X5 X6 X7};

for k=1:7
    figure;
    fft_X=fftshift(fft(x_list{k}))/N;
    subplot(3, 1, 1); plot(t, x_list{k});
    title('Sygnał w dziedzinie czasu');
    
    subplot(3, 1, 2); plot(w, abs(X_list{k}), 'LineWidth', 1.5); hold on;
    plot(w, abs(fft_X), 'r--'); % Widmo z FFT
    legend("Widmo ze wzoru", "Widmo z FFT")
    xlabel('Częstotliwość [Hz]'); ylabel('Amplituda [liniowo]');
    
    subplot(3, 1, 3); plot(w, 20*log10(abs(X_list{k})), 'LineWidth', 1.5); hold on;
    plot(w, 20*log10(abs(fft_X)), 'r--');
    legend("Widmo ze wzoru", "Widmo z FFT")
    xlabel('Częstotliwość [Hz]'); ylabel('Amplituda [dB]');
    
    %figure
    % plot(t, ifft(fft_X), 'r--')

end
