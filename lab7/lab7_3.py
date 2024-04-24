import numpy as np
import scipy.signal as signal
import matplotlib.pyplot as plt

# Parametry
fs = 3.2e6        # częstotliwość próbkowania
N = 32e6          # liczba próbek (IQ)
fc = 0.40e6       # częstotliwość centralna stacji MF
bwSERV = 80e3     # szerokość pasma usługi FM
bwAUDIO = 16e3    # szerokość pasma audio FM

# Wczytanie danych
with open('samples_100MHz_fs3200kHz.raw', 'rb') as f:
    data = np.fromfile(f, dtype=np.uint8)

# IQ --> zespolony
wideband_signal = data[::2] + 1j * data[1::2]

# Przesunięcie do częstotliwości bazowej
wideband_signal_shifted = wideband_signal * np.exp(-1j * 2 * np.pi * fc / fs * np.arange(N))

# Filtrowanie
Fstop = 80e3 + 2000  # od tego momentu tłumie
Fpass = 80e3          # przepuszczalna częstotliwość
Astop = 40            # tłumienie w paśmie zaporowym
Apass = 3             # maksymalne tłumienie w paśmie przepustowym

b, a = signal.ellip(3, Apass, Astop, Fpass / (fs / 2), 'low')
wideband_signal_filtered = signal.filtfilt(b, a, wideband_signal_shifted)

# Dekymowanie do pasma usługi
x = signal.decimate(wideband_signal_filtered, 20)
fs = fs / 20

# Demodulacja FM
dx = x[1:] * np.conj(x[:-1])
y = np.arctan2(np.imag(dx), np.real(dx))

# Filtrowanie audio
b = signal.firwin(128, [30 / (bwSERV / 2), 15e3 / (bwSERV / 2)], pass_zero=False)
y_audio = signal.filtfilt(b, 1, y)

# Odtwarzanie mono
ym = signal.decimate(y_audio, 5)

# Odtwarzanie stereo
b = signal.firwin(128, [18.990e3 / (bwSERV / 2), 19.010e3 / (bwSERV / 2)], pass_zero=False)
y_stereo = signal.filtfilt(b, 1, y)

# Przesunięcie stereo
N = 1600000
c = np.cos(2 * np.pi * (19.062e3 / bwSERV) * np.arange(N - 1))
y_stereo = y_stereo * c

# Filtrowanie do 30kHz
b = signal.firwin(128, [30 / (bwSERV / 2), 28e3 / (bwSERV / 2)], pass_zero=False)
y_stereo_filtered = signal.filtfilt(b, 1, y_stereo)
y_stereo_filtered = signal.resample(y_stereo_filtered, int(len(y_stereo_filtered) * 16 / fs), axis=0)

# Mono i stereo
ym = (ym - np.mean(ym)) / (1.001 * np.max(np.abs(ym)))
y_stereo_filtered = (y_stereo_filtered - np.mean(y_stereo_filtered)) / (1.001 * np.max(np.abs(y_stereo_filtered)))
ym = np.interp(np.linspace(0, len(ym), len(y_stereo_filtered)), np.arange(len(ym)), ym)
yl = 0.5 * (ym + y_stereo_filtered)
yr = 0.5 * (ym - y_stereo_filtered)
y_kek = np.column_stack((yl, yr))

# Plot 1: Gęstość widmowa mocy całego sygnału FM
plt.figure()
plt.psd(y, Fs=fs, NFFT=1024, window=signal.hamming)
plt.title('Gęstość widmowa mocy całego sygnału FM')

# Plot 2: Odfiltrowanie 30 Hz do 16 kHz
plt.figure()
plt.psd(y_audio, Fs=fs, NFFT=1024, window=signal.hamming)
plt.title('Odfiltrowanie 30 Hz do 16 kHz')

# Plot 3: Pilot
plt.figure()
plt.psd(y_stereo, Fs=fs, NFFT=1024, window=signal.hamming)
plt.title('Pilot')

# Plot 4: Filtr stereo fpl - 3fpl
fpl = 19062  # częstotliwość piku
b = signal.firwin(128, [fpl / (bwSERV / 2), 3 * fpl / (bwSERV / 2)], pass_zero=False)
f, h = signal.freqz(b, 1, 0.1 * np.pi * np.arange(80000) / 80000 * bwSERV)
plt.figure()
plt.plot(2 * f * (fs / (2 * np.pi)), 20 * np.log10(np.abs(h)))
plt.xlim([0, 60e3])
plt.title('Filtr stereo fpl - 3fpl')

# Plot 5: Odfiltrowany sygnał stereo od 23 kHz do 53 kHz
plt.figure()
plt.psd(y_stereo, Fs=fs, NFFT=1024, window=signal.hamming)
plt.title('Odfiltrowany sygnał stereo od 23 kHz do 53 kHz')

# Plot 6: Przesunięcie do 0 Hz cos 2fpl
plt.figure()
plt.psd(y_stereo, Fs=fs, NFFT=1024, window=signal.hamming)
plt.title('Przesunięcie do 0 Hz cos 2fpl')

# Plot 7: Resampled Stereo
plt.figure()
plt.psd(y_stereo_filtered, Fs=fs / 5, NFFT=1024, window=signal.hamming)
plt.title('Resampled Stereo')

plt.show()
