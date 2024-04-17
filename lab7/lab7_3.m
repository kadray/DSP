% odbiornik FM: P. Swiatkiewicz, T. Twardowski, T. Zielinski, J. Bułat

clear all; close all;

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


%% Syntetyczny sygnał fm
fs = 1e6;         % sampling frequency
N  = 2.699993e6;         % number of samples (IQ)
fc = 0.25e6;        % central frequency of MF station
bwSERV = 100e3;     % bandwidth of an FM service (bandwidth ~= sampling frequency!)
bwAUDIO = 20e3;     % bandwidth of an FM audio (bandwidth == 1/2 * sampling frequency!)
s = load('stereo_samples_fs1000kHz_LR_IQ.mat');
wideband_signal = s.I+s.Q;clear s;
%s = s-127;

% IQ --> complex

figure(1);
psd(spectrum.welch('Hamming',1024), wideband_signal(1:N),'Fs',fs);

% Extract carrier of selected service, then shift in frequency the selected service to the baseband
wideband_signal_shifted = wideband_signal .* exp(-sqrt(-1)*2*pi*fc/fs*[0:N-1]');

% % Filter out the service from the wide-band signal
[b,a] = butter(4, bwSERV/fs);

wideband_signal_filtered = filter( b, a, wideband_signal_shifted );

% Down-sample to service bandwidth - bwSERV = new sampling rate
x = wideband_signal_filtered( 1:fs/(bwSERV*2):end );

% FM demodulation
dx = x(2:end).*conj(x(1:end-1));
y = atan2( imag(dx), real(dx) );
figure(5);
psd(spectrum.welch('Hamming',1024), y,'Fs',(bwSERV*2));


% PILOT
Wn_pilot = [(18.95e3*2)/(bwSERV*2) (19.05e3*2)/(bwSERV*2)];
b_pilot = fir1(128, Wn_pilot, blackmanharris(128+1));
a_pilot = 1;
figure(6);
freqz(b_pilot, a_pilot, 512, bwSERV*2);
y_pilot = filter( b_pilot, a_pilot, y );
figure(7)
spectrogram(y_pilot, 4096, 4096-512, [18e3:1:20e3], bwSERV*2);
figure(8);
%psd(spectrum.welch('Hamming',1024), y_pilot,'Fs',bwSERV);
pwelch(y_pilot, 4096, 4096-512, [18e3:1:20e3], bwSERV*2);

%% Decimate to audio signal bandwidth bwAUDIO
% SUM
Wn_down = (15e3*2)/(bwSERV*2);
b_down = fir1(128, Wn_down, blackmanharris(128+1));
a_down = 1;
figure(9);
freqz(b_down, a_down, 512, (bwSERV*2));
y_audio_sum = filter( b_down, a_down, y ); % antyaliasing filter
figure(10);
psd(spectrum.welch('Hamming',1024), y_audio_sum,'Fs',bwAUDIO);
ym = y_audio_sum(1:5:end);

% DIFFERENCE
Wn_dif = [(23e3*2)/(bwSERV*2) (53e3*2)/(bwSERV*2)];
b_dif = fir1(128, Wn_dif, blackmanharris(128+1));
a_dif = 1;
figure(11);
freqz(b_dif, a_dif, 512, (bwSERV*2));
y_audio_dif = filter( b_dif, a_dif, y );

Wn_down_dif = (15e3*2)/(bwSERV*2);
b_down_dif = fir1(128, Wn_down_dif, blackmanharris(128+1));
a_down_dif = 1;
figure(14);
freqz(b_down_dif, a_down_dif, 512, (bwSERV*2));
y_audio_dif = filter( b_down_dif, a_down_dif, y_audio_dif ); % antyaliasing filter
figure(15);
psd(spectrum.welch('Hamming',1024), y_audio_dif,'Fs',bwAUDIO);
ys = y_audio_dif(1:5:end);

%% Listen to the final result
ym = ym-mean(ym);
ym = ym/(1.001*max(abs(ym)));
ys = ys/(1.001*max(abs(ys)));
yl = 0.5*(ym(1:end-13,1)+ys(14:end,1));
yr = 0.5*(ym(1:end-13,1)-ys(14:end,1));
yl = yl/(1.001*max(abs(yl)));
yr = yr/(1.001*max(abs(yr)));
soundsc(yr, bwAUDIO*2);