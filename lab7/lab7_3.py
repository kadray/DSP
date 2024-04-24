import numpy as np
import scipy.signal as signal
import sounddevice as sd
import soundfile as sf
import scipy.io as sio

# Parametry sygnału
fs = 1e6         # Częstotliwość próbkowania
N = 2.699993e6   # Liczba próbek (IQ)
fc = 0.25e6      # Częstotliwość nośna stacji MF
bwSERV = 100e3   # Szerokość pasma usługi FM
bwAUDIO = 20e3   # Szerokość pasma dźwięku FM

# Wczytanie danych z pliku .mat
data = sio.loadmat('stereo_samples_fs1000kHz_LR_IQ.mat')
I = data['I'].flatten()  # Dane I
Q = data['Q'].flatten()  # Dane Q

# Złożenie sygnału IQ do postaci zespolonej
wideband_signal = I + 1j * Q

# Wyświetl widmo sygnału
import matplotlib.pyplot as plt
plt.psd(wideband_signal, NFFT=1024, Fs=fs)
plt.title('Wideband Signal Spectrum')
plt.show()

# Przesunięcie sygnału szerokopasmowego na częstotliwość bazową
wideband_signal_shifted = wideband_signal * np.exp(-1j * 2 * np.pi * fc / fs * np.arange(N))

# Filtrowanie sygnału
b, a = signal.butter(4, bwSERV / fs)
wideband_signal_filtered = signal.lfilter(b, a, wideband_signal_shifted)

# Próbkowanie do szerokości pasma usługi
x = wideband_signal_filtered[::int(fs / (2 * bwSERV))]

# Demodulacja FM
dx = x[1:] * np.conj(x[:-1])
y = np.angle(dx)

# Wyświetl widmo sygnału po demodulacji
plt.psd(y, NFFT=1024, Fs=2 * bwSERV)
plt.title('Demodulated Signal Spectrum')
plt.show()

# Pilot
Wn_pilot = [(18.95e3 * 2) / (bwSERV * 2), (19.05e3 * 2) / (bwSERV * 2)]
b_pilot = signal.firwin(128, Wn_pilot, window='blackmanharris')
y_pilot = signal.lfilter(b_pilot, 1, y)

# Wyświetl spektrogram pilota
plt.specgram(y_pilot, NFFT=4096, Fs=2 * bwSERV, noverlap=4096 - 512, Fc=18e3)
plt.title('Pilot Spectrogram')
plt.show()

# Dekymatacja do pasma dźwiękowego
Wn_down = (15e3 * 2) / (bwSERV * 2)
b_down = signal.firwin(128, Wn_down, window='blackmanharris')
y_audio_sum = signal.lfilter(b_down, 1, y)

# Wyświetl widmo sygnału dźwiękowego
plt.psd(y_audio_sum, NFFT=1024, Fs=bwAUDIO)
plt.title('Audio Signal Spectrum')
plt.show()

# Przygotowanie sygnałów lewego i prawego kanału
ym = y_audio_sum[::5]
ys = signal.lfilter(b_down, 1, signal.lfilter(signal.firwin(128, [23e3 * 2 / (bwSERV * 2), 53e3 * 2 / (bwSERV * 2)], window='blackmanharris'), 1, y))[::5]
yl = (ym[:-13] + ys[13:]) / 2
yr = (ym[:-13] - ys[13:]) / 2

# Odtwarzanie sygnału
yl = (yl - np.mean(yl)) / (1.001 * np.max(np.abs(yl)))
yr = (yr - np.mean(yr)) / (1.001 * np.max(np.abs(yr)))
yl = yl.astype(np.float32)
yr = yr.astype(np.float32)

# Odtwarzanie dźwięku
# sd.play(np.column_stack((yl, yr)), bwAUDIO * 2)
# sd.wait()
