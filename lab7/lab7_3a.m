clear all; close all;
%% Syntetyczny sygnał fm
fs = 1e6;         % sampling frequency
N  = 2.699993e6;         % number of samples (IQ)
fc = 0.25e6;        % central frequency of MF station
bwSERV = 100e3;     % bandwidth of an FM service (bandwidth ~= sampling frequency!)
bwAUDIO = 20e3;     % bandwidth of an FM audio (bandwidth == 1/2 * sampling frequency!)
s = load('stereo_samples_fs1000kHz_LR_IQ.mat');
wideband_signal = s.I+s.Q;clear s;
fpl=19000;

%% Rzeczywisty sygnał fm
% fs = 3.2e6;         % sampling frequency
% N  = 32e6;         % number of samples (IQ)
% fc = 0.39e6;        % central frequency of MF station
% bwSERV = 80e3;     % bandwidth of an FM service (bandwidth ~= sampling frequency!)
% bwAUDIO = 16e3;     % bandwidth of an FM audio (bandwidth == 1/2 * sampling frequency!)
% f = fopen('samples_100MHz_fs3200kHz.raw');
% s = fread(f, 2*N, 'uint8');
% fclose(f);
% wideband_signal = s(1:2:end) + sqrt(-1)*s(2:2:end); clear s;
% fpl=19065.25;

%% Początkowe przetworzenie sygnału
wideband_signal_shifted = wideband_signal .* exp(-sqrt(-1)*2*pi*fc/fs*[0:N-1]');
%% Filtrowanie stacji
[b,a] = butter(4, bwSERV/fs);
wideband_signal_filtered = filter( b, a, wideband_signal_shifted );
%% Nowe próbkowanie
x = wideband_signal_filtered( 1:fs/(bwSERV*2):end );
%% Demodulacja FM
dx = x(2:end).*conj(x(1:end-1));
y = atan2( imag(dx), real(dx) );
figure(1);
psd(spectrum.welch('Hamming',1024), y,'Fs',(bwSERV*2));

%% Downsampling
Wn_down = (15e3*2)/(bwSERV*2);
b_down = fir1(128, Wn_down, blackmanharris(128+1));
a_down = 1;
y_audio_sum = filter( b_down, a_down, y ); % antyaliasing filter
figure(2)
psd(spectrum.welch('Hamming',1024), y_audio_sum,'Fs',bwAUDIO);
ym = y_audio_sum(1:5:end);

%% 1 - Pilot
Wn_pilot = [18.95e3/bwSERV 19.05e3/bwSERV];
b_pilot = fir1(128, Wn_pilot, blackmanharris(128+1));
y_pilot = filter( b_pilot, 1, y);
figure(3);
psd(spectrum.welch('Hamming',1024), y_pilot,'Fs',fs);

%% 2 - Filtr BP
Wn_dif = [fpl/bwSERV 3*fpl/bwSERV];
b_dif = fir1(128, Wn_dif, blackmanharris(128+1));
figure(4);
freqz(b_dif, 1, 512, (bwSERV*2));

%% 3 - Przesunięcie
y_audio_dif = filter( b_dif, 1, y);
figure(5);
psd(spectrum.welch('Hamming',1024), y_audio_dif,'Fs',bwSERV*2);
y_audio_dif = y_audio_dif .* cos(2*pi*fpl/bwSERV*[0:length(y_audio_dif)-1]');
figure(13);
psd(spectrum.welch('Hamming',1024), y_audio_dif,'Fs',bwSERV);

%% 4 - Antyliasing i downsampling
Wn_down_dif = 15e3/bwSERV;
b_down_dif = fir1(128, Wn_down_dif, blackmanharris(128+1));
a_down_dif = 1;
figure(6);
freqz(b_down_dif, a_down_dif, 512, (bwSERV*2));
y_audio_dif = filter( b_down_dif, a_down_dif, y_audio_dif ); % antyaliasing filter
figure(7);
psd(spectrum.welch('Hamming',1024), y_audio_dif,'Fs',bwAUDIO);
xlim([0, 2])
ys = y_audio_dif(1:5:end);

%% 5 - Odtworzenie stereo
ym = ym-mean(ym);
ym = ym/(1.001*max(abs(ym)));
ys = ys/(1.001*max(abs(ys)));
yl = 0.5*(ym(1:end-13,1)+ys(14:end,1));
yr = 0.5*(ym(1:end-13,1)-ys(14:end,1));
yl = yl/(1.001*max(abs(yl)));
yr = yr/(1.001*max(abs(yr)));
figure(8);
    subplot(2,1,1);
        plot(yl)
    subplot(2,1,2)
        plot(yr)
soundsc(yr, bwAUDIO*2);