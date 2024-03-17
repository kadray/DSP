import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat

# Wczytanie danych
data = loadmat('lab_03.mat')
x = data['x_9'].flatten()

index = 407676
modulo = (index % 16) + 1

ramki = 0
kor = []

for i in range(0, 4353 - 511 - 31 + 1):  # Poprawka: zmiana od 0
    prefix = x[i:i+31]
    dane = x[i+511:i+543]  # Poprawka: zmiana od 511 do 543
    kor.append(np.max(np.abs(np.correlate(prefix, dane, mode='full') / np.sqrt(np.sum(prefix ** 2) * np.sum(dane ** 2)))))
    if kor[-1] >= 0.99:
        ramki += 1

        if ramki == 1:
            r = np.zeros((ramki, 512))
            r[ramki-1,:] = x[i:i+512]  # Poprawka: zmiana od 511 do 512
        else:
            r = np.vstack((r, x[i:i+512]))  # Poprawka: zmiana od 511 do 512

plt.figure(2)
t = np.arange(len(kor))
plt.plot(t, kor)
plt.grid(True)

for i in range(ramki):
    X = np.fft.fft(r[i, :], 512)
    plt.figure(3)
    plt.plot(np.arange(1, 513), 20 * np.log10(np.abs(X)))
    plt.pause(0.01)

for i in range(ramki):
    plt.figure(4)
    plt.stem(np.arange(1, 513), r[i, :])
    plt.pause(0.1)

plt.show()