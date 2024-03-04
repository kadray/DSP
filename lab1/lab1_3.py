# Rozwiązanie
import numpy as np
import matplotlib.pyplot as plt
import scipy.io

data = scipy.io.loadmat('adsl_x.mat')
x = np.array(data['x'])
prefix_len = 32  # długość prefiksu
frame_len = 512  # długość ramki
package_len = prefix_len + frame_len # długość ramki i prefiksu
part=x[0:32]
plt.plot(np.correlate(x, x, mode='full'))
plt.show()