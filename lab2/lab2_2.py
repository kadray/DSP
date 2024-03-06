import numpy as np

N = 20

# Generowanie wektorów kosinusowych
A = np.zeros((N, N))
for k in range(N):
    s = np.sqrt(1/N) if k == 0 else np.sqrt(2/N)
    for n in range(N):
        A[k, n] = s * np.cos(np.pi * k / N * (n + 0.5))

# Sprawdzanie czy A*S==I
S=A.T
I=np.dot(A, S)
if np.allclose(I, np.eye(N)):
    print("AS==I")
else:
    print("AS!=I")

# Losowy wektor x
x=np.random.randn(N)
print("Sygnał początkowy:\n",x)
X=np.dot(A, x.T)

x_synth=np.dot(S,X)
print("Sygnał syntezowany:\n",x_synth)
if np.allclose(x, x_synth):
    print("Idealna rekonstrukcja sygnału")
else:
    print("Nieidealna rekonstrukcja sygnału")