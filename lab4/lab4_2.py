import numpy as np
import matplotlib.pyplot as plt
import time

def one_fft_for_two(x1, x2):
    if len(x1)!=len(x2):
        print("x1 i x2 nierówne")
        return -1
    N=len(x1)
    y= x1+1j*x2 #sygnał x1 jako rzeczywisty, sygnał x2 jako zespolony połączone w sygnał y
    Y=np.fft.fft(y) # transformata Y
    X1r=np.zeros(N)
    X1i=np.zeros(N)
    X2r=np.zeros(N)
    X2i=np.zeros(N)

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
    return X1, X2
#----------------------------------------------------
N=1024 # liczba próbek

x1=np.random.randn(N) #dwa losowe sygnały rzeczywiste
x2=np.random.randn(N)

X1_fft =np.fft.fft(x1) #zwykła transformata X1
X2_fft =np.fft.fft(x2) #zwykła transformata X2



X_=one_fft_for_two(x1, x2)
X1=X_[0]
X2=X_[1]

x1_rec = np.fft.fft(X1)
plt.figure(1)
plt.plot(np.arange(0, N), X1, "r-",np.arange(0, N), X1_fft, "bo")
plt.title("Uzyskane transformaty X1 dwoma sposobami")
plt.figure(2)
plt.plot(np.arange(0, N), X2, "r-",np.arange(0, N), X2_fft, "bo")
plt.title("Uzyskane transformaty X2 dwoma sposobami")
print("Błąd fft-algorytm podwójny:", abs((np.mean(X2-X2_fft))+abs(np.mean(X1-X1_fft)))/2)

one_fft_time=[]
double_fft_time=[]
errors=[]
for i in range(1, 16):
    N=pow(2, i)
    x1=np.random.randn(N)
    x2=np.random.randn(N)
    stime=time.time()
    X_=one_fft_for_two(x1, x2)
    etime=time.time()
    one_fft_time.append(etime-stime)
    stime=time.time()
    X1_fft =np.fft.fft(x1)
    X2_fft =np.fft.fft(x2)
    etime=time.time()
    double_fft_time.append(etime-stime)
    #print(one_fft_time[i-1])

plt.figure(3)
plt.plot(np.arange(len(one_fft_time)), one_fft_time, label="Czasy dla pojedynczego FFT")
plt.plot(np.arange(len(double_fft_time)), double_fft_time, label="Czasy dla podwójnego FFT")
plt.xlabel("Potęgi 2^N")
plt.ylabel("Czas wykonania algorytmu")
plt.legend()
plt.show()
