import numpy as np
import matplotlib.pyplot as plt
import time
def radix2(x):
  N = len(x)
  if N == 1:   # warunek konczacy rekurencje
    return x
  else:
    X1 = radix2(x[0::2])
    X2 = radix2(x[1::2])
    Z = np.exp(-2j * np.pi * np.arange(N) / N)
    X = np.concatenate([X1 + Z[:N // 2] * X2, X1 + Z[N // 2:] * X2])
    return X
  
x = np.random.randn(256)  # Przykładowe dane wejściowe
X = radix2(x)
x_rec=np.fft.ifft(X)
plt.figure(1)
plt.plot(np.arange(0, len(x)), x, "b-", np.arange(0, len(x_rec)), x_rec, "ro")
plt.title("Odtworzony sygnał x porównany z wejściowym")
errors=[]
fft_times=[]
radix2_times=[]
for i in range(0, 15):
    N = pow(2, i)
    x = np.random.rand(N)
    stime=time.time()
    X_fft = np.fft.fft(x)   # oryginalne DFT
    etime=time.time()
    fft_times.append(etime-stime)
    stime=time.time()
    X_radix = radix2(x)          # DFT sklejane z dwóch połówek 
    etime=time.time()
    radix2_times.append(etime-stime)
    errors.append(np.mean(np.abs(X_fft-X_radix)))

plt.figure(2)
plt.plot(np.arange(len(errors)), errors)
plt.title("Wykres błędu odwzorowania w zależności od potęgi 2 próbek")
plt.xlabel("Potęgi 2^N")
plt.ylabel("błąd")
plt.figure(3)
plt.plot(np.arange(len(fft_times)), fft_times, label="fft")
plt.plot(np.arange(len(radix2_times)), radix2_times, label="Radix-2")
plt.title("Porównanie czasów wykonywania algorytmów")
plt.xlabel("Potęgi 2^N")
plt.ylabel("Czas wykonania algorytmu")
plt.legend()
plt.show()

