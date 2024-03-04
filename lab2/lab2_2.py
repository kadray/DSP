import numpy as np
from scipy.fftpack import idct

# Tworzenie macierzy DCT
A = np.array([[1, 2, 0, 1],
              [0, 1, 2, 1],
              [2, 1, 1, 0],
              [1, 0, 1, 2]])

# Transponowanie macierzy A
A_transpose = A.T

# Obliczanie IDCT
S = np.linalg.inv(np.fft.idct(np.eye(4)))  # IDCT macierzy jednostkowej 4x4

# Sprawdzenie czy S*A daje macierz identycznościową
identity_matrix = np.eye(4)
check_identity = np.allclose(np.dot(S, A), identity_matrix)

print("Czy iloczyn macierzy S i A jest równy macierzy identycznościowej? ", check_identity)

# Tworzenie sygnału losowego
x = np.random.randn(4)

# Analiza
x_prime = np.dot(A, x)

# Synteza
x_s = np.dot(S, x_prime)

# Sprawdzenie czy rekonstrukcja jest perfekcyjna
perfect_reconstruction = np.allclose(x_s, x)

print("Czy rekonstrukcja jest perfekcyjna? ", perfect_reconstruction)