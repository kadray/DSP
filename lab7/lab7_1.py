import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import firwin, lfilter, freqz

# Parametry filtru
fs = 1200  # Częstotliwość próbkowania [Hz]
df = 200   # Szerokość pasma [Hz]
fc = 300   # Częstotliwość środkowa pasma [Hz]

# Długość filtru (ilość próbek)
N = 128    # lub N = 129
#zmienia się symetria, dla 129 filtr jest symetryczny bo mamy wartość środkową
f_low = fc - df / 2
f_high = fc + df / 2
# Projektowanie filtrów
def design_filter(window_type):
    # Obliczenie współczynników filtra FIR
    h = firwin(N, [f_low, f_high], fs=fs, pass_zero=False, window=window_type)
    # Obliczenie charakterystyki częstotliwościowej filtra
    w, h_freqz = freqz(h, 1, worN=2000)
    # Obliczenie poziomu tłumienia w paśmie zaporowym
    stop_band_attenuation = -20 * np.log10(min(abs(h_freqz)))

    return w, h_freqz, stop_band_attenuation

# Rodzaje okien
window_types = ['boxcar', 'hann', 'hamming', 'blackman', 'blackmanharris']
results = {}

# Projektowanie filtrów dla różnych okien
for window_type in window_types:
    w, h_freqz, stop_band_attenuation = design_filter(window_type)
    results[window_type] = {'w': w, 'h_freqz': h_freqz, 'stop_band_attenuation': stop_band_attenuation}

# Wyświetlenie charakterystyk częstotliwościowych
plt.figure(figsize=(12, 6))
for window_type, result in results.items():
    plt.plot(result['w'] * fs / (2 * np.pi), 20 * np.log10(abs(result['h_freqz'])), label=window_type)
plt.ylim(-200, 10)
plt.title('Charakterystyka amplitudowo-częstotliwościowa')
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Amplituda [dB]')
plt.legend()
plt.grid()


# Wyświetlenie charakterystyk fazowo-częstotliwościowych
plt.figure(figsize=(12, 6))
idx=1
for window_type, result in results.items():
    plt.subplot(5, 1, idx)
    idx+=1
    plt.plot(result['w'] * fs / (2 * np.pi), np.angle(result['h_freqz']), label=window_type)
    plt.legend()
plt.title('Charakterystyka fazowo-częstotliwościowa')
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Faza [rad]')
plt.grid()


# # Wyświetlenie poziomu tłumienia w paśmie zaporowym
# for window_type, result in results.items():
#     print(f"Okno {window_type}: Poziom tłumienia w paśmie zaporowym = {result['stop_band_attenuation']:.2f} dB")

# Generowanie sygnału testowego
t = np.arange(0, 1, 1/fs)
x = np.sin(2 * np.pi * 100 * t) + np.sin(2 * np.pi * 200 * t) + np.sin(2 * np.pi * 300 * t) + np.sin(2 * np.pi * 500 * t)

# Filtracja sygnału testowego
filtered_signals = {}
for window_type, result in results.items():
    h = firwin(N, [f_low, f_high], fs=fs, pass_zero=False, window=window_type)
    filtered_signals[window_type] = lfilter(h, 1, x)

# Wyświetlenie sygnału przed i po filtracji
plt.figure(figsize=(12, 6))

idx=1
for window_type, filtered_signal in filtered_signals.items():
    plt.subplot(5, 1, idx)
    idx+=1
    plt.plot(t, x, label='Sygnał wejściowy')
    plt.plot(t, filtered_signal, label=window_type)
    plt.legend()
plt.title('Sygnał przed i po filtracji')
plt.xlabel('Czas [s]')
plt.ylabel('Amplituda')
plt.grid()


# Wyświetlenie poziomu tłumienia w paśmie zaporowym
for window_type, result in results.items():
    print(f"Okno {window_type}: Poziom tłumienia w paśmie zaporowym = {result['stop_band_attenuation']:.2f} dB")

# Obliczenie widma gęstości mocy sygnału przed i po filtracji
frequencies = np.fft.rfftfreq(len(x), d=1/fs)
fft_x = np.abs(np.fft.rfft(x))
fft_filtered_signals = {}
for window_type, filtered_signal in filtered_signals.items():
    fft_filtered_signals[window_type] = np.abs(np.fft.rfft(filtered_signal))

# Wyświetlenie widma gęstości mocy
plt.figure(figsize=(12, 6))
plt.plot(frequencies, fft_x, label='Przed filtracją')
for window_type, fft_filtered_signal in fft_filtered_signals.items():
    plt.plot(frequencies, fft_filtered_signal, label=f'Po filtracji ({window_type})')
plt.title('Widmo gęstości mocy')
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Amplituda')
plt.legend()
plt.grid()
plt.show()
