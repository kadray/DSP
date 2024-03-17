import numpy as np
import matplotlib.pyplot as plt

def fft_real(x):
    N = len(x)
    # Transformata Fouriera sygnału rzeczywistego
    X = np.fft.fft(x)
    # Zerowanie urojonych części
    X_real = X.real
    X_imag = X.imag
    X_imag[0] = 0
    X_imag[N//2] = 0
    return X_real, X_imag

def fft_complex(x):
    # Transformata Fouriera sygnału zespolonego
    return np.fft.fft(x)

# Generowanie losowych danych
N = 1024
x = np.random.normal(size=N)

# Transformaty Fouriera
X_real, X_imag = fft_real(x)
X_complex = fft_complex(x)

# Porównanie wyników
plt.figure(figsize=(10, 5))
plt.subplot(1, 2, 1)
plt.plot(X_complex.real, label='Re{X_complex}')
plt.plot(X_complex.imag, label='Im{X_complex}')
plt.title('Complex FFT')
plt.legend()

plt.subplot(1, 2, 2)
plt.plot(X_real, label='Re{X_real}')
plt.plot(X_imag, label='Im{X_real}')
plt.title('Real FFT')
plt.legend()

plt.show()