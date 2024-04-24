% odbiornik FM: P. Swiatkiewicz, T. Twardowski, T. Zielinski, J. Bułat

clear all; close all;
%%
fs = 3.2e6;         % sampling frequency
N  = 32e6;         % number of samples (IQ)
fc = 0.40e6;        % central frequency of MF station
bwSERV = 80e3;     % bandwidth of an FM service (bandwidth ~= sampling frequency!)
bwAUDIO = 16e3;     % bandwidth of an FM audio (bandwidth == 1/2 * sampling frequency!)
f = fopen('samples_100MHz_fs3200kHz.raw');
s = fread(f, 2*N, 'uint8');
fclose(f);



%% IQ --> complex
wideband_signal = s(1:2:end) + sqrt(-1)*s(2:2:end); clear s;

%% Extract carrier of selected service, then shift in frequency the selected service to the baseband
wideband_signal_shifted = wideband_signal .* exp(-1i*2*pi*fc/fs*[0:N-1]');

%% Filter out the service from the wide-band signal

Astop = 40; % t�umienie w pa�mie zaporowym 
Fstop = 80e3 + 2000; % od tego moemntu t�umie
Fpass = 80e3; %przepuszaczna mx czestotliwo��
Apass = 3;

LowPassSpec = fdesign.lowpass(Fpass, Fstop, Apass, Astop,3.2e6);
LowPassFilter1 = design(LowPassSpec,'ellip');

[b, a] = tf(LowPassFilter1);
wideband_signal_filtered = filter( b, a, wideband_signal_shifted );

%% Down-sample to service bandwidth - bwSERV = new sampling rate
x = decimate(wideband_signal_filtered,20);
fs = fs/20;
%% FM demodulation
dx = x(2:end).*conj(x(1:end-1));
y = atan2( imag(dx), real(dx) );
%% Display FM signal
figure(1);
psd(spectrum.welch('Hamming',1024), y,'Fs',fs);
title('G�sto�c widmowa mocy ca�ego sygna�u FM');

%% Decimate to audio signal bandwidth bwAUDIO
% filtr sk�adowej mono 30Hz - 15kHz
N=128;
b = fir1(N,[30/80e3 15e3/80e3],blackmanharris(N+1));

y_audio =  filtfilt(b,1,y);
ym = decimate(y_audio,5); 

%% 1. ODZYSKAJ PILOT
N=101;
Wn_1=[(18.990e3)/80e3 (19.010e3)/80e3];
b = fir1(N, Wn_1);
y_pik =  filtfilt(b,1,y);
%19,0625 kHz
figure(3);
psd(spectrum.welch('Hamming',1024), y_pik,'Fs',fs);
title('Pilot');

%% 2. ZAPROJEKTUJ FIR BP - Filtr Stereo
fpl = 19062.5; % peak
Wn_2 = [(fpl)/80e3 (3*fpl)/80e3];
b = fir1(N,Wn_2,blackmanharris(N+1));
[h,f] = freqz(b,1,0.1:0.5:80e3,80e3);
figure(4);
plot(2*f,20*log(abs(h)),'r-')
xlim([0, 60e3])
xline(19e3, '--r');
xline(57e3, '--r');
yline(-40, '--g');
title('Filtr stereo fpl - 3fpl');

%% Odfiltrowanie stereo z sygnału
%% Filtrowanie BP sygnału y
y_stereo = filtfilt(b,1,y); 
figure(5);
psd(spectrum.welch('Hamming',1024), y_stereo,'Fs',fs);
title('Odfiltrowany sygnał stereo od 19 kHz do 57 kHz');

%% 3. Przesuniecie stereo
N = 1600000;
c = cos(2*pi*(fpl/bwSERV)*[0:N-2]'); %% tak jak w instrukcji - zamiast e^ jest cosinus
y_stereo = y_stereo.*c;
figure(6);
psd(spectrum.welch('Hamming',1024), y_stereo,'Fs',fs);
title('Przesunięcie do 0 Hz cos 2fpl');

%% 4. Filtrowanie do 30kHz
N = 101;
b = fir1(N,[30/80e3 28e3/80e3],blackmanharris(N+1));
[h,f] = freqz(b,1,0.1:0.5:80e3,80e3);

y_stereo_filtered  = filtfilt(b,1,y_stereo);
%y_stereo_filtered = decimate(y_stereo_filtered,5);
y_stereo_filtered = resample(y_stereo_filtered,16,80);

%% widmo odfiltrowanego stereo do 30khz
figure(7)
psd(spectrum.welch('Hamming',1024), y_stereo_filtered,'Fs',fs/5);
title('Resampled Stereo');

%% yl and yr
ym = ym-mean(ym);
ym = ym/(1.001*max(abs(ym)));


y_stereo_filtered = y_stereo_filtered-mean(y_stereo_filtered);
y_stereo_filtered = y_stereo_filtered./(1.001*max(abs(y_stereo_filtered)));
yl = 0.5*(ym+y_stereo_filtered);
yr = 0.5*(ym-y_stereo_filtered);

ys = [yl yr];
%% Listen stereo to the final result 
%soundsc( ys, bwAUDIO*2);
%% Listen mono to the final result 
soundsc(ym,bwAUDIO*2)