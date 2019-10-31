from matplotlib import pyplot as plt
import numpy as np
emb = np.fromfile('.\\Release\\MNIST_emb.bin', np.float32)
emb.shape
emb = emb.reshape((70000,2))
plt.scatter(emb[...,0], emb[...,1])
plt.show()