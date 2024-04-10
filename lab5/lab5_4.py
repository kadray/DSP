import numpy as np
from scipy.signal import ellip, zpk2tf, freqs, cheby1
import matplotlib.pyplot as plt

# Ustawienia początkowe
points = 4096
N = 4  
band_width=75 #dla +- 100 kHz
band_center = 96
mid_freq = 2 * np.pi * 1e6 * band_center  # Przeliczenie na radiany/s

tollerance = 2 * np.pi * 1e3 * band_width  # Przeliczenie na radiany/s

# Zakres częstotliwości
w = np.linspace(mid_freq - 2 * tollerance, mid_freq + 2 * tollerance, points)

# Projektowanie filtra
ze, pe, ke = ellip(N, 3, 40, [mid_freq - tollerance, mid_freq + tollerance], btype='bandpass', analog=True, output='zpk')

# Konwersja zpk na transfer function (tf)
be, ae = zpk2tf(ze, pe, ke)

# Obliczenie odpowiedzi częstotliwościowej
he = freqs(be, ae, w)


plt.plot(w / (2 * np.pi * 1e6), 20 * np.log10(np.abs(he[1])),)
plt.plot([95, 97], [-40 ,-40])
plt.axis([band_center - 2 * band_width / 1e3, band_center + 2 * band_width / 1e3, -45, 5])
plt.grid(True)
plt.title("Odpowiedź częstotliwościowa")
plt.xlabel("Częstotliwość (MHz)")
plt.ylabel("Odpowiedź (dB)")
plt.show()