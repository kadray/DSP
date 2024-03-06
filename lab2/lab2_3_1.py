import numpy as np
import matplotlib.pyplot as plt

# Częstotliwości i amplitudy sinusoid
frequencies = [50, 100, 150]  # Hz
amplitudes = [50, 100, 150]    # Amplitudy

# Częstotliwość próbkowania (ilość próbek na sekundę)
fs = 1000  # Hz
t = np.arange(0, 1, 1/fs)  # Tworzymy wektor czasu od 0 do 1 sekundy z częstotliwością próbkowania fs

# Inicjalizacja sygnału
x = np.zeros_like(t)

# Generowanie sygnału jako suma sinusoid
for freq, amp in zip(frequencies, amplitudes):
    x += amp * np.sin(2 * np.pi * freq * t)

# Wykres sygnału

plt.plot(t, x)
plt.xlabel('Czas [s]')
plt.ylabel('Amplituda')
plt.grid(True)
plt.show()
