import numpy as np
import matplotlib.pyplot as plt

# Zera i bieguny transmitancji
z = [-1j*5, 1j*5, -1j*15, 1j*15]
p = [-0.5-1j*9.5, -0.5+1j*9.5, -1+1j*10, -1-1j*10, -0.5+1j*10.5, -0.5-1j*10.5]
# Zespolona zmienna transformacji Laplace'a
# dla s=jw przechodzi w transformację Fouriera:
w = np.arange(0.1, 20, 0.1)

# Zapisz transmitancję (1) wykorzystując powyższe parametry.
bm = np.poly(z)
an = np.poly(p)

# Przedstaw zera i bieguny na płaszczyźnie zespolonej.
plt.figure('Zera i bieguny')
plt.plot(np.real(z), np.imag(z), 'ro', np.real(p), np.imag(p), 'b*')
plt.title('Zera i bieguny transmitancji')
plt.legend(['Zera transmitancji', 'Bieguny transmitancji'])
plt.xlabel('Re')
plt.ylabel('Img')
plt.grid()


# Charakterystyka amplitudowo-częstotliwościowa
H = np.polyval(bm, 1j*w) / np.polyval(an, 1j*w)
Hlog = 20 * np.log10(np.abs(H))

plt.figure('Charakterystyka A-cz')
plt.subplot(1, 2, 1)
plt.plot(w, np.abs(H), 'b')
plt.title('|H(jw)| - Skala liniowa')
plt.xlabel('w [rad/s]')
plt.ylabel('|H(jw)|')
plt.grid()

plt.subplot(1, 2, 2)
plt.plot(w, Hlog, 'b')
plt.title('20*log10|H(jw)| - Skala decybelowa')
plt.xlabel('w [rad/s]')
plt.ylabel('20*log10|H(jw)|')
plt.grid()

# Charakterystyka fazowo-częstotliwościowa
H3 = np.polyval(bm, 1j*w) / np.polyval(an, 1j*w)
Hp = np.angle(H3)

plt.figure('Charakterystyka f-cz')
plt.plot(w, np.unwrap(Hp), 'b')
plt.title('Charakterystyka f-cz')
plt.xlabel('Częstotliwośc [Hz]')
plt.ylabel('Faza [rad]')
plt.show()
