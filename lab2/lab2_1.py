import numpy as np

# Parametry
N = 20
# Funkcja do generowania wektorów kosinusowych
def generate_cosine_vectors(N):
    A = np.zeros((N, N))
    for k in range(N):
        sk = np.sqrt(1/N) if k == 0 else np.sqrt(2/N)
        for n in range(N):
            A[k, n] = sk * np.cos(np.pi * k / N * (n + 0.5))
    return A

# Generowanie macierzy transformaty DCT-II
A = generate_cosine_vectors(N)

# Sprawdzanie ortonormalności
dot_products = np.dot(A, A.T)
is_orthonormal = np.allclose(dot_products, np.eye(N))

print("Macierz A transformaty DCT-II:")
print(A)

if is_orthonormal:
    print("\nWszystkie wektory są do siebie ortonormalne.")
else:
    print("\nNie wszystkie wektory są do siebie ortonormalne.")