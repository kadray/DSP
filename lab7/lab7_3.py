import numpy as np
from scipy.io import wavfile
import matplotlib.pyplot as plt
from scipy.signal import freqz, lfilter, firwin, firwin2, decimate, filtfilt, resample, butter

# Parameters
fs = 3.2e6          # sampling frequency
N = 32e6            # number of samples
fc = 0.40e6         # central frequency of MF station
bwSERV = 80e3       # bandwidth of an FM service
bwAUDIO = 16e3      # bandwidth of an FM audio


with open('samples_100MHz_fs3200kHz.raw', 'rb') as f:
    s = np.fromfile(f, dtype=np.uint8)

s = s - 127

# IQ do postaci zespolonej
wideband_signal = s[::2] + 1j * s[1::2]
# Przesunięcie do pasma podstawowego
wideband_signal_shifted = wideband_signal * np.exp(-1j * 2 * np.pi * fc / fs * np.arange(N))
# Filtracja stacji
b, a = butter(4, bwSERV / fs)
wideband_signal_filtered = lfilter(b, a, wideband_signal_shifted)

# Próbkowanie do szerokości pasma usługi
x = wideband_signal_filtered[::int(fs / (bwSERV * 2))]

# Demodulacja FM
dx = x[1:] * np.conj(x[:-1])
y = np.angle(dx)
# Filtracja antyaliasingowa i dekodowanie do szerokości pasma audio
Wn_down = (15e3 * 2) / (bwSERV * 2)
b_down = firwin(129, Wn_down, nyq=bwSERV, window='blackmanharris')
y_audio = lfilter(b_down, 1, y)

# Filtr pasmowoprzepustowy w obrębie 19 kHz

f_pilot = 19000  # Częstotliwość sygnału pilota
f_bandwidth = 1000  # Szerokość pasma filtru (1 kHz)
taps_fir2 = 101  # Długość odpowiedzi impulsowej (nieparzysta dla zachowania symetrii)

# Projektowanie filtru FIR 2
nyquist = 0.5 * fs
cutoff = f_pilot / nyquist
width = f_bandwidth / nyquist
fir2 = signal.firwin(taps_fir2, [cutoff - 0.5 * width, cutoff + 0.5 * width], pass_zero=False)