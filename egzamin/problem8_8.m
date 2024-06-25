% cps_08_iir_projekt.m
clear all; close all;
% Wymagania odnosnie filtracji cyfrowej
fpr = 2000; % czestotliwosc probkowania
f1 = 400; % czestotliwosc dolna filtra band-pass
f2 = 600; % czestotliwosc gorna filtra band-pass
N = 6; % liczba biegunow prototypu analogowego
Rp = 3; Rs = 60; % oscylacje (R-ripples) w [dB] w pasmie PASS i STOP
% Wymagania cyfrowe --> analogowe
f1 = 2*fpr*tan(pi*f1/fpr) / (2*pi);
f2 = 2*fpr*tan(pi*f2/fpr) / (2*pi);
w0 = 2*pi*sqrt(f1*f2);
dw = 2*pi*(f2-f1);
% Projekt filtra analogowego
[z,p,gain] = ellipap(N,Rp,Rs); % prototyp analogowy eliptyczny dolno-przepustowy
[z,p,gain] = lp2bsMY(z,p,gain,w0,dw); % transformacja czestotliwosci NASZA: LP -> BS
b = gain*poly(z); a = poly(p); % zera & bieguny analogowe --> wspolczynniki [b,a]
freqs(b,a), pause % odpowiedz czestotliwosciowa filtra analogowego [b,a]
% Dodaj rysunek z polozeniem zer & biegunow filtra analogowego
% Oblicz sam i pokaz odpowiedz czestotliwosciowa filtra analogowego
% Konwersja filtra analogowego na cyfrowy
[z,p,gain] = bilinearMY(z,p,gain,fpr); % funkcja biliearMY() NASZA
b = real( gain*poly(z) ); a = real( poly(p) ); % zera & bieguny cyfrowe --> wsp. [b,a]
fvtool(b,a), pause % wyswietlenie zaprojektowanego filtra
% Dodaj rysunek pokazujacy polozenie zer & biegunow filtra cyfrowego
% Oblicz i pokaz odpowiedz czestotliwosciowa filtra, w Matlabie H=freqz(b,a,f,fpr)
% Dokonaj filtracji wybranych sygnalow, w Matlabie y=filter(b,a,x)


% ... kontynuacja programu cps_08_iir_intro.m
% Sygnal wejsciowy x(n) - dwie sinusoidy: 20 and 500 Hz
Nx = 1000; % liczba probek sygnalu
dt = 1/fpr; t = dt*(0:Nx-1); % chwile probkowania
%x = zeros(1,Nx); x(1) = 1; % sygnal delta Kroneckera (impuls jednostkowy)
x = sin(2*pi*20*t+pi/3) + sin(2*pi*500*t+pi/7); % suma dwoch sinusow
% Rekursywna filtracja cyfrowa IIR: x(n) --> [ b, a ] --> y(n)
% y=filter(b,a,x); % funkcja Matlaba
M = length(b); % liczba wspolczynnikow {b}
N = length(a); a = a(2:N); N=N-1; % liczba wspolczynnikow {a}, usun a0=1
bx = zeros(1,M); % bufor bx na probki wejsciowe x(n)
by = zeros(1,N); % bufor by na probki wyjsciowe y(n)
for n = 1 : Nx % PETLA GLOWNA
bx = [ x(n) bx(1:M-1) ]; % nowa probka x(n) na poczatek bufora bx
y(n) = sum( bx .* b ) - sum( by .* a ); % filtracja = dwie srednie wazone, y(n)=?
by = [ y(n) by(1:N-1) ]; % zapamietanie y(n) w buforze by
end %
% RYSUNKI: porownanie wejscia i wyjscia filtra
figure;
subplot(211); plot(t,x); grid; % sygnal wejsciowy x(n)
subplot(212); plot(t,y); grid; pause % sygnal wyjsciowy y(n)
figure; % widma FFT drugicj polowek sygnalow x(n) i y(n) (bez stanow przejsciowych)
k=Nx/2+1:Nx; f0 = fpr/(Nx/2); f=f0*(0:Nx/2-1);
subplot(211); plot(f,20*log10(abs(2*fft(x(k)))/(Nx/2))); grid;
subplot(212); plot(f,20*log10(abs(2*fft(y(k)))/(Nx/2))); grid; pause

% brat
% clear all; close all;

% % Sampling frequency
% fpr = 2000;

% % Low-pass filter design
% fc = 100; % cutoff frequency
% [N, Wn] = buttord(fc/(fpr/2), (fc+50)/(fpr/2), 3, 60);
% [b_lp, a_lp] = butter(N, Wn, 'low');
% [z_lp, p_lp, k_lp] = tf2zpk(b_lp, a_lp);

% % Plot poles and zeros of low-pass filter
% figure;
% zplane(z_lp, p_lp);
% title('Poles and Zeros of Low-Pass Filter');

% % Frequency response of low-pass filter
% figure;
% freqz(b_lp, a_lp, 1024, fpr);
% title('Frequency Response of Low-Pass Filter');

% % Band-pass filter design
% f1 = 400; % lower cutoff frequency
% f2 = 600; % upper cutoff frequency
% [N, Wn] = buttord([f1 f2]/(fpr/2), [f1-100 f2+100]/(fpr/2), 3, 60);
% [b_bp, a_bp] = butter(N, Wn, 'bandpass');
% [z_bp, p_bp, k_bp] = tf2zpk(b_bp, a_bp);

% % Plot poles and zeros of band-pass filter
% figure;
% zplane(z_bp, p_bp);
% title('Poles and Zeros of Band-Pass Filter');

% % Frequency response of band-pass filter
% figure;
% freqz(b_bp, a_bp, 1024, fpr);
% title('Frequency Response of Band-Pass Filter');

% % Generate input signal
% Nx = 1000; % number of samples
% dt = 1/fpr; t = dt*(0:Nx-1); % sampling times
% x = sin(2*pi*20*t+pi/3) + sin(2*pi*500*t+pi/7); % sum of two sinusoids

% % Apply low-pass filter
% y_lp = filter(b_lp, a_lp, x);

% % Apply band-pass filter
% y_bp = filter(b_bp, a_bp, x);

% % Plot input and output signals
% figure;
% subplot(311); plot(t, x); grid;
% title('Input Signal');
% subplot(312); plot(t, y_lp); grid;
% title('Output Signal of Low-Pass Filter');
% subplot(313); plot(t, y_bp); grid;
% title('Output Signal of Band-Pass Filter');

% % FFT of signals
% X = fft(x);
% Y_lp = fft(y_lp);
% Y_bp = fft(y_bp);

% f = fpr*(0:(Nx/2))/Nx;
% figure;
% subplot(311); plot(f, abs(X(1:Nx/2+1))); grid;
% title('FFT of Input Signal');
% subplot(312); plot(f, abs(Y_lp(1:Nx/2+1))); grid;
% title('FFT of Low-Pass Filtered Signal');
% subplot(313); plot(f, abs(Y_bp(1:Nx/2+1))); grid;
% title('FFT of Band-Pass Filtered Signal');
