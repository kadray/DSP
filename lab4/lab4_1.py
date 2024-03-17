import numpy as np
import matplotlib.pyplot as plt

def dit(x):
  N = len(x)
  if N == 1:   # warunek konczacy rekurencje
    return x
  else:
    X1 = dit(x[0::2])
    X2 = dit(x[1::2])
    Z = np.exp(-2j * np.pi * np.arange(N) / N)
    X = np.concatenate([X1 + Z[:N // 2] * X2, X1 + Z[N // 2:] * X2])
    return X


errors=[]
for i in range(0, 15):
    N = pow(2, i)
    x = np.random.rand(N)
    X_fft = np.fft.fft(x)   # oryginalne DFT
    X_dit = dit(x)          # DFT sklejane z dwóch połówek (1 etap podziału)
    errors.append(np.mean(np.abs(X_fft-X_dit)))
    print("Błąd DFT - DiT: " , errors[i]) 

plt.plot(np.arange(len(errors)), errors)
plt.xlabel("Potęgi 2")
plt.ylabel("błąd")
plt.show()