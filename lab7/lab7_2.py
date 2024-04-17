import numpy as np
import scipy
from scipy.signal import firwin, freqz, lfilter
import matplotlib.pyplot as plt

# Parametry filtru FIR 1
nyquist_rate = 48000  # Próbkowanie 48 kHz, więc Nyquist to 24 kHz
cutoff_freq = 18300.0  # Górna częstotliwość w Hz
num_taps = 101  # Długość odpowiedzi impulsowej filtra FIR

# Projektowanie filtru FIR 1
nyquist_cutoff = cutoff_freq / (0.5 * nyquist_rate)
taps_fir1 = firwin(num_taps, nyquist_cutoff, window='hamming', pass_zero=True)

# Parametry filtru FIR 2
fs = 48000  # Częstotliwość próbkowania
f_pilot = 19000  # Częstotliwość sygnału pilota
f_bandwidth = 1000  # Szerokość pasma filtru (1 kHz)
taps_fir2 = 101  # Długość odpowiedzi impulsowej (nieparzysta dla zachowania symetrii)

# Projektowanie filtru FIR 2
nyquist = 0.5 * fs
cutoff = f_pilot / nyquist
width = f_bandwidth / nyquist
coefficients_fir2 = firwin(taps_fir2, [cutoff - 0.5 * width, cutoff + 0.5 * width], pass_zero=False)

# Korekcja opóźnienia dla filtru FIR 2
delay_fir2 = (taps_fir2 - 1) / (2 * fs)  # Opóźnienie grupowe w sekundach

# Generowanie zróżnicowanego sygnału sinusoidalnego
t = np.linspace(0, 1, fs, endpoint=False)  # Wektor czasu

# Dodatkowe składowe sygnału
frequencies = np.linspace(30, 25000, 50)  # 10 częstotliwości od 30 Hz do 25000 Hz
additional_components = [np.sin(2 * np.pi * f * t) for f in frequencies]

# Sygnał zawierający dodatkowe składowe
signal = np.sum(additional_components, axis=0)

# Filtracja sygnału przez oba filtry
filtered_signal_fir1 = lfilter(taps_fir1, 1, signal)
filtered_signal_fir2 = lfilter(coefficients_fir2, 1, signal)

# Wykres odpowiedzi częstotliwościowej filtrów FIR
w1, h1 = freqz(taps_fir1, worN=8000)
w2, h2 = freqz(coefficients_fir2, worN=8000)
freq_fir1 = (nyquist_rate * 0.5 / np.pi) * w1
freq_fir2 = (fs * 0.5 / np.pi) * w2

# Plotowanie sygnału i wyników filtracji
plt.figure(figsize=(12, 10))

plt.subplot(3, 2, 1)
plt.plot(t, signal, 'b')
plt.title('Zróżnicowany sygnał wejściowy')
plt.xlabel('Czas [s]')
plt.ylabel('Amplituda')

plt.subplot(3, 2, 2)
plt.magnitude_spectrum(signal, Fs=nyquist_rate, color='blue')
plt.title('Spektrum sygnału wejściowego')

plt.subplot(3, 2, 3)
plt.plot(t, filtered_signal_fir1, 'r')
plt.title('Sygnał po filtracji FIR 1')
plt.xlabel('Czas [s]')
plt.ylabel('Amplituda')

plt.subplot(3, 2, 4)
plt.magnitude_spectrum(filtered_signal_fir1, Fs=nyquist_rate, color='red')
plt.title('Spektrum sygnału po filtracji FIR 1')

plt.subplot(3, 2, 5)
plt.plot(t, filtered_signal_fir2, 'g')
plt.title('Sygnał po filtracji FIR 2')
plt.xlabel('Czas [s]')
plt.ylabel('Amplituda')

plt.subplot(3, 2, 6)
plt.magnitude_spectrum(filtered_signal_fir2, Fs=fs, color='green')
plt.title('Spektrum sygnału po filtracji FIR 2')

plt.tight_layout()

# Plotowanie charakterystyk częstotliwościowych filtrów FIR
plt.figure(figsize=(12, 6))

plt.plot(0.5 * nyquist_rate * w1 / np.pi, 20 * np.log10(np.abs(h1)), 'b', label='FIR 1')
plt.plot(freq_fir1, 20 * np.log10(np.abs(h1)), 'b--')
plt.plot(freq_fir2, 20 * np.log10(np.abs(h2)), 'r', label='FIR 2')
plt.plot([19000, 19000], [-60, 10], 'ko--', label='Pilotażowa częstotliwość 19000 Hz')
plt.ylim(-60, 10)
plt.title("Charakterystyka częstotliwościowa filtrów FIR")
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Amplituda [dB]')
plt.legend()
plt.grid()
plt.show()
