import numpy as np
import matplotlib.pyplot as plt

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
  
x = np.random.randn(1024)  # Przykładowe dane wejściowe
X = radix2(x)
print(X)
x_rec=np.fft.ifft(X)
plt.figure(1)
plt.plot(np.arange(0, len(x)), x, "b-", np.arange(0, len(x_rec)), x_rec, "ro")
plt.show()
errors=[]
for i in range(0, 15):
    N = pow(2, i)
    x = np.random.rand(N)
    X_fft = np.fft.fft(x)   # oryginalne DFT
    X_dit = radix2(x)          # DFT sklejane z dwóch połówek 
    errors.append(np.mean(np.abs(X_fft-X_dit)))
    print("Błąd DFT - DiT: " , errors[i]) 

plt.plot(np.arange(len(errors)), errors)
plt.xlabel("Potęgi 2")
plt.ylabel("błąd")
plt.show()
