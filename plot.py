# Only for degeneracies:
import matplotlib.pyplot as plt
import numpy as np
import os

fig,(ax1,ax2)= plt.subplots(nrows=1,ncols=2,figsize=(12,5))

data = np.loadtxt('./Data/10,0.0.dat')
ave = np.log(np.abs(data[0,:]))
# std = np.log(data[:,1])
tim = [np.log(i+1) for i in range(ave.size)]
ax1.scatter(tim,ave,s=20,marker='o',label="L=10,dJ=0.0")

ax1.legend(loc='best')
ax1.set_title("M(t,L,J)")
ax1.set_xlabel("log(t)")
ax1.set_ylabel("log(M)")
ax1.set_ylim(min(ave),0)
ax1.set_xlim(0,8)


data = np.loadtxt('./Data/10,0.0.dat')
ave = data[0,:]
# std = np.log(data[:,1])
tim = [i+1 for i in range(ave.size)]
ax2.scatter(tim,ave,s=20,marker='o',label="L=10,dJ=0.0")

ax2.legend(loc='best')
ax2.set_title("M(t,L,J)")
ax2.set_xlabel("t")
ax2.set_ylabel("M")
ax2.set_ylim(-0.1,0.1)
ax2.set_xlim(250,)

plt.savefig('fig00.png')