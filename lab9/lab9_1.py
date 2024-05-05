import numpy as np
import matplotlib.pyplot as plt
# Parametry sygnału
fs = 8000  # Częstotliwość próbkowania [Hz]
t = 1  # Czas trwania [s]

# Częstotliwości i amplitudy harmonicznych
f1 = 34.2  # Częstotliwość pierwszej harmonicznej [Hz]
A1 = -0.5  # Amplituda pierwszej harmonicznej
f2 = 115.5  # Częstotliwość drugiej harmonicznej [Hz]
A2 = 1  # Amplituda drugiej harmonicznej

# Tworzenie osi czasu
timestep = 1 / fs  # Krok czasowy
time = np.arange(0, t, timestep)  # Oś czasu

# Generowanie sygnałów harmonicznych
harmonic1 = A1 * np.sin(2 * np.pi * f1 * time)
harmonic2 = A2 * np.sin(2 * np.pi * f2 * time)
dref = harmonic1 + harmonic2                                              # sygnał ”czysty” do porównania

target_snr_db = 20
t = np.linspace(1, 100, 1000)
x_volts = 10*np.sin(t/(2*np.pi))
x_watts = x_volts ** 2
sig_avg_watts = np.mean(x_watts)
sig_avg_db = 10 * np.log10(sig_avg_watts)
noise_avg_db = sig_avg_db - target_snr_db
noise_avg_watts = 10 ** (noise_avg_db / 10)

d = np.random.normal(dref, np.sqrt(noise_avg_watts)) # WE: sygnał  odniesienia dla sygnału x
x = np.append(d[0], d[:-1])                             #  WE: sygnał filtrowany, teraz opóźniony d
M = ???                                                 # długość filtru
mi = ???                                                #  współczynnik szybkości adaptacji

# sygnały wyjściowe z filtra
y = []
e = []
bx = np.zeros(M,1)                                      # bufor na próbki wejściowe x
h = np.zeros(M,1)                                       # początkowe (puste) wagi filtru

for n in range(1,x.length):
    bx[0] = np.insert(bx[:-1], [0], x[n])               # pobierz nową próbkę x[n] do bufora
    y[n] = h.transpose() * bx                           # oblicz y[n] = sum( x .* bx) – filtr FIR
    e[n] = d[n] - y[n]                                  # oblicz e[n]
    h = h + mi * e[n] * bx                              # LMS
    # h = h + mi * e[n] * bx /(bx.transpose() * bx)     # NLMS

print(len(time))

plt.plot(time, d)
plt.show()