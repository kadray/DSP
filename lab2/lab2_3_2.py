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

# Generowanie macierzy A
N = 100
A = np.zeros((N, N))
for k in range(N):
    s = np.sqrt(1/N) if k == 0 else np.sqrt(2/N)
    for n in range(N):
        A[k, n] = s * np.cos(np.pi * k / N * (n + 0.5))
S=A.T

fig, axs = plt.subplots(2, 1, figsize=(10, 8))  
# Wyświetlanie macierzy A i S
for i in range(N):

    print("Wiersz",i+1,"macierzy A:\n", A[i])
    print("Kolumna",i+1,"macierzy S:\n", S[:,i])
    axs[0].plot(A[i], label=f'Wiersz {i+1}', color='blue')
    axs[1].plot(S[:, i], label=f'Kolumna {i+1}', color='orange')
    plt.waitforbuttonpress()

