import numpy as np
import matplotlib.pyplot as plt
import math
shape = (300, 300)
Lx = shape[0]
Ly = shape[1]
# Spin block
block = np.ones(shape)

# J/(kT)
Jcp = 0.4


def metropolis(b):
    for i in range(shape[0]):
        for j in range(shape[1]):
            nei= (
                        b[(i + Lx + 1) % Lx][j] +
                        b[(i + Lx - 1) % Lx][j] +
                        b[i][(j + Ly + 1) % Ly] +
                        b[i][(j + Ly - 1) % Ly] 
                 )
            if np.random.random() < math.exp(-2*Jcp*nei*b[i][j]):
                b[i][j] = - b[i][j]


plt.ion()
plt.show()

im = plt.imshow(block, cmap='gray', vmin=-1, vmax=1, interpolation='none')
t = 0
for i in range(500):
    metropolis(block)
    im.set_data(block)
    plt.draw()
    plt.pause(.0000001)
    t = t + 1
    print(t)
Jcp = 0.5
while True:
    metropolis(block)
    im.set_data(block)
    plt.draw()
    plt.pause(.0000001)
    t = t+1
    print(t)