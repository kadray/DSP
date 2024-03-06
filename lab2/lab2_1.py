import numpy as np

N = 20

# Generowanie wektorów kosinusowych
A = np.zeros((N, N))
for k in range(N):
    s = np.sqrt(1/N) if k == 0 else np.sqrt(2/N)
    for n in range(N):
        A[k, n] = s * np.cos(np.pi * k / N * (n + 0.5))
        
# Sprawdzanie ortonormalności
# warunki:
# 1 - kolumny macierze mają iloczyn skalarny 1
# 2 - iloczyny między wektorami wynoszą 0
def is_orthonormal(matrix):
    #1
    norms = np.linalg.norm(matrix, axis=0)
    if not np.allclose(norms, 1):
        return False
    #1
    dot_products = np.dot(matrix.T, matrix)
    if not np.allclose(dot_products, np.eye(matrix.shape[1])):
        return False

    return True

print("Macierz A transformaty DCT-II:")
print(A)

if is_orthonormal(A):
    print("\nWszystkie wektory są do siebie ortonormalne.")
else:
    print("\nNie wszystkie wektory są do siebie ortonormalne.")