import numpy as np
import scipy.signal as signal
import matplotlib.pyplot as plt
from scipy.io import wavfile

fs = 3.2e6        # częstotliwość próbkowania
N = 32e6          # liczba próbek (IQ)
fc = 0.39e6       # częstotliwość centralna stacji MF
bwSERV = 80e3     # szerokość pasma usługi FM
bwAUDIO = 16e3    # szerokość pasma audio FM

# Odczytanie surowych próbek IQ
with open('samples_100MHz_fs3200kHz.raw', 'rb') as f:
    s = np.fromfile(f, dtype=np.uint8)

s = s - 127

# IQ do postaci zespolonej
wideband_signal = s[::2] + 1j * s[1::2]
# Przesunięcie do pasma podstawowego
wideband_signal_shifted = wideband_signal * np.exp(-1j * 2 * np.pi * fc / fs * np.arange(N))
# Filtracja stacji
b, a = signal.butter(4, bwSERV / fs)
wideband_signal_filtered = signal.lfilter(b, a, wideband_signal_shifted)

# Próbkowanie do szerokości pasma usługi
x = wideband_signal_filtered[::int(fs / (bwSERV * 2))]

# Demodulacja FM
dx = x[1:] * np.conj(x[:-1])
y = np.angle(dx)
# Filtracja antyaliasingowa i dekodowanie do szerokości pasma audio
Wn_down = (15e3 * 2) / (bwSERV * 2)
b_down = signal.firwin(129, Wn_down, nyq=bwSERV, window='blackmanharris')
y_audio = signal.lfilter(b_down, 1, y)

# Widmo mocy sygnału demodulowanego
frequencies, psd = signal.welch(y, fs=bwSERV*2, window='hamming', nperseg=1024)
plt.figure()
plt.plot(frequencies, np.log10(np.abs(psd)))
plt.title('Widmo mocy sygnału demodulowanego')
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Gęstość mocy')

fs = 48000 
# Filtr dolnoprzepustowy do 19 kHz
cutoff_1 = 18000.0  # Górna częstotliwość w Hz
num_taps = 101  # Długość odpowiedzi impulsowej filtra FIR
# Projektowanie filtru FIR 1
nyquist_cutoff = cutoff_1 / (0.5 * fs)
fir1 = signal.firwin(num_taps, nyquist_cutoff, window='hamming')

# Filtr pasmowoprzepustowy w obrębie 19 kHz

f_pilot = 19000  # Częstotliwość sygnału pilota
f_bandwidth = 1000  # Szerokość pasma filtru (1 kHz)
taps_fir2 = 101  # Długość odpowiedzi impulsowej (nieparzysta dla zachowania symetrii)

# Projektowanie filtru FIR 2
nyquist = 0.5 * fs
cutoff = f_pilot / nyquist
width = f_bandwidth / nyquist
fir2 = signal.firwin(taps_fir2, [cutoff - 0.5 * width, cutoff + 0.5 * width], pass_zero=False)

# Obliczenie odpowiedzi filtrów w dziedzinie częstotliwości
w_lowpass, h_lowpass = signal.freqz(fir1, worN=1599999)
w_bandpass, h_bandpass = signal.freqz(fir2, worN=1599999)
freq_fir1 = (fs * 0.5 / np.pi) * w_lowpass
freq_fir2 = (fs * 0.5 / np.pi) * w_bandpass
# Plot odpowiedzi filtrów w dziedzinie częstotliwości
plt.figure(figsize=(10, 6))

plt.plot(0.5 * fs * w_lowpass / np.pi, np.log10(np.abs(h_lowpass)), label='Filtr dolnoprzepustowy')
plt.title('Charakterystyka amplitudowa filtru dolnoprzepustowego')
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Wzmocnienie')
plt.legend()

plt.figure(figsize=(10, 6))
plt.plot(0.5 * fs * w_bandpass / np.pi, np.log10(np.abs(h_bandpass)), label='Filtr pasmowoprzepustowy')
plt.title('Charakterystyka amplitudowa filtru pasmowoprzepustowego')
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Wzmocnienie')
plt.legend()


# Filtracja sygnału przez oba filtry
filtered_signal_fir1 = signal.lfilter(fir1, 1, y)
filtered_signal_fir2 = signal.lfilter(fir2, 1, y)
plt.figure()
f, A1 = signal.welch(filtered_signal_fir1, fs=fs, window='hamming', nperseg=1024)
plt.plot(f, np.log10(np.abs(A1)))
plt.figure()
f, A2 = signal.welch(filtered_signal_fir2, fs=fs, window='hamming', nperseg=1024)
plt.plot(f, np.log10(np.abs(A2)))
plt.show()