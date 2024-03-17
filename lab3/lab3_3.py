import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import windows
from scipy.fft import fft
def dtft(signal, frequency_range, fs):
    N = len(signal)
    n = np.arange(N)
    k = np.arange(len(frequency_range))
    frequencies = frequency_range / fs

    dtft_result = np.zeros(len(frequency_range), dtype=complex)

    for kk in k:
        dtft_result[kk] = np.sum(signal * np.exp(-2j * np.pi * frequencies[kk] * n))

    return dtft_result
# Parametry sygnału
A1 = 1
f1 = 100  
phi1 = np.pi / 7
A2 = 0.0001
f2 = 125
phi2 = np.pi / 11
fs = 1000  # częstotliwość próbkowania
N = 100    # liczba próbek
#N=1000

# Tworzenie wektora czasu
t = np.arange(N) / fs

# Tworzenie sygnału x(t)
x_t = A1 * np.cos(2 * np.pi * f1 * t + phi1) + A2 * np.cos(2 * np.pi * f2 * t + phi2)
freq_range=np.arange(0, 500, 0.1)
X = dtft(x_t, freq_range, fs)

# Okna
N = len(X)
rect_window = windows.boxcar(N)
hamming_win = windows.hamming(N)
blackman_win = windows.blackman(N)
chebyshev_100dB_win = windows.chebwin(N, at=100)
chebyshev_120dB_win = windows.chebwin(N, at=120)

# Mnożenie przez okna
X_rect = X * rect_window
X_hamming = X * hamming_win
X_blackman = X * blackman_win
X_chebyshev_100dB = X * chebyshev_100dB_win
X_chebyshev_120dB = X * chebyshev_120dB_win

# Wykresy
omega = freq_range
plt.figure(figsize=(12, 8))
plt.subplot(3, 2, 1)
plt.plot(omega, np.abs(X_rect))
plt.title('Rectangular Window')
plt.subplot(3, 2, 2)
plt.plot(omega, np.abs(X_hamming))
plt.title('Hamming Window')
plt.subplot(3, 2, 3)
plt.plot(omega, np.abs(X_blackman))
plt.title('Blackman Window')
plt.subplot(3, 2, 4)
plt.plot(omega, np.abs(X_chebyshev_100dB))
plt.title('Chebyshev Window (100 dB)')
plt.subplot(3, 2, 5)
plt.plot(omega, np.abs(X_chebyshev_120dB))
plt.title('Chebyshev Window (120 dB)')
plt.tight_layout()
plt.show()