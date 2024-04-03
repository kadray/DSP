import numpy as np
from scipy.signal import freqs, impulse, TransferFunction, step
import matplotlib.pyplot as plt

N_list = [2, 4, 6, 8]
w3dB = 2 * np.pi * 100
w = np.linspace(0, 2000, num=20001) * 2 * np.pi 
ang = np.zeros((4, len(w)))
Hdec = np.zeros((4, len(w)))
Hlin = np.zeros((4, len(w)))

for i, N in enumerate(N_list):
    p = np.pi/2 + (1/2) * np.pi/N + (np.arange(1, N+1)-1)*np.pi/N
    poles = w3dB * np.exp(1j * p)
    wzm = np.prod(-poles)
    a = np.poly(poles)
    b = [wzm]
    w, h = freqs(b, a, worN=w)
    
    ang[i, :] = np.angle(h)
    Hdec[i, :] = 20 * np.log10(np.abs(h))
    Hlin[i, :] = np.abs(h)


# A-cz liniowe
plt.figure()
for i in range(4):
    plt.plot(w / (2 * np.pi), Hlin[i, :], label=f"{N_list[i]}")
plt.legend()
plt.title("Charakterystyka A-cz liniowa")

# A-cz logartymiczne
plt.figure()
for i in range(4):
    plt.semilogx(w / (2 * np.pi), Hdec[i, :], label=f"{N_list[i]}")
plt.grid(True)
plt.legend()
plt.title("Charakterystyka A-cz logarytmiczna")

# Faza
plt.figure()
for i in range(4):
    plt.plot(w / (2 * np.pi), ang[i, :], label=f"{N_list[i]}")
plt.legend()
plt.title("Charakterystyka cz-f")

# Dla N=4
N = 4
p4 = w3dB * np.exp(1j * (np.pi/2 + 1/2 * np.pi/N + (np.arange(1, N+1)-1)*np.pi/N))

a = np.poly(p4)
b = [np.prod(-p4)]
H = TransferFunction(b, a)

t_imp, y = impulse(H)
plt.figure()
plt.plot(t_imp, y)
plt.title("Odpowiedź impulsowa")

t_step, y = step(H)
plt.figure()
plt.plot(t_step, y)
plt.title("Odpowiedź na skok jednostkowy")

plt.show()