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
A1 = 100
f1 = 125  # Zmieniamy częstotliwość pierwszej składowej sygnału
phi1 = np.pi / 7
A2 = 200
f2 = 200
phi2 = np.pi / 11
fs = 1000  # częstotliwość próbkowania
N = 100    # liczba próbek

# Tworzenie wektora czasu
t = np.arange(N) / fs

# Tworzenie sygnału x(t)
x_t = A1 * np.cos(2 * np.pi * f1 * t + phi1) + A2 * np.cos(2 * np.pi * f2 * t + phi2)

# Dodanie zer na końcu sygnału
M = 100
xz = np.append(x_t, np.zeros(M))
# Obliczenie FFT sygnału z dodaniem zer
X2 = np.fft.fft(xz) / (N + M)

# Obliczenie DtFT
fx3 = np.arange(0, 1000, 0.25)
X3=dtft(x_t, fx3, fs)
# Wektor częstotliwości dla DFT
fx1 = fs * np.arange(N) / N
# Wektor częstotliwości dla FFT z dodaniem zer
fx2 = np.fft.fftfreq(len(xz), 1 / fs)


# Plotowanie widm
plt.figure(figsize=(10, 6))
plt.plot(fx1, np.abs(X2[:N]), 'o', label='$X_1$ (DFT)')
plt.plot(fx2, np.abs(X2), 'bx', label='$X_2$ (FFT z dodaniem zer)')
plt.plot(fx3, np.abs(X3), 'k-', label='$X_3$ (DtFT)')
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Amplituda')
plt.title('Porównanie widm $X_1$, $X_2$ i $X_3$')
plt.legend()
plt.grid()
plt.xlim(0, fs / 2)  # Ograniczenie widoczności do pasma Nyquista
plt.show()

