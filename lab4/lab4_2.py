import numpy as np
import matplotlib.pyplot as plt
import time

N=1024 # liczba próbek

x1=np.random.randn(N) #dwa losowe sygnały rzeczywiste
x2=np.random.randn(N)
s_time=time.time()
X1_fft =np.fft.fft(x1) #zwykła transformata X1
X2_fft =np.fft.fft(x2) #zwykła transformata X2
e_time=time.time()
fft_time=e_time-s_time
y= x1+1j*x2 #sygnał x1 jako rzeczywisty, sygnał x2 jako zespolony połączone w sygnał y
Y=np.fft.fft(y) # transformata Y

print(Y)
X1r=np.zeros(N)
X1i=np.zeros(N)
X2r=np.zeros(N)
X2i=np.zeros(N)
s_time=time.time()
for k in range(1,N): # odzyskiwanie transformaty ze wzorów
    X1r[k] = 0.5*(np.real(Y[k]) + np.real(Y[N-k]))
    X1i[k] = 0.5*(np.imag(Y[k]) - np.imag(Y[N-k]))

    X2r[k] = 0.5*(np.imag(Y[k]) + np.imag(Y[N-k]))
    X2i[k] = 0.5*(np.real(Y[N-k]) - np.real(Y[k]))

X1r[0] = np.real(Y[0])
X1i[0] = 0
X2r[0] = np.imag(Y[0])
X2i[0] = 0

X1 = X1r+1j*X1i
X2 = X2r+1j*X2i
e_time=time.time()
fun_time=e_time-s_time
print(fft_time, fun_time)
x1_rec = np.fft.fft(X1)
plt.figure(1)
plt.plot(np.arange(0, N), X1, "r-",np.arange(0, N), X1_fft, "bo")
print(abs(np.mean(X1-X1_fft)))
plt.figure(2)
plt.plot(np.arange(0, N), X2, "r-",np.arange(0, N), X2_fft, "bo")
print(abs(np.mean(X2-X2_fft)))
plt.show()