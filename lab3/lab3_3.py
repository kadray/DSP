import numpy as np
import matplotlib.pyplot as plt
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

# Tworzenie wektora czasu
t = np.arange(N) / fs

# Tworzenie sygnału x(t)
x_t = A1 * np.cos(2 * np.pi * f1 * t + phi1) + A2 * np.cos(2 * np.pi * f2 * t + phi2)

frequency_range=np.arange(0, 500, 0.1)
X=dtft(x_t, frequency_range, fs)
plt.plot(frequency_range, X)
plt.show()

#nie widać drugiej składowej bo amplituda A2 jest za mała
