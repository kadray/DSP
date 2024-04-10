import numpy as np
import scipy.io
import scipy.signal
import matplotlib.pyplot as plt
from scipy.io import wavfile

data = scipy.io.loadmat('butter.mat')
z, p, k = [np.squeeze(data[param]) for param in ('z', 'p', 'k')]
b, a = scipy.signal.zpk2tf(z, p, k)
fs = 16000
num_d, den_d = scipy.signal.bilinear(b, a,fs)
fs, s = wavfile.read('data/s5.wav')
filtered_signal = scipy.signal.lfilter(num_d, den_d, s)

plt.figure(figsize=(10, 8))

plt.subplot(2, 1, 1)
plt.specgram(s, NFFT=4096, Fs=fs, noverlap=4096-512)
plt.title('Spectrogram przed filtrowaniem')
plt.ylabel('Częstotliwość [Hz]')

# After filtering
plt.subplot(2, 1, 2)
plt.specgram(filtered_signal, NFFT=4096, Fs=fs, noverlap=4096-512)
plt.title('Spectrogram po filtrowaniu')
plt.xlabel('Czas [s]')
plt.ylabel('Częstotliwość [Hz]')

plt.tight_layout()

# Plotting signals in the time domain
t = np.arange(len(s)) / fs
plt.figure(figsize=(10, 6))
plt.plot(t, s, label='Przed filtrowaniem')
plt.plot(t, filtered_signal, label='Przed filtrowaniem', color='red')
plt.xlabel('Czas [s]')
plt.ylabel('Amplituda')
plt.legend(['Przed filtrowaniem', 'Po filtrowaniu'])
plt.show()

'''
sygnał s5:
a: 1472, 702        3
b: 1339, 946        0
c: 1339, 774        5
d: 1339, 702        2
e: 1339, 943        0
'''