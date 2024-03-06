import numpy as np
import matplotlib.pyplot as plt

# Częstotliwości i amplitudy sinusoid
frequencies = [50, 100, 150]  # Hz
#frequencies = [50, 105, 150] 
#frequencies = [52.5, 107.5, 152.5] 
amplitudes = [50, 100, 150]    # Amplitudy

# Częstotliwość próbkowania (ilość próbek na sekundę)
fs = 1000  # Hz
t = np.arange(0, 1, 1/fs)  # Tworzymy wektor czasu od 0 do 1 sekundy z częstotliwością próbkowania fs

# Inicjalizacja sygnału
x = np.zeros_like(t)

# Generowanie sygnału jako suma sinusoid
for freq, amp in zip(frequencies, amplitudes):
    x += amp * np.sin(2 * np.pi * freq * t)


# Generowanie macierzy A
N = 100
A = np.zeros((N, N))
for k in range(N):
    s = np.sqrt(1/N) if k == 0 else np.sqrt(2/N)
    for n in range(N):
        A[k, n] = s * np.cos(np.pi * k / N * (n + 0.5))
S=A.T

x_samples = x[np.arange(0, len(x), len(x)//N)[:N]]
t_samples= np.arange(N)/fs
y=np.dot(A, x_samples)
x_synth=np.dot(S,y)
f=np.arange(N) * fs/N

fig, axs = plt.subplots(3, 2)

axs[0, 0].plot(t_samples, x_synth)
axs[0, 0].set_title("Oryginalny sygnał x")
axs[0, 0].set_xlabel('Czas [s]')
axs[0, 0].set_ylabel('Amplituda')
axs[0, 0].grid(True)

axs[0, 1].stem(f, np.abs(np.fft.fft(x_samples)))
axs[0, 1].set_title("Oryginalny Sygnał x w dziedzinie częstotliwości")
axs[0, 1].set_xlabel('Częstotliwość [Hz]')
axs[0, 1].set_ylabel('Amplituda')
axs[0, 1].grid(True)

axs[1, 0].plot(t_samples, y)
axs[1, 0].set_title('Sygnał zanalizowany')
axs[1, 0].set_xlabel('Czas [s]')
axs[1, 0].set_ylabel('Amplituda')
axs[1, 0].grid(True)

axs[1, 1].stem(f, np.abs(np.fft.fft(y)))
axs[1, 1].set_title("Zanalizowany sygnał x w dziedzinie częstotliwości")
axs[1, 1].set_xlabel('Częstotliwość [Hz]')
axs[1, 1].set_ylabel('Amplituda')
axs[1, 1].grid(True)

axs[2, 0].plot(t_samples, x_synth)
axs[2, 0].set_title('Sygnał odtworzony')
axs[2, 0].set_xlabel('Czas [s]')
axs[2, 0].set_ylabel('Amplituda')
axs[2, 0].grid(True)

axs[2, 1].stem(f, np.abs(np.fft.fft(x_synth)))
axs[2, 1].set_title("Odtworzony sygnał x w dziedzinie częstotliwości")
axs[2, 1].set_xlabel('Częstotliwość [Hz]')
axs[2, 1].set_ylabel('Amplituda')
axs[2, 1].grid(True)
plt.show()
if np.allclose(x_samples, x_synth):
    print("Idealna rekonstrukcja sygnału")
else:
    print("Nieidealna rekonstrukcja sygnału")