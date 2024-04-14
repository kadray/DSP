import numpy as np
import scipy
from scipy.signal import firwin, freqz, lfilter
import matplotlib.pyplot as plt
# Parametry filtru
nyquist_rate = 48000  # Próbkowanie 48 kHz, więc Nyquist to 24 kHz
cutoff_freq = 19000.0  # Górna częstotliwość w Hz
num_taps = 101  # Długość odpowiedzi impulsowej filtra FIR
# Projektowanie filtru FIR
nyquist_cutoff = cutoff_freq / (0.5 * nyquist_rate)
taps = firwin(num_taps, nyquist_cutoff, window='hamming', pass_zero=True)
# Wykres odpowiedzi częstotliwościowej
w1, h1 = freqz(taps, worN=8000)

#--------FILTR 2--------------
fs = 44100  # Częstotliwość próbkowania
f_pilot = 19000  # Częstotliwość sygnału pilota
f_bandwidth = 1000  # Szerokość pasma filtru (1 kHz)
taps = 101  # Długość odpowiedzi impulsowej (nieparzysta dla zachowania symetrii)
# Projektowanie filtru FIR
nyquist = 0.5 * fs
cutoff = f_pilot / nyquist
width = f_bandwidth / nyquist
taps = taps
# Tworzenie filtru FIR
coefficients = firwin(taps, [cutoff - 0.5*width, cutoff + 0.5*width], pass_zero=False)
# Korekcja opóźnienia
delay = (taps - 1) / (2 * fs)  # Opóźnienie grupowe w sekundach
# Obliczanie odpowiedzi impulsowej filtra FIR
w2, h2 = freqz(coefficients, worN=8000)
# Obliczanie częstotliwości w Hz
freq = (fs * 0.5 / np.pi) * w2
# Plotowanie charakterystyki częstotliwościowej filtra FIR
plt.figure(figsize=(10, 6))
plt.plot(0.5 * nyquist_rate * w1 / np.pi, 20 * np.log10(np.abs(h1)), 'b')
plt.plot(freq, 20 * np.log10(abs(h2)), 'r')
plt.title("Charakterystyka częstotliwościowa filtru FIR")
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Amplituda [dB]')
plt.grid()
plt.show()